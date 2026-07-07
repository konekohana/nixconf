{...}: {
  virtualisation.docker.enable = true;

  users.users.nixos.extraGroups = ["docker"];
}
