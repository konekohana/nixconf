{...}: {
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    # TODO: change this to "check" to see undeclared stuff. Declare what's
    # needed and delete what's not and then probably set this to "uninstall"
    # or "zap"? Idk what the difference is look at this:
    # https://mynixos.com/nix-darwin/option/homebrew.onActivation.cleanup
    onActivation.cleanup = "none";

    # TODO flip this on once I actually declare some homebrew setup.
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;
  };
}
