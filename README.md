# Agentic Project Workflow

## Spec-driven agentic development.

Agentic Project Workflow provides structured workflows that capture your standards, your stack, and the unique details of your codebase. It gives your AI agents the specs they need to consistently ship quality code.

## What it does

Agentic Project Workflow includes:

- **📋 Instructions** - Step-by-step workflows for product planning, spec creation, task execution, and analysis
- **📐 Standards** - Code style guides, best practices, and tech stack definitions
- **🤖 Commands** - Ready-to-use AI commands for Claude Code and Cursor
- **🎯 Agents** - Specialized agents for context fetching, file creation, git workflows, testing, and project management

## Installation

### 1. Clone and customize your base setup
```bash
# Clone the repository
git clone https://github.com/tejacques/agentic-workflow.git ~/

# Customize standards and instructions to fit your needs
cd ~/agentic-workflow
# Edit files in instructions/, standards/, commands/, etc.
```

### 2. Install into any project
```bash
# Navigate to your project
cd ~/my-project

# Install Agentic Project Workflow locally (no internet required!)
bash ~/agentic-workflow/setup/install.sh

# Or with Claude Code support
bash ~/agentic-workflow/setup/install.sh --claude-code

# Or with Cursor support  
bash ~/agentic-workflow/setup/install.sh --cursor

# Or both
bash ~/agentic-workflow/setup/install.sh --claude-code --cursor
```

## Usage

### Claude Code Commands
After installation with `--claude-code`:

**Core Workflow:**
- `/plan-product` - Set the mission & roadmap for a new product
- `/analyze-product` - Set up the mission and roadmap for an existing product  
- `/create-spec` - Create a spec for a new feature
- `/execute-tasks` - Build and ship code for a new feature

**Advanced Features:**
- `/resume-task` - Resume interrupted tasks with full context restoration
- `/refine-context` - Capture discoveries and update institutional knowledge

### Cursor Rules
After installation with `--cursor`:

**Core Workflow:**
- `@plan-product` - Set the mission & roadmap for a new product
- `@analyze-product` - Set up the mission and roadmap for an existing product
- `@create-spec` - Create a spec for a new feature  
- `@execute-tasks` - Build and ship code for a new feature

**Advanced Features:**
- `@resume-task` - Resume interrupted tasks with full context restoration  
- `@refine-context` - Capture discoveries and update institutional knowledge

## Installation Options

```bash
bash ~/agentic-workflow/setup/install.sh [OPTIONS]

Options:
  --claude-code               Add Claude Code support
  --cursor                    Add Cursor support
  --overwrite-instructions    Overwrite existing instruction files
  --overwrite-standards       Overwrite existing standards files
  --project-type=TYPE         Use specific project type for installation
  -h, --help                  Show help message
```

## Project Structure

After installation, your project will have:

```
your-project/
├── docs/
│   └── standards/         # Code standards and best practices
├── .agentic-workflow/     # Main workflow directory
│   ├── instructions/      # Workflow instructions
│   ├── specs/            # Feature specifications (created during workflow)
│   ├── sessions/         # Session logging and context management
│   │   ├── current/      # Active session state
│   │   ├── completed/    # Archived sessions
│   │   └── discoveries.md # Institutional knowledge
│   ├── recaps/           # Feature completion summaries
│   └── mcps/             # MCP integration guides
├── .claude/              # Claude Code files (if --claude-code)
│   ├── commands/         # AI commands
│   └── agents/           # Specialized agents
├── .cursor/              # Cursor files (if --cursor)
│   └── rules/            # Cursor command rules
└── .githooks/            # Git hooks for project standards
```

## Key Features

### 🧠 **Session Persistence & Context Management**
- **Resume Interrupted Work**: Never lose context when switching tasks or sessions
- **Conversation Logging**: Complete transcript of all development sessions
- **Task State Recovery**: Pick up exactly where you left off with full context
- **Context Serialization**: Preserve decisions, blockers, and implementation details

### ✅ **Built-in Quality Assurance**
- **Acceptance Criteria Validation**: Automatic verification against original spec requirements
- **Gap Analysis**: Detailed reporting of missing functionality before deployment
- **Spec Compliance**: Ensures deliverables match user stories and scope

### 📚 **Institutional Knowledge Capture**
- **Discovery Documentation**: Automatically capture unexpected behaviors and learnings
- **Technical Insights**: Build a knowledge base of non-obvious implementation details
- **Future Guidance**: Help future developers avoid pitfalls and understand system evolution
- **Decision Tracking**: Record how and why technical decisions changed during implementation

### 🔧 **Enhanced Development Tools**
- **Semantic Code Search**: Optional Codanna integration for intelligent codebase navigation
- **Git Standards Enforcement**: Automated hooks prevent Claude attribution in commits
- **Dynamic Installation**: Robust installer automatically discovers new commands and agents
- **Conditional Enhancement**: Advanced features degrade gracefully when not available

## Benefits

- 🚀 **Local-first** - No internet dependency after initial clone
- ⚡ **Fast installation** - Local copying vs. downloading
- 🎛️ **Full customization** - Edit your base setup to fit your needs
- 📶 **Works offline** - Perfect for air-gapped environments
- 🔄 **Easy updates** - Just run the install script again
- 🛡️ **Reliable** - No network failures or API limits

---

Keep building! 🚀
