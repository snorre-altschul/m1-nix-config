{ pkgs, ... }: {
  programs.nvf = {
    enable = true;
    settings = {
      vim.lsp = {
        enable = true;
        servers."nil_ls" = {
          enable = true;
          filetypes = [ "nix" ];
        };
      };

      vim.theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };

      vim.telescope.enable = true;

      vim.binds.whichKey.enable = true;

      vim.visuals.cellular-automaton.enable = true;

      vim.treesitter = {
        enable = true;
        highlight.enable = true;
      };

      vim.options = {
        shiftwidth = 2;
        tabstop = 2;
        scrolloff = 8;
      };

      vim.languages = {
        enableFormat = true;
        enableTreesitter = true;

        "nix" = {
          enable = true;
          treesitter.enable = true;
        };
      };
    };
  };
}
