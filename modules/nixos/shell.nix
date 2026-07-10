{pkgs, ...}: {
  programs.zsh.enable = true;

  users.users.root.shell = pkgs.zsh;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    alejandra
    difftastic
    file
    git
    git-lfs
    gnumake
    hdparm
    htop
    jq
    lz4
    moreutils
    ncdu
    powertop
    pv
    tig
    wget
    zopfli
  ];
}
