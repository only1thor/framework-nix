# Top 5 commands to stay updated

[what are the top 5 commands i need for keeping my nixOS system up to date?](https://www.phind.com/search?cache=x57nb7z8ffek1hwezmfx5l0f)

Answer | GPT-3.5-Turbo Model


To keep your NixOS system up to date, you can use the following commands:

1. `nix-channel --update`: This command updates the NixOS channels on your system. NixOS channels are a mechanism for distributing Nix expressions and associated binaries. By updating the channels, you ensure that your system is pulling the latest updates and package upgrades.

2. `nixos-rebuild switch`: This command rebuilds and activates the NixOS system configuration. It applies any changes you have made to the configuration files and ensures that your system is up to date with the latest configuration changes.

3. `nix-env --upgrade`: This command upgrades all user-installed packages on your system. It updates packages to their latest versions, ensuring that you have the most recent features and bug fixes.

4. `nix-collect-garbage -d`: This command collects garbage and removes old generations of packages. It helps to free up disk space by removing unused packages and generations of NixOS installations.

5. `nix-channel --list`: This command lists the available NixOS channels on your system. It shows the channels you have subscribed to and helps you verify that you are using the desired channels for updates.

Remember to run these commands with appropriate privileges (e.g., using `sudo`) if required.

It's important to note that these commands are just a subset of the available NixOS maintenance commands. You can explore the NixOS manual and documentation for more advanced commands and options.

sources:
[NixOS Manual - Upgrading NixOS](https://nixos.org/manual/nixos/stable/#sec-upgrading-nixos)
[NixOS Anywhere - Quickstart Guide](https://github.com/nix-community/nixos-anywhere#quickstart-guide)

## Personal experice:
```bash
sudo nix-channel --update
sudo nixos-rebuild switch
sudo nix-env --delete-generations 1d
sudo nix-collect-garbage --delete-older-than 1d
```

### Finding gnome settings to define in home manager:
```bash
dconf dump / > before.txt
# change setting in UI
dconf dump / > after.txt
# diff files and add to "dconf.settings" in home manager config.
```
