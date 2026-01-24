{pkgs, ...}: let
  inherit (pkgs) lib;
in {
  vim.lsp = {
    enable = true;
    inlayHints.enable = false;
    lspconfig.enable = true;

    mappings = {
      format = "<F3>";
      codeAction = null;
    };

    servers."*" = {
      root_markers = [".git"];
      capabilities.textDocument.semanticTokens.multilineTokenSupport = true;
    };

    servers."nil" = {
      nix.flake = {
        "autoArchive" = true;
        "autoEvalInputs" = true;
      };
    };

    servers."nixd" = {
      enable = true;
      filetypes = ["nix"];
    };
  };

  vim.enableLuaLoader = true;

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
    images.img-clip = {
      enable = true;
      setupOpts = {
        keys = [
          {
            _1 = "<leader>p";
            _2 = "<cmd>PasteImage<cr>";
            desc = "Paste image from system clipboard";
          }
        ];
      };
    };
  };

  vim.dashboard.alpha = {
    enable = true;
  };

  vim.autocomplete.blink-cmp = {
    enable = true;
    setupOpts = {
      keyword.range = "full";
      accept.auto_brackets = true;
      completion = {
        list.selection = {
          preselect = false;
          auto_insert = true;
        };
        ghost_text.enable = false;
      };
      signature.enable = false;
    };
  };

  vim.undoFile.enable = true;
  vim.searchCase = "smart";
  vim.visuals.fidget-nvim = {
    enable = true;
  };

  vim.notes.todo-comments = {
    enable = true;
    mappings = {
      trouble = null;
    };
  };

  vim.keymaps = [
    {
      key = "<leader>la";
      mode = ["n"];
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
      setup =
        # lua
        "vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)";
    };
    smear-cursor = {
      package = pkgs.vimPlugins.smear-cursor-nvim;
      setup =
        # lua
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
    render-markdown = {
      package = pkgs.vimPlugins.render-markdown-nvim;
      setup =
        # lua
        ''
          require("render-markdown").setup {}
        '';
    };
  };

  vim.debugger.nvim-dap = {
    enable = true;
    ui.enable = true;
    sources = {
      lldb =
        #lua
        ''
          require("dap").adapters.codelldb = {
            type = "server",
            port = "''${port}",
            executable = {
              command = "${pkgs.lldb}/bin/lldb-dap",
              args = { "--port", "''${port}" },
            },
          }
        '';
    };
  };

  vim.telescope = {
    enable = true;
    setupOpts.defaults.path_display = [
      "smart"
      "truncate"
    ];
    extensions = [
      {
        name = "lsp_handlers";
        packages = [
          (pkgs.vimUtils.buildVimPlugin {
            name = "telescope-lsp-handlers";
            src = pkgs.fetchFromGitHub {
              owner = "gbrlsnchs";
              repo = "telescope-lsp-handlers.nvim";
              rev = "de02085d6af1633942549a238bc7a5524fa9b201";
              sha256 = "sha256-AgwzHr2UmwwqzlXlmQPLxdf6+EX6frvA2FJ/aJKSN3w=";
            };
          })
        ];
        setup = {
          code_action = {
            telescope = pkgs.lib.generators.mkLuaInline "require('telescope.themes').get_dropdown({})";
          };
        };
      }
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

  vim.autocmds = [
    {
      enable = true;
      command =
        # vim
        ''lua vim.highlight.on_yank{higroup='IncSearch', timeout=100}'';
      event = [
        "TextYankPost"
      ];
      pattern = [
        "*"
        "silent!"
      ];
    }
  ];

  # shit broken
  # vim.formatter.conform-nvim.formatters.<formatter_name>.command
  # vim.formatter.conform-nvim.formatters = {
  #   "alejandra".command = lib.getExe pkgs.alejandra;
  # };
  vim.formatter.conform-nvim.enable = lib.mkForce false;

  vim.languages = {
    enableFormat = true;
    enableTreesitter = true;

    "nix" = {
      enable = true;
      treesitter.enable = true;
    };

    "rust".enable = true;

    "clang" = {
      enable = true;
      lsp.enable = true;
    };

    "ts" = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
      extraDiagnostics.enable = true;
    };

    "svelte" = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
      extraDiagnostics.enable = true;
    };

    "tailwind" = {
      enable = true;
      lsp.enable = true;
    };

    "css" = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    # "csharp" = {
    #   enable = true;
    #   lsp.enable = true;
    #   lsp.package = [
    #     "csharp-ls"
    #     "-l"
    #     "error"
    #   ];
    # };

    "bash" = {
      enable = true;
      lsp.enable = false;
      treesitter.enable = true;
    };

    "markdown" = {
      enable = true;
      lsp.enable = false;
      treesitter.enable = true;
    };

    "lua" = {
      enable = true;
      lsp.enable = true;
    };

    "typst" = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    "qml" = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
  };

  vim.extraPackages = with pkgs; [
    nixd
    nil
    fzf
    ueberzugpp
    clang-tools
    lua-language-server
    ripgrep
    fd
    wl-clipboard
  ];
}
