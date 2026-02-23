# todo
# htop config (home manager)
#   show path name by default (can be switched using the `p` key when htop is running)
#   https://github.com/htop-dev/htop/issues/519#issuecomment-775492551
# display calibration https://wiki.archlinux.org/title/Framework_Laptop_13_(AMD_Ryzen_7040_Series)#Display
# easyeffects
#   https://wiki.archlinux.org/title/Framework_Laptop_13_(AMD_Ryzen_7040_Series)#Speakers
#   https://autoeq.app/
#   basically I want to copy the easyeffects setup I had in Arch
# fwupd https://wiki.archlinux.org/title/Framework_Laptop_13_(AMD_Ryzen_7040_Series)#Firmware
{pkgs, ...}: {
  imports = [
    ./network.nix
    ./syncthing.nix
    ./hardware.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.tmp.useTmpfs = true;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  virtualisation.virtualbox.host.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = ["cs_CZ.UTF-8/UTF-8"];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "hana";
  };

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [pkgs.mutter];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    wireplumber.package = pkgs.wireplumber.overrideAttrs (prev: {
      version = "0.5.12";
      src = prev.src.override {
        rev = "0.5.12";
        hash = "sha256-3LdERBiPXal+OF7tgguJcVXrqycBSmD3psFzn4z5krY=";
      };
    });
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hana = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
    home = "/home/hana";
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.gnupg.agent.enable = true;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    cargo
    discord
    easyeffects
    element-desktop
    ffmpeg-full # todo find out the difference between this and ffmpeg
    fluffychat
    fw-ectool
    gcc
    gimp
    gnomeExtensions.appindicator
    gnomeExtensions.executor
    gnomeExtensions.freon
    gnomeExtensions.launch-new-instance
    gnomeExtensions.system-monitor-next
    gnome-terminal
    gnome-tweaks
    gnupg
    gnuplot
    libreoffice
    lm_sensors
    losslesscut-bin
    nixd
    nix-index
    obsidian
    opencode
    python3
    rustc
    spotify
    telegram-desktop
    vlc
    vscode
    webcord
    wifi-qr
    wl-clipboard
    zed-editor
    (olympus.override {
      celesteWrapper = pkgs.steam-run;
      skipHandlerCheck = true;
    })
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    fira-code
    fira-mono
    fira-code-symbols
  ];

  nixpkgs.config.allowUnfree = true;

  # todo switch to chrony
  services.ntp.enable = true;

  # In order to enable discovery of Google Cast devices (and possibly other
  # Spotify Connect devices) in the same network by the Spotify app, you need
  # to open UDP port 5353 by adding the following line to your configuration.nix:
  # https://nixos.wiki/wiki/Spotify
  networking.firewall.allowedUDPPorts = [5353];

  # Do not change unless you understand exactly what the option does.
  # man configuration.nix
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
