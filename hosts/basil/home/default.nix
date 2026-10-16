{pkgs, ...}: {
  imports = [
    ../../../modules/home/shell.nix
    ../../../modules/home/git-work.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  home.stateVersion = "26.05";
}
