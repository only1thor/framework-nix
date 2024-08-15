{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # pin to a specific commit to wait for upstream conflict with nixpkgs to be resolved
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # Add home-manager as an input
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure we're using the same nixpkgs version
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager,... }@inputs: rec{
    # This instantiates nixpkgs for each system listed
    # Allowing you to configure it (e.g. allowUnfree)
    # Our configurations will use these instances
    legacyPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" "x86_64-darwin" ] (system:
      import inputs.nixpkgs {
        inherit system;
        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

        config.allowUnfree = true;
      }
    );
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
         ./configuration.nix
          "${nixos-hardware}/framework/13-inch/12th-gen-intel"
          # Include the Home Manager module
          home-manager.nixosModules.home-manager
          {
            # use the global pkgs that is configured via the system level nixpkgs options. 
            # This saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH, 
            # which is otherwise used for importing Nixpkgs.
            # (and should save some disk space?)
            home-manager.useGlobalPkgs = true;

            # set packages to be installed to /etc/profiles, for nixos-rebuild build-vm support.
            # (this may become the upstream default value in the future)
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup"; # required i guess..
          }
        ];
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
