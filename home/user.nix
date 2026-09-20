{ pkgs, config, zen-browser, ... }: {

  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    userName = "davy";
    userEmail = "306048104+bugsintheweb@://github.com";
  };

  programs.zoxide.enable = true;
  programs.zsh.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  # Required for Stylix dark rules to bind perfectly inside your system
  dconf.enable = true;

  # =========================================================================
  # STYLIX AUTO-THEMING SYSTEM (UNIFIED ENGINE)
  # =========================================================================
  stylix = {
    enable = true;
    image = ./wallpaper.jpg; # <-- Staged via git add home/wallpaper.jpg!
    
    # Curated Base16 theme engine (Tokyo Night brings beautiful desktop contrast)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night.yaml";
    polarity = "dark";

    # Unified font handling injected across your apps, system menus, & terminal
    fonts = {
      monospace = {
        # Fixed the font path attribute string cleanly
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
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
  # NIRI CONFIGURATION (NATIVE KDL IMPLEMENTATION)
  # =========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    layout {
        gaps 12
        default-column-width { proportion 0.5; }
        
        focus-ring {
            enable
            width 3
            active-color "#${config.lib.stylix.colors.base0D}"
            inactive-color "#${config.lib.stylix.colors.base02}"
        }
    }

    binds {
        // System & Core Applications
        "Mod+Return" { spawn "alacritty"; }
        "Mod+Space" { spawn "fuzzel"; }
        "Mod+Q" { close-window; }
        
        // Custom Omarchy Menu Trigger
        "Mod+Alt+Space" { spawn "fuzzel" "--dmenu" "--prompt=Workflow Tasks: "; }

        // Navigation (Scrolling Ribbon)
        "Mod+Left"  { focus-column-left; }
        "Mod+Right" { focus-column-right; }
        "Mod+H"     { focus-column-left; }
        "Mod+L"     { focus-column-right; }

        "Mod+Ctrl+Left"  { move-column-left; }
        "Mod+Ctrl+Right" { move-column-right; }
        "Mod+Ctrl+H"     { move-column-left; }
        "Mod+Ctrl+L"     { move-column-right; }

        // Sizing
        "Mod+R" { switch-preset-column-width; }
        "Mod+F" { maximize-column; }
        
        // Workspaces
        "Mod+Up"   { focus-workspace-up; }
        "Mod+Down" { focus-workspace-down; }
        "Mod+Shift+Up"   { move-column-to-workspace-up; }
        "Mod+Shift+Down" { move-column-to-workspace-down; }
    }

    animations {
        slowdown 1.0
    }
  '';
}
