<overview>
Values are a way to read, write, and observe data attributes on a controller's element. They're typed, can have defaults, and trigger callbacks when changed.
</overview>

<defining_values>
## Defining Values

```javascript
export default class extends Controller {
  static values = {
    url: String,                              // Required string
    count: Number,                            // Required number
    enabled: Boolean,                         // Required boolean
    items: Array,                             // Required array
    config: Object,                           // Required object
    timeout: { type: Number, default: 3000 }, // With default
    loading: { type: Boolean, default: false }
  }
}
```

**Supported types:** String, Number, Boolean, Array, Object
</defining_values>

<html_syntax>
## HTML Syntax

```html
<div data-controller="loader"
     data-loader-url-value="/api/data"
     data-loader-count-value="5"
     data-loader-enabled-value="true"
     data-loader-items-value='["a","b","c"]'
     data-loader-config-value='{"key": "value"}'>
</div>
```

Pattern: `data-{controller}-{valueName}-value="{value}"`

**Multi-word values use kebab-case in HTML:**
```javascript
static values = { refreshInterval: Number }
// HTML: data-loader-refresh-interval-value="5000"
```
</html_syntax>

<value_properties>
## Value Properties

Each value creates three properties:

| Property | Type | Description |
|----------|------|-------------|
| `this.urlValue` | typed | The current value |
| `this.hasUrlValue` | Boolean | Whether attribute exists |
| `this.urlValue = x` | setter | Updates HTML attribute |

```javascript
export default class extends Controller {
  static values = { count: Number }

  increment() {
    this.countValue++  // Updates data-*-count-value attribute
  }

  reset() {
    if (this.hasCountValue) {
      this.countValue = 0
    }
  }
}
```
</value_properties>

<value_changed_callbacks>
## Value Changed Callbacks

React to value changes:

```javascript
export default class extends Controller {
  static values = {
    url: String,
    count: Number
  }

  // Called when urlValue changes
  urlValueChanged(value, previousValue) {
    console.log(`URL changed from ${previousValue} to ${value}`)
    this.loadContent()
  }

  // Called when countValue changes
  countValueChanged(value, previousValue) {
    this.updateDisplay()
  }

  // Also called on connect if value exists
  connect() {
    // urlValueChanged already called if data-*-url-value exists
  }
}
```

**Callback timing:**
- Called on `connect()` if attribute has a value
- Called whenever the value changes (programmatically or attribute mutation)
- Receives new value and previous value as arguments
</value_changed_callbacks>

<type_coercion>
## Type Coercion

Values are automatically coerced to their declared type:

```javascript
static values = {
  count: Number,
  enabled: Boolean,
  items: Array
}
```

```html
<!-- Number: string → number -->
<div data-example-count-value="42">  <!-- this.countValue === 42 -->

<!-- Boolean: string → boolean -->
<div data-example-enabled-value="true">   <!-- this.enabledValue === true -->
<div data-example-enabled-value="false">  <!-- this.enabledValue === false -->
<div data-example-enabled-value="">       <!-- this.enabledValue === false -->

<!-- Array/Object: JSON string → parsed value -->
<div data-example-items-value='[1,2,3]'>  <!-- this.itemsValue === [1,2,3] -->
```

**Important:** Boolean values are true only for the string "true"
</type_coercion>

<default_values>
## Default Values

```javascript
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 5000 },
    enabled: { type: Boolean, default: true },
    items: { type: Array, default: [] },
    config: { type: Object, default: {} }
  }

  connect() {
    // If no data-*-timeout-value attribute, this.timeoutValue === 5000
    console.log(this.timeoutValue)
  }
}
```

**Without default:** `this.hasXValue` is false if attribute missing
**With default:** `this.hasXValue` is true even if attribute missing
</default_values>

<updating_values>
## Updating Values

```javascript
export default class extends Controller {
  static values = {
    count: Number,
    items: Array,
    config: Object
  }

  increment() {
    this.countValue++
    // Automatically updates data-*-count-value attribute
  }

  addItem(item) {
    // For arrays/objects, must assign new reference
    this.itemsValue = [...this.itemsValue, item]

    // This won't trigger callback:
    // this.itemsValue.push(item)  // BAD - same reference
  }

  updateConfig(key, value) {
    this.configValue = { ...this.configValue, [key]: value }
  }
}
```

**Important:** For Array and Object values, you must assign a new reference to trigger the callback.
</updating_values>

<values_vs_targets>
## Values vs Targets

**Use Values for:**
- Configuration/options
- State that should persist in HTML
- Data that might change
- Numbers, booleans, strings

**Use Targets for:**
- DOM element references
- Elements you need to manipulate

```html
<div data-controller="slideshow"
     data-slideshow-index-value="0"
     data-slideshow-autoplay-value="true"
     data-slideshow-interval-value="5000">
  <div data-slideshow-target="slide">Slide 1</div>
  <div data-slideshow-target="slide">Slide 2</div>
  <button data-slideshow-target="prev">Previous</button>
  <button data-slideshow-target="next">Next</button>
</div>
```
</values_vs_targets>

<common_patterns>
## Common Value Patterns

**Feature flags:**
```javascript
static values = {
  autoSubmit: { type: Boolean, default: false },
  debug: { type: Boolean, default: false }
}

connect() {
  if (this.autoSubmitValue) {
    this.startAutoSubmit()
  }
}
```

**URL configuration:**
```javascript
static values = {
  url: String,
  method: { type: String, default: "GET" }
}

async load() {
  const response = await fetch(this.urlValue, {
    method: this.methodValue
  })
}
```

**Timing configuration:**
```javascript
static values = {
  delay: { type: Number, default: 300 },
  duration: { type: Number, default: 1000 }
}
```

**State tracking:**
```javascript
static values = {
  open: { type: Boolean, default: false },
  selectedId: Number
}

openValueChanged(isOpen) {
  this.menuTarget.classList.toggle("hidden", !isOpen)
}
```
</common_patterns>

<observing_external_changes>
## Observing External Changes

Values react to attribute changes from any source:

```javascript
// Controller
static values = { count: Number }

countValueChanged(value) {
  console.log("Count is now:", value)
}

// External JavaScript
document.querySelector("[data-controller='counter']")
  .dataset.counterCountValue = "10"
// Triggers countValueChanged(10)
```

This enables:
- Turbo Stream updates to values
- Other controllers updating your values
- DevTools attribute editing
</observing_external_changes>

<anti_patterns>
## Anti-Patterns

**Don't mutate arrays/objects in place:**
```javascript
// Bad - doesn't trigger callback
this.itemsValue.push(item)

// Good
this.itemsValue = [...this.itemsValue, item]
```

**Don't use values for DOM references:**
```javascript
// Bad
static values = { buttonId: String }
document.getElementById(this.buttonIdValue)

// Good
static targets = ["button"]
this.buttonTarget
```

**Don't forget defaults for optional config:**
```javascript
// Risky - might be undefined
static values = { timeout: Number }
setTimeout(fn, this.timeoutValue) // Could be NaN

// Safe
static values = { timeout: { type: Number, default: 1000 } }
```
</anti_patterns>
