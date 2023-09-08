# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/framework/12th-gen-intel>  
      ./hardware-configuration.nix
    ];

  nix = {
   package = pkgs.nixFlakes;
   extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
     "experimental-features = nix-command flakes";
  };  


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  networking.hostId = "476d182d";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-983043a6-9eaf-404b-b709-dcdcc7efe9d1".device = "/dev/disk/by-uuid/983043a6-9eaf-404b-b709-dcdcc7efe9d1";
  boot.initrd.luks.devices."luks-983043a6-9eaf-404b-b709-dcdcc7efe9d1".keyFile = "/crypto_keyfile.bin";

  # Enable ntfs filesystem support
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;
  
  # Enable android development
  programs.adb.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
#  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.gdm.enable = true; 
#  services.xserver.desktopManager.lxqt.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # enable mounting of Iphone
  services.usbmuxd.enable = true;

  # enable logitech wireless hardware with solaar
  hardware.logitech.wireless.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tc = {
    isNormalUser = true;
    description = "tc";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "uucp"];
    packages = with pkgs; [
      slack
      
    ];
  };
  users.users.kvili = {
    isNormalUser = true;
    description = "Line";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "uucp" ];
    packages = with pkgs; [
      google-chrome
      
    ];
  };
  users.users.marscheck = {
    isNormalUser = true;
    description = "The Marschecks";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "adbusers" "uucp" ];
    packages = with pkgs; [
      google-chrome
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    dua
    arduino
    wget
    git
    htop
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gthumb
    gimp
    inkscape
    lapce
    firefox
    chromium
    vscode
    ffmpeg
    vlc
    mpv
    signal-desktop
    steam
    solaar
    cura
    libreoffice
    libimobiledevice # enable mount Iphone
    ifuse # optional, to mount using 'ifuse'
    transmission-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
