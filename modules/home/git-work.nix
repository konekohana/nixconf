{
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    GIT_EXTERNAL_DIFF = lib.getExe pkgs.difftastic;
  };

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    settings = {
      user.name = "Hana Volková";
      user.email = "hana.volkova@rockwellautomation.com";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
      rebase.autosquash = true;
    };
  };
}
