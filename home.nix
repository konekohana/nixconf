{
  lib,
  pkgs,
  ...
}: {
  home.username = "hana";
  home.homeDirectory = "/home/hana";

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    #enableCompletion = true;
    #autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      zshConfig = lib.mkOrder 1000 "source ~/.p10k.zsh";
    in
      lib.mkMerge [zshConfigEarlyInit zshConfig];

    # todo move the programs that I need for stuff in here to home manager config
    shellAliases = {
      #cargo = "cargo mommy";
      gdc = "git diff --cached";
      gsh = "git show --ext-diff";
      cp = "cp --reflink=auto";
      hddlist = ''printf "/dev/%s \n" $(lsblk -J -o name,rota | jq -r ".blockdevices[] | select(.rota).name")'';
      hddstate = "sudo hdparm -C $(hddlist)";
      hddstop = "sudo hdparm -y $(hddlist)";
    };

    history.size = 1000000000000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "virtualenv"
      ];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
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

  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [alejandra nil package-version-server];
    extensions = ["nix" "toml"];
    userSettings = {
      edit_predictions.mode = "subtle";
      features = {
        edit_prediction_provider = "copilot";
      };
      theme = {
        mode = "system";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      languages.Nix.formatter.external = {
        command = "alejandra";
        arguments = ["--quiet" "--"];
      };
    };
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
