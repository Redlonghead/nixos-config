{
  pkgs,
  ...
}:

{
  home.packages = (
    with pkgs;
    [
      # ciscoPacketTracer8 # 8.2.2 can't be downloaded anymore from Cisco
      p3x-onenote
      teams-for-linux
    ]
  );
}
