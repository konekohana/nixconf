{pkgs, ...}: {
  imports = [
    ../../../modules/home/shell.nix
  ];

  home.username = "hana";
  home.homeDirectory = "/home/hana";

  home.stateVersion = "25.05";
}
