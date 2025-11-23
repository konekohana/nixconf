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
{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  nixpkgs.config.permittedInsecurePackages = ["electron-36.9.5"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "peony"; # Define your hostname.

  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    wifi.backend = "iwd";
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.AddressRandomization = "network";
      General.Country = "CS";
      Settings.AutoConnect = true; # https://unix.stackexchange.com/a/623037
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [pkgs.mutter];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };

  # todo learn what exactly the services.xserver options
  # do, because… I don't run X server at all afaik?
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape,grp:win_space_toggle";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
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

  # NTK vpn
  environment.etc = let
    conn = (pkgs.formats.ini {}).generate "NTK.nmconnection" {
      connection = {
        id = "NTK";
        uuid = "1dae7053-5c20-46e4-b966-bc7dba8947ce";
        type = "vpn";
        autoconnect = false;
        permissions = "user:hana:";
      };

      vpn = {
        ca = "${./NTK-ca.pem}";
        challenge-response-flags = 2;
        cipher = "AES-128-CBC";
        connection-type = "password";
        data-ciphers = "AES-128-CBC";
        dev = "tun";
        dev-type = "tun";
        password-flags = "1";
        remote = "vpn.techlib.cz:1194";
        remote-cert-tls = "server";
        username = "volkuh@ADMIN";
        service-type = "org.freedesktop.NetworkManager.openvpn";
      };

      ipv4.method = "auto";
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  in {
    "NetworkManager/system-connections/${conn.name}" = {
      source = conn;
      mode = "0600";
    };
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
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

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "hana";
    group = "users";
    configDir = "/home/hana/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        phone = {
          id = "N2XK34D-Y6HRJVH-AJYS6MH-XUZAF4Y-UOFPBUG-ZECJC5Y-JRM3Q3J-AJSNHAY";
          name = "Kočk Xperia 1 V";
        };
        nas = {
          id = "PY5VBZF-EGC5OPF-WDTCBG4-2MBZCK2-WD66ETA-T6WMOCC-CXIORH3-3J3K7AR";
          name = "NAS";
        };
        dawn-desktop = {
          id = "3M4GJYE-KCTH2GI-7XIC6IG-BKZ2TKI-HJTMVP3-UXBCFIY-CVJT2GQ-6VBF6QH";
          name = "PONI-CATTO";
        };
        dawn-phone = {
          id = "CLEC7MH-JMO7LCR-542RMDK-ABUGSDZ-2D5UJUK-6TSJT36-Q4IXTJM-NIUAGQI";
          name = "Dawn Pixel 6 Pro";
        };
      };

      folders = {
        "6zqvq-sn64z" = {
          label = "Kot";
          path = "${config.users.users.hana.home}/syncthing/Kot";
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "31";
          };
          devices = ["phone" "nas"];
        };
        "snekurr-shared" = {
          label = "Shared";
          path = "${config.users.users.hana.home}/syncthing/Shared";
          devices = ["phone" "nas" "dawn-desktop" "dawn-phone"];
        };
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3
    cargo
    rustc
    gcc
    pv
    tig
    obsidian
    nix-index
    lz4
    vim
    wget
    vscode
    discord
    bitwarden-desktop
    lm_sensors
    gimp
    git
    htop
    file
    fluffychat
    difftastic
    powertop
    gnupg
    gnome-tweaks
    gnome-terminal
    gnomeExtensions.executor
    gnomeExtensions.appindicator
    gnomeExtensions.freon
    gnomeExtensions.launch-new-instance
    gnomeExtensions.system-monitor-next
    gnumake
    gnuplot
    spotify
    jq
    hdparm
    powertop
    nixd
    element-desktop
    vlc
    webcord
    wifi-qr
    zsh
    telegram-desktop
    zed-editor
    zopfli
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
