{...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.users.hana.extraGroups = ["docker"];
}
