{
  pkgs,
  userSettings,
  ...
}:

let

  #TODO finish this service
  # SOPS file
  sops = {
    url = "";
    oidc = {
      id = "";
      secret = "";
    };
  };

in
{
  services.freshrss = {
    enable = true;
    package = pkgs.freshrss;
    baseUrl = sops.url;
    dataDir = "/var/lib/freshrss";
    authType = "http_auth";
    defaultuser = userSettings.username;
    passwordFile = ""; # SOPS file
  };

  environment.sessionVariables = {
    TRUSTED_PROXY = "10.1.0.0/16";
    OIDC_ENABLED = 1;
    OIDC_PROVIDER_METADATA_URL = "https://${sops.url}/application/o/freshrss/.well-known/openid-configuration";
    OIDC_CLIENT_ID = sops.oidc.id;
    OIDC_CLIENT_SECRET = sops.oidc.secret;
    OIDC_X_FORWARDED_HEADERS = "X-Forwarded-Port X-Forwarded-Proto X-Forwarded-Host";
    OIDC_SCOPES = "openid email profile";
  };

}
