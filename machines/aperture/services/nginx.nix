{ lib, pkgs, config, ... }:
let
  forgejo = config.services.forgejo.settings;
  vaultwarden = config.services.vaultwarden.config;
in
{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "bitwarden.barovia.local".extraConfig = ''
        encode zstd gzip

        reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
            header_up X-Real-IP {remote_host}
        }
      '';
    };
  };
  services.nginx = {
    enable = false;
    statusPage = true;
    virtualHosts = {

      "adguard.barovia.local" = {
        forceSSL = false;
        enableACME = false;
        locations."/".proxyPass = "http://localhost:3000";
      };

      ${forgejo.server.DOMAIN} = {
        forceSSL = false;
        enableACME = false;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/".proxyPass = "http://localhost:${toString forgejo.server.HTTP_PORT}";
      };

      "home.barovia.local" = {
        forceSSL = false;
        enableACME = false;
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
        };
      };

      # NOTE: services.nextcloud already used nginx!

      # 404 those that don't match
      "_" = {
        default = true;
        locations."/" = {
          return = "404";
        };
      };
    };
  };
}
