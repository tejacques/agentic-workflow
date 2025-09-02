#!/bin/bash

# Context7 MCP Installation Script for Claude Code
# Installs Context7 MCP server for up-to-date documentation injection

set -e

echo "🔧 Context7 MCP Installation for Claude Code"
echo "============================================"
echo

# Check if Claude Code CLI is available
check_claude_cli() {
    if ! command -v claude >/dev/null 2>&1; then
        echo "❌ Claude Code CLI is not installed or not in PATH."
        echo "   Please install Claude Code first: https://claude.ai/code"
        exit 1
    fi
    
    echo "✅ Claude Code CLI detected"
}

# Install Context7 MCP for Claude Code
install_context7() {
    echo "📦 Installing Context7 MCP for Claude Code..."
    
    if claude mcp add --transport http context7 --scope project https://mcp.context7.com/mcp; then
        echo "✅ Context7 MCP server added successfully"
    else
        echo "❌ Failed to add Context7 MCP server"
        exit 1
    fi
}

# Show usage instructions
show_usage() {
    echo
    echo "🎉 Context7 MCP Installation Complete!"
    echo "====================================="
    echo
    echo "How to use Context7:"
    echo "  Simply include 'use context7' in your prompts to automatically"
    echo "  inject up-to-date documentation for the technologies you're working with."
    echo
    echo "Examples:"
    echo "  • 'Create a Next.js app with TypeScript. use context7'"
    echo "  • 'Write a PostgreSQL query to find duplicates. use context7'"
    echo "  • 'Set up React testing with Jest. use context7'"
    echo
    echo "The Context7 MCP server is now available in this project scope."
    echo
}

# Main installation flow
main() {
    check_claude_cli
    install_context7
    show_usage
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Context7 MCP Installation Script for Claude Code"
        echo
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "Options:"
        echo "  --help, -h       Show this help message"
        echo
        echo "Installs Context7 MCP server for Claude Code with project scope."
        ;;
    *)
        main
        ;;
esac