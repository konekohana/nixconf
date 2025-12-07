{...}: {
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpYgq5u3+JV/lBCtWXU2+MSl0S1CDrHVDBUwy3rYHH8 hana@arch"
  ];

  users.users.hana.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpYgq5u3+JV/lBCtWXU2+MSl0S1CDrHVDBUwy3rYHH8 hana@arch"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
