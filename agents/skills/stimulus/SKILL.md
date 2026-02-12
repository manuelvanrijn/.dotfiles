---
name: stimulus
description: Build Stimulus controllers from scratch through production. Full lifecycle - create, debug, test, optimize, integrate with Turbo. Covers targets, values, actions, outlets, and UI patterns.
---

<essential_principles>
## How Stimulus Works

Stimulus is a modest JavaScript framework that connects JavaScript behavior to HTML via data attributes. It doesn't render HTML—it enhances existing HTML with interactivity.

### 1. HTML-First Philosophy

State lives in the DOM, not JavaScript. Controllers can be discarded between page changes and reinitialize from cached HTML. Design controllers to read state from data attributes and restore themselves on reconnection.

### 2. Convention Over Configuration

Stimulus uses predictable naming conventions:
- Controller: `data-controller="clipboard"`
- Targets: `data-clipboard-target="source"`
- Actions: `data-action="click->clipboard#copy"`
- Values: `data-clipboard-url-value="/api/copy"`
- Classes: `data-clipboard-supported-class="visible"`
- Outlets: `data-clipboard-result-outlet="#result"`

### 3. Lifecycle Awareness

Controllers have three lifecycle callbacks:
- `initialize()` - Called once when controller is instantiated
- `connect()` - Called when controller is connected to DOM (can happen multiple times with Turbo)
- `disconnect()` - Called when controller is removed from DOM

Always clean up in `disconnect()` what you set up in `connect()` (timers, event listeners, observers).

### 4. Scope Isolation

Each controller only sees elements within its scope (the element with `data-controller` and its descendants). Targets must be within scope. Use outlets to communicate across controller boundaries.

### 5. Progressive Enhancement

Build HTML that works without JavaScript first. Use Stimulus to enhance, not replace. Check for API support before using features:
```javascript
connect() {
  if ("clipboard" in navigator) {
    this.element.classList.add(this.supportedClass)
  }
}
```
</essential_principles>

<intake>
**What would you like to do?**

1. Build a new controller
2. Debug an existing controller
3. Add a feature to a controller
4. Review controller(s) for best practices
5. Optimize performance
6. Implement a UI pattern (modal, dropdown, tabs, etc.)
7. Integrate with Turbo
8. Handle forms
9. Something else

**Wait for response before proceeding.**
</intake>

<routing>
| Response | Workflow |
|----------|----------|
| 1, "new", "create", "build", "start" | `workflows/build-new-controller.md` |
| 2, "broken", "fix", "debug", "crash", "bug", "not working" | `workflows/debug-controller.md` |
| 3, "add", "feature", "extend", "modify" | `workflows/add-feature.md` |
| 4, "review", "audit", "check", "best practices", "patterns" | `workflows/review-controller.md` |
| 5, "slow", "optimize", "performance", "fast", "memory" | `workflows/optimize-performance.md` |
| 6, "modal", "dropdown", "tabs", "accordion", "toggle", "UI", "pattern" | `workflows/implement-ui-pattern.md` |
| 7, "turbo", "frames", "streams", "hotwire" | `workflows/integrate-turbo.md` |
| 8, "form", "validation", "submit", "input" | `workflows/handle-forms.md` |
| 9, other | Clarify, then select workflow or references |

**After reading the workflow, follow it exactly.**
</routing>

<verification_loop>
## After Every Change

1. **Does it connect?** Check browser console for Stimulus connection messages
2. **Do targets resolve?** Verify `this.hasXxxTarget` returns true
3. **Do actions fire?** Add temporary console.log in action methods
4. **Does it clean up?** Navigate away and back - no errors, no memory leaks

```javascript
// Debug mode - add to application.js
application.debug = true
```

Report to the user:
- "Controller connects: ✓"
- "Targets found: X of Y"
- "Actions working: ✓/✗"
- "Ready for testing"
</verification_loop>

<reference_index>
## Domain Knowledge

All in `references/`:

**Core APIs:** architecture.md, targets.md, values.md, actions.md, outlets.md, classes.md
**Ecosystem:** stimulus-use.md, ui-patterns.md
**Integration:** turbo-integration.md
**Quality:** testing-debugging.md, performance.md, anti-patterns.md
</reference_index>

<workflows_index>
## Workflows

All in `workflows/`:

| File | Purpose |
|------|---------|
| build-new-controller.md | Create new controller from scratch |
| debug-controller.md | Find and fix bugs |
| add-feature.md | Add functionality to existing controller |
| review-controller.md | Audit controllers for best practices |
| optimize-performance.md | Profile and speed up |
| implement-ui-pattern.md | Build modals, dropdowns, tabs, etc. |
| integrate-turbo.md | Work with Turbo Frames/Streams |
| handle-forms.md | Form validation and submission |
</workflows_index>
