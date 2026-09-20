{ pkgs, config, zen-browser, ... }: {

  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  
  programs.git = {
    enable = true;
    settings.user.Name = "davy";
    settings.user.Email = "306048104+bugsintheweb@://github.com";
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
    image = ./wallpaper.jpg; 
    
    # FIX: Pointing to the palette scheme safely via built-in system mapping strings
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml"; 
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
    };

    targets.gtk.enable = true;
  };

  # =========================================================================
  # PACKAGES & TOOLS
  # =========================================================================
  home.packages = with pkgs; [
    proton-authenticator
    protonmail-desktop   
    fuzzel        
    alacritty     
    waybar
    awww
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # =========================================================================
  # HYPRLAND CONFIGURATION
  # =========================================================================
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      
      exec-once = [
        "awww-daemon"                                     # Starts the wallpaper engine
        "awww img ${./wallpaper.jpg}"                     # Smoothly loads your staged image
        "waybar"                                          # Launches your status bar
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      monitor = ",preferred,auto,1";

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;

        "col.active_border" = "rgb(${config.lib.stylix.colors.base0D}) rgb(${config.lib.stylix.colors.base0E}) 45deg";
        "col.inactive_border" = "rgb(${config.lib.stylix.colors.base02})";

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popup 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

bind = [
        # Core application shortcuts
        "SUPER, Return, exec, alacritty"
        "SUPER, Space, exec, fuzzel"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, F, togglefloating,"

        # Custom Global Menu Shortcut (Super + Alt + Space)
        "SUPER_ALT, Space, exec, fuzzel --dmenu --prompt='Workflow Tasks: '"

        # Focus Shifts (Vim motions)
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        # Workspace switching
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"

        # Moving windows to specified workspaces
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
    };
  };
}
