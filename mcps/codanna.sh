#!/bin/bash

# Codanna MCP Installation Script
# This script installs Codanna semantic code search tool and configures it as an MCP

set -e

# Configuration
MCP_NAME="codanna"
MCP_JSON='{"command":"codanna","args":["serve","--watch"],"env":{"RUST_LOG":"info"}}'

echo "📦 Installing Codanna MCP..."

# Check prerequisites
check_prerequisites() {
    local missing_deps=()
    
    # Check if Rust/Cargo is available
    if ! command -v cargo >/dev/null 2>&1; then
        missing_deps+=("cargo (Rust toolchain)")
    fi
    
    # Check if Claude CLI is available
    if ! command -v claude >/dev/null 2>&1; then
        missing_deps+=("claude (Claude CLI)")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "  ❌ Missing prerequisites:"
        for dep in "${missing_deps[@]}"; do
            echo "     - $dep"
        done
        echo ""
        echo "  Install missing prerequisites:"
        echo "  - Rust toolchain: https://rustup.rs/"
        echo "  - Claude CLI: npm install -g @anthropic-ai/claude-cli"
        echo ""
        echo "  ⚠️  Skipping Codanna MCP installation (workflow continues without it)"
        return 1
    fi
    
    return 0
}

# Install Codanna tool
install_codanna_tool() {
    echo "  🔧 Installing Codanna tool..."
    
    # Check if already installed
    if command -v codanna >/dev/null 2>&1; then
        local current_version=$(codanna --version 2>/dev/null | head -n1 || echo "unknown")
        echo "  ✓ Codanna already installed: $current_version"
        return 0
    fi
    
    # Install via cargo
    if cargo install codanna; then
        echo "  ✓ Codanna installed successfully"
        return 0
    else
        echo "  ❌ Failed to install Codanna via cargo"
        return 1
    fi
}

# Configure MCP integration
configure_mcp() {
    echo "  🔗 Configuring Codanna MCP integration..."
    
    # Check if MCP already exists
    if claude mcp list 2>/dev/null | grep -q "$MCP_NAME"; then
        echo "  ✓ Codanna MCP already configured"
        return 0
    fi
    
    # Add MCP configuration
    if claude mcp add-json "$MCP_NAME" "$MCP_JSON" 2>/dev/null; then
        echo "  ✓ Codanna MCP configured successfully"
        return 0
    else
        echo "  ❌ Failed to configure Codanna MCP"
        return 1
    fi
}

# Initialize Codanna in project
initialize_project() {
    echo "  🚀 Initializing Codanna in project..."
    
    # Check if already initialized
    if [ -f ".codanna/config.toml" ]; then
        echo "  ✓ Codanna already initialized in project"
        return 0
    fi
    
    # Initialize Codanna
    if codanna init 2>/dev/null; then
        echo "  ✓ Codanna initialized in project"
        
        # Index common source directories if they exist
        for dir in "src" "lib" "app" "components" "pages" "api"; do
            if [ -d "$dir" ]; then
                echo "  📁 Indexing $dir directory..."
                if codanna index "$dir" 2>/dev/null; then
                    echo "  ✓ Indexed $dir successfully"
                else
                    echo "  ⚠️  Failed to index $dir (continuing)"
                fi
            fi
        done
        
        return 0
    else
        echo "  ❌ Failed to initialize Codanna in project"
        return 1
    fi
}

# Main installation flow
main() {
    if ! check_prerequisites; then
        return 1
    fi
    
    if ! install_codanna_tool; then
        echo "  ❌ Codanna MCP installation failed at tool installation step"
        return 1
    fi
    
    if ! configure_mcp; then
        echo "  ❌ Codanna MCP installation failed at MCP configuration step"
        return 1
    fi
    
    if ! initialize_project; then
        echo "  ⚠️  Codanna MCP installed but project initialization failed"
        echo "  💡 Run 'codanna init' and 'codanna index src' manually when ready"
    fi
        
    echo "  ✅ Codanna MCP installation completed successfully"
    return 0
}

# Run main installation
main "$@"