---
description: Resume interrupted task with full context restoration from session logs
globs:
alwaysApply: false
encoding: UTF-8
---

# Task Resume Rules

## Overview

Resume an interrupted task by restoring context from session logs and continuing from the last known state.

<pre_flight_check>
  EXECUTE: @.agentic-workflow/instructions/meta/pre-flight.md
</pre_flight_check>

<process_flow>

<step number="1" name="session_state_analysis">

### Step 1: Session State Analysis

Check for current session state and determine what task was interrupted.

<session_files>
  <task_state>@.agentic-workflow/sessions/current/task-state.json</task_state>
  <context>@.agentic-workflow/sessions/current/context.json</context>
  <transcript>@.agentic-workflow/sessions/current/transcript.md</transcript>
</session_files>

<state_validation>
  IF all session files exist:
    PROCEED to context restoration
  ELSE:
    INFORM user no active session found
    SUGGEST starting new task instead
    EXIT process
</state_validation>

</step>

<step number="2" name="context_restoration">

### Step 2: Context Restoration

Read and analyze session files to restore complete working context.

<context_loading>
  <task_identification>
    READ task-state.json for:
    - Current spec folder path
    - Active task number and description
    - Subtask progress and completion status
    - Last known working state
  </task_identification>
  
  <context_reconstruction>
    READ context.json for:
    - Loaded context files and their key points
    - Decision history and rationale
    - Active variables and state
    - Integration context (MCPs, tools, etc.)
  </context_reconstruction>
  
  <conversation_history>
    READ transcript.md for:
    - Recent conversation flow
    - Last user instructions
    - Current blockers or issues
    - Implementation decisions made
  </conversation_history>
</context_loading>

</step>

<step number="3" name="state_verification">

### Step 3: State Verification

Verify current project state matches session expectations.

<verification_checks>
  <spec_validation>
    VERIFY spec folder exists at recorded path
    CONFIRM tasks.md matches expected state
    CHECK for any external changes since session save
  </spec_validation>
  
  <branch_validation>
    CHECK current git branch matches expected branch
    VERIFY no uncommitted changes conflict with planned work
    CONFIRM working directory is clean or as expected
  </branch_validation>
  
  <file_validation>
    CHECK all referenced files still exist
    VERIFY no critical files were modified externally
    CONFIRM development environment is ready
  </file_validation>
</verification_checks>

</step>

<step number="4" name="resume_presentation">

### Step 4: Resume Presentation

Present current state and next steps to user for confirmation.

<resume_summary>
  ## 🔄 Task Resume Summary
  
  **Spec**: [spec-name] ([spec-folder-path])
  **Task**: [current-task-description]
  **Progress**: [completed-subtasks] of [total-subtasks] subtasks completed
  **Last Activity**: [timestamp of last session activity]
  
  ### ✅ Completed Subtasks
  - [list of completed subtasks with checkmarks]
  
  ### 📋 Next Steps  
  - [next-subtask-description]
  - [subsequent-subtasks if applicable]
  
  ### 📝 Recent Context
  [Summary of last 2-3 important decisions or blockers from transcript]
  
  ### ⚠️ Notes
  [Any important caveats, blockers, or context from session state]
</resume_summary>

<continuation_options>
  PROMPT user with options:
  1. "Continue with next subtask: [subtask-description]"
  2. "Review and modify plan before continuing"  
  3. "Start fresh analysis of current state"
  4. "Switch to different task or spec"
</continuation_options>

</step>

<step number="5" name="seamless_continuation">

### Step 5: Seamless Continuation

Based on user choice, continue with appropriate workflow.

<continuation_flow>
  <option_1_continue>
    IF user chooses to continue:
      LOAD @.agentic-workflow/instructions/core/execute-task.md
      CONTINUE with current task from next subtask
      UPDATE session state as work progresses
  </option_1_continue>
  
  <option_2_review>
    IF user wants to review plan:
      PRESENT current tasks.md for modification
      ALLOW updates to task breakdown  
      SAVE changes to session state
      THEN proceed with execution
  </option_2_review>
  
  <option_3_fresh_start>
    IF user wants fresh analysis:
      ARCHIVE current session to completed/
      START new analysis of spec requirements
      CREATE new session state
      PROCEED with standard execute-tasks flow
  </option_3_fresh_start>
  
  <option_4_switch>
    IF user wants to switch tasks:
      SAVE current session state
      PROMPT for new task/spec selection
      LOAD different context as appropriate
  </option_4_switch>
</continuation_flow>

</step>

<step number="6" name="session_state_update">

### Step 6: Session State Update

Update session files with resumed activity.

<state_updates>
  <transcript_update>
    APPEND to transcript.md:
    - Resume timestamp and context
    - User continuation choice
    - Any plan modifications made
  </transcript_update>
  
  <task_state_update>
    UPDATE task-state.json:
    - Resume timestamp
    - Current active subtask
    - Any modified task breakdown
  </task_state_update>
  
  <context_refresh>
    UPDATE context.json:
    - Refreshed file states
    - Updated working variables
    - Current session configuration
  </context_refresh>
</state_updates>

</step>

</process_flow>

<post_flight_check>
  EXECUTE: @.agentic-workflow/instructions/meta/post-flight.md
</post_flight_check>

## Error Handling

### No Session Found
If no current session exists:
- Inform user clearly
- Suggest alternative actions (start new task, check completed sessions)
- Do not create empty session state

### Corrupted Session State
If session files are corrupted or inconsistent:
- Report specific issues found
- Offer to start fresh analysis
- Preserve corrupted files for debugging

### External Changes
If project state doesn't match session expectations:
- Report discrepancies clearly
- Ask user how to proceed
- Update session state to match reality

## Best Practices

1. **Context Preservation**: Maintain all original context and decisions
2. **State Consistency**: Ensure all session files remain synchronized
3. **User Agency**: Always confirm next steps with user
4. **Graceful Degradation**: Handle missing or corrupted session data elegantly
5. **Audit Trail**: Log all resume activities to transcript

The resume functionality should feel seamless, as if the conversation never stopped.