
{ config, pkgs, ... }:
{
  security.pki.certificates = [ 
    (builtins.readFile ./ca-cert.pem) 
  ];
}
