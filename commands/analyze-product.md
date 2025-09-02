---
description: Analyze existing codebase and set up Agentic Project Workflow with product mission
argument-hint: [analysis-focus]
allowed-tools: Task(subagent_type:context-fetcher,file-creator), Read, Write, Edit, Bash, Grep, Glob
---

# Analyze Product

Analyze an existing codebase to understand its architecture, extract its mission, and set up Agentic Project Workflow with appropriate documentation and standards.

## Usage

```
/analyze-product [analysis-focus]
```

**Arguments:**
- `analysis-focus` (optional): Specific aspect to focus analysis on ("architecture", "api", "frontend", "database", or "full")

## What This Command Does

1. **Codebase Analysis**: Comprehensive examination of existing project:
   - Identifies technical stack, frameworks, and architectural patterns
   - Analyzes file structure, naming conventions, and coding standards
   - Maps API endpoints, database schemas, and component relationships  
   - Understands current feature set and user-facing functionality

2. **Mission Extraction**: Derives product understanding from existing code:
   - Infers target users from UI patterns and feature implementations
   - Identifies core problems solved by analyzing existing functionality
   - Extracts value propositions from user-facing features and flows
   - Creates mission documentation based on discovered patterns

3. **Workflow Setup**: Installs Agentic Project Workflow infrastructure:
   - Sets up workflow instructions tailored to discovered tech stack
   - Creates standards documents matching existing code patterns  
   - Establishes spec and session management structure
   - Configures agents and commands for the specific project type

## Perfect For

**Existing projects that need:**
- Structured development workflow and documentation
- Better spec-driven feature development process
- Institutional knowledge capture and sharing
- Standardized code patterns and best practices
- Strategic roadmap planning for future features

## Examples

```bash
# Full comprehensive analysis
/analyze-product

# Focus on API architecture
/analyze-product api

# Analyze frontend structure and patterns
/analyze-product frontend

# Focus on database and data modeling
/analyze-product database

# Analyze overall architecture patterns
/analyze-product architecture
```

## Analysis Areas

### Technical Stack Discovery
- **Frameworks**: Identifies React, Rails, Node.js, Django, etc.
- **Database**: PostgreSQL, MongoDB, Redis usage patterns
- **Architecture**: Monolith, microservices, serverless patterns
- **Testing**: Jest, RSpec, pytest testing approaches
- **Deployment**: Docker, CI/CD, cloud platform configurations

### Code Pattern Analysis  
- **Naming Conventions**: How files, classes, and variables are named
- **Code Organization**: Directory structures and module patterns
- **Style Guidelines**: Formatting, linting, and coding standards currently used
- **Documentation Patterns**: README structure, code comments, API docs

### Feature Understanding
- **User Flows**: Key user journeys and interaction patterns
- **Core Features**: Primary functionality and value delivered
- **Integration Points**: External APIs, third-party services, webhooks
- **Business Logic**: Core domain models and business rules

## Generated Documentation

After analysis, creates:
- **Mission Documentation**: Product mission, users, and value proposition
- **Technical Stack Document**: Comprehensive tech stack and architecture overview
- **Code Standards**: Guidelines matching existing project patterns
- **Initial Roadmap**: Suggested improvements and future feature areas

## Related Commands

- `/plan-product` - For new products without existing codebases
- `/create-spec` - Create feature specifications based on analysis insights
- `/execute-tasks` - Implement new features following discovered patterns

## Implementation Details

Detailed analysis process and extraction methods are defined in:
@.agentic-workflow/instructions/core/analyze-product.md
