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

# Test cases
run_tests() {
    local total_tests=0
    local passed_tests=0
    
    log_info "Starting installation tests..."
    
    # Test 1: Basic installation (no flags)
    total_tests=$((total_tests + 1))
    if run_test "Basic Installation" "" ".agentic-workflow/instructions,.agentic-workflow/sessions,docs/standards,.agentic-workflow/mcps,.githooks"; then
        passed_tests=$((passed_tests + 1))
    fi
    cleanup
    
    # Test 2: Claude Code installation
    total_tests=$((total_tests + 1))
    if run_test "Claude Code Installation" "--claude-code" ".agentic-workflow/instructions,.claude/commands,.claude/agents,.agentic-workflow/sessions,docs/standards,.githooks"; then
        passed_tests=$((passed_tests + 1))
    fi
    cleanup
    
    # Test 3: Cursor installation
    total_tests=$((total_tests + 1))
    if run_test "Cursor Installation" "--cursor" ".agentic-workflow/instructions,.cursor/rules,.agentic-workflow/sessions,docs/standards,.githooks"; then
        passed_tests=$((passed_tests + 1))
    fi
    cleanup
    
    # Test 4: Combined installation
    total_tests=$((total_tests + 1))
    if run_test "Combined Installation" "--claude-code --cursor" ".agentic-workflow/instructions,.claude/commands,.claude/agents,.cursor/rules,.agentic-workflow/sessions,docs/standards,.githooks"; then
        passed_tests=$((passed_tests + 1))
    fi
    cleanup
    
    # Test 5: Help functionality
    total_tests=$((total_tests + 1))
    log_info "Running test: Help Functionality"
    if $INSTALL_SCRIPT --help | grep -q "Usage:"; then
        log_success "Test passed: Help Functionality"
        passed_tests=$((passed_tests + 1))
    else
        log_error "Test failed: Help Functionality"
    fi
    
    # Test Results Summary
    echo ""
    log_info "=========================================="
    log_info "           TEST RESULTS SUMMARY           "
    log_info "=========================================="
    log_info "Total tests: $total_tests"
    log_info "Passed: $passed_tests"
    log_info "Failed: $((total_tests - passed_tests))"
    
    if [ $passed_tests -eq $total_tests ]; then
        log_success "ALL TESTS PASSED! ✅"
        return 0
    else
        log_error "SOME TESTS FAILED! ❌"
        return 1
    fi
}

# Detailed verification function
verify_installation_details() {
    local test_dir="$1"
    
    log_info "Running detailed verification of installation..."
    
    cd "$test_dir"
    
    # Verify directory structure
    local dirs_to_check=(
        ".agentic-workflow"
        ".agentic-workflow/instructions"
        ".agentic-workflow/sessions"
        ".agentic-workflow/sessions/current"
        ".agentic-workflow/sessions/completed"
        ".agentic-workflow/recaps"
        ".agentic-workflow/mcps"
        "docs"
        "docs/standards"
        ".githooks"
    )
    
    for dir in "${dirs_to_check[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Missing directory: $dir"
            return 1
        fi
    done
    
    # Verify key files exist
    local files_to_check=(
        ".agentic-workflow/sessions/discoveries.md"
        ".agentic-workflow/mcps/codanna-setup.md"
        ".agentic-workflow/mcps/mcp-integration.md"
        ".githooks/commit-msg"
        ".githooks/post-commit"
        ".githooks/pre-commit"
    )
    
    for file in "${files_to_check[@]}"; do
        if [ ! -f "$file" ]; then
            log_error "Missing file: $file"
            return 1
        fi
    done
    
    # Verify git hooks are executable
    if [ ! -x ".githooks/commit-msg" ]; then
        log_error "Git hook not executable: .githooks/commit-msg"
        return 1
    fi
    
    # Verify git config was updated
    if ! git config core.hooksPath | grep -q ".githooks"; then
        log_error "Git hooks path not configured"
        return 1
    fi
    
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
    
    # Run all tests
    if run_tests; then
        # Run one final detailed verification test
        log_info "Running final detailed verification test..."
        mkdir -p "$TEST_DIR"
        cd "$TEST_DIR"
        git init --quiet
        git config user.email "test@example.com"
        git config user.name "Test User"
        
        $INSTALL_SCRIPT --claude-code --cursor >/dev/null 2>&1
        
        if verify_installation_details "$TEST_DIR"; then
            log_success "🎉 COMPLETE TEST SUITE PASSED! Installation script is working correctly."
            exit 0
        else
            log_error "❌ Final detailed verification failed"
            exit 1
        fi
    else
        log_error "❌ Test suite failed"
        exit 1
    fi
}

# Run main function
main "$@"