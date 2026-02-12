# Workflow: Add Feature to Controller

<required_reading>
**Read these reference files NOW:**
1. references/architecture.md
2. references/values.md
3. references/outlets.md
4. references/stimulus-use.md
</required_reading>

<process>
## Step 1: Understand the Existing Controller

Read the controller and identify:
- Current targets, values, actions, outlets
- Lifecycle methods and what they do
- Dependencies (other libraries, APIs)

## Step 2: Determine Feature Type

| Feature Type | Approach |
|--------------|----------|
| New DOM manipulation | Add target + action |
| New configuration option | Add value |
| Cross-controller communication | Add outlet |
| New behavior (resize, visibility) | Use stimulus-use mixin |
| Reusable across controllers | Create mixin or base controller |

## Step 3: Add New Target (if needed)

```javascript
// Before
static targets = ["source"]

// After
static targets = ["source", "output", "status"]
```

```html
<div data-clipboard-target="output"></div>
<span data-clipboard-target="status"></span>
```

## Step 4: Add New Value (if needed)

```javascript
// Before
static values = { url: String }

// After
static values = {
  url: String,
  timeout: { type: Number, default: 3000 },
  autoClose: { type: Boolean, default: false }
}

// Add change callback if needed
timeoutValueChanged(value, previousValue) {
  this.resetTimer()
}
```

```html
<div data-controller="notification"
     data-notification-timeout-value="5000"
     data-notification-auto-close-value="true">
```

## Step 5: Add New Action (if needed)

```javascript
// Add the method
dismiss(event) {
  event.preventDefault()
  this.element.remove()
}

// Or with params
select({ params: { id, name } }) {
  console.log(`Selected ${name} (${id})`)
}
```

```html
<button data-action="click->notification#dismiss">Close</button>

<!-- With params -->
<button data-action="click->items#select"
        data-items-id-param="123"
        data-items-name-param="Widget">
  Select
</button>
```

## Step 6: Add Outlet (if cross-controller communication needed)

```javascript
// In the calling controller
static outlets = ["result"]

updateResults() {
  if (this.hasResultOutlet) {
    this.resultOutlet.refresh()
  }
}

// Handle connection/disconnection
resultOutletConnected(outlet, element) {
  console.log("Result outlet connected")
}
```

```html
<div data-controller="search"
     data-search-result-outlet="#results">
  <!-- search form -->
</div>

<div id="results" data-controller="result">
  <!-- results display -->
</div>
```

## Step 7: Add stimulus-use Behavior (if applicable)

```javascript
import { Controller } from "@hotwired/stimulus"
import { useClickOutside, useTransition } from "stimulus-use"

export default class extends Controller {
  connect() {
    useClickOutside(this)
    useTransition(this, {
      enterActive: "transition ease-out duration-300",
      enterFrom: "opacity-0",
      enterTo: "opacity-100",
      leaveActive: "transition ease-in duration-200",
      leaveFrom: "opacity-100",
      leaveTo: "opacity-0"
    })
  }

  clickOutside(event) {
    this.close()
  }
}
```

## Step 8: Dispatch Events (for loose coupling)

```javascript
save() {
  // Do the save...

  // Dispatch event for other code to listen
  this.dispatch("saved", {
    detail: { id: this.idValue, name: this.nameValue }
  })
}
```

```html
<!-- Other elements can listen -->
<div data-controller="list"
     data-action="item:saved->list#refresh">
```

## Step 9: Test the New Feature

1. Test the happy path
2. Test edge cases (missing targets, undefined values)
3. Test with Turbo navigation
4. Test keyboard accessibility (if UI feature)

## Step 10: Update HTML as Needed

Ensure all new targets, values, and actions are documented in usage:

```html
<!--
  Controller: notification
  Targets: message, closeButton
  Values: timeout (Number, default: 3000), autoClose (Boolean)
  Actions: dismiss, show
-->
<div data-controller="notification"
     data-notification-timeout-value="5000"
     data-notification-auto-close-value="true">
  <p data-notification-target="message"></p>
  <button data-action="click->notification#dismiss"
          data-notification-target="closeButton">
    &times;
  </button>
</div>
```
</process>

<anti_patterns>
Avoid:
- Adding features that don't belong (split into new controller)
- Making the controller do too much
- Tight coupling between controllers (use events or outlets)
- Hard-coding values that should be configurable
- Duplicating logic that could be extracted to a mixin
</anti_patterns>

<success_criteria>
Feature successfully added when:
- Existing functionality still works
- New feature works as expected
- No console errors
- Works after Turbo navigation
- Code is clean and follows existing patterns
- HTML documents new targets/values/actions
</success_criteria>
