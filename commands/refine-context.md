---
description: Analyze session transcripts for discoveries and update institutional knowledge base
argument-hint: [session-id]
allowed-tools: Task(subagent_type:knowledge-curator), Read, Write, Edit, Grep, Glob
---

# Refine Context

Analyze development session transcripts to extract valuable discoveries and update institutional knowledge documentation for future implementers.

## Usage

```
/refine-context [session-id]
```

**Arguments:**
- `session-id` (optional): Specific session to analyze (defaults to current/most recent session)

## What This Command Does

1. **Session Analysis**: Reviews development session transcripts for significant discoveries:
   - Unexpected system behaviors or constraints
   - Hidden dependencies between components
   - Incorrect initial assumptions that were corrected
   - Non-obvious technical limitations discovered during implementation

2. **Knowledge Extraction**: Identifies insights that transcend specific implementation details:
   - Architectural insights from implementation experience
   - Integration challenges and their solutions
   - Performance characteristics discovered during development
   - Security considerations that emerged during building

3. **Documentation Updates**: Captures discoveries in institutional knowledge base:
   - Updates `.agentic-workflow/sessions/discoveries.md` with new insights
   - Cross-references with existing discoveries for patterns
   - Updates relevant project documentation with discovered constraints

## When to Use

**Perfect timing:**
- After completing a complex implementation with unexpected challenges
- When debugging revealed system behaviors that weren't documented
- After discovering integration complexities not anticipated in planning
- Following performance issues or scalability discoveries

**Skip if:**
- Only routine, expected development work occurred
- No surprising behaviors or constraints were discovered
- Session involved only reading/analysis without implementation challenges

## Examples

```bash
# Analyze current session for discoveries
/refine-context

# Analyze specific session
/refine-context 2025-01-29-oauth-implementation

# Analyze after complex debugging session
/refine-context 2025-01-28-database-performance-issues
```

## What Gets Captured

**High-Value Discoveries:**
- "We thought X would work, but discovered Y constraint"
- "Integration with Z required unexpected configuration changes"
- "Performance degrades at N concurrent users due to connection pooling"
- "Security requirement emerged: API calls need rate limiting"

**Low-Value Information (Filtered Out):**
- Standard coding patterns and expected behaviors
- Temporary debugging issues that were easily resolved
- Personal preferences or routine implementation details

## Output

The command produces:
- Updated `discoveries.md` with new institutional knowledge entries
- Cross-references to related existing discoveries
- Recommendations for updating project documentation
- Summary of knowledge patterns identified

## Related Commands

- `/execute-tasks` - Often followed by refine-context after complex implementations
- `/resume-task` - Benefits from refined context about previous discoveries
- `/create-spec` - Informed by institutional knowledge for better planning

## Implementation Details

Detailed analysis process and discovery templates are defined in:
@.agentic-workflow/instructions/core/refine-context.md