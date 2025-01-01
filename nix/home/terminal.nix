{ pkgs, ... }:
let
  zsh = true;
in
{
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = zsh;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "jasper-clarke";
      userEmail = "me@jasperclarke.com";
      signing = {
        key = "B02A7007E0D92292";
        signByDefault = true;
      };
    };
    ssh = {
      enable = true;
      extraConfig = ''
        Host gitlab.com
          IdentityFile ~/.ssh/private
        Host github.com
          IdentityFile ~/.ssh/private
        Host 192.168.100.134
          IdentityFile ~/.ssh/private
      '';
    };
    kitty = {
      enable = true;
      package = pkgs.kitty.overrideAttrs (oldAttrs: {
        prePatch = ''
          substituteInPlace kitty/fast_data_types.pyi \
            --replace 'allow_bitmapped_fonts: bool = False' 'allow_bitmapped_fonts: bool = True'
          substituteInPlace kitty/fontconfig.c \
            --replace 'allow_bitmapped_fonts = 0' 'allow_bitmapped_fonts = 1'
        '';
      });
      # font.name = "JetBrains Mono";
      # font.size = 17;
      # extraConfig = builtins.toString (builtins.readFile ./kitty.conf);
      settings = {
        confirm_os_window_close = 0;
        sync_to_monitor = true;
        enable_audio_bell = false;
        window_padding_width = 15;
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.2";
      };
      keybindings = {
        "ctrl+enter" = "previous_window";
        "ctrl+space" = "toggle_layout stack";
      };
    };
    zsh = {
      enable = zsh;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        "cd" = "z";
      };
      initExtra = ''
        $HOME/Projects/Golang/bibopener/bibopener
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = zsh;
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = zsh;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./config/omp.json));
    };
  };
}
