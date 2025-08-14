{ lib, pkgs, config, ... }:
let
  forgejo = config.services.forgejo.settings;
in
{
  services.nginx = {
    enable = true;
    statusPage = true;
    virtualHosts = {

      "adguard.barovia.local" = {
        forceSSL = false;
        enableACME = false;
        extraConfig = ''
          client_max_body_size 512M;
        '';
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
