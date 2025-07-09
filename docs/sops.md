# SOPS Configuration Overview

I use [sops-nix](https://github.com/mic92/sops-nix) to access secrets that should not be in the nix store and git history. All of the actual SOPS files are in a separate private repo to make sure nothing is ever leaked and allow me to setup other nixos modules that I don't want public, which you can learn more [here](./nixos-secrets.md) (once I make it).

In my nixos-secrets repo I have a folder called sops with all of the relevant files needed inside. This includes a `.sops.yaml` file and a home, host, server `{level}-secrets.yaml` file. All of the sops-nix configuration is currently done in my nixos-config repo in the corresponding sops.nix file or inside the service's configuration.

- [host sops.nix file](../hosts/common/core/sops.nix)
- [home sops.nix file](../home/beacon/common/core/sops.nix)
- server-secret.yaml file is not currently used.

______________________________________________________________________

## Required packages

### Shell.nix

For setting up SOPS on new computers I have a shell.nix to install all of the relevant packages that will be needed. This does use a flake.lock to access packages. This shell can be use with `nix-shell ./shell.nix`. Below is the code for that as well.

```nix
#################### DevShell ####################
#
# Custom shell for bootstrapping on secrets management

let
  lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs-stable.locked;
  nixpkgs = fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
    sha256 = lock.narHash;
  };
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in

pkgs.mkShellNoCC {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  packages = with pkgs; [
    # Required for pre-commit hook 'nixpkgs-fmt' only on Darwin
    # REF: <https://discourse.nixos.org/t/nix-shell-rust-hello-world-ld-linkage-issue/17381/4>
    libiconv

    nix
    home-manager
    git
    just
    pre-commit

    age
    ssh-to-age
    sops
  ];
}
```

### Nix Package List

- git
- age
- ssh-to-age
- sops

______________________________________________________________________

## Settings up SOPS keys

SOPS can use two types of keys, pgp & age. I will be using age as I will be deriving most of the keys from corresponding ssh keys with `ssh-to-age` and that supports ed25519 encryption. I also setup a "dev" age key that will have access to all of the modules so that I can modify them and fix problems if other keys fail.

### Dev / Standalone Key

1. Create the default folder where sops will look for an age key.
2. Create an age key with `age-keygen` specifying the output to the folder we just created.

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

> [!IMPORTANT]
> Your private key is inside this keys.txt so be careful!
> I would suggest backing up your private key in a secure manor.

3. Copy your public key

   - This should have been printed to the terminal and if not it is in the `keys.txt` file we just created.
   - You can also run `age-keygen -y ~/.config/sops/age/keys.txt`

4. Go to or [create](#the-sopsyaml-file) your `.sops.yaml` file and add it in.

   - I added it in as user "dev"

### Age key derived from SSH key

Verify that the SSH keys you want to use are made and you can access them both and you have the `ssh-to-age` package. I will be using the SSH key pair made for the host at `/etc/ssh/` named `ssh_host_ed225519_key`.

1. Cat the contents of your public key to `ssh-to-age`

```sh
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

2. Go to or [create](#the-sopsyaml-file) your `.sops.yaml` file and add it in.

   - I added it in under host and with its `$HOSTNAME` as the name

### The .sops.yaml File

This is the configuration file that sops uses to know what public keys to use to encrypt the secrets file and the corresponding private key to decrypt the file.

This is done in [yaml](https://yaml.org/) syntax.

1. Create `.sops.yaml` file

```sh
nano .sops.yaml
```

2. Add your public age keys under the `keys:` list.
   - I like to add `&users` and `&hosts` and then the keys.

```yaml
keys:
  - &users:
    - &dev age1lvyvwawkr0mcnnnncaghunadrqkmuf9e6507x9y920xxpp866cnql7dp2z
  - &hosts:
    - &HOSTNAME age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
```

4. Add `creation_rules:` onto the file and under it add the `path_regex:` with a path to the secrets file relative to the `.sops.yaml` file.

```yaml
keys:
  - &users:
    - &dev age1lvyvwawkr0mcnnnncaghunadrqkmuf9e6507x9y920xxpp866cnql7dp2z
  - &hosts:
    - &HOSTNAME age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
creation_rules:
  - path_regex: host-secrets.yaml$
```

5. Then add the `key_groups:` under `creation_rules:`.

```yaml
keys:
  - &users:
    - &dev age1lvyvwawkr0mcnnnncaghunadrqkmuf9e6507x9y920xxpp866cnql7dp2z
  - &hosts:
    - &HOSTNAME age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
creation_rules:
  - path_regex: host-secrets.yaml$
    key_groups:
    - age:
```

6. Now add `age:` under `key_groups:`. This list will be all of the keys that can encrypt and decrypt the given secrets file so add in at least the `dev` key from before.

> [!TIP]
> Since we used "&" on the `dev:` entry at the top we can just use `*dev` everywhere else in the file. This is part of the yaml syntax.

```yaml
keys:
  - &users:
    - &dev age1lmj6qd3775er4hnnxh6qf74ndjs3yrueny25kjczqrkc2uyq4chqmwwtya
  - &hosts:
    - &HOSTNAME age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
creation_rules:
  - path_regex: host-secrets.yaml$
    key_groups:
    - age:
      - *dev
      - *HOSTNAME
```

7. Add as many keys you would like under the key_groups

> [!NOTE]
> To add other secrets files like I use just add a new `path_regex:` and its `key_group:` list.

______________________________________________________________________

## SOPS Secrets Files

To open sops encrypted files we need to use the `sops` command with the relative path to the file. SOPS also needs the `.sops.yaml` we just created so make sure you are running `sops` from where ever you `.sops.yaml` is or specify it in the command with `--config VALUE`.

```sh
sops hosts-secrets.yaml
```