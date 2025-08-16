{ lib, pkgs, config, ... }:
let
  forgejo = config.services.forgejo.settings;
  vaultwarden = config.services.vaultwarden.config;
in
{
  services.nginx = {
    enable = true;
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

      "bitwarden.barovia.local" = {
        forceSSL = true;
        enableACME = false;
        locations."/".proxyPass = "http://localhost:${toString vaultwarden.ROCKET_PORT}";
        # NOTE: Have to manually add these files from
        sslCertificate = "/etc/ssl/certs/aperture.crt";
        sslCertificateKey = "/etc/ssl/private/aperture.key";
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
