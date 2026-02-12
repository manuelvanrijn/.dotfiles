<overview>
Performance optimization strategies for Stimulus controllers, including event handling, DOM operations, and memory management.
</overview>

<profiling>
## Profiling Controllers

**Add timing to methods:**
```javascript
export default class extends Controller {
  search() {
    console.time("search")
    // ... search logic
    console.timeEnd("search")
  }

  connect() {
    console.time("connect")
    // ... setup
    console.timeEnd("connect")
  }
}
```

**Use Chrome DevTools:**
1. Open Performance tab
2. Record while interacting
3. Look for:
   - Long tasks (>50ms)
   - Layout thrashing
   - Excessive repaints
</profiling>

<debounce_throttle>
## Debouncing and Throttling

**Debounce:** Wait for pause in events (good for search input)

```javascript
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["search"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  search() {
    // Only called 300ms after last keystroke
  }
}
```

**Manual debounce:**
```javascript
export default class extends Controller {
  connect() {
    this.search = this.debounce(this.search.bind(this), 300)
  }

  debounce(fn, wait) {
    let timeout
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => fn(...args), wait)
    }
  }

  search() {
    // Debounced
  }
}
```

**Throttle:** Limit frequency (good for scroll/resize)

```javascript
import { useThrottle } from "stimulus-use"

export default class extends Controller {
  static throttles = ["onScroll"]

  connect() {
    useThrottle(this, { wait: 100 })
  }

  onScroll() {
    // Called at most every 100ms
  }
}
```
</debounce_throttle>

<dom_optimization>
## DOM Operation Optimization

**Avoid layout thrashing:**
```javascript
// Bad - causes multiple reflows
items.forEach(item => {
  const height = item.offsetHeight  // Read
  item.style.width = height + "px" // Write
  const width = item.offsetWidth   // Read (reflow!)
  item.style.height = width + "px" // Write
})

// Good - batch reads, then writes
const dimensions = items.map(item => ({
  height: item.offsetHeight,
  width: item.offsetWidth
}))

items.forEach((item, i) => {
  item.style.width = dimensions[i].height + "px"
  item.style.height = dimensions[i].width + "px"
})
```

**Use CSS classes instead of inline styles:**
```javascript
// Bad
this.element.style.display = "none"
this.element.style.opacity = "0"

// Good
this.element.classList.add(this.hiddenClass)
```

**Use document fragments for multiple inserts:**
```javascript
// Bad
items.forEach(item => {
  this.listTarget.appendChild(createItem(item))
})

// Good
const fragment = document.createDocumentFragment()
items.forEach(item => {
  fragment.appendChild(createItem(item))
})
this.listTarget.appendChild(fragment)
```

**Use `hidden` attribute over display manipulation:**
```javascript
// Preferred
element.hidden = true

// Alternative
element.classList.add("hidden")
```
</dom_optimization>

<event_optimization>
## Event Listener Optimization

**Use event delegation:**
```html
<!-- Bad - listener on each item -->
<ul>
  <li data-action="click->list#select">Item 1</li>
  <li data-action="click->list#select">Item 2</li>
  <!-- 100 more items... -->
</ul>

<!-- Good - single listener on parent -->
<ul data-action="click->list#select">
  <li data-list-item-param="1">Item 1</li>
  <li data-list-item-param="2">Item 2</li>
</ul>
```

```javascript
select(event) {
  const item = event.target.closest("li")
  if (item) {
    const id = item.dataset.listItemParam
    this.handleSelect(id)
  }
}
```

**Use passive listeners for scroll/touch:**
```javascript
connect() {
  this.handleScroll = this.onScroll.bind(this)
  window.addEventListener("scroll", this.handleScroll, { passive: true })
}

disconnect() {
  window.removeEventListener("scroll", this.handleScroll)
}
```

**Remove listeners in disconnect:**
```javascript
connect() {
  this.boundHandler = this.handler.bind(this)
  document.addEventListener("keydown", this.boundHandler)
}

disconnect() {
  document.removeEventListener("keydown", this.boundHandler)
}
```
</event_optimization>

<memory_management>
## Memory Management

