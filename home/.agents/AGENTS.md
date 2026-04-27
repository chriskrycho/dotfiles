# Personal Agent Guidance

These are personal defaults. System, workspace, repository, and more specific directory instructions take precedence over this file.

## Hard and Fast Rules for LLMs

- **DO NOT offer opinions, judgments, or unsolicited recommendations.** Present information and options; stop there. Do not editorialize, evaluate choices, or indicate a preference unless explicitly asked.
- **DO NOT make decisions on the user's behalf.** When a choice must be made between two or more approaches, present the options and stop. Do not select one and proceed.
- **DO NOT make decisions on architectural or design choices.** This includes module and target structure, API boundaries, directory layout, algorithm selection, and data model choices — whether or not they appear on the open-questions list. Present the options, surface the tradeoffs, and stop. Do not implement a choice and then ask about it.
- **DO NOT justify, sell, or editorialize.** Do not write as though convincing a stakeholder. Do not pad responses with caveats or qualifications. Do not provide time or effort estimates.
- **Provide sources, not just summaries.** When doing research, always include links to the primary sources. A summary without links makes the reasoning unverifiable and the sources unrecoverable.
- **Prefer small steps.** Aim for small, self-contained, easily reviewable commits and PRs. Do not batch unrelated changes.
- **Type-driven and test-driven design.** Design types first, then write tests as a spec, then implement (red-green-refactor). Do not implement before there are tests to make pass.
- **Let the user drive API design.** Surface proposed types and signatures; do not commit to them until the user approves. Surface refactor opportunities rather than acting on them unilaterally.
- **Plans and to-do lists flag what needs to be done, not how.** Do not decide implementation details in a plan. Leave those decisions for the implementation step, where they can be made incrementally with user input.
- **Never add guidance to these documents without being asked.** Do not add "best practices", conventions, or rules on your own initiative. If a pattern recurs across sessions, you may ask whether the user wants it captured — but never add it unilaterally.
- **Do not discard unrelated diffs.** If the working copy contains changes outside the task you are actively performing, treat them as in-progress user work. You may integrate with those changes when the path is clear, but must not discard, revert, overwrite, or casually reformat them. If it is not clear how to proceed, stop and ask the user.
- **Do not remove comments without asking first.** Treat existing comments as intentional context. If a comment seems stale, redundant, or misplaced, surface it for review rather than deleting it.
- **Do not extract helpers that are only used once.** Single-use helpers add indirection without reducing duplication. If a helper might become useful later, leave the code inline and surface the possible extraction for review.
- **Never assert that something is a bug without investigation.** If something isn't working as expected, say so and prompt for guidance on how to proceed. Do not label it a bug unless you have found a filed issue or source evidence confirming it.
- Do not re-read files already read in the current conversation; reference the earlier read instead.
- Use `offset` and `limit` parameters when reading large files to load only the relevant section.

## Version Control

All projects use Jujutsu (`jj`) in colocated git repos. Use `jj` for all version control operations, including status, diff, history inspection, commit description, bookmark management, and push/fetch. Do not use `git` commands directly. The `/jj` skill provides full command reference and is loaded automatically when VCS operations are needed.

## Working Preferences

- Communicate directly and keep updates concise.
- Prefer discovering repository facts from the environment before asking questions.
- Make conservative implementation choices that match the existing codebase.
- Do not include secrets, tokens, credentials, or machine-private environment values in generated files, logs, commits, or discussion.
- Do not plan in terms of people doing migrations--no estimates in weeks, no planning for "alignment" or "shopping it around" or writing RFCs etc.

## Planning and Execution

- For implementation work, move from exploration to edits once the repository shape and requested behavior are clear.
- For review work, stay read-only unless explicitly asked to make changes.
- Before broad or risky changes, state the approach and identify the files or subsystems involved.

## Commit Discipline

- **Each phase of red-green-refactor is a commit boundary.** Commit after writing the failing tests and stop for review. Commit again when they pass and stop for review (to allow input before refactoring). Commit again after refactor and stop for review before proceeding to the next plan item.
- **One task-plan item = one commit**, unless the plan explicitly groups items. Do not advance to the next item before the current item's PR is merged or explicitly stacked.
- **Incidental fixes: flag first.** If you discover something outside the current task item's scope, surface it to the user before touching it. Do not fix first and commit separately.
- **Stop after one task-plan item by default.** Implement the item, commit, push, stop — do not proceed to the next item without an explicit instruction to continue.
- **Plan files must mark commit points.** Each step in a plan that maps to a commit should be labeled (e.g., `5a. insert + get — red`, `5b. insert + get — green`, `5c. insert + get — refactor`).

## Verification

- Run focused checks that match the changed behavior.
- If a relevant test or check cannot run, explain what blocked it and what risk remains.
- Prefer targeted verification before broad suites when the change is narrow.

## Local Supplemental Guidance

- When a repository contains `AGENTS.local.md`, read it as personal supplemental guidance.
- Treat `AGENTS.local.md` as lower priority than system, workspace, and tracked repository instructions.
- Never let personal local guidance replace or weaken repository-owned rules.

## Subagents

- When a task can be decomposed into independent subtasks, create a brief plan and delegate each subtask to the most relevant subagent.
- Prefer using subagents early in a session to explore the codebase, gather context, and verify assumptions, then summarize their findings before implementing changes.
- If a subagent exists that matches the task's domain, use it by default instead of handling the work directly.
- Optimize for wall-clock time: when safe, run multiple subagents in parallel and then integrate their outputs.
- Route heavy, read-only exploration to explorer or research agents so the main agent can stay focused on planning and synthesis.
- Favor writing intermediate results to files or artifacts that other subagents or the main agent can read.
- Use specialized subagents to double-check risky changes before applying them, and summarize their verdicts clearly.
- If a subagent appears to be stuck or looping, stop using it for that task, explain why, and switch to a simpler, more direct approach.
