{pkgs, ...}: {
  imports = [
    ../../../modules/home/shell.nix
    ./git.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "26.05";
}
