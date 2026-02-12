<overview>
Common mistakes to avoid when building Stimulus controllers. These anti-patterns can lead to bugs, poor performance, or maintenance issues.
</overview>

<controller_anti_patterns>
## Controller Anti-Patterns

<anti_pattern name="God Controller">
**Problem:** Single controller doing too many unrelated things.

```javascript
// Bad - does everything
export default class extends Controller {
  validateForm() { }
  submitForm() { }
  showModal() { }
  hideModal() { }
  filterTable() { }
  sortTable() { }
  updateChart() { }
  trackAnalytics() { }
}
```

**Instead:** Split into focused controllers.

```javascript
// Good - single responsibility
// form_controller.js
export default class extends Controller {
  validate() { }
  submit() { }
}

// modal_controller.js
export default class extends Controller {
  show() { }
  hide() { }
}

// table_controller.js
export default class extends Controller {
  filter() { }
  sort() { }
}
```
</anti_pattern>

<anti_pattern name="Not Cleaning Up">
**Problem:** Setting up listeners/timers in connect() but not cleaning up in disconnect().

```javascript
// Bad - memory leak
connect() {
  document.addEventListener("keydown", this.handleKeydown)
  this.timer = setInterval(this.poll, 5000)
}
```

**Instead:** Always clean up.

```javascript
// Good
connect() {
  this.handleKeydown = this.onKeydown.bind(this)
  document.addEventListener("keydown", this.handleKeydown)
  this.timer = setInterval(this.poll.bind(this), 5000)
}

disconnect() {
  document.removeEventListener("keydown", this.handleKeydown)
  clearInterval(this.timer)
}
```
</anti_pattern>

<anti_pattern name="Storing State in JavaScript">
**Problem:** Keeping state in controller properties instead of the DOM.

```javascript
// Bad - state lost on Turbo navigation
export default class extends Controller {
  connect() {
    this.count = 0  // Lost when page cached/restored
  }

  increment() {
    this.count++
    this.render()
  }
}
```

**Instead:** Use values (stored in HTML attributes).

```javascript
// Good - survives Turbo navigation
export default class extends Controller {
  static values = { count: Number }

  increment() {
    this.countValue++
  }

  countValueChanged() {
    this.render()
  }
}
```
</anti_pattern>

<anti_pattern name="Using querySelector Instead of Targets">
**Problem:** Querying DOM directly instead of using targets.

```javascript
// Bad
connect() {
  this.input = this.element.querySelector("input")
  this.button = this.element.querySelector("button")
}

submit() {
  console.log(this.input.value)
}
```

**Instead:** Use targets.

```javascript
// Good
static targets = ["input", "button"]

submit() {
  console.log(this.inputTarget.value)
}
```
</anti_pattern>

<anti_pattern name="Hard-coding Classes">
**Problem:** Hard-coding CSS classes that might need customization.

```javascript
// Bad - can't customize styling
show() {
  this.element.classList.add("bg-blue-500")
  this.element.classList.remove("hidden")
}
```

**Instead:** Use the Classes API.

```javascript
// Good - customizable via HTML
static classes = ["active", "hidden"]

show() {
  this.element.classList.add(this.activeClass)
  this.element.classList.remove(this.hiddenClass)
}
```

```html
<div data-controller="toggle"
     data-toggle-active-class="bg-blue-500 text-white"
     data-toggle-hidden-class="hidden">
```
</anti_pattern>
</controller_anti_patterns>

<dom_anti_patterns>
## DOM Anti-Patterns

<anti_pattern name="Layout Thrashing">
**Problem:** Alternating reads and writes causing multiple reflows.

```javascript
// Bad - causes layout thrashing
items.forEach(item => {
  const height = item.offsetHeight  // Read - triggers reflow
  item.style.width = height + "px" // Write
})
```

**Instead:** Batch reads, then writes.

```javascript
// Good
const heights = items.map(item => item.offsetHeight)
items.forEach((item, i) => {
  item.style.width = heights[i] + "px"
})
```
</anti_pattern>

<anti_pattern name="Excessive Target Queries">
**Problem:** Querying targets repeatedly in loops.

