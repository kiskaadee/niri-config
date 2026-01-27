# Niri Configuration (Modular)

This directory contains a modular Niri window manager configuration for Arch Linux.

## Structure

```
.
├── config.kdl              # Original monolithic configuration (backup)
├── config-modular.kdl      # New modular main config
├── modules/                # Modular configuration files
│   ├── outputs.kdl         # Monitor configurations
│   ├── input.kdl           # Keyboard, mouse, touchpad settings
│   ├── layout.kdl          # Window gaps, borders, focus rings
│   ├── window-rules.kdl    # Per-application window rules
│   ├── binds.kdl           # Keybindings and shortcuts
│   ├── startup.kdl         # Startup applications
│   └── preferences.kdl     # Animations, screenshots, misc
├── scripts/
│   └── screenshot.sh       # Rofi-based screenshot script
└── README.md               # This file
```

## Modules Overview

### Hardware Configuration

- **`outputs.kdl`**: Monitor setup for dual-monitor configuration
  - Samsung external monitor (top): 1920x1080@60Hz
  - BOE laptop display (bottom): 1920x1080@60Hz, centered

- **`input.kdl`**: Input device settings
  - Keyboard: Right Alt as Compose key, numlock enabled
  - Touchpad: tap-to-click, natural scrolling
  - Focus: warp-mouse-to-focus, instant focus-follows-mouse

### Window Management

- **`layout.kdl`**: Visual appearance and layout behavior
  - 16px gaps between windows
  - Focus ring: cyan (#7fc8ff) active, dimmed (#45475a) inactive
  - Borders: disabled
  - Shadows: disabled
  - Preset column widths: 33%, 50%, 67%

- **`window-rules.kdl`**: Application-specific behaviors
  - WezTerm: workaround for initial configure bug
  - Firefox: picture-in-picture as floating window

### User Interface

- **`binds.kdl`**: All keybindings (organized by category)
  - Window management: Mod+HJKL/arrows for navigation
  - Monitor management: Mod+Shift+HJKL
  - Workspace management: Mod+U/I, Mod+1-9
  - Screenshots: Mod+Shift+S (Rofi script)
  - Media controls: XF86Audio* keys
  - System: Mod+Shift+E to quit

- **`startup.kdl`**: Auto-launched applications
  - noctalia (native shell)
  - xwayland-satellite (X11 compatibility)

- **`preferences.kdl`**: General settings
  - Screenshot path: ~/Screenshots/
  - Animations: enabled (default)
  - Hotkey overlay: enabled

## Usage

### Switching to Modular Config

To use the modular configuration:

```bash
# Backup current config
cp config.kdl config-backup.kdl

# Switch to modular config
mv config.kdl config-original.kdl
cp config-modular.kdl config.kdl

# Reload niri (it will auto-reload on config change)
# Or manually: niri msg action reload-config
```

### Editing Modules

Each module can be edited independently. Niri watches all included files for changes and automatically reloads the configuration.

Example: To change keybindings, edit `modules/binds.kdl`:

```bash
$EDITOR modules/binds.kdl
```

Niri will detect the change and reload automatically.

### Adding Custom Modules

You can create additional modules for specific purposes:

```bash
# Example: Create a custom theme module
$EDITOR modules/theme-catppuccin.kdl

# Include it in config-modular.kdl
echo 'include "modules/theme-catppuccin.kdl"' >> config-modular.kdl
```

Remember: includes are **positional** - later includes override earlier ones.

## Include System

Niri's include system has these properties:

- **Positional**: Later includes override earlier settings
- **Merging**: Most sections merge (you can set individual properties)
- **Multipart sections**: `output`, `window-rule`, `workspace` are inserted as-is
- **Binds**: Override previously-defined conflicting keys
- **Live reload**: All included files are watched for changes

See the [official documentation](https://github.com/YaLTeR/niri/wiki/Configuration:-Include) for details.

## Maintenance

### Reverting to Original

To revert to the original monolithic config:

```bash
cp config-original.kdl config.kdl
```

### Syncing Changes

If you modify the modular config and want to update the backup:

```bash
git add -A
git commit -m "feat: <your change description>

Co-Authored-By: Warp <agent@warp.dev>"
git push origin main
```

## Hardware Setup

- **Laptop**: BOE 0x0C02 display @ 1920x1080
- **External Monitor**: Samsung LS24D300G @ 1920x1080
- **Layout**: Vertical stack (external top, laptop bottom, centered alignment)
- **Input**: Built-in keyboard and touchpad with natural scrolling

## Key Features

- ✅ Dual-monitor vertical stack configuration
- ✅ Mouse-driven focus with instant activation
- ✅ Cross-monitor navigation (focus-*-or-monitor commands)
- ✅ Rofi-based screenshot workflow
- ✅ Media key support (volume, brightness, playback)
- ✅ Accent composition (Right Alt as Compose key)
- ✅ Auto-warp mouse to focused windows

## Links

- [Niri Wiki](https://yalter.github.io/niri/)
- [Configuration Reference](https://github.com/YaLTeR/niri/wiki)
- [KDL Format](https://kdl.dev)
