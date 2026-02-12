<overview>
Outlets let you reference other Stimulus controller instances from a controller. They enable cross-controller communication and coordination.
</overview>

<defining_outlets>
## Defining Outlets

```javascript
export default class extends Controller {
  static outlets = ["search", "user-status", "notification"]
}
```

Each outlet creates properties:

| Property | Type | Description |
|----------|------|-------------|
| `this.searchOutlet` | Controller | First matching controller (throws if none) |
| `this.searchOutlets` | Controller[] | All matching controllers |
| `this.hasSearchOutlet` | Boolean | Whether outlet exists |
| `this.searchOutletElement` | Element | Element of first outlet controller |
| `this.searchOutletElements` | Element[] | Elements of all outlet controllers |
</defining_outlets>

<html_syntax>
## HTML Syntax

```html
<!-- Host controller with outlet -->
<div data-controller="chat"
     data-chat-user-status-outlet=".user-status">
  <!-- chat content -->
</div>

<!-- Target controller elements -->
<div class="user-status" data-controller="user-status">User 1</div>
<div class="user-status" data-controller="user-status">User 2</div>
```

Pattern: `data-{controller}-{outlet-name}-outlet="{CSS selector}"`

**Important:** Multi-word outlets use kebab-case in both the array and attribute:
```javascript
static outlets = ["user-status"]
// HTML: data-chat-user-status-outlet
```
</html_syntax>

<accessing_outlets>
## Accessing Outlets

```javascript
export default class extends Controller {
  static outlets = ["result"]

  search() {
    // Single outlet (first match, throws if none)
    this.resultOutlet.display(this.query)

    // Check existence first
    if (this.hasResultOutlet) {
      this.resultOutlet.display(this.query)
    }

    // All outlets
    this.resultOutlets.forEach(outlet => {
      outlet.refresh()
    })

    // Access outlet's element
    this.resultOutletElement.classList.add("active")

    // Access outlet's properties
    console.log(this.resultOutlet.countValue)
    console.log(this.resultOutlet.itemTargets)
  }
}
```
</accessing_outlets>

<outlet_callbacks>
## Outlet Connected/Disconnected Callbacks

React when outlets connect or disconnect:

```javascript
export default class extends Controller {
  static outlets = ["result"]

  resultOutletConnected(outlet, element) {
    console.log("Result outlet connected:", outlet)
    console.log("Outlet element:", element)
    outlet.initialize()
  }

  resultOutletDisconnected(outlet, element) {
    console.log("Result outlet disconnected")
  }
}
```

**Callback timing:**
- `Connected`: Called when outlet element is added to DOM or attribute changes
- `Disconnected`: Called when outlet element is removed or attribute changes
</outlet_callbacks>

<calling_outlet_methods>
## Calling Outlet Methods

```javascript
// result_controller.js
export default class extends Controller {
  static targets = ["list"]
  static values = { count: Number }

  display(items) {
    this.listTarget.innerHTML = items.map(i => `<li>${i}</li>`).join("")
    this.countValue = items.length
  }

  clear() {
    this.listTarget.innerHTML = ""
    this.countValue = 0
  }

  refresh() {
    // Reload from server
  }
}

// search_controller.js
export default class extends Controller {
  static outlets = ["result"]

  async search() {
    const items = await this.fetchResults()

    // Call method on outlet
    this.resultOutlet.display(items)
  }

  clear() {
    // Call on all outlets
    this.resultOutlets.forEach(outlet => outlet.clear())
  }
}
```
</calling_outlet_methods>

<accessing_outlet_state>
## Accessing Outlet State

```javascript
export default class extends Controller {
  static outlets = ["cart"]

  checkout() {
    // Access outlet values
    const total = this.cartOutlet.totalValue
    const items = this.cartOutlet.itemCountValue

    // Access outlet targets
    const cartItems = this.cartOutlet.itemTargets

    // Access outlet classes
    const isActive = this.cartOutletElement.classList.contains(
      this.cartOutlet.activeClass
    )
  }
}
```
</accessing_outlet_state>

<multiple_selectors>
## Multiple Outlet Selectors

Target multiple elements with one selector:

```html
<div data-controller="manager"
     data-manager-worker-outlet=".worker, #special-worker">
</div>

<div class="worker" data-controller="worker">Worker 1</div>
<div class="worker" data-controller="worker">Worker 2</div>
<div id="special-worker" data-controller="worker">Special</div>
```

```javascript
export default class extends Controller {
  static outlets = ["worker"]

  notifyAll() {
    // All three workers
    this.workerOutlets.forEach(worker => worker.notify())
  }
}
```
</multiple_selectors>

<dynamic_outlets>
## Dynamic Outlet Selection

Change outlet selector dynamically:

```javascript
export default class extends Controller {
  static outlets = ["panel"]

  switchTo(sectionId) {
    // Update the outlet selector
    this.element.dataset.dashboardPanelOutlet = `#${sectionId}`
    // Triggers panelOutletConnected/Disconnected callbacks
  }
}
```
</dynamic_outlets>

<outlets_vs_events>
## Outlets vs Events

**Use Outlets when:**
- Need to call methods on another controller
- Need to access another controller's state
- Tight coupling is acceptable
- One-to-one or one-to-few relationship

**Use Events when:**
- Loose coupling preferred
- Multiple unknown listeners
- Bubbling needed
- Fire-and-forget communication

```javascript
// Outlet approach - direct call
this.resultOutlet.display(items)

// Event approach - loose coupling
this.dispatch("search:complete", { detail: { items } })
```

```html
<!-- Event listening -->
<div data-controller="result"
     data-action="search:complete->result#display">
```
</outlets_vs_events>

<common_patterns>
## Common Outlet Patterns

**Form + Results:**
```html
<div data-controller="search" data-search-result-outlet="#results">
  <input data-action="input->search#query">
</div>
<div id="results" data-controller="result"></div>
```

**Tabs + Panels:**
```html
<div data-controller="tabs" data-tabs-panel-outlet=".tab-panel">
  <button data-action="tabs#show" data-tabs-index-param="0">Tab 1</button>
  <button data-action="tabs#show" data-tabs-index-param="1">Tab 2</button>
</div>
<div class="tab-panel" data-controller="panel">Panel 1</div>
<div class="tab-panel" data-controller="panel">Panel 2</div>
```

**Modal Trigger:**
```html
<button data-controller="trigger"
        data-trigger-modal-outlet="#main-modal"
        data-action="trigger#open">
  Open Modal
</button>
<div id="main-modal" data-controller="modal">...</div>
```
</common_patterns>

<anti_patterns>
## Anti-Patterns

**Don't use outlets for elements in scope (use targets):**
```javascript
// Bad - element is within controller scope
static outlets = ["input"]

// Good
static targets = ["input"]
```

**Don't call outlet methods without checking existence:**
```javascript
// Bad - throws if outlet missing
this.resultOutlet.display(items)

// Good
if (this.hasResultOutlet) {
  this.resultOutlet.display(items)
}
```

**Don't create circular outlet dependencies:**
```javascript
// Controller A
static outlets = ["b"]

// Controller B
static outlets = ["a"]
// Can lead to infinite loops
```
</anti_patterns>
