# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions =
      lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.plymouth.enable = true;
  boot.plymouth.logo = pkgs.fetchurl {
    url = "https://nixos.org/logo/nixos-hires.png";
    sha256 = "5117cfea79811fdd2f605ba9063bc7f2a2e610e1a5a26b863720821f4f7b7fc7";
  };
  networking.hostId = "476d182d";
  networking.firewall.allowedTCPPortRanges = [
    { from = 4000; to = 4001; }
    { from = 8000; to = 8080; }
    { from = 21; to = 23; }
  ];


  # Enable swap on luks
  boot.initrd.luks.devices."luks-335fb536-011f-4482-9515-6def690d79f5".device = "/dev/disk/by-uuid/335fb536-011f-4482-9515-6def690d79f5";
 
  # Enable ntfs filesystem support
  boot.supportedFilesystems = ["ntfs" "zfs"];

  networking.hostName = "framework"; # Define your hostname.

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

  # Enable the Gnome Desktop Environment with gdm login manager.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # enable mounting of Iphone
  services.usbmuxd.enable = true;

  # enable firmware updates with fwupd
  services.fwupd.enable = true;

  # enable logitech wireless hardware with solaar
  hardware.logitech.wireless.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = ",dvorak";
    options = "grp:win_space_toggle";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable Via qmk configureator udev stuff
  services.udev.packages = with pkgs; [
    qmk-udev-rules # what it says on the tin
  ];

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
  };

  programs.steam.enable = true;
  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tc = {
    isNormalUser = true;
    description = "tc";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "docker" "adbusers" "uucp" "tty" "dialout"];
    packages = with pkgs; [
      # add programs for user tc here
    ];
  };
  users.users.kvili = {
    isNormalUser = true;
    description = "Line";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "docker" "adbusers" "uucp"];
    packages = with pkgs; [
      google-chrome
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  services.tailscale.enable = true;
  # List packages installed in system profile. 
  # To search, run eg.:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    dua
    android-studio
    jdk17
    python3
    arduino
    wget
    netcat
    git
    htop
    gnome.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded
    gnome-extensions-cli
    anki
    pavucontrol
    gparted
    gthumb
    gimp
    inkscape
    lapce
    firefox
    chromium
    microsoft-edge
    vscode
    ffmpeg
    fwupd
    usbutils
    yt-dlp
    vlc
    mpv
    upscayl
    openscad
    pinta
    marp-cli
    prusa-slicer
    signal-desktop
    steam
    solaar
    cura
    libreoffice
    libimobiledevice # enable mount Iphone
    ifuse # optional, to mount using 'ifuse'
    qmk
    transmission-gtk
    tailscale
    virt-manager
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

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
