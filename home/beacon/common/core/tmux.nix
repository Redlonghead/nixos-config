{
  pkgs,
  ...
}:

{
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;

    mouse = true;
    shortcut = "space";
    baseIndex = 1;
    keyMode = "vi";
    terminal = "kitty";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
    ];
  };
}
