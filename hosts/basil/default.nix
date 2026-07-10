{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./docker.nix
    ./podman.nix
    ./zscaler.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    bubblewrap
    gh
    pi-coding-agent
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  users.users.nixos.shell = pkgs.zsh;

  system.stateVersion = "26.05";
}
