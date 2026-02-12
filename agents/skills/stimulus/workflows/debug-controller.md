# Workflow: Debug Controller

<required_reading>
**Read these reference files NOW before debugging:**
1. references/testing-debugging.md
2. references/architecture.md
3. references/anti-patterns.md
</required_reading>

<process>
## Step 1: Enable Debug Mode

```javascript
// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"
const application = Application.start()
application.debug = true  // Logs connect/disconnect events
window.Stimulus = application  // Access from console
```

For stimulus-use mixins:
```javascript
application.stimulusUseDebug = true
```

## Step 2: Check Controller Connection

Open browser console and look for:
- `"clipboard" connected` (good)
- No message (controller not connecting)

**If not connecting:**

1. **Check data-controller attribute:**
```html
<!-- Correct -->
<div data-controller="clipboard">

<!-- Wrong - typo -->
<div data-controller="clipboad">

<!-- Wrong - camelCase -->
<div data-controller="clipBoard">
```

2. **Check file naming:**
```
✓ clipboard_controller.js
✗ clipboardController.js
✗ clipboard.js
```

3. **Check controller registration:**
```javascript
// With importmaps - run:
// bin/rails stimulus:manifest:update

// Check app/javascript/controllers/index.js
import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)
```

4. **Check for JavaScript errors** in console before Stimulus loads

## Step 3: Check Targets

```javascript
// In controller or console
console.log("Has source target:", this.hasSourceTarget)
console.log("Source targets:", this.sourceTargets)
console.log("Source target:", this.sourceTarget)  // Throws if missing
```

**If targets not found:**

1. **Check target is within controller scope:**
```html
<div data-controller="clipboard">
  <!-- ✓ Inside scope -->
  <input data-clipboard-target="source">
</div>
<!-- ✗ Outside scope -->
<input data-clipboard-target="source">
```

2. **Check target naming:**
```html
<!-- Correct -->
<input data-clipboard-target="source">

<!-- Wrong - wrong controller name -->
<input data-other-target="source">

<!-- Wrong - camelCase in HTML -->
<input data-clipboard-target="sourceInput">
```

3. **Check static targets array:**
```javascript
// Must declare targets
static targets = ["source"]  // ✓
static targets = ["Source"]  // ✗ Case matters
```

## Step 4: Check Actions

Add logging to action:
```javascript
copy(event) {
  console.log("copy called", event)
  console.log("event target:", event.target)
  console.log("event currentTarget:", event.currentTarget)
}
```

**If action not firing:**

1. **Check action syntax:**
```html
<!-- Correct -->
<button data-action="click->clipboard#copy">

<!-- Wrong - missing event -->
<button data-action="clipboard#copy">

<!-- Wrong - wrong separator -->
<button data-action="click->clipboard.copy">
<button data-action="click:clipboard#copy">
```

2. **Check action name matches method:**
```javascript
// Method name
copy() { }  // ✓

// HTML
data-action="click->clipboard#copy"  // ✓
data-action="click->clipboard#Copy"  // ✗ Case matters
```

3. **Check event type:**
```html
<!-- Common events -->
data-action="click->..."
data-action="submit->..."
data-action="input->..."
data-action="change->..."
data-action="keydown->..."

<!-- Form elements have defaults -->
<form data-action="clipboard#submit">  <!-- defaults to submit event -->
<input data-action="clipboard#update"> <!-- defaults to input event -->
<button data-action="clipboard#click"> <!-- defaults to click event -->
```

## Step 5: Check Values

```javascript
console.log("URL value:", this.urlValue)
console.log("Has URL value:", this.hasUrlValue)
console.log("All values:", this.constructor.values)
```

**If values incorrect:**

1. **Check value attribute naming:**
```html
<!-- Correct - kebab-case with -value suffix -->
<div data-clipboard-url-value="/api">
<div data-clipboard-refresh-interval-value="5000">

<!-- Wrong -->
<div data-clipboard-url="/api">
<div data-clipboard-urlValue="/api">
```

2. **Check value type declaration:**
```javascript
static values = {
  url: String,
  count: Number,
  enabled: Boolean,
  items: Array,
  config: Object
}
```

3. **Check JSON for Array/Object values:**
```html
<div data-clipboard-items-value='["a","b","c"]'>
<div data-clipboard-config-value='{"key": "value"}'>
```

## Step 6: Check Outlets

```javascript
console.log("Has result outlet:", this.hasResultOutlet)
console.log("Result outlets:", this.resultOutlets)
```

**If outlets not connecting:**

1. **Check outlet selector:**
```html
<div data-controller="search"
     data-search-result-outlet="#results">
```

2. **Check target element has the controller:**
```html
<div id="results" data-controller="result">
```

3. **Check outlet declaration:**
```javascript
static outlets = ["result"]  // Use controller identifier
```

## Step 7: Check Turbo Compatibility

```javascript
connect() {
  console.log("Connected at:", new Date().toISOString())
}

disconnect() {
  console.log("Disconnected at:", new Date().toISOString())
}
```

Navigate with Turbo and check:
- Does controller reconnect?
- Are there duplicate event listeners?
- Are timers/intervals cleaned up?

**Common Turbo issues:**

```javascript
// Bad - event listener added multiple times
connect() {
  document.addEventListener("keydown", this.handler)
}

// Good - clean up in disconnect
connect() {
  this.handler = this.handleKeydown.bind(this)
  document.addEventListener("keydown", this.handler)
}

disconnect() {
  document.removeEventListener("keydown", this.handler)
}
```

## Step 8: Console Debugging

```javascript
// Access controller from console
const element = document.querySelector('[data-controller="clipboard"]')
const controller = Stimulus.getControllerForElementAndIdentifier(element, "clipboard")

// Inspect controller
console.log(controller)
console.log(controller.sourceTarget)
console.log(controller.urlValue)

// Call methods
controller.copy()
```
</process>

<common_issues>
**Controller not found:**
- Typo in data-controller name
- Controller file not registered
- JavaScript build error preventing load

**Target not found:**
- Target outside controller scope
- Typo in target name
- Target added after connect (use targetConnected callback)

**Action not firing:**
- Wrong event type
- Typo in action name
- Event propagation stopped

**Values undefined:**
- Wrong attribute format
- Type mismatch (string vs number)
- Missing default value

**Works once, breaks on navigation:**
- Not cleaning up in disconnect()
- Global event listeners accumulating
- Timers not cleared
</common_issues>

<success_criteria>
Debugging complete when:
- Controller connects without errors
- All targets are found
- Actions fire correctly
- Values have expected values
- Works after Turbo navigation
- No memory leaks (listeners cleaned up)
</success_criteria>
