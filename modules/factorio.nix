{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (factorio.overrideAttrs (_: {
      meta.platforms = ["aarch64-linux"];
      actual = {
        candidateHashFilenames = [
          "factorio_linux_2.0.45.tar.xz"
        ];
        name = "factorio_alpha_x64-2.0.45.tar.xz";
        needsAuth = true;
        sha256 = "32b004a648dfc8b8e2bb6b82f648e5be458a13b7fefad79487a1d663c6f3b711";
        tarDirectory = "x64";
        url = "https://factorio.com/get-download/2.0.45/alpha/linux64";
        version = "2.0.45";
      };
    }))
  ];
}
