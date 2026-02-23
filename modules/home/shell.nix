{
  lib,
  pkgs,
  ...
}: {
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

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

    shellAliases = {
      gdc = "git diff --cached";
      gsh = "git show --ext-diff";
      cd = "echo \"Hi Kimmy!\"; cd";
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
}
