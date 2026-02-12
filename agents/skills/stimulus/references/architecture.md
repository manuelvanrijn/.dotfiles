<overview>
Stimulus controller architecture patterns, lifecycle methods, and structural best practices.
</overview>

<controller_structure>
## Recommended Controller Structure

Order your controller code consistently:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 1. Static properties
  static targets = ["source", "output"]
  static values = { url: String, count: Number }
  static classes = ["active", "loading"]
  static outlets = ["result"]

  // 2. Lifecycle methods
  initialize() {
    // Called once when controller is instantiated
    // Use for one-time setup that doesn't depend on DOM
  }

  connect() {
    // Called when controller is connected to DOM
    // Can be called multiple times (Turbo navigation)
    // Set up event listeners, observers, timers
  }

  disconnect() {
    // Called when controller is removed from DOM
    // Clean up everything set up in connect()
  }

  // 3. Public actions (called from data-action)
  copy() {
    // Action method
  }

  select(event) {
    // Action with event parameter
  }

  // 4. Value change callbacks
  countValueChanged(value, previousValue) {
    // Called when countValue changes
  }

  // 5. Target callbacks
  itemTargetConnected(element) {
    // Called when item target is added
  }

  itemTargetDisconnected(element) {
    // Called when item target is removed
  }

  // 6. Outlet callbacks
  resultOutletConnected(outlet, element) {
    // Called when result outlet connects
  }

  // 7. Private methods (prefix with #)
  #formatOutput(text) {
    // Private helper method
  }

  // 8. Getters and setters
  get isValid() {
    return this.hasSourceTarget && this.sourceTarget.value.length > 0
  }
}
```
</controller_structure>

<lifecycle_methods>
## Lifecycle Methods

<method name="initialize">
**When:** Called once when controller is first instantiated.
**Use for:** One-time setup, binding methods, creating caches.
**Note:** DOM might not be fully available.

```javascript
initialize() {
  this.boundHandler = this.handleKeydown.bind(this)
  this.cache = new Map()
}
```
</method>

<method name="connect">
**When:** Called each time controller is connected to DOM.
**Use for:** Setting up event listeners, observers, timers, initial state.
**Note:** Called again after Turbo navigation restores cached page.

```javascript
connect() {
  document.addEventListener("keydown", this.boundHandler)
  this.startPolling()
  this.element.classList.add("initialized")
}
```
</method>

<method name="disconnect">
**When:** Called when controller is removed from DOM.
**Use for:** Cleanup - remove listeners, clear timers, destroy third-party instances.
**Critical:** Always clean up what you set up in connect().

```javascript
disconnect() {
  document.removeEventListener("keydown", this.boundHandler)
  this.stopPolling()
  this.chart?.destroy()
  clearInterval(this.timer)
}
```
</method>
</lifecycle_methods>

<application_controller>
## Application Controller Pattern

Create a base controller for shared functionality:

```javascript
// controllers/application_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Shared helper methods
  dispatch(name, detail = {}) {
    this.element.dispatchEvent(
      new CustomEvent(name, {
        detail,
        bubbles: true,
        cancelable: true
      })
    )
  }

  // Common getters
  get csrfToken() {
    return document.querySelector("[name='csrf-token']")?.content
  }

  // Shared fetch wrapper
  async fetch(url, options = {}) {
    const response = await fetch(url, {
      headers: {
        "X-CSRF-Token": this.csrfToken,
        "Accept": "application/json",
        ...options.headers
      },
      ...options
    })

    if (!response.ok) throw new Error(`HTTP ${response.status}`)
    return response
  }
}

// Other controllers extend this
// controllers/posts_controller.js
import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  async save() {
    await this.fetch("/posts", {
      method: "POST",
      body: new FormData(this.element)
    })
    this.dispatch("saved")
  }
}
```
</application_controller>

<inheritance>
## Inheritance Pattern

Use when controller shares 100% of parent's logic:

```javascript
// controllers/dropdown_controller.js
export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  hide() {
    this.menuTarget.classList.add("hidden")
  }
}

// controllers/user_menu_controller.js
import DropdownController from "./dropdown_controller"

export default class extends DropdownController {
  static targets = [...DropdownController.targets, "avatar"]

  connect() {
    super.connect?.()
    this.loadAvatar()
  }

  loadAvatar() {
    // Additional functionality
  }
}
```

**When to use:** "Is a" relationship (UserMenu is a Dropdown)
**When NOT to use:** When you only need some functionality (use mixins instead)
</inheritance>

<mixins>
## Mixin Pattern

Share behavior across unrelated controllers:

```javascript
// mixins/debounce.js
export const useDebounce = (controller, { wait = 300 } = {}) => {
  const debounced = new Map()

  controller.constructor.debounces?.forEach(methodName => {
    const original = controller[methodName].bind(controller)
    let timeout

    controller[methodName] = (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => original(...args), wait)
    }
  })
}

// Usage
import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "../mixins/debounce"

export default class extends Controller {
  static debounces = ["search"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  search() {
    // Called at most every 300ms
  }
}
```

**When to use:** "Acts as a" relationship (Controller acts as debounced)
**Prefer over inheritance** when mixing multiple behaviors
</mixins>

<event_communication>
## Controller Communication

**Option 1: Events (loosely coupled)**

```javascript
// Dispatching controller
export default class extends Controller {
  save() {
    // Do save...
    this.dispatch("saved", { detail: { id: 123 } })
  }
}

// Listening controller (via HTML)
<div data-controller="list"
     data-action="form:saved->list#refresh">
```

**Option 2: Outlets (direct reference)**

```javascript
// See references/outlets.md for full documentation
export default class extends Controller {
  static outlets = ["result"]

  update() {
    this.resultOutlet.refresh()
  }
}
```

**When to use each:**
- **Events:** Loose coupling, multiple listeners, bubbling needed
- **Outlets:** Direct method calls, accessing state, tight integration
</event_communication>

<naming_conventions>
## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Controller file | snake_case | `clipboard_controller.js` |
| Controller identifier | kebab-case | `data-controller="clipboard"` |
| Target name | camelCase | `static targets = ["submitButton"]` |
| Value name | camelCase | `static values = { refreshInterval: Number }` |
| Value attribute | kebab-case | `data-clipboard-refresh-interval-value` |
| Action method | camelCase | `copyToClipboard()` |
| Class name | camelCase | `static classes = ["isActive"]` |
| Outlet name | kebab-case in array | `static outlets = ["user-status"]` |
</naming_conventions>

<scope>
## Controller Scope

Each controller's scope is the element with `data-controller` and its descendants.

```html
<div data-controller="parent">
  <!-- In parent scope -->
  <input data-parent-target="input">

  <div data-controller="child">
    <!-- In child scope, NOT parent scope -->
    <input data-child-target="input">
    <!-- This is NOT visible to parent controller -->
  </div>
</div>
```

**Key points:**
- Targets must be within controller's scope
- Nested controllers have separate scopes
- Use outlets to reference controllers outside scope
- Multiple controllers can be on same element: `data-controller="clipboard tooltip"`
</scope>

<decision_tree>
## Architecture Decision Tree

**Need shared functionality?**
- Shared across ALL controllers → Application Controller
- Shared across SOME controllers → Mixin
- Child is specialized version of parent → Inheritance

**Need controller communication?**
- Loose coupling, multiple listeners → Events
- Direct method calls, state access → Outlets
- Simple boolean flag → Shared CSS class

**Need external library?**
- Initialize in `connect()`
- Destroy in `disconnect()`
- Consider lazy loading
</decision_tree>
