# Off-site backup target for our NAS at home.
{
  config,
  pkgs,
  ...
}: let
  pool = "pool";
  target = "${pool}/nas";
in {
  boot.supportedFilesystems.zfs = true;
  boot.zfs.extraPools = [pool];
  boot.zfs.forceImportRoot = false;

  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # Syncoid on NAS connects to baobab via SSH and invokes a shell command that
  # needs mbuffer.
  environment.systemPackages = [pkgs.mbuffer];

  users.groups.syncoid = {};
  users.users.syncoid = {
    isSystemUser = true;
    group = "syncoid";
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYJyIttgkKAIolfbA/JMtmt97Gu1tiOAoSTz7484mw8 root@nas"
    ];
  };

  # Declarative way to `zfs allow` some stuff for the syncoid user. Probably
  # a bit of an overkill but Idunno this sounds easy to forget if I have to
  # recreate the pool from scratch in the future ^^
  systemd.services.syncoid-zfs-allow = {
    description = "Delegate ZFS receive permissions to the syncoid user";
    after = ["zfs.target"];
    wantedBy = ["multi-user.target"];
    path = [config.boot.zfs.package];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = "zfs allow -u syncoid receive:append,create,mount,hold,release ${target}";
  };

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
}
