{ pkgs, config, zen-browser, ... }: {

  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Git Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "davy";
        email = "306048104+bugsintheweb@users.noreply.github.com";
      };
    };
  };

  programs.zoxide.enable = true;
  programs.zsh.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  dconf.enable = true;

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
    xwayland-satellite # Allows X11 apps to run inside Niri
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Omarchy-style CLI utilities
    ripgrep
    fd
    eza
    bat
    fzf
    lazygit
    wl-clipboard

    # Custom Workflow Menu
    (pkgs.writeShellScriptBin "workflow-panel" ''
      OPTIONS="🌐 Open Zen Browser\n📬 Launch Proton Mail Stack\n💻 Open VS Code Projects\n🔄 Reboot System\n🛑 Shutdown Workstation"

      CHOICE=$(echo -e "$OPTIONS" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Workflow Tasks: " --lines=5)

      case "$CHOICE" in
        *"Open Zen Browser"*)
          zen-browser ;;
        *"Launch Proton Mail Stack"*)
          protonmail-desktop & proton-authenticator ;;
        *"Open VS Code Projects"*)
          code ~/nixos-workstation ;;
        *"Reboot System"*)
          systemctl reboot ;;
        *"Shutdown Workstation"*)
          systemctl poweroff ;;
      esac
    '')
  ];

  # =========================================================================
  # NIRI SCROLLING TILE MANAGER CONFIGURATION
  # =========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    // Layout and Window Styling
    layout {
      gaps 8
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#${config.lib.stylix.colors.base0D}"
        inactive-color "#${config.lib.stylix.colors.base02}"
      }
    }

    // Autostart background processes
    spawn-at-startup "awww-daemon"
    spawn-at-startup "awww" "img" "${./wallpaper.jpg}"
    spawn-at-startup "waybar"
    spawn-at-startup "xwayland-satellite"

    // Input configuration
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
      focus-follows-mouse
    }

    // Keybindings
    binds {
      // Core launchers
      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Alt+Space { spawn "workflow-panel"; }

      // Window controls
      Mod+Shift+Q { close-window; }
      Mod+Shift+E { quit; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }

      // Vim-style Column & Window navigation
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }

      // Column & Window movement
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }

      // Workspace switching (vertical navigation in Niri)
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }

      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }

      // Column resizing
      Mod+R { switch-preset-column-width; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
    }
  '';

  # =========================================================================
  # WAYBAR FOR NIRI
  # =========================================================================
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "tray" ];

        "niri/workspaces" = {
          format = "{name}";
        };

        "niri/window" = {
          format = "{title}";
          max-length = 40;
        };

        "clock" = {
          format = "{:%H:%M - %a, %b %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          format = "CPU: {usage}%";
          tooltip = false;
        };

        "memory" = {
          format = "RAM: {}%";
        };
      };
    };
  };
}
