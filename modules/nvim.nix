{ pkgs, config, ... }:
{
  # Only enable T*pescr*pt language server in work profile
  specialisation.work.configuration = {
    programs.nvf.settings.vim = {
      languages = {
        "ts" = {
          enable = true;
          extensions = {
            ts-error-translator.enable = true;
          };
          extraDiagnostics.enable = true;
        };
      };
    };
  };

  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
    settings = import ./nvim-configuration.nix { inherit pkgs; };
  };
}
