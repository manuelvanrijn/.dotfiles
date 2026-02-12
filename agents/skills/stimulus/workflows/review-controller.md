# Workflow: Review Stimulus Controllers

<required_reading>
**Read these reference files NOW:**
1. references/anti-patterns.md
2. references/architecture.md
3. references/ui-patterns.md
4. references/stimulus-use.md
5. references/performance.md
</required_reading>

<process>
## Step 1: Gather Controllers

Ask the user which controller(s) to review:
- Single controller file path
- Multiple controller paths
- "All controllers" (scan `app/javascript/controllers/`)

Read all specified controller files before proceeding.

## Step 2: Run Checklist Per Controller

For each controller, evaluate against this checklist:

### Architecture & Structure
- [ ] Single responsibility (not a "god controller")
- [ ] Appropriate use of static definitions (targets, values, classes, outlets)
- [ ] Clean lifecycle methods (connect/disconnect properly paired)
- [ ] No state stored in JS properties (use values instead)

### Targets & DOM
- [ ] Uses targets instead of querySelector
- [ ] No excessive target queries in loops (cache if needed)
- [ ] HTML in templates, not JS strings
- [ ] Uses Classes API instead of hard-coded class names

### Values & State
- [ ] Default values provided where appropriate
- [ ] Arrays/objects assigned as new references (not mutated)
- [ ] Value change callbacks used for reactive updates
- [ ] State survives Turbo navigation

### Actions & Events
- [ ] Uses data-action instead of addEventListener
- [ ] Proper event modifiers (:prevent, :stop) where needed
- [ ] Debounce/throttle on input handlers
- [ ] No manual event listener setup without cleanup

### Communication
- [ ] Uses outlets or events (not tight coupling via querySelector)
- [ ] No circular dependencies between controllers
- [ ] Custom events dispatched for cross-controller communication

### Cleanup & Memory
- [ ] disconnect() cleans up everything from connect()
- [ ] Timers cleared (clearInterval, clearTimeout)
- [ ] Event listeners removed
- [ ] Third-party libraries destroyed

### Turbo Compatibility
- [ ] Handles page cache restoration
- [ ] No assumptions about connect() running once
- [ ] External libraries properly destroyed/reinitialized

### Performance
- [ ] No layout thrashing (batched reads/writes)
- [ ] Expensive operations debounced
- [ ] Lazy initialization where appropriate
- [ ] No unnecessary DOM queries

### Existing Solutions
- [ ] Check if stimulus-components has equivalent
- [ ] Check if stimulus-use mixin would simplify
- [ ] Consider Rails helper wrapper if used 3+ times

## Step 3: Generate Report

For each controller, output:

```
## [controller_name]_controller.js

### Summary
[1-2 sentence overview of controller quality]

### Issues Found
1. **[Category]**: [Issue description]
   - Line X: [specific code reference]
   - Fix: [how to resolve]

2. ...

### Recommendations
- [Suggested improvements that aren't bugs]

### Good Practices
- [What the controller does well]
```

## Step 4: Prioritize Fixes

After all controllers reviewed, provide:

```
## Priority Fixes

### Critical (bugs, memory leaks)
1. [controller]: [issue]

### High (anti-patterns, maintenance burden)
1. [controller]: [issue]

### Low (nice-to-have improvements)
1. [controller]: [issue]
```

## Step 5: Offer to Fix

Ask the user:
"Would you like me to fix any of these issues? I can:
1. Fix all critical issues
2. Fix specific issues (list numbers)
3. Show me the fixes without applying them"
</process>

<review_patterns>
## Quick Reference: What to Look For

**Red Flags (always fix):**
```javascript
// State in JS property
this.count = 0

// querySelector instead of target
this.element.querySelector(".btn")

// HTML strings in JS
this.element.innerHTML = `<div>...</div>`

// addEventListener without cleanup
document.addEventListener("keydown", this.handler)

// Mutating arrays
this.itemsValue.push(item)
```

**Yellow Flags (consider fixing):**
```javascript
// Hard-coded classes
this.element.classList.add("hidden")

// No debounce on search
search(event) { fetch(`/search?q=${event.target.value}`) }

// Tight coupling
document.querySelector('[data-controller="other"]')
```

**Green Patterns (good):**
```javascript
// Values for state
static values = { count: { type: Number, default: 0 } }

// Targets for DOM
static targets = ["button", "output"]

// Classes API
static classes = ["active", "hidden"]

// Proper cleanup
disconnect() {
  this.observer?.disconnect()
  clearInterval(this.timer)
}

// stimulus-use for common behaviors
connect() {
  useClickOutside(this)
  useDebounce(this, { wait: 300 })
}
```
</review_patterns>

<stimulus_components_check>
## Check Against stimulus-components

If the controller implements any of these, suggest the library instead:

| Controller Purpose | Use Instead |
|-------------------|-------------|
| Modal/dialog | @stimulus-components/dialog |
| Dropdown menu | @stimulus-components/dropdown |
| Copy to clipboard | @stimulus-components/clipboard |
| Toast notifications | @stimulus-components/notification |
| Show/hide toggle | @stimulus-components/reveal |
| Drag and drop | @stimulus-components/sortable |
| Lazy load content | @stimulus-components/content-loader |
| Auto-submit form | @stimulus-components/auto-submit |
| Character counter | @stimulus-components/character-counter |
| Password toggle | @stimulus-components/password-visibility |
</stimulus_components_check>

<success_criteria>
Review is complete when:
- All specified controllers have been read and evaluated
- Each controller has a clear summary with issues categorized
- Priority list helps user know where to focus
- User has been offered concrete fixes
</success_criteria>
