{pkgs, ...}: {
  programs.fastfetch = let
    logo = pkgs.writeText "lix-logo" ''
              $1◢██◣      $2◥███◣  ◢██◣
              $1◥███◣      $2◥███◣◢███◤
               $1◥███◣      $2◥██████◤
           $1◢█████████████◣ $2◥████◤
          $1◢███████████████◣ $2◥███◣    $3◢◣
                             $2◥███◣  $3◢██◣
              $2◢███◤           $2◥██◤ $3◢███◤
             $2◢███◤             $2◥◤ $3◢███◤
      $2◢█████████◤                $3◢████████◣
      $2◥████████◤                $3◢█████████◤
          $2◢███◤ $4◢◣             $3◢███◤
         $2◢███◤ $4◢██◣           $3◢███◤
         $2◥██◤  $4◥███◣
          $2◥◤    $4◥███◣ $2◥███████████████◤
                $4◢████◣ $2◥█████████████◤
               $4◢██████◣      $2◥███◣
              $4◢███◤◥███◣      $2◥███◣
              $4◥██◤  ◥███◣      $2◥██◤
    '';
  in {
    enable = true;
    settings = {
      logo = {
        source = logo;
        type = "file";
        padding = {
          top = 0;
          left = 3;
          right = 3;
        };
        color = {
          # The original Lix logo is themed after the lesbian flag and looks
          # great on a light background, but I had to desaturate the colors
          # a bit for it to look good in terminal as well.
          "1" = "#d362a4"; #d362a4
          "2" = "#d54620"; #d52d00
          "3" = "#a3206e"; #a30262
          "4" = "#ff9a56"; #ff9a56
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "display"
        "bios"
        "btrfs"
      ];
    };
  };
}
