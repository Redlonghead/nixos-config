{ configVars, ... }:

{
  i18n.defaultLocale = configVars.systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = configVars.systemSettings.locale;
    LC_IDENTIFICATION = configVars.systemSettings.locale;
    LC_MEASUREMENT = configVars.systemSettings.locale;
    LC_MONETARY = configVars.systemSettings.locale;
    LC_NAME = configVars.systemSettings.locale;
    LC_NUMERIC = configVars.systemSettings.locale;
    LC_PAPER = configVars.systemSettings.locale;
    LC_TELEPHONE = configVars.systemSettings.locale;
    LC_TIME = configVars.systemSettings.locale;
  };
}
