#!/bin/bash

# Agentic Project Workflow Local Installation Script
# This script installs Agentic Project Workflow from a local repository clone to a project directory

set -e  # Exit on error

# Initialize flags
OVERWRITE_INSTRUCTIONS=false
OVERWRITE_STANDARDS=false
CLAUDE_CODE=false
CURSOR=false
PROJECT_TYPE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --overwrite-instructions)
            OVERWRITE_INSTRUCTIONS=true
            shift
            ;;
        --overwrite-standards)
            OVERWRITE_STANDARDS=true
            shift
            ;;
        --claude-code|--claude|--claude_code)
            CLAUDE_CODE=true
            shift
            ;;
        --cursor|--cursor-cli)
            CURSOR=true
            shift
            ;;
        --project-type=*)
            PROJECT_TYPE="${1#*=}"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Installs Agentic Project Workflow from local repository to the current project directory."
            echo ""
            echo "Options:"
            echo "  --overwrite-instructions    Overwrite existing instruction files"
            echo "  --overwrite-standards       Overwrite existing standards files"
            echo "  --claude-code               Add Claude Code support"
            echo "  --cursor                    Add Cursor support"
            echo "  --project-type=TYPE         Use specific project type for installation"
            echo "  -h, --help                  Show this help message"
            echo ""
            echo "Example usage:"
            echo "  cd ~/Projects/my-project"
            echo "  bash ~/Projects/agentic-workflow/setup/install.sh --claude-code"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo ""
echo "🚀 Agentic Project Workflow Local Installation"
echo "=============================================="
echo ""

# Auto-detect agentic-workflow source directory from script location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTIC_WORKFLOW_BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Verify we have a valid agentic-workflow source directory
if [ ! -f "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" ] || [ ! -d "$AGENTIC_WORKFLOW_BASE_DIR/instructions" ] || [ ! -d "$AGENTIC_WORKFLOW_BASE_DIR/standards" ]; then
    echo "❌ Error: Could not find valid agentic-workflow repository structure at '$AGENTIC_WORKFLOW_BASE_DIR'"
    echo ""
    echo "Expected directory structure:"
    echo "  $AGENTIC_WORKFLOW_BASE_DIR/config.yml"
    echo "  $AGENTIC_WORKFLOW_BASE_DIR/instructions/"
    echo "  $AGENTIC_WORKFLOW_BASE_DIR/standards/"
    echo ""
    echo "Make sure you're running this script from a cloned agentic-workflow repository."
    exit 1
fi

# Get project directory info
CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")
AGENTIC_DIR="./.agentic-workflow"
DOCS_DIR="./docs"

echo "📍 Installing to project: $PROJECT_NAME ($CURRENT_DIR)"
echo "📂 Using agentic-workflow source: $AGENTIC_WORKFLOW_BASE_DIR"
echo ""

# Source shared functions
source "$SCRIPT_DIR/functions.sh"

echo "📁 Creating project directories..."
echo ""
mkdir -p "$AGENTIC_DIR"
mkdir -p "$DOCS_DIR"
mkdir -p "$AGENTIC_DIR/sessions/current"
mkdir -p "$AGENTIC_DIR/sessions/completed"
mkdir -p "$AGENTIC_DIR/recaps"
mkdir -p "$AGENTIC_DIR/mcps"

# Auto-enable tools based on config if no flags provided
if [ "$CLAUDE_CODE" = false ]; then
    # Check if claude_code is enabled in config
    if grep -q "claude_code:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" && \
       grep -A1 "claude_code:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" | grep -q "enabled: true"; then
        CLAUDE_CODE=true
        echo "  ✓ Auto-enabling Claude Code support (from agentic-workflow config)"
    fi
fi

if [ "$CURSOR" = false ]; then
    # Check if cursor is enabled in config
    if grep -q "cursor:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" && \
       grep -A1 "cursor:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" | grep -q "enabled: true"; then
        CURSOR=true
        echo "  ✓ Auto-enabling Cursor support (from agentic-workflow config)"
    fi
fi

# Read project type from config or use flag
if [ -z "$PROJECT_TYPE" ] && [ -f "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" ]; then
    # Try to read default_project_type from config
    PROJECT_TYPE=$(grep "^default_project_type:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml" | cut -d' ' -f2 | tr -d ' ')
    if [ -z "$PROJECT_TYPE" ]; then
        PROJECT_TYPE="default"
    fi
