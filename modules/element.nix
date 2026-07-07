_: {
  programs.element-desktop = {
    enable = true;
    settings = {
      default_server_config = {
        "m.homeserver" = {
          base_url = "https://matrix.spoodythe.one";
          server_name = "spoodythe.one";
        };
        "m.identity_server" = {
          base_url = "https://matrix.org";
        };
      };
      brand = "Matrix";
      integrations_ui_url = "";
      integrations_rest_url = "";

      disable_custom_urls = true;
      disable_guests = true;
      disable_login_language_selector = true;
      disable_3pid_login = false;

      force_verification = true;
    };
  };
}
