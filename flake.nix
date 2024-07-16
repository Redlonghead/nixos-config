{
  description = "Connor's NixOS-config Flake";

  outputs = { self, ... } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = inputs.nixpkgs-stable.lib.genAttrs [
        "x86_64-linux"
      ];

      inherit (inputs.nixpkgs-stable) lib;
      configVars = import ./vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit inputs outputs configVars configLib; };

      pkgs = import inputs.nixpkgs-stable {
        system = configVars.systemSettings.system;
        config = {
          allowUnfree = true;
        };
      };

      home-manager = inputs.home-manager-stable;
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
          let pkgs = inputs.nixpkgs-stable.legacyPackages.${configVars.systemSettings.system};
          in import ./pkgs { inherit pkgs; }
        );

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: pkgs.nixpkgs-fmt);

      # Shell configured with packages that are typically only needed when working on or with nix-config.
      devShells = forAllSystems
        (system:
          let pkgs = inputs.nixpkgs-stable.legacyPackages.${configVars.systemSettings.system};
          in import ./shell.nix { inherit pkgs; }
        );

      nixosConfigurations = {

        CB-FW = lib.nixosSystem {
          modules = [
            ./hosts/CB-FW
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
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    ########## Personal inputs ##########

    # Private repo. with SOPS encrypted secrets and nixosModules
    nixos-secrets = {
      url = "git+ssh://git@gitlab.com/Redlonghead/nixos-secrets.git"; # =main&shallow=1
    };

    ########## Extra inputs #############
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

}
