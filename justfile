HOST := `hostname`
USER := `echo $USER`

alias ns := nixosSwitch
alias hm := homeManagerSwitch
alias s := sync
alias fu := flakeUpdate
alias nst := nixosTrace
alias hmt := homeManagerTrace
alias gc := garbageCollect

# Default recipe to display help information
_default:
    @just --list --unsorted --justfile {{ justfile() }}

[no-exit-message]
_lint:
    nix fmt
    git add .

[no-exit-message]
_nixosPre: _lint
    @(cd ~/src/nixos-secrets && git fetch && git rebase) || true
    nix flake update nixos-secrets

@_homeManagerPost:
    pgrep Hyprland &> /dev/null
    echo '{{ style("warning") }}Reloading Hyprland{{ NORMAL }}'
    hyprctl reload &> /dev/null
    pgrep .waybar-wrapped &> /dev/null
    echo '{{ style("warning") }}Restarting waybar{{ NORMAL }}'
    killall .waybar-wrapped 
    waybar &> /dev/null & disown

# Rekeys the provided file with the .sops.yaml config
[working-directory: '~/src/nixos-secrets/sops']
rekey secret:
    sops updatekeys -y {{ secret }}
    @git add -u 
    git commit -m "chore: rekey {{ secret }}"
    git push

# Rebuilds NixOS
[no-exit-message]
nixosSwitch host=HOST: _nixosPre
    @echo '{{ style("warning") }}Building NixOS system{{ NORMAL }}'
    sudo nixos-rebuild --flake .#{{ host }} switch

# Rebuilds Home Manager
[no-exit-message]
homeManagerSwitch host=HOST user=USER: _lint && _homeManagerPost
    @echo '{{ style("warning") }}Building User Settings{{ NORMAL }}'
    home-manager switch --flake .#{{ user }}@{{ host }}

# Rebuilds both NixOS & Home Manager
[no-exit-message]
sync: nixosSwitch homeManagerSwitch

# Runs rebuild in test and has both shows-trace and eval-cache false
[no-exit-message]
nixosTrace host=HOST: _nixosPre
    sudo nixos-rebuild test --show-trace --option eval-cache false --flake .#{{ host }}

# Has both shows-trace and eval-cache false
[no-exit-message]
homeManagerTrace host=HOST user=USER: _lint && _homeManagerPost
    home-manager switch --show-trace --option eval-cache false --flake .#{{ user }}@{{ host }}

# Updates the flake and rebuilds NixOS
[no-exit-message]
flakeUpdate: && nixosSwitch
    nix flake update

# Garbage Collect for NixOS
[no-exit-message]
garbageCollect: && nixosSwitch
    nix-collect-garbage --delete-old
