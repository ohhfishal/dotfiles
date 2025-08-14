{ config, pkgs, ... }:

{
  environment.etc."nextcloud-admin-pass".text = "defaultpassword123";
  services.nextcloud = {
    enable = true;
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
