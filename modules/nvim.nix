{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim.lsp = {
        enable = true;
        inlayHints.enable = false;
        lspconfig.enable = true;

        mappings.format = "<F3>";

        servers."*" = {
          root_markers = [ ".git" ];
          capabilities.textDocument.semanticTokens.multilineTokenSupport = true;
        };
        servers."nixd" = {
          enable = true;
          filetypes = [ "nix" ];
        };
      };

      vim.theme.enable = true;

      vim.autocomplete.blink-cmp.enable = true;

      vim.undoFile.enable = true;

      vim.searchCase = "smart";

      vim.visuals.fidget-nvim = {
        enable = true;
      };

      vim.keymaps = [
        {
          key = "<leader>la";
          mode = [ "n" ];
          action = ''require("actions-preview").code_actions'';
          lua = true;
          silent = true;
          desc = "Code action";
        }
      ];

      vim.extraPlugins = {
        actions-preview = {
          package = pkgs.vimPlugins.actions-preview-nvim;
        };
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
          format = {
            package = pkgs.nixfmt-rfc-style;
            type = "nixfmt";
          };
        };

        "ts" = {
          enable = true;
          extensions = {
            ts-error-translator.enable = true;
          };
          extraDiagnostics.enable = true;
        };
        "rust".enable = true;
      };

      vim.extraPackages = with pkgs; [
        nixd
        nil
      ];
    };
  };
}
