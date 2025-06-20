{...}: {
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      url."https://git.spoodythe.one/".insteadOf = ["spoody:"];
      user = {
        name = "m1nix";
        email = "m1nix@mail.spoodythe.one";
      };
    };
  };
}
