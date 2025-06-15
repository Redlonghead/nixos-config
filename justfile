HOST := `hostname`
USER := `echo $USER`

# Default recipe to display help information
[private]
default:
    @just --list

[private]
@ns-pre:
    nix fmt
    git add .
    (cd ../nixos-secrets && git fetch && git rebase) || true
    nix flake update nixos-secrets

[private]
@hm-pre:
    nix fmt
    git add .

# Rebuilds both NixOS & Home Manager
sync: ns hm

# Rebuilds NixOS
ns host=HOST: ns-pre
    sudo nixos-rebuild --flake .#{{ host }} switch

# Rebuilds Home Manager
hm host=HOST user=USER: hm-pre && hm-post
    home-manager switch --flake .#{{ user }}@{{ host }}

# Runs rebuild in test and has both shows-trace and eval-cache false
ns-trace host=HOST: ns-pre
    sudo nixos-rebuild test --show-trace --option eval-cache false --flake .#{{ host }}

# Has both shows-trace and eval-cache false
hm-trace host=HOST user=USER: hm-pre && hm-post
    home-manager switch --show-trace --option eval-cache false --flake .#{{ user }}@{{ host }}

# Updates the flake and rebuilds NixOS
@ns-update: && (ns HOST)
    nix flake update

# Rekeys the provided file with the .sops.yaml config
@rekey secret:
    cd ../nixos-secrets/sops && (sops updatekeys -y {{ secret }} && git add -u && (git commit -m "chore: rekey {{ secret }}" || true) && git push)

# Garbage Collect for NixOS
@gc: && ns
    nix-collect-garbage --delete-old

[private]
@hm-post:
    pgrep Hyprland &> /dev/null && echo "Reloading Hyprland" && hyprctl reload &> /dev/null
    pgrep .waybar-wrapped &> /dev/null && echo "Restarting waybar" && killall .waybar-wrapped && waybar &> /dev/null & disown