```javascript
// Bad - queries targets every iteration
for (let i = 0; i < 100; i++) {
  if (this.itemTargets.length > 0) {
    this.itemTargets[0].textContent = i
  }
}
```

**Instead:** Cache the query.

```javascript
// Good
const items = this.itemTargets
const first = items[0]
if (first) {
  for (let i = 0; i < 100; i++) {
    first.textContent = i
  }
}
```
</anti_pattern>

<anti_pattern name="Building HTML in JavaScript">
**Problem:** Constructing HTML strings in JavaScript instead of using templates.

```javascript
// Bad - HTML mixed with JS, hard to maintain, XSS risk
addItem(name) {
  const html = `
    <li class="item">
      <span class="name">${name}</span>
      <button class="delete-btn" onclick="this.remove()">Delete</button>
    </li>
  `
  this.listTarget.insertAdjacentHTML("beforeend", html)
}
```

**Instead:** Use a `<template>` tag as a target.

```html
<div data-controller="list">
  <template data-list-target="template">
    <li class="item" data-list-target="item">
      <span data-list-target="name"></span>
      <button data-action="list#remove">Delete</button>
    </li>
  </template>

  <ul data-list-target="container"></ul>
  <button data-action="list#add">Add Item</button>
</div>
```

```javascript
// Good - HTML stays in HTML, JS just clones and populates
export default class extends Controller {
  static targets = ["template", "container", "item", "name"]

  add() {
    const clone = this.templateTarget.content.cloneNode(true)
    clone.querySelector("[data-list-target='name']").textContent = "New Item"
    this.containerTarget.appendChild(clone)
  }

  remove(event) {
    event.currentTarget.closest("[data-list-target='item']").remove()
  }
}
```

**Benefits:**
- HTML structure visible in markup (easier to style and maintain)
- Proper Stimulus targets and actions work automatically
- No XSS risk from string interpolation
- Templates can be customized per-page without JS changes
</anti_pattern>
</dom_anti_patterns>

<event_anti_patterns>
## Event Anti-Patterns

<anti_pattern name="Adding Listeners Manually">
**Problem:** Using addEventListener when data-action works.

```javascript
// Bad
connect() {
  this.buttonTarget.addEventListener("click", this.handleClick.bind(this))
}
```

**Instead:** Use data-action in HTML.

```html
<!-- Good -->
<button data-action="controller#handleClick">Click</button>
```
</anti_pattern>

<anti_pattern name="Forgetting Event Modifiers">
**Problem:** Not preventing default on links/forms.

```html
<!-- Bad - navigates AND runs action -->
<a href="/fallback" data-action="click->modal#open">Open</a>
```

**Instead:** Use :prevent modifier.

```html
<!-- Good -->
<a href="/fallback" data-action="click->modal#open:prevent">Open</a>
```
</anti_pattern>

<anti_pattern name="Not Debouncing Input">
**Problem:** Firing on every keystroke.

```javascript
// Bad - fires on every character
search(event) {
  fetch(`/search?q=${event.target.value}`)
}
```

**Instead:** Debounce.

```javascript
// Good
import { useDebounce } from "stimulus-use"

static debounces = ["search"]

connect() {
  useDebounce(this, { wait: 300 })
}

search(event) {
  fetch(`/search?q=${event.target.value}`)
}
```
</anti_pattern>
</event_anti_patterns>

<communication_anti_patterns>
## Communication Anti-Patterns

<anti_pattern name="Tight Controller Coupling">
**Problem:** Controllers directly referencing each other by DOM query.

```javascript
// Bad
submit() {
  const resultController = document.querySelector('[data-controller="result"]')
  // Now tightly coupled to result controller existing
}
```

**Instead:** Use outlets or events.

```javascript
// Good - outlets
static outlets = ["result"]

submit() {
  if (this.hasResultOutlet) {
    this.resultOutlet.display(data)
  }
}

// Good - events
submit() {
  this.dispatch("submitted", { detail: { data } })
}
```
</anti_pattern>

<anti_pattern name="Circular Dependencies">
**Problem:** Controllers depending on each other.

```javascript
// Bad - A depends on B, B depends on A
// controller_a.js
static outlets = ["b"]
// controller_b.js
static outlets = ["a"]
```

