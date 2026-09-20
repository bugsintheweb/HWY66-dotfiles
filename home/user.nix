{ pkgs, config, zen-browser, ... }:

{
  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "davy";
    userEmail = "306048104+bugsintheweb@users.noreply.github.com";
  };

  programs.zoxide.enable = true;
  programs.zsh.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  dconf.enable = true;

  # =========================================================================
  # STYLIX AUTO-THEMING SYSTEM (UNIFIED ENGINE)
  # =========================================================================
  stylix = {
    enable = true;
    image = ./wallpaper.jpg; # <-- Drop your favorite wallpaper here!
    
    # Curated Base16 theme engine (Tokyo Night brings beautiful desktop contrast)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night.yaml";
    polarity = "dark";

    # Unified font handling injected across your apps, system menus, & terminal
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jet-brains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
    };

    # Explicitly force Stylix to auto-generate matching GTK apps & icon profiles
    targets.gtk.enable = true;
  };

  # =========================================================================
  # PACKAGES & TOOLS
  # =========================================================================
  home.packages = with pkgs; [
    proton-authenticator
    protonmail-desktop   

    # Ricing & UI Utilities
    fuzzel        # Ultra-fast, minimal app launcher (Auto-themed by Stylix!)
    alacritty     # Snappy, hardware-accelerated terminal (Auto-themed by Stylix!)

    # Main workflow browser pulled from custom flake input
    zen-browser.packages.${pkgs.system}.default
  ];
  
  # =========================================================================
  # VS CODE DEVELOPER PROFILES
  # =========================================================================
  home.file.".config/Code/User/settings.json".text = ''
    {
      "editor.formatOnSave": true,
      "files.autoSave": "onFocusChange",
      "terminal.integrated.defaultProfile.linux": "zsh" 
    }
  '';

  home.file.".config/Code/User/keybindings.json".text = ''
   [
     {
       "key": "ctrl+shift+p",
       "command": "workbench.action.showCommands"
     }
   ]
  '';

  # =========================================================================
  # NIRI SCROLLING TILING CONFIGURATION
  # =========================================================================
  programs.niri = {
    settings = {
      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          tap = true;
          natural-scroll = true; # Highly tactile horizontal timeline flow
        };
      };

      layout = {
        gaps = 12;
        default-column-width = { proportion = 0.5; };
        
        # Niri active selection frame colored directly by Stylix accent hooks
        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#${config.lib.stylix.colors.base0D}";   
          inactive.color = "#${config.lib.stylix.colors.base02}"; 
        };
      };

      # Omarchy inspired keyboard layout maps
      binds = {
        # System & Core Applications
        "Mod+Return".action.spawn = [ "alacritty" ];
        "Mod+Space".action.spawn = [ "fuzzel" ];     
        "Mod+Q".action.close-window = [];
        
        # Omarchy Custom Workflow Menu Shortcut
        "Mod+Alt+Space".action.spawn = [ "fuzzel" "--dmenu" "--prompt=Workflow Tasks: " ];

        # Navigation: Scrolling horizontally across the infinite ribbon
        "Mod+Left".action.focus-column-left = [];
        "Mod+Right".action.focus-column-right = [];
        "Mod+H".action.focus-column-left = [];      
        "Mod+L".action.focus-column-right = [];

        # Shifting window objects on the ribbon
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Right".action.move-column-right = [];
        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+L".action.move-column-right = [];

        # Infinite Ribbon Resizing
        "Mod+R".action.switch-preset-column-width = []; 
        "Mod+F".action.maximize-column = [];            
        
        # Workspaces (Endless horizontal ribbons stacked vertically)
        "Mod+Up".action.focus-workspace-up = [];
        "Mod+Down".action.focus-workspace-down = [];
        "Mod+Shift+Up".action.move-column-to-workspace-up = [];
        "Mod+Shift+Down".action.move-column-to-workspace-down = [];
      };

      animations = {
        enable = true;
        slowdown = 1.0;
      };
    };
  };
}
