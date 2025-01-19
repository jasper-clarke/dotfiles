{ inputs
, user
, pkgs
, system
, config
, ...
}: {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.tridactyl-native ];
    profiles.${user} = {
      isDefault = true;
      settings = {
        "browser.display.background_color" = config.lib.stylix.colors.base00;
        "browser.bookmarks.autoExportHTML" = true;
        "browser.bookmarks.visibility" = "never";
        "browser.aboutConfig.showWarning" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "devtools.debugger.prompt-connection" = false;
      };
      userChrome = builtins.readFile ./config/firefox/userChrome.css;
      userContent = builtins.readFile ./config/firefox/userContent.css;
      extensions = with inputs.firefox-addons.packages.${system}; [
        bitwarden
        darkreader
        ublock-origin
        tridactyl
      ];
      search = {
        default = "DuckDuckGo";
        force = true;
      };
    };
  };
}
