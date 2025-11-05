_: {
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      url."forgejo@git.spoodythe.one:".insteadOf = ["spoody:"];
      user = {
        name = "spoody";
        email = "m1nix@mail.spoodythe.one";
      };
    };
  };
}
