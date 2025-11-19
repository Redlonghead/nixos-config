{
  description = "Connor's NixOS-config Flake";

  outputs =
    { self, systems, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems =
        f:
        inputs.nixpkgs-stable.lib.genAttrs (import systems) (
          system: f inputs.nixpkgs-stable.legacyPackages.${system}
        );

      # Extend lib with custom library functions
      lib = inputs.nixpkgs-stable.lib.extend (
        self: super: { custom = import ./lib { inherit (inputs.nixpkgs-stable) lib; }; }
      );

      configVars = import ./vars { inherit inputs lib; };
      specialArgs = {
        inherit
          inputs
          outputs
          configVars
          ;
      };

      pkgs = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

      # Eval the treefmt modules
      treefmtEval = forAllSystems (
        pkgs:
        inputs.treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            yamlfmt.enable = true;
            just.enable = true;
            mdformat = {
              enable = true;
              settings.number = true;
            };
          };

          settings.global.excludes = [
            ".envrc"
            "themes/*"
            "*.mustache"
            "*.jpg"
            "*.pub"
            "*.conf"
            "justfile"
          ];
        }
      );

    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      nixosModules = import ./modules/nixos;
      homeModules = import ./modules/home-manager;

      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (system: import ./pkgs { inherit pkgs; });

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # Nix Flake checker available through 'nix flake check'
      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      # Shell configured with packages that are typically only needed when working on or with nix-config.
      devShells = forAllSystems (system: import ./shell.nix { inherit pkgs; });

      nixosConfigurations = {

        CLB-FRW-LNX-001 = lib.nixosSystem {
          modules = [
            ./hosts/CLB-FRW-LNX-001
          ];
          inherit specialArgs lib;
        };

        CLB-TWR-LNX-001 = lib.nixosSystem {
          modules = [
            ./hosts/CLB-TWR-LNX-001
          ];
          inherit specialArgs lib;
        };
      };

      homeConfigurations = {
        "beacon@CLB-FRW-LNX-001" = inputs.home-manager-stable.lib.homeManagerConfiguration {
          # home-manager extents lib as well so I need to inherit lib
          inherit pkgs lib;
          modules = [
            ./home/beacon/CLB-FRW-LNX-001.nix
          ];
          extraSpecialArgs = specialArgs;
        };

        "beacon@CLB-TWR-LNX-001" = inputs.home-manager-stable.lib.homeManagerConfiguration {
          # home-manager extents lib as well so I need to inherit lib
          inherit pkgs lib;
          modules = [
            ./home/beacon/CLB-TWR-LNX-001.nix
          ];
          extraSpecialArgs = specialArgs;
        };
      };
    };

  inputs = {
    ########## Main inputs #############
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    ########## Personal inputs ##########

    # Private repo. with SOPS encrypted secrets and nixosModules
    nixos-secrets = {
      url = "git+ssh://git@gitlab.com/Redlonghead/nixos-secrets.git";
    };

    ########## Extra inputs #############
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";

    calibrePlugins.url = "git+https://codeberg.org/Nydragon/calibre-plugins";
  };

}
