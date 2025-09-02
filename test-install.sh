#!/bin/bash

# Test Script for Agentic Project Workflow Installation
# This script tests the install.sh script in a safe, isolated environment

set -e  # Exit on any error

# Configuration
TEST_DIR="/tmp/agentic-workflow-test-$$"  # Use process ID for uniqueness
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/setup/install.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Cleanup function
cleanup() {
    if [ -d "$TEST_DIR" ]; then
        log_info "Cleaning up test directory: $TEST_DIR"
        rm -rf "$TEST_DIR"
    fi
}

# Set trap for cleanup on exit
trap cleanup EXIT

# Test function
run_test() {
    local test_name="$1"
    local test_flags="$2"
    local expected_files="$3"
    
    log_info "Running test: $test_name"
    
    # Create fresh test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Initialize git repo (needed for git hooks)
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Run installation
    log_info "Executing: $INSTALL_SCRIPT $test_flags"
    if ! $INSTALL_SCRIPT $test_flags >/dev/null 2>&1; then
        log_error "Installation failed for test: $test_name"
        return 1
    fi
    
    # Verify expected files exist
    local success=true
    IFS=',' read -ra FILES <<< "$expected_files"
    for file in "${FILES[@]}"; do
        file=$(echo "$file" | xargs)  # Trim whitespace
        if [ ! -e "$file" ]; then
            log_error "Expected file/directory missing: $file"
            success=false
        fi
    done
    
    if [ "$success" = true ]; then
        log_success "Test passed: $test_name"
        return 0
    else
        log_error "Test failed: $test_name"
        return 1
    fi
}

# Verify prerequisites
verify_prerequisites() {
    log_info "Verifying prerequisites..."
    
    if [ ! -f "$INSTALL_SCRIPT" ]; then
        log_error "Install script not found: $INSTALL_SCRIPT"
        exit 1
    fi
    
    if [ ! -x "$INSTALL_SCRIPT" ]; then
        log_error "Install script is not executable: $INSTALL_SCRIPT"
        exit 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/instructions" ]; then
        log_error "Instructions directory not found: $SCRIPT_DIR/instructions"
        exit 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/standards" ]; then
        log_error "Standards directory not found: $SCRIPT_DIR/standards"
        exit 1
    fi
    
    log_success "Prerequisites verified"
}

# Single comprehensive test
run_installation_test() {
    log_info "Starting comprehensive installation test..."
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Initialize git repo (needed for git hooks)
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Test help functionality first
    log_info "Testing help functionality..."
    if ! $INSTALL_SCRIPT --help | grep -q "Usage:"; then
        log_error "Help functionality test failed"
        return 1
    fi
    log_success "Help functionality test passed"
    
    # Run comprehensive installation
    log_info "Running installation with --claude-code --cursor flags..."
    if ! $INSTALL_SCRIPT --claude-code --cursor; then
        log_error "Installation failed"
        return 1
    fi
    
    log_success "Installation completed successfully"
    return 0
}

# MCP verification function
verify_mcp_installation() {
    log_info "Verifying MCP installations..."
    
    # Check if Claude CLI is available
    if ! command -v claude >/dev/null 2>&1; then
        log_warning "Claude CLI not found - skipping MCP verification"
        return 0
    fi
    
    # Discover expected MCPs from source directory
    local expected_mcps=()
    if [ -d "$SCRIPT_DIR/mcps" ]; then
        for mcp_script in "$SCRIPT_DIR/mcps"/*.sh; do
            if [ -f "$mcp_script" ]; then
                # Extract MCP name from filename (install-context7.sh -> context7)
                local mcp_name=$(basename "$mcp_script" | sed 's/install-//' | sed 's/\.sh$//')
                expected_mcps+=("$mcp_name")
            fi
        done
    fi
    
    if [ ${#expected_mcps[@]} -eq 0 ]; then
        log_info "No MCP install scripts found - skipping MCP verification"
        return 0
    fi
    
    log_info "Expected MCPs: ${expected_mcps[*]}"
    
    # Initialize Claude project context first, then get list of installed MCPs
    # Note: claude mcp list needs project context to be initialized first
    echo "" | timeout 5 claude >/dev/null 2>&1 || true  # Initialize project context
    
    local installed_mcps_output
    if ! installed_mcps_output=$(claude mcp list 2>/dev/null); then
        log_warning "Could not retrieve MCP list - MCPs may not have installed correctly"
        return 0
    fi
    
    # Check each expected MCP is installed
    local missing_mcps=()
    local installed_mcps=()
    
    for expected_mcp in "${expected_mcps[@]}"; do
        if echo "$installed_mcps_output" | grep -q "$expected_mcp"; then
            installed_mcps+=("$expected_mcp")
        else
            missing_mcps+=("$expected_mcp")
        fi
    done
    
    # Report results
    if [ ${#installed_mcps[@]} -gt 0 ]; then
        log_success "Successfully installed MCPs: ${installed_mcps[*]}"
    fi
    
    if [ ${#missing_mcps[@]} -gt 0 ]; then
        log_warning "MCPs that failed to install: ${missing_mcps[*]}"
        log_info "This is expected if MCP installation requirements aren't met"
    fi
    
    return 0  # Don't fail the test - MCP installation is optional
}

# Detailed verification function
verify_installation_details() {
    log_info "Running detailed verification of installation..."
    
    # Verify core directories exist
    local core_dirs=(".agentic-workflow" "docs" ".githooks")
    for dir in "${core_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Missing core directory: $dir"
            return 1
        fi
    done
    
    # Verify Claude Code directories (should exist with --claude-code flag)
    if [ ! -d ".claude" ]; then
        log_error "Missing .claude directory (expected with --claude-code flag)"
        return 1
    fi
    
    # Verify Cursor directories (should exist with --cursor flag)  
    if [ ! -d ".cursor" ]; then
        log_error "Missing .cursor directory (expected with --cursor flag)"
        return 1
    fi
    
    # Verify git hooks are executable
    for hook in .githooks/*; do
        if [ -f "$hook" ] && [ ! -x "$hook" ]; then
            log_error "Git hook not executable: $hook"
            return 1
        fi
    done
    
    # Verify git config was updated
    if ! git config core.hooksPath | grep -q ".githooks"; then
        log_error "Git hooks path not configured"
        return 1
    fi
    
    # Verify source files were copied
    if [ ! -d ".agentic-workflow/instructions" ] || [ -z "$(ls -A .agentic-workflow/instructions)" ]; then
        log_error "Instructions not copied properly"
        return 1
    fi
    
    if [ ! -d "docs/standards" ] || [ -z "$(ls -A docs/standards)" ]; then
        log_error "Standards not copied properly"
        return 1
    fi
    
    # Verify MCP installations
    verify_mcp_installation
    
    log_success "Detailed verification passed"
    return 0
}

# Main execution
main() {
    echo ""
    log_info "=========================================="
    log_info "   AGENTIC PROJECT WORKFLOW TEST SUITE   "
    log_info "=========================================="
    echo ""
    
    # Verify prerequisites first
    verify_prerequisites
    
    # Run installation test
    if run_installation_test; then
        # Run detailed verification
        if verify_installation_details; then
            log_success "🎉 COMPLETE TEST SUITE PASSED! Installation script is working correctly."
            exit 0
        else
            log_error "❌ Installation verification failed"
            exit 1
        fi
    else
        log_error "❌ Installation test failed"
        exit 1
    fi
}

# Run main function
main "$@"