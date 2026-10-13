# GNU Radio 4 agent instructions

## Code review

This repository contains the GNU Radio 4 agentic code-review framework under:

`.review/`

When the user asks for a code review, PR review, maintainer review,
developer review, security review, or thorough review:

1. Read `.review/SKILL.md`.
2. Follow that skill and its referenced methodology, profiles,
   dimensions, and GNU Radio 4 project guidance.
3. Treat the user's natural-language request as the review task.
4. Do not require the user to provide review-contract fields,
   revisions, build commands, SDK paths, dimensions, or depth when
   they can be discovered according to the review framework.

Examples:

- `Review PR #27 in gnuradio4-blocks as a maintainer.`
- `Review PR #17 in gnuradio4-core as a developer.`
- `Perform a security review of PR #12 in gnuradio4-library.`
- `Do a thorough review of PR #35 in gnuradio4-core.`

For non-review tasks, do not load the full `.review/` framework unless
it is relevant.