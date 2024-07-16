{ pkgs, ... }:

{
  # I know about home manager's config for oh my posh
  # but I cannot get the settings option to work so I
  # just went the round about way of things

  home.packages = with pkgs; [
    oh-my-posh
  ];

  programs.zsh.initExtra = ''eval "$(oh-my-posh init zsh --config "/home/beacon/.config/oh-my-posh/config.yaml")"'';

  home.file."config.yaml" = {
    target = ".config/oh-my-posh/config.yaml";
    text = ''
      $schema: https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json
      blocks:
        - alignment: left
          newline: true
          segments:
            - background: "#61AFEF"
              foreground: "#ffffff"
              powerline_symbol: 
              template: " {{ .Path }} "
              properties:
                style: full
              style: powerline
              type: path
            - background: "#2e9599"
              background_templates:
                - "{{ if or (.Working.Changed) (.Staging.Changed) }}#f36943{{ end }}"
                - "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#a8216b{{ end }}"
                - "{{ if gt .Ahead 0 }}#35b5ff{{ end }}"
                - "{{ if gt .Behind 0 }}#f89cfa{{ end }}"
              foreground: "#193549"
              foreground_templates:
                - "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#ffffff{{ end }}"
              powerline_symbol: 
              template: " {{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }} "
              properties:
                branch_max_length: 25
                fetch_status: true
              style: powerline
              type: git
          type: prompt
      blocks
        - segments:
            - type: text
              background: transparent
              template: ❯
          type: prompt
          alignment: left
          newline: true
      secondary_prompt:
        background: transparent
        foreground: magenta
        template: "❯❯"
      final_space: true
      version: 2
    '';
  };

}
