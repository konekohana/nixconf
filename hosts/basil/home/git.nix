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
    signing.format = "openpgp";
    settings = {
      user.name = "Hana Volková";
      user.email = "hana.volkova@rockwellautomation.com";
      init.defaultBranch = "main";
      diff.algorithm = "histogram";
    };
  };
}
