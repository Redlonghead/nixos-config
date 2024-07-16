{
  description = "Connor's NixOS Flake";

  outputs = { self, ... } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = pkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      configVars = import ./vars { inherit inputs pkgs lib; };
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit inputs pkgs configVars configLib pkgs-stable; };

      pkgs = (if (configVars.systemSettings.profile == "server")
      then
        pkgs-stable
      else
        (import inputs.nixpkgs-unstable {
          #FIXME error: infinite recursion encountered
          # overlays = [ (import ./overlays) ];
          system = configVars.systemSettings.system;
          config = {
            allowUnfree = true;
          };
        })
      );

      pkgs-stable = import inputs.nixpkgs-stable {
        system = configVars.systemSettings.system;
        config = {
          allowUnfree = true;
        };
      };

      lib = (if (configVars.systemSettings.profile == "server")
      then
        inputs.nixpkg-stable.lib
      else
        inputs.nixpkgs-unstable.lib
      );

      home-manager = (if (configVars.systemSettings.profile == "server")
      then
        inputs.home-manager-stable
      else
        inputs.home-manager-unstable
      );

    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems
        (system:
          let pkgs = pkgs.legacyPackages.${system};
          in import ./pkgs { inherit pkgs; }
        );

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: pkgs.nixpkgs-fmt);

      # Shell configured with packages that are typically only needed when working on or with nix-config.
      devShells = forAllSystems
        (system:
          # let pkgs = nixpkgs.legacyPackages.${system};
          import ./shell.nix { inherit pkgs; }
        );

      nixosConfigurations = {

        CB-FW = lib.nixosSystem {
          modules = [
            ./hosts/CB-FW
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
          inherit specialArgs;
        };
      };

      homeConfigurations = {
        "beacon@CB-FW" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/beacon/CB-FW.nix
          ];
          extraSpecialArgs = specialArgs;
        };
      };
    };

  inputs = {
    ########## Main inputs #############
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    ########## Personal inputs ##########

    # Private repo. with SOPS encrypted secrets
    nix-secrets = {
      url = "git+ssh://git@gitlab.com/Redlonghead/nixos-secrets.git"; # =main&shallow=1
      flake = false;
    };

    ########## Extra inputs #############
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

}
