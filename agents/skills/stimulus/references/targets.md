<overview>
Targets let you reference important elements by name. They're the preferred way to access DOM elements within a controller's scope.
</overview>

<defining_targets>
## Defining Targets

```javascript
export default class extends Controller {
  static targets = ["source", "output", "submitButton"]
}
```

Each target name creates three properties:

| Property | Type | Description |
|----------|------|-------------|
| `this.sourceTarget` | Element | First matching element (throws if none) |
| `this.sourceTargets` | Element[] | All matching elements |
| `this.hasSourceTarget` | Boolean | Whether target exists |
</defining_targets>

<html_syntax>
## HTML Syntax

```html
<div data-controller="search">
  <input data-search-target="input" type="text">
  <button data-search-target="submit">Search</button>
  <div data-search-target="results"></div>

  <!-- Multiple targets on same element -->
  <input data-search-target="input field" type="text">
</div>
```

Pattern: `data-{controller}-target="{targetName}"`
</html_syntax>

<accessing_targets>
## Accessing Targets

```javascript
export default class extends Controller {
  static targets = ["item", "output"]

  showCount() {
    // Single target (first match)
    this.outputTarget.textContent = `${this.itemTargets.length} items`
  }

  selectAll() {
    // All targets
    this.itemTargets.forEach(item => {
      item.checked = true
    })
  }

  submit() {
    // Check existence first
    if (this.hasOutputTarget) {
      this.outputTarget.textContent = "Submitting..."
    }
  }

  // Throws error if target doesn't exist
  dangerousMethod() {
    this.outputTarget.textContent = "Oops" // Throws if no target
  }
}
```
</accessing_targets>

<target_callbacks>
## Target Connected/Disconnected Callbacks

React to targets being added or removed from the DOM:

```javascript
export default class extends Controller {
  static targets = ["item"]

  // Called when an item target is added to DOM
  itemTargetConnected(element) {
    console.log("Item added:", element)
    this.updateCount()
    element.classList.add("initialized")
  }

  // Called when an item target is removed from DOM
  itemTargetDisconnected(element) {
    console.log("Item removed:", element)
    this.updateCount()
  }

  updateCount() {
    console.log(`Now have ${this.itemTargets.length} items`)
  }
}
```

**Use cases:**
- Initialize third-party widgets on new elements
- Update counts/summaries when items change
- Clean up resources when elements removed
- Sort or reorder items
</target_callbacks>

<optional_targets>
## Optional Targets Pattern

When targets might not exist:

```javascript
export default class extends Controller {
  static targets = ["error", "success"]

  showResult(isSuccess) {
    // Safe - checks existence first
    if (isSuccess && this.hasSuccessTarget) {
      this.successTarget.classList.remove("hidden")
    }

    if (!isSuccess && this.hasErrorTarget) {
      this.errorTarget.classList.remove("hidden")
    }
  }

  // Alternative: use optional chaining
  showMessage(message) {
    this.successTarget?.textContent = message
  }
}
```
</optional_targets>

<target_vs_queryselector>
## Targets vs querySelector

**Use targets for:**
- Elements you reference multiple times
- Elements critical to controller function
- Elements that might be dynamically added

**Use querySelector for:**
- One-time, simple lookups
- Elements outside your scope (but prefer outlets)
- Complex selectors targets can't express

```javascript
// Prefer targets
static targets = ["submitButton"]
this.submitButtonTarget.disabled = true

// Acceptable for one-off or complex selector
const firstError = this.element.querySelector(".error:first-child")
```
</target_vs_queryselector>

<multiple_targets>
## Working with Multiple Targets

```javascript
export default class extends Controller {
  static targets = ["checkbox"]

  checkAll() {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = true
    })
  }

  uncheckAll() {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = false
    })
  }

  get checkedCount() {
    return this.checkboxTargets.filter(cb => cb.checked).length
  }

  get isAllChecked() {
    return this.checkboxTargets.every(cb => cb.checked)
  }

  get isNoneChecked() {
    return this.checkboxTargets.every(cb => !cb.checked)
  }
}
```
</multiple_targets>

<dynamic_targets>
## Dynamic Targets

Targets work with dynamically added elements:

```html
<div data-controller="list">
  <template data-list-target="template">
    <li data-list-target="item">New Item</li>
  </template>

  <ul data-list-target="container"></ul>

  <button data-action="list#addItem">Add</button>
</div>
```

```javascript
export default class extends Controller {
  static targets = ["template", "container", "item"]

  addItem() {
    const content = this.templateTarget.content.cloneNode(true)
    this.containerTarget.appendChild(content)
    // itemTargetConnected will be called automatically
  }

  itemTargetConnected(element) {
    console.log("New item added:", element)
  }
}
```
</dynamic_targets>

<common_patterns>
## Common Target Patterns

**Form targets:**
```javascript
static targets = ["form", "input", "submit", "error"]
```

**Modal targets:**
```javascript
static targets = ["dialog", "backdrop", "closeButton"]
```

**List targets:**
```javascript
static targets = ["container", "item", "empty", "count"]
```

**Toggle targets:**
```javascript
static targets = ["trigger", "content"]
```
</common_patterns>

<anti_patterns>
## Anti-Patterns

**Don't use querySelector when targets work:**
```javascript
// Bad
const input = this.element.querySelector("[data-search-target='input']")

// Good
this.inputTarget
```

**Don't access targets before connect:**
```javascript
// Bad - targets not ready in initialize
initialize() {
  this.inputTarget.value = "default" // Might fail
}

// Good
connect() {
  this.inputTarget.value = "default"
}
```

**Don't ignore missing targets:**
```javascript
// Bad - throws error
this.optionalTarget.classList.add("active")

// Good - check first
if (this.hasOptionalTarget) {
  this.optionalTarget.classList.add("active")
}
```
</anti_patterns>
