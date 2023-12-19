{
 

description = ''A flake that creates a devShell containing the following:
			- Nixvim (based on nixos-unstable)
            - NodeJS

		'';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      

	# Configure Neovim
	nvim = nixvim.legacyPackages.${system}.makeNixvim {
	
	globals.mapleader = " ";

        # Undo directory and set undodir to true(long-lasting undo tree)
        extraConfigLua = ''
		vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir";
		vim.opt.undofile = true;
        '';

	# Neovim basic options
	options = {

		# Show line numbers
		number = true;
		relativenumber = true;
		scrolloff = 8;

		# Tabs
		shiftwidth = 4;
		tabstop = 4;
		softtabstop = 4;
		expandtab = true;



		incsearch = true;

		colorcolumn = "80";

	};

	keymaps = [
		# My keymap

        # Normal mode
        
        # jump half a page and stay in the middle of the screen
        {
            mode = "n";
            key = "<C-d>";
            action = "<C-d>zz";
        }

        {
            mode = "n";
            key = "<C-u>";
            action = "<C-u>zz";
        }
        
        {
            mode = "n";
            key = "n";
            action = "nzzzv";
        }

        {
            mode = "n";
            key = "N";
            action = "Nzzzv";
        }

        {
            mode = "n";
            key = "<leader>y";
            action = "\"+y";
        }
        
        {
            mode = "n";
            key = "<leader>o";
            action = "o<Esc>";
        }
        
        {
            mode = "n";
            key = "<leader>O";
            action = "O<Esc>";
        }


        {
            mode = "n";
            key = "<leader>d";
            action = "\"_d";
        }


        {
            mode = "n";
            key = "Q";
            action = "<nop>";
        }
        
        {
            mode = "n";
            key = "<c-z>";
            action = "<nop>";
        }

        {
            mode = "n";
            key = "<leader>f";
            action = "function() vim.lsp.buf.format() end)";
        }

        {
            mode = "n";
            key = "<leader>k";
            action = "<cmd>lnext<CR>zz";
        }

        {
            mode = "n";
            key = "<leader>j";
            action = "<cmd>lprev<CR>zz";
        }

        # diagnostic go to next
        {
            mode = "n";
            key = "<C-k>";
            action = "<cmd>cnext<CR>zz";
        }

        # diagnostic go to prev
        { 
            mode = "n";
            key = "<C-k>";
            action = "<cmd>cprev<CR>zz";
        }

        {
            mode = "n";
            key = "<leader>s";
            action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
        }

		# Undotree
		{
            mode = "n";
            key = "<leader>u";
            action = "<cmd>UndotreeToggle<CR>";
            options = {
                silent = true;
                noremap = true;
            };
		}


		# Fugitive
		{
            mode = "n";
            key = "<leader>gs";
			action = "<cmd>Git<CR>";
            options = {
                silent = true;
                noremap = true;
            };
		}

		{
            mode = "n";
            key = "<leader>t";
            action = "<cmd>NvimTreeToggle<CR>";
            options = {
                silent = true;
                noremap = true;
            };
		}

# ----------------------------------------------------------------

    # Visual mode
        {
            mode = "v";
            key = "<leader>y";
            action = "\"+y";
        }

        {
            mode = "v";
            key = "<leader>d";
            action = "\"_d";
        }
        
        {
            mode = "v";
            key = "J";
            action = ":m '>+1<CR>gv=gv";
        }

		{
            mode = "v";
            key = "K";
			action = ":m '<-2<CR>gv=gv";
		}

        {
            mode = "v";
            key = "<leader>p";
            action = "\"_dP";
        }


	];

# ---------------------------------------------------------------------------- #


	# Color scheme
	colorschemes.tokyonight.enable = true;
	
	plugins.lightline.enable = true;

	# File Tree plugin
	plugins.nvim-tree = {
		enable = true;
		disableNetrw = true;
		openOnSetup = true;
		tab.sync.open = true;
	};

	# Code highlighting and indentation(All grammars enabled by default)
	plugins.treesitter = {
		enable = true;
		indent = true;
		folding = false;
	};

    plugins.ts-autotag = {
        enable = true;
        filetypes = [
          "html"
          "javascript"
          "typescript"
          "javascriptreact"
          "typescriptreact"
          "svelte"
          "vue"
          "tsx"
          "jsx"
          "rescript"
          "xml"
          "php"
          "markdown"
          "astro"
          "glimmer"
          "handlebars"
          "hbs"
        ];
        skipTags = [
          "area"
          "base"
          "br"
          "col"
          "command"
          "embed"
          "hr"
          "img"
          "slot"
          "input"
          "keygen"
          "link"
          "meta"
          "param"
          "source"
          "track"
          "wbr"
          "menuitem"
        ];
    };

	# Enables fuzzy finding through treesitter, LSP...
	plugins.telescope = {
		enable = true;

		keymaps = {
		#	"<leader>fg" = "live_grep"; <--- this requires ripgrep(not available as a module in nixvim for now)
			"<leader>ff" = "find_files";
			"<leader>fb" = "buffers";
			"<leader>fg" = "live_grep";
			"<C-p>" = "git_files";

			/*
			This doesnt work because perhaps it should be in some extraConfigLua variable	
			Grep text with telescope in current file
			"<leader>ps" = {
				action = "function() builtin.grep_string({ search = vim.fn.input(\"Grep > \")}); end";
			};
			*/	
		};
	};

	# Telescope extension
	plugins.harpoon = {
		enable = true;

		keymaps = {

			addFile = "<leader>a";
			toggleQuickMenu = "<C-e>";
			navFile = {
				"1" = "<C-h>";
				"2" = "<C-t>";
				"3" = "<C-m>";
			};
		};
	};


	# Git integration
	plugins.fugitive = {
        enable = true;
    };


	# Track change history
	plugins.undotree.enable = true;


	plugins.inc-rename = {
		enable = true;
		cmdName = "IncRename";
		hlGroup = "Substitute";
		previewEmptyName = false;
		showMessage = true;
		inputBufferType = null;
		postHook = null;
	};
	
	# Auto comments
	plugins.comment-nvim = {
		enable = true;

		toggler.line = "gcc";
		toggler.block = "gbc";
	};

	# Language Server Protocol
	plugins.lsp = {
		enable = true;

		keymaps = {
			silent = true;
			diagnostic = {
			#	"<leader>k" = "goto_prev"; <--- defined above
			#	"<leader>j" = "goto_next"; <--- defined above
			};

			lspBuf = {
				"gd" = "definition";
				"gD" = "references";
				"gt" = "type_definition";
				"gi" = "implementation";
				"K" = "hover";
			};
			
		};

		servers = {
			astro.enable = true;
			bashls.enable = true;
			clangd.enable = true;
			clojure-lsp.enable = true;
			cssls.enable = true;
			dartls.enable = true;
			denols.enable = true;
			eslint.enable = true;
            svelte.enable = true;
			elixirls.enable = true;
			futhark-lsp.enable = true;
			gopls.enable = true;
			hls.enable = true;
			html.enable = true;
			jsonls.enable = true;
			lua-ls.enable = true;
			metals.enable = true;
			nil_ls.enable = true;
			pylsp.enable = true;
			pyright.enable = true;
			rnix-lsp.enable = true;
			ruff-lsp.enable = true;
			rust-analyzer = {
                enable = true;
                installRustc = true;
                installCargo = true;
            };
			# sourcekit.enable = true;
			tailwindcss.enable = true;
			terraformls.enable = true;
			texlab.enable = true;
			tsserver.enable = true;
			typst-lsp.enable = true;
			vuels.enable = true;
			yamlls.enable = true;
			zls.enable = true;
		};
		
	}; 

	#Rust tools to make use of LSP for rust
	plugins.rust-tools.enable = true;

	# Auto-completion
	plugins.luasnip = {
		enable = true;
# not sure how to setup this snippet lib ---> "rafamadriz/friendly-snippets"
	};

	plugins.nvim-cmp = {
		enable = true;

		snippet.expand = "luasnip";
		completion = {
			keywordLength = 1;
		};
		# Can define more sources later. see nixvim cmp helper for full list
		sources = 
          [
            { name = "nvim_lsp"; }
            { name = "luasnip"; } #For luasnip users.
            { name = "path"; }
            { name = "buffer"; }
          ]
        ;
        
		# Mappings for autocompletion
		mapping = {
		    "<CR>" = "cmp.mapping.confirm({ select = true })";
		    "<C-p>" = "cmp.mapping.select_prev_item(cmp_select)";
		    "<C-n>" = "cmp.mapping.select_next_item(cmp_select)";
		    "<C-Space>" = "cmp.mapping.complete()";
		};

	};

	/*
	plugins.coq-nvim = {
		enable = true;
		autoStart = true;
	};
	*/

	# Debugging
	#plugins.dap.enable = true;


	# TODO: 
	# Utils: (auto) refactor and indentations
	# Debugging tools like vimspector and codelldb and nvim-DAP
	# FOR DAP: MUST SET A DIFFERENT BRANCH OF nixpkgs AND CONSISTENTLY SET FOR NIXVIM TOO!!!
	# Snippets(rafamadriz/friendly-snippets) - LATER
	};

	in {
	  devShell = pkgs.mkShell { buildInputs = [ nvim pkgs.ripgrep pkgs.nodejs_20]; };
	});    

}
