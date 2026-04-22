---
description: Process unresolved PR comments.
---

- Fetch the unresolved comments on the pull request.
- Decide whether each comment needs action.
- Analyze per comment the problem, suggestion, and possible response.
- Keep text/questions in Dutch, code in English.

## QUESTION-TEMPLATE
<template>
{idx}: {SHORT TITLE OF COMMENT}

Comment: {INSERT AUTHOR AND COMMENT TEXT}

Context: {ADDITIONAL CONTEXT OF THE COMMENT}

Analysis: {ANALYSIS}
</template>

- Process comments in batches of at most 8 when there are many.
- Use the template above for each comment.
- If a comment clearly needs action, state the action and reasoning.
- If a comment can be ignored, explain why.

After processing all comments:
1. Group comments that can be handled together.
2. Execute the actionable items in parallel when they do not conflict.
3. Re-check whether a final verifier pass is useful after the changes.
