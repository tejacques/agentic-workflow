---
description: Initialize a new product with mission, roadmap, and Agentic Project Workflow setup
argument-hint: [product-name] [project-directory]
allowed-tools: Task(subagent_type:file-creator), Read, Write, Edit, Bash, Grep, Glob
---

# Plan Product

Initialize a new product with comprehensive mission documentation, strategic roadmap, and complete Agentic Project Workflow setup.

## Usage

```
/plan-product [product-name] [project-directory]
```

**Arguments:**
- `product-name` (required): Name of the product you're planning (e.g., "TaskFlow", "ChatBot Pro")
- `project-directory` (optional): Target directory path for the project setup

## What This Command Does

1. **Product Strategy Creation**: Develops core product documentation including:
   - Mission statement with target users and problems solved
   - Technical stack decisions and architecture guidelines  
   - Initial roadmap with phases and milestones
   - Decision log for tracking strategic choices

2. **Workflow Installation**: Sets up complete Agentic Project Workflow infrastructure:
   - Installs workflow instructions and templates
   - Configures standards and best practices
   - Sets up spec and session management structure
   - Establishes git hooks and automation

3. **Environment Preparation**: Prepares the development environment:
   - Creates project directory structure
   - Initializes version control if needed
   - Sets up code standards and style guides
   - Configures development tooling integration

## Generated Structure

```
your-product/
├── docs/
│   ├── product/
│   │   ├── mission.md          # Full mission document
│   │   ├── mission-lite.md     # Executive summary
│   │   ├── roadmap.md          # Product roadmap
│   │   ├── tech-stack.md       # Technical decisions
│   │   └── decisions.md        # Decision log
│   └── standards/              # Code standards and guidelines
├── .agentic-workflow/          # Workflow infrastructure
│   ├── instructions/           # Process definitions
│   ├── sessions/              # Session management
│   └── specs/                 # Feature specifications (created as needed)
└── .claude/                   # Claude Code integration
    ├── commands/              # Workflow commands
    └── agents/                # Specialized agents
```

## Examples

```bash
# Plan a new SaaS product
/plan-product "TaskFlow Pro" ~/projects/taskflow

# Plan mobile app in current directory
/plan-product "FitnessTracker"

# Plan enterprise solution with specific path
/plan-product "DataViz Dashboard" /workspace/enterprise-dash

# Plan simple product (will prompt for details)
/plan-product MyApp
```

## What You'll Be Asked

The command will guide you through defining:
- **Target Users**: Who will use this product?
- **Core Problem**: What problem does it solve?
- **Value Proposition**: What makes it different/better?
- **Technical Approach**: Framework, database, architecture preferences
- **Launch Timeline**: When do you want to ship the first version?

## Best Practices

- **Be Specific**: Clear product names and problem statements lead to better roadmaps
- **Think Users First**: Focus on user value rather than technical features
- **Start Simple**: Initial roadmap should focus on MVP functionality
- **Document Decisions**: The decision log captures reasoning for future reference

## Related Commands

- `/analyze-product` - Set up workflow for existing products
- `/create-spec` - Create feature specifications after product planning
- `/execute-tasks` - Implement planned features

## Implementation Details

Detailed planning process and templates are defined in:
@.agentic-workflow/instructions/core/plan-product.md
