{ ... }:
{
  programs.iamb = {
    enable = true;
    settings = {
      default_profile = "personal";
      profiles."personal" = {
        user_id = "@spoody:spoodythe.one";
      };
      layout.style = "restore";
      settings = {
        notifications.enabled = true;
        image_preview = {
          size = {
            height = 10;
            width = 66;
          };
        };
        user_gutter_width = 15;
        message_user_color = true;
        username_display = "displayname";
        users = {
          "@gags5:spoodythe.one" = {
            color = "light-red";
          };
          "@conduit:spoodythe.one" = {
            color = "green";
          };
        };
      };
    };
  };
}