elif [ -z "$PROJECT_TYPE" ]; then
    PROJECT_TYPE="default"
fi

echo ""
echo "📦 Using project type: $PROJECT_TYPE"

# Determine source paths based on project type
INSTRUCTIONS_SOURCE=""
STANDARDS_SOURCE=""

if [ "$PROJECT_TYPE" = "default" ]; then
    INSTRUCTIONS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/instructions"
    STANDARDS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/standards"
else
    # Look up project type in config
    if grep -q "^  $PROJECT_TYPE:" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml"; then
        # Extract paths for this project type
        INSTRUCTIONS_PATH=$(awk "/^  $PROJECT_TYPE:/{f=1} f&&/instructions:/{print \$2; exit}" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml")
        STANDARDS_PATH=$(awk "/^  $PROJECT_TYPE:/{f=1} f&&/standards:/{print \$2; exit}" "$AGENTIC_WORKFLOW_BASE_DIR/config.yml")

        # Expand tilde in paths
        INSTRUCTIONS_SOURCE=$(eval echo "$INSTRUCTIONS_PATH")
        STANDARDS_SOURCE=$(eval echo "$STANDARDS_PATH")

        # Check if paths exist
        if [ ! -d "$INSTRUCTIONS_SOURCE" ] || [ ! -d "$STANDARDS_SOURCE" ]; then
            echo "  ⚠️  Project type '$PROJECT_TYPE' paths not found, falling back to default instructions and standards"
            INSTRUCTIONS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/instructions"
            STANDARDS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/standards"
        fi
    else
        echo "  ⚠️  Project type '$PROJECT_TYPE' not found in config, using default instructions and standards"
        INSTRUCTIONS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/instructions"
        STANDARDS_SOURCE="$AGENTIC_WORKFLOW_BASE_DIR/standards"
    fi
fi

# Copy instructions to agentic-workflow directory and standards to docs directory
echo ""
echo "📥 Installing instruction files to $AGENTIC_DIR/instructions/"
copy_directory "$INSTRUCTIONS_SOURCE" "$AGENTIC_DIR/instructions" "$OVERWRITE_INSTRUCTIONS"

echo ""
echo "📥 Installing standards files to $DOCS_DIR/standards/"
copy_directory "$STANDARDS_SOURCE" "$DOCS_DIR/standards" "$OVERWRITE_STANDARDS"

# Handle Claude Code installation for project
if [ "$CLAUDE_CODE" = true ]; then
    echo ""
    echo "📥 Installing Claude Code support..."
    mkdir -p "./.claude/commands"
    mkdir -p "./.claude/agents"

    # Copy commands from agentic-workflow repository
    echo "  📂 Commands:"
    if [ -d "$AGENTIC_WORKFLOW_BASE_DIR/commands" ]; then
        copy_directory "$AGENTIC_WORKFLOW_BASE_DIR/commands" "./.claude/commands" "false"
    else
        echo "  ⚠️  Warning: commands directory not found in agentic-workflow repository"
    fi

    echo ""
    echo "  📂 Agents:"
    if [ -d "$AGENTIC_WORKFLOW_BASE_DIR/claude-code/agents" ]; then
        copy_directory "$AGENTIC_WORKFLOW_BASE_DIR/claude-code/agents" "./.claude/agents" "false"
    else
        echo "  ⚠️  Warning: claude-code/agents directory not found in agentic-workflow repository"
    fi
fi

# Handle Cursor installation for project
if [ "$CURSOR" = true ]; then
    echo ""
    echo "📥 Installing Cursor support..."
    mkdir -p "./.cursor/rules"

    echo "  📂 Rules:"

    # Convert commands from agentic-workflow repository to Cursor rules
    if [ -d "$AGENTIC_WORKFLOW_BASE_DIR/commands" ]; then
        # Dynamically discover all .md files in commands directory
        for cmd_file in "$AGENTIC_WORKFLOW_BASE_DIR/commands"/*.md; do
            # Check if the glob pattern found actual files
            if [ -f "$cmd_file" ]; then
                cmd_name=$(basename "$cmd_file" .md)
                convert_to_cursor_rule "$cmd_file" "./.cursor/rules/${cmd_name}.mdc"
            fi
        done
    else
        echo "  ⚠️  Warning: commands directory not found in agentic-workflow repository"
    fi
fi

# Setup git hooks
echo ""
echo "📥 Installing git hooks..."
if [ -d "$AGENTIC_WORKFLOW_BASE_DIR/githooks" ]; then
    mkdir -p "./.githooks"
    copy_directory "$AGENTIC_WORKFLOW_BASE_DIR/githooks" "./.githooks" "true"
    
    # Set executable permissions
    chmod +x ./.githooks/*
    
    # Configure git to use the hooks directory
    git config core.hooksPath .githooks
    echo "  ✓ Git hooks installed and configured"
else
    echo "  ⚠️  Git hooks directory not found in agentic-workflow repository"
fi

# Setup session logging
echo ""
echo "📥 Setting up session logging..."
if [ ! -f "$AGENTIC_DIR/sessions/discoveries.md" ]; then
    cat > "$AGENTIC_DIR/sessions/discoveries.md" << 'EOF'
# Institutional Knowledge & Discoveries

This file captures significant discoveries made during development that would help future implementers.

## Template for New Discoveries

### [YYYY-MM-DD] Discovery Title

**Context**: Brief description of what was being implemented

**Discovery**: What was discovered that wasn't obvious or documented

**Impact**: How this knowledge affects future development

**Technical Details**: Specific implementation notes if applicable

---

EOF
    echo "  ✓ Session logging initialized"
else
    echo "  ⚠️  Session logging already initialized"
fi

# Setup MCP integration (optional)
echo ""
echo "📥 Setting up MCP integration (optional)..."

# Check if we have any MCP install scripts
if [ -d "$AGENTIC_WORKFLOW_BASE_DIR/mcps" ] && [ -n "$(find "$AGENTIC_WORKFLOW_BASE_DIR/mcps" -name "*.sh" -type f 2>/dev/null)" ]; then
    echo "  📂 Found MCP installation scripts..."
    
    # Run all .sh scripts in the mcps directory
    for mcp_script in "$AGENTIC_WORKFLOW_BASE_DIR/mcps"/*.sh; do
        if [ -f "$mcp_script" ]; then
            script_name=$(basename "$mcp_script")
            echo "  🔧 Running $script_name..."
            
            # Make sure script is executable and run it
            if chmod +x "$mcp_script" && "$mcp_script"; then
                echo "  ✓ $script_name completed successfully"
            else
                echo "  ⚠️  $script_name failed (continuing without it)"
            fi
        fi
    done
else
    echo "  ⚠️  No MCP installation scripts found - skipping MCP setup"
fi

echo "  ✓ MCP integration setup complete"

# Success message
echo ""
echo "✅ Agentic Project Workflow has been installed in your project ($PROJECT_NAME)!"
echo ""
echo "📍 Project-level files installed to:"
echo "   .agentic-workflow/instructions/    - Agentic Project Workflow instructions"  
echo "   .agentic-workflow/sessions/        - Session logging and context management"
echo "   .agentic-workflow/mcps/            - MCP integration guides"
echo "   docs/standards/                    - Development standards"
echo "   .githooks/                         - Git hooks for project standards"

if [ "$CLAUDE_CODE" = true ]; then
    echo "   .claude/commands/          - Claude Code commands"
    echo "   .claude/agents/            - Claude Code specialized agents"
fi

if [ "$CURSOR" = true ]; then
    echo "   .cursor/rules/             - Cursor command rules"
fi

echo ""
echo "--------------------------------"
echo ""
echo "Next steps:"
echo ""

if [ "$CLAUDE_CODE" = true ]; then
    echo "Claude Code usage:"
    echo "  /plan-product    - Set the mission & roadmap for a new product"
    echo "  /analyze-product - Set up the mission and roadmap for an existing product"
    echo "  /create-spec     - Create a spec for a new feature"
    echo "  /execute-tasks   - Build and ship code for a new feature"
    echo ""
fi

if [ "$CURSOR" = true ]; then
    echo "Cursor usage:"
    echo "  @plan-product    - Set the mission & roadmap for a new product"
    echo "  @analyze-product - Set up the mission and roadmap for an existing product"
    echo "  @create-spec     - Create a spec for a new feature"
    echo "  @execute-tasks   - Build and ship code for a new feature"
    echo ""
fi

echo "--------------------------------"
echo ""
echo "💡 Tip: You can customize your standards and instructions in docs/"
echo "💡 Tip: To update from your agentic-workflow base, just run this script again"
echo ""
echo "Keep building! 🚀"
echo ""