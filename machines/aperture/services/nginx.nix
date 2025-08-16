{ lib, pkgs, config, ... }:
let
  forgejo = config.services.forgejo.settings;
  vaultwarden = config.services.vaultwarden.config;
in
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "adguard.barovia.local".extraConfig = ''
        encode zstd gzip

        reverse_proxy :3000 {
            header_up X-Real-IP {remote_host}
        }
      '';

      "bitwarden.barovia.local".extraConfig = ''
        encode zstd gzip

        reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
            header_up X-Real-IP {remote_host}
        }
      '';

      ${forgejo.server.DOMAIN}.extraConfig = ''
        encode zstd gzip

        reverse_proxy :${toString forgejo.server.HTTP_PORT} {
            header_up X-Real-IP {remote_host}
        }
      '';

      # NOTE: services.nextcloud configured to use caddy

      # TODO: Handle 404's domain

    };
  };
}
