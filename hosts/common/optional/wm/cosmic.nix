{ ... }:

{
  imports = [
    ./wayland.nix
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

}



# TODO add Cosmic as a display manager 
# Below adds within a flake as its not in upstream yet
# The greeter does not work yet and only shows very basic background and logout GUI rn
# Can't run anything it seems

# Inputs

# nixos-cosmic = {
#   url = "github:lilyinstarlight/nixos-cosmic";
#   inputs.nixpkgs.follows = "nixpkgs-unstable";
# };

# Nixos Config

# CB-FW = lib.nixosSystem {
#   modules = [
#   {
#     nix.settings = {
#       substituters = [ "https://cosmic.cachix.org/" ];
#       trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
#     };
#   }
#     nixos-cosmic.nixosModules.default
#     ./hosts/CB-FW
#   ];
#   inherit specialArgs;
# };
