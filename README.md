<div align="center">
<h1>
<img width="100" src="docs/nixos.jpg" /> <br>
</h1>
</div>

# My NixOS Configuration

Some documentation on how to install (WIP) and who I have based my config off of and what documentation I use when adding new features.

______________________________________________________________________

## SOPS Home Manager

Some commands to fix errors from SOPS not working with Home Manager correctly

### Update Private Repo flake.lock

`nix flake lock --update-input nixos-secrets`

### Errors

1. `home-manager switch --refresh --flake .#$USER@$HOST`
2. `systemctl --user reset-failed`
3. `home-manager switch --flake .#user` (or `beacon sync user`)

## Resources

- [Nix Docs](https://nix.dev)
- [NixOS Wiki](https://wiki.nixos.org)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/) - a unofficial intro book for NixOS and & Flakes by Ryan Yin

## Acknowledgements

- [Ryan Yin](https://nixos-and-flakes.thiscute.world/) - A great book
- [Librephoenix](https://gitlab.com/librephoenix/nixos-config) - Got me started in NixOS with his videos and I have some of his style config
- [EmergentMind](https://github.com/EmergentMind/nix-config) - For my main structure & the setup of my SOPS nix through his videos
- [Vimjoyer](https://github.com/vimjoyer) - Excellent high level videos that get me started on delving deeper into.

## Git Naming convention

This is really for myself as its just "Conventional Commits" style and its my fist time doing this.

### Commits

- `feat:` – a new feature is introduced
- `fix:` – a bug fix has occurred
- `chore:` – changes that do not relate to a fix or feature and don't modify src or test files (for example updating dependencies)
- `refactor:` – refactored code that neither fixes a bug nor adds a feature
- `docs:` – updates to documentation such as a the README or other markdown files
- `style:` – changes that do not affect the meaning of the code, likely related to code formatting such as white-space, missing semi-colons, and so on.
- `perf:` – performance improvements
- `revert:` – reverts a previous commit

### Branches

- `feature/` –  These branches are used for developing new features (like feature/login-system).
- `bugfix/` – These branches are used to fix bugs in the code (like bugfix/header-styling).
- `docs/` – These branches are used to write, update, or fix documentation (like docs/api-endpoints).
