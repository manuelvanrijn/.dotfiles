# Workflow: Build New Controller

<required_reading>
**Read these reference files NOW before building:**
1. references/architecture.md
2. references/targets.md
3. references/values.md
4. references/actions.md
</required_reading>

<process>
## Step 1: Define the Controller's Purpose

Ask: What single responsibility does this controller have?

Good examples:
- "Toggle visibility of an element"
- "Copy text to clipboard"
- "Auto-submit form on change"
- "Load content from URL"

Bad examples (too broad):
- "Handle all form interactions"
- "Manage the entire page"

Name convention: `{noun}` or `{verb}-{noun}` in kebab-case
- `clipboard`, `dropdown`, `modal`, `tabs`
- `auto-submit`, `content-loader`, `remote-form`

## Step 2: Create the Controller File

```javascript
// app/javascript/controllers/{name}_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log(`${this.identifier} connected`)
  }
}
```

For Rails with importmaps, controllers auto-register. For other setups:

```javascript
// app/javascript/controllers/index.js
import { application } from "./application"
import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)
```

## Step 3: Define Static Properties

Add what the controller needs:

```javascript
export default class extends Controller {
  static targets = ["source", "button"]  // DOM elements to reference
  static values = {
    url: String,                          // Configuration from HTML
    timeout: { type: Number, default: 3000 }
  }
  static classes = ["active", "loading"]  // CSS class names from HTML
  static outlets = ["result"]             // Other controllers to communicate with
}
```

**Decide what goes where:**
- **Targets**: Elements you need to read from or manipulate
- **Values**: Configuration that might vary per instance
- **Classes**: CSS classes that might be customized
- **Outlets**: Other controllers you need to call methods on

## Step 4: Write the HTML

```html
<div data-controller="clipboard"
     data-clipboard-url-value="/api/copy"
     data-clipboard-active-class="bg-green-500">

  <input data-clipboard-target="source"
         type="text"
         value="Text to copy">

  <button data-action="click->clipboard#copy"
          data-clipboard-target="button">
    Copy
  </button>
</div>
```

## Step 5: Implement Lifecycle Methods

```javascript
export default class extends Controller {
  static targets = ["source", "button"]
  static values = { url: String }

  // Called once when instantiated
  initialize() {
    this.boundHandler = this.handleKeydown.bind(this)
  }

  // Called when connected to DOM
  connect() {
    document.addEventListener("keydown", this.boundHandler)
  }

  // Called when disconnected from DOM
  disconnect() {
    document.removeEventListener("keydown", this.boundHandler)
  }
}
```

## Step 6: Implement Actions

```javascript
export default class extends Controller {
  static targets = ["source", "output"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)
    this.outputTarget.textContent = "Copied!"
  }

  // Action with event parameter
  select(event) {
    event.preventDefault()
    this.sourceTarget.select()
  }

  // Action with params from HTML: data-clipboard-id-param="123"
  delete({ params: { id } }) {
    console.log(`Deleting item ${id}`)
  }
}
```

## Step 7: Add Value Change Callbacks

```javascript
export default class extends Controller {
  static values = { count: Number }

  // Called whenever countValue changes
  countValueChanged(value, previousValue) {
    console.log(`Count changed from ${previousValue} to ${value}`)
    this.updateDisplay()
  }
}
```

## Step 8: Add Target Callbacks (Optional)

```javascript
export default class extends Controller {
  static targets = ["item"]

  // Called when item target is added to DOM
  itemTargetConnected(element) {
    console.log("Item added:", element)
  }

  // Called when item target is removed from DOM
  itemTargetDisconnected(element) {
    console.log("Item removed:", element)
  }
}
```

## Step 9: Verify

1. Open browser dev tools console
2. Enable Stimulus debug: `Stimulus.debug = true`
3. Check for connection message
4. Test each action
5. Test with Turbo navigation (if applicable)

```bash
# If using importmaps, ensure controller is discoverable
bin/rails stimulus:manifest:update
```
</process>

<anti_patterns>
Avoid:
- Controllers that do too many things (split into multiple controllers)
- Storing state in JavaScript when it should be in HTML values
- Forgetting to clean up in `disconnect()`
- Using `document.querySelector` instead of targets
- Hard-coding CSS classes instead of using the Classes API
</anti_patterns>

<success_criteria>
A well-built controller:
- Has a single, clear responsibility
- Uses targets for DOM references (not querySelector)
- Uses values for configuration (not hard-coded)
- Cleans up in disconnect() what it sets up in connect()
- Works after Turbo navigation
- Has descriptive action names (verbs)
- Connects without console errors
</success_criteria>
