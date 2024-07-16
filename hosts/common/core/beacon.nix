{ pkgs, configVars, ... }:
# Script from https://gitlab.com/librephoenix/nixos-config/-/blob/main/system/bin/phoenix.nix?ref_type=heads
let
  myScript = ''
    #! /bin/sh

    CONFIG_DIR="${configVars.userSettings.dotfilesDir}"
    param="sync,refresh,update,upgrade,pull,harden,soften,gc"
    sync_param="system,user"
    gc_param="full, "

    print_usage() {
        printf "\n\tUsage: '$0 <options>'\n\tOptions:\n\t\tsync - updates the nix system to use the latest configuration\n\t\trefresh - updates the syle configuration\n\t\tupdate - updates the flake but does not sync the new changes\n\t\tupgrade - updates the flake and syncs the new changes\n\t\tpull - pulls the lastest git updates to configuration & keeps local changes in git stash\n\t\tharden - changes the configuartion to be owned by root\n\t\tsoften - Lowers the configuration to be owned by user 1000\n\t\tgc - runs the nixos garbage collect
        "
    }

    in_list() {
        LIST=$1
        DELIMITER=$2
        VALUE=$3
        echo $LIST | tr "$DELIMITER" '\n' | grep -F -q -x "$VALUE"
    }

    system_sync () {
        sudo nixos-rebuild switch --flake $CONFIG_DIR
    }

    refresh () {
        pgrep Hyprland &> /dev/null && echo "Reloading hyprland" && hyprctl reload &> /dev/null
        pgrep .waybar-wrapped &> /dev/null && echo "Restarting waybar" && killall .waybar-wrapped && echo "Running waybar" && waybar &> /dev/null & disown
        pgrep Hyprland &> /dev/null && echo "Reapplying background from stylix via swaybg" && echo "Running ~/.swaybg-stylix" && ~/.swaybg-stylix &> /dev/null & disown
        echo "\n"
    }

    user_sync () {
        home-manager switch --flake $CONFIG_DIR
        refresh
    }

    sync () {
        system_sync
        user_sync
    }

    update () {
        sudo nix flake update $CONFIG_DIR
    }

    harden () {
        pushd $CONFIG_DIR &> /dev/null
        chown 0:0 .
        chown 0:0 profiles/default-config.nix
        chown 0:0 profiles/*/*-config.nix
        chown -R 0:0 system
        chown 0:0 flake.lock
        chown 0:0 flake.nix
        chown 0:0 hosts/*/configuration.nix
        chown 0:0 hosts/*/hardware-configuration.nix
        chown 0:0 harden.sh
        chown 0:0 soften.sh
        chown 0:0 install.sh
        chown 0:0 update.sh
        popd &> /dev/null
    }

    soften () {
        pushd $CONFIG_DIR &> /dev/null
        chown -R 1000:users .
        popd &> /dev/null
    }

    pull () {
        soften
      
        pushd $CONFIG_DIR &> /dev/null
        git stash
        git pull
        git stash apply
        popd &> /dev/null
      
        harden
    }

    if ! in_list $param "," $1; then
        print_usage
    else
        if [ "$1" = "sync" ]; then
            if [ "$#" -gt 2 ]; then
                echo "sync can only take one argument which is either 'user' or 'system'."
            elif [ "$2" = "system" ]; then
                system_sync
            elif [ "$2" = "user" ]; then
                user_sync
            elif [ "$2" = "" ]; then
                sync
            else
                echo "sync can only take one argument which is either 'user' or 'system'."
            fi
        elif [ "$1" = "refresh" ]; then
            refresh
        elif [ "$1" = "update" ]; then
            update
        elif [ "$1" = "upgrade" ]; then
            update
            sync
        elif [ "$1" = "pull" ]; then
            pull
        elif [ "$1" = "harden" ]; then
            harden
        elif [ "$1" = "soften" ]; then
            soften
        else [ "$1" = "gc" ]
            if [ "$#" -gt 2 ]; then
                echo "Warning: The 'gc' command only accepts one argument (collect_older_than)";
            fi
            if [ "$2" = "full" ]; then
                sudo nix-collect-garbage --delete-old
                nix-collect-garbage --delete-old
            elif [ "$2" ]; then
                sudo nix-collect-garbage --delete-older-than $2
                nix-collect-garbage --delete-older-than $2
            else
                sudo nix-collect-garbage --delete-older-than 30d
                nix-collect-garbage --delete-older-than 30d
            fi
        fi
    fi
  '';
in
{
  environment.systemPackages = [
    (pkgs.writeScriptBin "beacon" myScript)
  ];
}
