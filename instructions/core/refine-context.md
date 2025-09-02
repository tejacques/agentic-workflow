---
description: Analyze current session for discoveries and update institutional knowledge documentation
globs:
alwaysApply: false
encoding: UTF-8
---

# Context Refinement Rules

## Overview

Analyze session transcripts for significant discoveries and update institutional knowledge to help future implementers.

<pre_flight_check>
  EXECUTE: @.agentic-workflow/instructions/meta/pre-flight.md
</pre_flight_check>

<process_flow>

<step number="1" subagent="knowledge-curator" name="transcript_analysis">

### Step 1: Transcript Analysis

Use the knowledge-curator subagent to analyze current and recent session transcripts for significant discoveries.

<transcript_sources>
  <current_session>@.agentic-workflow/sessions/current/transcript.md</current_session>
  <recent_completed>Most recent 2-3 sessions in @.agentic-workflow/sessions/completed/</recent_completed>
</transcript_sources>

<instructions>
  ACTION: Use knowledge-curator subagent
  REQUEST: "Analyze current session transcript for institutional knowledge:
            - Current session: .agentic-workflow/sessions/current/transcript.md  
            - Look for discoveries, changed assumptions, unexpected behaviors
            - Identify insights that would help future implementers
            - Focus on technical discoveries, not routine implementation"
  WAIT: For discovery analysis and recommendations
</instructions>

</step>

<step number="2" subagent="knowledge-curator" name="discovery_extraction">

### Step 2: Discovery Extraction

Use the knowledge-curator subagent to extract and format qualified discoveries.

<discovery_criteria>
  <high_value>
    - Unexpected system behaviors or constraints
    - Hidden dependencies between components  
    - Incorrect initial assumptions that were corrected
    - Non-obvious technical limitations
    - Architectural insights from implementation
    - Integration challenges and solutions
  </high_value>
  
  <exclude>
    - Routine implementation details
    - Standard coding patterns
    - Expected behaviors
    - Temporary debugging issues
  </exclude>
</discovery_criteria>

<instructions>
  ACTION: Use knowledge-curator subagent to extract discoveries
  REQUEST: "For each qualified discovery found:
            - Format using the institutional knowledge template
            - Provide concrete context and technical details
            - Explain impact on future development
            - Include resolution or workaround if applicable"
  PROCESS: Formatted discovery entries
</instructions>

</step>

<step number="3" subagent="knowledge-curator" name="knowledge_integration">

### Step 3: Knowledge Integration

Use the knowledge-curator subagent to integrate discoveries into institutional knowledge.

<integration_targets>
  <discoveries_file>@.agentic-workflow/sessions/discoveries.md</discoveries_file>
  <related_docs>Any spec or standards files that discoveries relate to</related_docs>
</integration_targets>

<instructions>
  ACTION: Use knowledge-curator subagent  
  REQUEST: "Update institutional knowledge:
            - Add new discoveries to .agentic-workflow/sessions/discoveries.md
            - Check for patterns with existing discoveries
            - Update related documentation if discoveries reveal broader insights
            - Maintain chronological organization"
  VERIFY: All updates are properly integrated
</instructions>

</step>

<step number="4" name="documentation_updates">

### Step 4: Related Documentation Updates  

Check if discoveries should update other project documentation.

<documentation_targets>
  <technical_specs>
    IF discoveries reveal system constraints:
      UPDATE relevant technical-spec.md files
      ADD discovered limitations to scope considerations
  </technical_specs>
  
  <standards>
    IF discoveries suggest new best practices:
      CONSIDER updating docs/standards/ files
      ADD new patterns or anti-patterns discovered
  </standards>
  
  <workflow_improvements>
    IF discoveries suggest workflow improvements:
      CONSIDER updating instruction files
      ADD new error handling or validation steps
  </workflow_improvements>
</documentation_targets>

<update_process>
  FOR each documentation update needed:
    IDENTIFY specific file and section to update
    DESCRIBE proposed change clearly
    ASK user for approval before making changes
    UPDATE file if approved
    LOG changes to current session transcript
</update_process>

</step>

<step number="5" name="refinement_summary">

### Step 5: Refinement Summary

Provide summary of knowledge refinement activities.

<summary_template>
  ## 📚 Context Refinement Summary
  
  **Analysis Date**: [current-date]
  **Sessions Analyzed**: [list of session files analyzed]
  
  ### 🔍 Discoveries Identified: [count]
  [Brief bullet list of discovery titles]
  
  ### 📝 Documentation Updates: [count]  
  [List of files updated with brief description]
  
  ### 💡 Key Insights
  [1-2 most significant discoveries that affect future work]
  
  ### 📋 Follow-up Actions
  [Any recommended follow-up actions for broader improvements]
</summary_template>

</step>

<step number="6" name="session_logging">

### Step 6: Session Activity Logging

Log refinement activity to current session transcript.

<logging_format>
  ### [HH:MM] Context Refinement Session
  
  **Discoveries Added**: [count] new institutional knowledge entries
  **Documentation Updated**: [list of updated files]  
  **Analysis Scope**: [session files analyzed]
  **Key Insights**: [brief summary of most important discoveries]
</logging_format>

<session_state_update>
  IF discoveries affect current task context:
    UPDATE task-state.json with relevant new insights
    UPDATE context.json with refined understanding
</session_state_update>

</step>

</process_flow>

<post_flight_check>
  EXECUTE: @.agentic-workflow/instructions/meta/post-flight.md
</post_flight_check>

## Trigger Conditions

### Automatic Triggers
- After task completion in execute-tasks workflow
- When sessions are archived to completed/
- Before major milestone reviews

### Manual Triggers  
- User runs /refine-context command
- After resolving complex technical issues
- When patterns emerge across multiple sessions

## Quality Standards

### Discovery Quality
1. **Objective**: Focus on facts, not opinions
2. **Actionable**: Knowledge should influence future decisions  
3. **Specific**: Provide concrete examples and technical details
4. **Timeless**: Capture insights that remain relevant over time

### Documentation Quality
1. **Searchable**: Use clear, descriptive titles and keywords
2. **Contextual**: Provide sufficient context for understanding
3. **Linked**: Cross-reference related discoveries and documentation
4. **Maintained**: Keep discoveries current and remove obsolete entries

## Common Refinement Patterns

### Technical Discoveries
- "Library X behaves differently than documented when..."
- "Performance degrades significantly when..."  
- "Integration with Y requires undocumented configuration..."

### Process Improvements
- "Testing approach Z proved much more effective..."
- "Debugging technique A saved significant time..."
- "Architecture pattern B scales better than expected..."

### Assumption Corrections
- "Initially assumed X, but discovered Y..."
- "Expected simple integration, but required complex..."
- "Thought performance would be adequate, but..."

The context refinement process transforms individual learning into organizational knowledge, ensuring insights are preserved and accessible for future development cycles.