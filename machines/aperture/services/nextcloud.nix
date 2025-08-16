{ config, pkgs, ... }:

{
  imports = [
    "${fetchTarball {
      url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
      sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  ];

  environment.etc."nextcloud-admin-pass".text = "defaultpassword123";
  services.nextcloud = {
    enable = true;
    webserver = "caddy";
    package = pkgs.nextcloud31;
    hostName = "nextcloud.barovia.local";
    # TODO: database.createLocally = true;
    config = {
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
      # TODO: Swap to postgres
      # dbtype = "pgsql";
    };
    settings = {
      trusted_domains = [ "192.168.0.*" ];
    };
    # autoUpdateApps = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;
  };
}
