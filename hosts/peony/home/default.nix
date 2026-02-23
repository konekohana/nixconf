{pkgs, ...}: {
  imports = [
    ../../../modules/home/shell.nix
    ./fastfetch.nix
    ./zed.nix
    scripts/fwpower.nix
    scripts/train-toolbar.nix
  ];

  home.username = "hana";
  home.homeDirectory = "/home/hana";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    speedcrunch
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
      user.name = "Hana Volková";
      user.email = "volek@adamv.cz";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
      commit.gpgsign = true;
      user.signingkey = "7566D5D1583FA5DD7E6E967EF5F055EA76CF32C3";
    };
  };

  home.stateVersion = "24.11";
}
