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
        system = "x86_64-linux";
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
        (system: import ./pkgs { inherit pkgs; });

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: pkgs.nixpkgs-fmt);

      # Shell configured with packages that are typically only needed when working on or with nix-config.
      devShells = forAllSystems
        (system: import ./shell.nix { inherit pkgs; });

      nixosConfigurations = {

        CLB-FRW-LNX-001 = lib.nixosSystem {
          modules = [
            ./hosts/CLB-FRW-LNX-001
          ];
          inherit specialArgs;
        };

        CLB-TWR-LNX-001 = lib.nixosSystem {
          modules = [
            ./hosts/CLB-TWR-LNX-001
          ];
          inherit specialArgs;
        };
      };

      homeConfigurations = {
        "beacon@CLB-FRW-LNX-001" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/beacon/CLB-FRW-LNX-001.nix
          ];
          extraSpecialArgs = specialArgs;
        };

        "beacon@CLB-TWR-LNX" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/beacon/CLB-TWR-LNX-001.nix
          ];
          extraSpecialArgs = specialArgs;
        };
      };
    };

  inputs = {
    ########## Main inputs #############
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/release-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
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
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

}
