{ ... }:
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
      userEmail = "jasper@windswept.digital";
    };
    ssh = {
      enable = true;
      extraConfig = ''
        Host gitlab.com
          IdentityFile ~/.ssh/private
        Host github.com
          IdentityFile ~/.ssh/private
        Host 192.168.100.133
          IdentityFile ~/.ssh/private
      '';
    };
    kitty = {
      enable = true;
      # font.name = "JetBrains Mono";
      # font.size = 17;
      # extraConfig = builtins.toString (builtins.readFile ./kitty.conf);
      settings = {
        confirm_os_window_close = 0;
        sync_to_monitor = true;
        enable_audio_bell = false;
        window_padding_width = 15;
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