**Clear references in disconnect:**
```javascript
disconnect() {
  // Clear timers
  clearInterval(this.timer)
  clearTimeout(this.timeout)

  // Disconnect observers
  this.observer?.disconnect()
  this.resizeObserver?.disconnect()

  // Destroy third-party instances
  this.chart?.destroy()
  this.editor?.destroy()

  // Clear caches
  this.cache = null
  this.items = null
}
```

**Use WeakMap for element data:**
```javascript
const elementData = new WeakMap()

export default class extends Controller {
  connect() {
    elementData.set(this.element, { initialized: true })
  }

  // Data is automatically garbage collected when element is removed
}
```

**Avoid closures that capture large objects:**
```javascript
// Bad - captures entire controller in closure
connect() {
  const data = this.largeDataObject
  this.element.addEventListener("click", () => {
    console.log(data)  // data captured, can't be GC'd
  })
}

// Good - bind method instead
connect() {
  this.boundHandler = this.handleClick.bind(this)
  this.element.addEventListener("click", this.boundHandler)
}

handleClick() {
  console.log(this.largeDataObject)
}
```
</memory_management>

<lazy_loading>
## Lazy Loading

**Lazy load heavy dependencies:**
```javascript
export default class extends Controller {
  async connect() {
    if (this.hasCanvasTarget) {
      // Load only when needed
      const { Chart } = await import("chart.js")
      this.chart = new Chart(this.canvasTarget, this.config)
    }
  }
}
```

**Use Intersection Observer for off-screen content:**
```javascript
import { useIntersection } from "stimulus-use"

export default class extends Controller {
  connect() {
    useIntersection(this, { threshold: 0.1 })
  }

  appear() {
    // Only load when visible
    this.loadContent()
  }

  async loadContent() {
    if (this.loaded) return
    this.loaded = true

    const response = await fetch(this.urlValue)
    this.element.innerHTML = await response.text()
  }
}
```
</lazy_loading>

<caching>
## Caching Strategies

**Cache expensive computations:**
```javascript
export default class extends Controller {
  get items() {
    // Cache the result
    if (!this._items) {
      this._items = this.computeExpensiveItems()
    }
    return this._items
  }

  invalidateCache() {
    this._items = null
  }

  itemTargetConnected() {
    this.invalidateCache()
  }
}
```

**Cache DOM queries:**
```javascript
export default class extends Controller {
  connect() {
    // Cache if targets won't change
    this.cachedItems = this.itemTargets
  }

  processItems() {
    this.cachedItems.forEach(item => {
      // Use cached reference
    })
  }
}
```
</caching>

<target_optimization>
## Target Query Optimization

**Minimize target queries in loops:**
```javascript
// Bad - queries targets every iteration
for (let i = 0; i < 100; i++) {
  this.itemTargets[0].classList.add("processed")
}

// Good - query once
const items = this.itemTargets
for (let i = 0; i < items.length; i++) {
  items[i].classList.add("processed")
}
```

**Use `has*Target` before accessing:**
```javascript
// Throws if target doesn't exist
this.optionalTarget.doSomething()

// Safe
if (this.hasOptionalTarget) {
  this.optionalTarget.doSomething()
}
```
</target_optimization>

<performance_checklist>
## Performance Checklist

**Event Handling:**
- [ ] Debounce high-frequency input events
- [ ] Throttle scroll/resize handlers
- [ ] Use event delegation for repeated elements
- [ ] Use passive listeners for scroll/touch
- [ ] Remove listeners in disconnect()

**DOM Operations:**
- [ ] Batch DOM reads and writes
- [ ] Use CSS classes instead of inline styles
- [ ] Use document fragments for multiple inserts
- [ ] Minimize target queries in loops

**Memory:**
- [ ] Clear timers/intervals in disconnect()
- [ ] Destroy third-party libraries in disconnect()
- [ ] Use WeakMap for element-associated data
- [ ] Clear caches when no longer needed

**Loading:**
- [ ] Lazy load heavy dependencies
- [ ] Use Intersection Observer for off-screen content
- [ ] Cache expensive computations
</performance_checklist>
