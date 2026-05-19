# https://nixos.org/manual/nixos/stable/index.html#module-services-nextcloud-basic-usage
{pkgs, ...}: rec {
  services.nextcloud = {
    enable = true;
    occ = true;
    package = pkgs.nextcloud33;
    hostName = "nextcloud.local";
    config = {
      adminuser = "admin";
      adminpassFile = "${pkgs.writeText "nextcloud-admin-pass" "admin"}";
      dbtype = "sqlite";
    };
  };

  # Weird hacky way to make the underlying nginx server `listen 127.0.0.1 80;`
  # https://nginx.org/en/docs/http/ngx_http_core_module.html#listen
  #
  # This might break any time with upstream changes but I won't need it for long.
  services.nginx.virtualHosts."${services.nextcloud.hostName}".listenAddresses = ["127.0.0.1"];
}
