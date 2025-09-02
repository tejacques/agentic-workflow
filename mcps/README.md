# MCP (Model Context Protocol) Integration System

This directory contains modular MCP installation scripts that extend the agentic workflow with enhanced capabilities.

## Architecture

Each MCP is implemented as a self-contained installation script that:
1. **Checks prerequisites** - Verifies required tools are available
2. **Installs the tool** - Uses appropriate package manager (cargo, npm, etc.)
3. **Configures MCP integration** - Registers with Claude CLI
4. **Initializes project setup** - Tool-specific project configuration
5. **Graceful degradation** - Workflow continues if installation fails

## Available MCPs

### Codanna (`codanna.sh`)
- **Purpose**: Semantic code search and AST-based navigation
- **Prerequisites**: Rust toolchain, Claude CLI
- **Installation**: `cargo install codanna`
- **Integration**: Enhances context-fetcher agent with semantic search
- **Project Setup**: Initializes `.codanna/` config and indexes source directories

## Installation Process

During `setup/install.sh` execution:
1. Discovers all `.sh` files in `mcps/` directory
2. Executes each MCP install script
3. Collects success/failure results
4. Reports overall MCP installation status
5. Continues workflow installation regardless of MCP failures

## Adding New MCPs

To add a new MCP integration:

1. **Create install script**: `mcps/your-mcp.sh`
2. **Follow the template**:
```bash
#!/bin/bash
set -e

echo "📦 Installing Your MCP..."

check_prerequisites() {
    # Check for required tools
}

install_tool() {
    # Install the MCP tool
}

configure_mcp() {
    # Register with Claude CLI
}

initialize_project() {
    # Project-specific setup
}

main() {
    # Execute all steps with error handling
}

main "$@"
```

3. **Make executable**: `chmod +x mcps/your-mcp.sh`
4. **Test installation**: The install script will automatically discover and run it

## MCP Script Requirements

Each MCP script must:
- ✅ Be executable (`chmod +x`)
- ✅ Handle missing prerequisites gracefully
- ✅ Return appropriate exit codes (0 = success, 1 = failure)
- ✅ Use consistent output formatting with emojis and status indicators
- ✅ Support idempotent installation (safe to run multiple times)

## Testing MCP Installation

To test MCP installations:
```bash
# Test individual MCP
./mcps/codanna.sh

# Test all MCPs via main installer
bash setup/install.sh

# Verify MCP registrations
claude mcp list
```

## Troubleshooting

### Common Issues
1. **Prerequisites missing**: Install required tools (Rust, Node.js, etc.)
2. **Claude CLI not found**: Install with `npm install -g @anthropic-ai/claude-cli`
3. **Permission errors**: Ensure scripts are executable
4. **Network issues**: Some tools require internet for initial installation

### Debug Commands
```bash
# Check Claude CLI
claude --version
claude mcp list

# Check individual tools
codanna --version

# Test MCP connections
claude mcp test <mcp-name>
```

## Design Principles

1. **Modular**: Each MCP is self-contained
2. **Optional**: Workflow functions without any MCPs
3. **Graceful**: Failures don't break main installation
4. **Discoverable**: New MCPs auto-discovered by installer
5. **Testable**: Scripts can be run independently

This architecture makes the MCP system extensible and maintainable while keeping the core workflow robust.