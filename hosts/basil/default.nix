{
  config,
  lib,
  pkgs,
  nix-index-database,
  ...
}: {
  imports = [
    ./docker.nix
    ./podman.nix
    ./zscaler.nix
  ];

  programs.nix-index.package = nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    bubblewrap
    nodejs
    python3
    ruff
    rustup
    gcc
    gh
    pi-coding-agent
    (callPackage ../../packages/bpi {})
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  users.users.nixos.shell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
