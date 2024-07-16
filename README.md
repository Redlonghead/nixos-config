## SOPS Home manager 
### Update Private Repo flake.lock
`nix flake lock --update-input nix-secrets`

### Errors
1. `home-manager switch --refresh --flake .#user`
2. `systemctl --user reset-failed`
3. `home-manager switch --flake .#user` (or `beacon sync user`)