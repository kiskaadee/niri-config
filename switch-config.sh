#!/usr/bin/env bash

# ===================================================
# Niri Config Switcher
# ===================================================
# Switch between monolithic and modular configurations

set -e

CONFIG_DIR="$HOME/.config/niri"
CURRENT_CONFIG="$CONFIG_DIR/config.kdl"
MODULAR_CONFIG="$CONFIG_DIR/config-modular.kdl"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

show_usage() {
    cat << EOF
Usage: $0 [modular|monolithic|status]

Commands:
  modular     - Switch to modular configuration
  monolithic  - Switch to original monolithic configuration
  status      - Show which config is currently active

The current config.kdl will be backed up before switching.
EOF
    exit 1
}

check_modular() {
    if head -n 5 "$CURRENT_CONFIG" | grep -q "MODULAR"; then
        return 0
    else
        return 1
    fi
}

show_status() {
    echo "Current configuration status:"
    echo "----------------------------"
    if [ -f "$CURRENT_CONFIG" ]; then
        if check_modular; then
            echo "✅ Active: MODULAR configuration"
            echo "   Using: config-modular.kdl (via config.kdl)"
        else
            echo "✅ Active: MONOLITHIC configuration"
            echo "   Using: config.kdl (original)"
        fi
    else
        echo "❌ No config.kdl found!"
        exit 1
    fi
    
    echo ""
    echo "Available configurations:"
    [ -f "$MODULAR_CONFIG" ] && echo "  📦 config-modular.kdl (7 modules)"
    [ -f "$CONFIG_DIR/config-original.kdl" ] && echo "  📄 config-original.kdl (monolithic backup)"
    
    echo ""
    echo "Module files:"
    if [ -d "$CONFIG_DIR/modules" ]; then
        ls -1 "$CONFIG_DIR/modules/" | sed 's/^/  - /'
    else
        echo "  (none - modules/ directory not found)"
    fi
}

switch_to_modular() {
    echo "Switching to modular configuration..."
    
    # Backup current config
    cp "$CURRENT_CONFIG" "${CURRENT_CONFIG}${BACKUP_SUFFIX}"
    echo "✅ Backed up current config to: config.kdl${BACKUP_SUFFIX}"
    
    # Copy modular config
    cp "$MODULAR_CONFIG" "$CURRENT_CONFIG"
    echo "✅ Activated modular configuration"
    echo ""
    echo "The configuration will auto-reload in Niri."
    echo "You can now edit individual modules in modules/ directory."
}

switch_to_monolithic() {
    echo "Switching to monolithic configuration..."
    
    # Check if original exists
    if [ ! -f "$CONFIG_DIR/config-original.kdl" ]; then
        echo "❌ Error: config-original.kdl not found!"
        echo "Cannot switch to monolithic config without original backup."
        exit 1
    fi
    
    # Backup current config
    cp "$CURRENT_CONFIG" "${CURRENT_CONFIG}${BACKUP_SUFFIX}"
    echo "✅ Backed up current config to: config.kdl${BACKUP_SUFFIX}"
    
    # Restore original
    cp "$CONFIG_DIR/config-original.kdl" "$CURRENT_CONFIG"
    echo "✅ Activated monolithic configuration"
    echo ""
    echo "The configuration will auto-reload in Niri."
}

# Main logic
case "${1:-}" in
    modular)
        if check_modular; then
            echo "Already using modular configuration."
            exit 0
        fi
        switch_to_modular
        ;;
    monolithic)
        if ! check_modular; then
            echo "Already using monolithic configuration."
            exit 0
        fi
        switch_to_monolithic
        ;;
    status)
        show_status
        ;;
    *)
        show_usage
        ;;
esac
