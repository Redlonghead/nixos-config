{
  inputs,
  ...
}:

{

  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  hardware = {
    graphics.enable = true;
    nvidia.open = true;
  };

}
