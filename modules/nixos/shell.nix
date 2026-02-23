{pkgs, ...}: {
  programs.zsh.enable = true;

  users.users.root.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    alejandra
    difftastic
    file
    git
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
    vim
    wget
    zopfli
  ];
}