**Instead:** Use events for bidirectional communication.

```javascript
// Good - events are one-way
// controller_a.js
update() {
  this.dispatch("updated")
}

// controller_b.js
// In HTML: data-action="a:updated->b#refresh"
```
</anti_pattern>
</communication_anti_patterns>

<turbo_anti_patterns>
## Turbo Anti-Patterns

<anti_pattern name="Not Handling Turbo Cache">
**Problem:** Third-party libraries break when page is restored from cache.

```javascript
// Bad - chart duplicates when page restored
connect() {
  this.chart = new Chart(this.element, config)
}
```

**Instead:** Destroy in disconnect or before cache.

```javascript
// Good
connect() {
  this.chart = new Chart(this.element, config)
}

disconnect() {
  this.chart?.destroy()
  this.chart = null
}
```
</anti_pattern>

<anti_pattern name="Assuming Connect Runs Once">
**Problem:** Initializing things that should only happen once.

```javascript
// Bad - runs every time Turbo restores page
connect() {
  this.expensiveSetup()  // Runs multiple times
}
```

**Instead:** Track initialization.

```javascript
// Good
static values = { initialized: Boolean }

connect() {
  if (!this.initializedValue) {
    this.expensiveSetup()
    this.initializedValue = true
  }
}
```
</anti_pattern>
</turbo_anti_patterns>

<value_anti_patterns>
## Value Anti-Patterns

<anti_pattern name="Mutating Arrays/Objects">
**Problem:** Mutating arrays/objects in place doesn't trigger callbacks.

```javascript
// Bad - doesn't trigger itemsValueChanged
this.itemsValue.push(newItem)
this.configValue.key = "new value"
```

**Instead:** Assign new references.

```javascript
// Good
this.itemsValue = [...this.itemsValue, newItem]
this.configValue = { ...this.configValue, key: "new value" }
```
</anti_pattern>

<anti_pattern name="Missing Default Values">
**Problem:** Accessing values that might not exist.

```javascript
// Bad - might be undefined
static values = { timeout: Number }

connect() {
  setTimeout(fn, this.timeoutValue)  // Could be NaN
}
```

**Instead:** Provide defaults.

```javascript
// Good
static values = { timeout: { type: Number, default: 1000 } }
```
</anti_pattern>
</value_anti_patterns>

<testing_anti_patterns>
## Testing Anti-Patterns

<anti_pattern name="Not Waiting for Stimulus">
**Problem:** Running assertions before Stimulus connects.

```javascript
// Bad - controller might not be connected yet
document.body.innerHTML = '<div data-controller="test"></div>'
expect(controller.connected).toBe(true)  // Fails
```

**Instead:** Wait for MutationObserver.

```javascript
// Good
document.body.innerHTML = '<div data-controller="test"></div>'
await new Promise(r => setTimeout(r, 0))
expect(controller.connected).toBe(true)
```
</anti_pattern>

<anti_pattern name="Not Cleaning Up Tests">
**Problem:** Tests affecting each other.

```javascript
// Bad - leaves DOM dirty
test("test 1", () => {
  document.body.innerHTML = '<div data-controller="test"></div>'
})

test("test 2", () => {
  // Still has DOM from test 1!
})
```

**Instead:** Clean up in afterEach.

```javascript
// Good
afterEach(() => {
  document.body.innerHTML = ""
  application.stop()
})
```
</anti_pattern>
</testing_anti_patterns>

<summary>
## Quick Reference

| Anti-Pattern | Fix |
|--------------|-----|
| God controller | Split into focused controllers |
| Not cleaning up | Always implement disconnect() |
| State in JS | Use values (DOM attributes) |
| querySelector | Use targets |
| Hard-coded classes | Use Classes API |
| Layout thrashing | Batch reads and writes |
| HTML in JS strings | Use `<template>` targets |
| Manual listeners | Use data-action |
| No debounce | Use stimulus-use debounce |
| Tight coupling | Use outlets or events |
| Turbo cache issues | Destroy in disconnect |
| Mutating arrays | Assign new references |
| Missing defaults | Add default to value definition |
</summary>
