# Mirror of baobab's backup-target.nix. The backup on peony is meant to be pull
# based so no extra SSH configuration is necessary. Temporary until I get my
# desktop set up.
{
  config,
  pkgs,
  ...
}: let
  target = "laptopbackup/nas";
in {
  boot.supportedFilesystems.zfs = true;
  boot.zfs.forceImportRoot = false;
  networking.hostId = "84c07a31";

  # Needed for the syncoid CLI tool.
  environment.systemPackages = [pkgs.sanoid];

  services.sanoid = {
    enable = true;
    templates.replica = {
      autosnap = false;
      autoprune = true;
      hourly = 0;
      daily = 7;
      weekly = 4;
      monthly = 0;
      yearly = 0;
    };
    datasets.${target} = {
      useTemplate = ["replica"];
      recursive = true;
    };
  };

  # Skip sanoid runs of the pool is not imported.
  systemd.services.sanoid.serviceConfig.ExecCondition = "${config.boot.zfs.package}/sbin/zfs list -H -o name ${target}";
}