{ pkgs, config, ... }:
{
  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
    settings = {
      vim.lsp = {
        enable = true;
        inlayHints.enable = false;
        lspconfig.enable = true;

        mappings = {
          format = "<F3>";
          codeAction = null;
        };

        servers."*" = {
          root_markers = [ ".git" ];
          capabilities.textDocument.semanticTokens.multilineTokenSupport = true;
        };
        servers."nixd" = {
          enable = true;
          filetypes = [ "nix" ];
        };
      };

      vim.theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
      };

      vim.utility = {
        leetcode-nvim = {
          setupOpts.image_support = true;
          enable = true;
        };
        images.image-nvim.enable = true;
      };

      vim.dashboard.alpha = {
        enable = true;
      };

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
        undotree = {
          package = pkgs.vimPlugins.undotree;
          setup = # lua
            "vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)";
        };
        smear-cursor = {
          package = pkgs.vimPlugins.smear-cursor-nvim;
          setup = # lua
            ''
              require("smear_cursor").setup {
                -- stiffness = 0.5,
                -- trailing_stiffness = 0.5,
                -- damping = 0.67,
                -- matrix_pixel_threshold = 0.5,
                smear_insert_mode = false,
                scroll_buffer_space = true,
                legacy_computing_symbols_support = true,
              }'';
        };
      };

      vim.telescope = {
        enable = true;
        setupOpts.defaults.path_display = [
          "smart"
          "truncate"
        ];
      };

      vim.statusline.lualine.enable = true;

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

        "clang" = {
          enable = true;
          lsp.enable = true;
        };

        "csharp" = {
          enable = true;
          lsp.enable = true;
        };

        "bash" = {
          enable = true;
          lsp.enable = false;
          treesitter.enable = true;
        };
      };

      vim.extraPackages = with pkgs; [
        nixd
        nil
        fzf
        ueberzugpp
        clang-tools
      ];
    };
  };
}
