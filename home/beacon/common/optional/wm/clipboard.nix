{ pkgs, ... }:

{
  services.clipse = {
    enable = true;
    package = pkgs.clipse;
    # theme = {
    #   useCustomTheme = true;
    #   DimmedDesc = "#ffffff";
    #   DimmedTitle = "#ffffff";
    #   FilteredMatch = "#ffffff";
    #   NormalDesc = "#ffffff";
    #   NormalTitle = "#ffffff";
    #   SelectedDesc = "#ffffff";
    #   SelectedTitle = "#ffffff";
    #   SelectedBorder = "#ffffff";
    #   SelectedDescBorder = "#ffffff";
    #   TitleFore = "#ffffff";
    #   Titleback = "#434C5E";
    #   StatusMsg = "#ffffff";
    #   PinIndicatorColor = "#ff0000";
    # };
  };

  home.packages = with pkgs; [
    clipse
    wl-clipboard
  ];
}