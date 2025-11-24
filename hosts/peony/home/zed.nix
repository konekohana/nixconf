{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      clang-tools # for clangd
      nil
      package-version-server
      rust-analyzer
      ruff
    ];
    extensions = ["nix" "toml"];
    userSettings = {
      edit_predictions.mode = "subtle";
      features = {
        edit_prediction_provider = "copilot";
      };
      theme = {
        mode = "system";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      languages.Nix.formatter.external = {
        command = "alejandra";
        arguments = ["--quiet" "--"];
      };
      languages."Plain Text" = {
        ensure_final_newline_on_save = false;
        format_on_save = "off";
      };
    };
  };
}
