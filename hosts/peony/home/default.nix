{pkgs, ...}: {
  imports = [
    ./zed.nix
    ./zsh.nix
  ];

  home.username = "hana";
  home.homeDirectory = "/home/hana";

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${./lix-logo.txt}";
        type = "file";
        padding = {
          top = 1;
          left = 3;
          right = 3;
        };
        color = {
          # The original Lix logo is themed after the lesbian flag and looks
          # great on a light background, but I had to desaturate the colors
          # a bit for it to look good in terminal as well.
          "1" = "#d362a4"; #d362a4
          "2" = "#d54620"; #d52d00
          "3" = "#a3206e"; #a30262
          "4" = "#ff9a56"; #ff9a56
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "display"
        "bios"
        "btrfs"
        "localip"
        "publicip"
        "battery"
        "bluetooth"
        "sound"
        "wifi"
      ];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    speedcrunch
    #(writeShellScriptBin {
    #  name = "fwpower";
    #  runtimeInputs = [ lazydocker ]; # what does this do??
    #  text = builtins.readFile ./lzd;
    #})
  ];

  home.file = {
    ".config/nixpkgs/config.nix".text = ''{ allowUnfree = true; }'';
  };

  home.sessionVariables = {
    GIT_EXTERNAL_DIFF = "difft";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # disable the goofy overscroll animation (thanks Max!)
        "apz.overscroll.enabled" = false;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Hana Volků";
      user.email = "volek@adamv.cz";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
      commit.gpgsign = true;
      user.signingkey = "7566D5D1583FA5DD7E6E967EF5F055EA76CF32C3";
    };
  };

  home.stateVersion = "24.11";
}
