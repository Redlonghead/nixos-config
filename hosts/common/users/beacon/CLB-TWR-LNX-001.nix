{ ... }:

{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### User-specific Optional Configs ####################
    common/optional/syncthing.nix
  ];

}
