# Basically a copy of modules/nixos/shell.nix because some stuff from there
# is Linux only. TODO look into a better way to organize shared shell setup
# that would let me do all of this in one file.
{pkgs, ...}: {
  programs.zsh.enable = true;

  environment.variables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    alejandra
    difftastic
    file
    git
    git-lfs
    gnumake
    htop
    jq
    lz4
    moreutils
    ncdu
    pv
    ripgrep
    shellcheck
    tig
    vim
    wget
    zopfli
  ];
}
