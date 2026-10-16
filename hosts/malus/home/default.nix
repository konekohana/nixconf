{username, ...}: {
  imports = [
    ../../../modules/home/shell.nix
    ../../../modules/home/git-work.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Extra variables for stuff not managed by Nix.
  # TODO look into making some of those managed by nix.
  home.sessionVariables.PROTO_HOME = "$HOME/.proto";
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.docker/bin"
    "$HOME/.proto/shims"
    "$HOME/.proto/bin"
  ];

  # system.defaults.screencapture sets the screencapture folder (in
  # ../macos.nix) but we need to actually create the folder otherwise
  # the files end up on desktop anyway
  home.file."Pictures/Screenshots/.keep".text = "";

  home.stateVersion = "26.05";
}
