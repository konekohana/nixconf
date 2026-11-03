{...}: {
  homebrew = {
    enable = true;
    enableZshIntegration = true;

    # Make sure that brew actually zaps everything I remove from here.
    onActivation.cleanup = "zap";

    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    taps = ["artginzburg/tap"];
    casks = [
      # Apps that aren't in nixpkgs
      "artginzburg/tap/wheelclick"
      "docker-desktop"

      # Apps that are in nixpkgs but are built from source. Those use an ad-hoc
      # signature that changes with each build which can caus issues, so I'm
      # installing the brew version of those instead.
      "caffeine"
      "zed"

      # This one is in nixpkgs and is not built from source but is broken -_-
      "linearmouse"
    ];
  };
}
