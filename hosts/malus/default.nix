{
  pkgs,
  username,
  nix-index-database,
  ...
}: {
  imports = [
    ./macos.nix
    ./homebrew.nix
    ./shell.nix
    ../../modules/nixos/zscaler.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  programs.nix-index.package = nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;

  # TODO maybe just activate nix-command and flakes for all hosts at this point?
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Should hopefully be unnecessary in the future? But needed for now as
  # nix-darwin devs are figuring out the future multi-user reorganization.
  # https://github.com/nix-darwin/nix-darwin/blob/4cff07de74/modules/system/primary-user.nix#L13
  system.primaryUser = "hana.volkova";

  # The user is not managed by nix but home manager still needs to know the home.
  users.users."hana.volkova".home = "/Users/hana.volkova";

  # touch ID for sudo yay
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  environment.systemPackages = with pkgs; [
    cargo-insta
    gh
    nats-server
    natscli
    nodejs
    pi-coding-agent
    protobuf
    python3
    ruff
    rustup
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg # For terminal
  ];

  # bump only after reading `darwin-rebuild changelog`
  system.stateVersion = 7;
}
