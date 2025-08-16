{ config, pkgs, ... }:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/lib/backups/vaultwarden";
    # NOTE: Need to make this by hand
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
    config = {
      DOMAIN = "http://bitwarden.barovia.local";
      SIGNUPS_ALLOWED = true;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "info";

    };
  };
}
