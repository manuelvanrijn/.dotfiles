# Workflow: Optimize Controller Performance

<required_reading>
**Read these reference files NOW:**
1. references/performance.md
2. references/architecture.md
3. references/anti-patterns.md
</required_reading>

<process>
## Step 1: Identify Performance Issues

Common symptoms:
- Slow page load / Time to Interactive
- Janky scrolling
- Delayed response to user input
- Memory growth over time
- High CPU usage

## Step 2: Profile with Browser DevTools

```javascript
// Add timing to actions
copy() {
  console.time("copy")
  // ... action code
  console.timeEnd("copy")
}

// Profile connect/disconnect
connect() {
  console.time("connect")
  // ... setup code
  console.timeEnd("connect")
}
```

Use Chrome DevTools:
1. Performance tab → Record
2. Interact with controller
3. Look for long tasks, layout thrashing

## Step 3: Optimize Expensive Operations

### Debounce Input Handlers

```javascript
import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["search"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  search() {
    // Only called 300ms after last input
    fetch(`/search?q=${this.inputTarget.value}`)
  }
}
```

Or manually:
```javascript
connect() {
  this.search = this.debounce(this.search.bind(this), 300)
}

debounce(fn, wait) {
  let timeout
  return (...args) => {
    clearTimeout(timeout)
    timeout = setTimeout(() => fn.apply(this, args), wait)
  }
}
```

### Throttle Scroll/Resize Handlers

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

## Step 4: Optimize DOM Operations

### Batch DOM Reads and Writes

```javascript
// Bad - causes layout thrashing
items.forEach(item => {
  const height = item.offsetHeight  // Read
  item.style.width = height + "px" // Write
})

// Good - batch reads, then writes
const heights = items.map(item => item.offsetHeight)
items.forEach((item, i) => {
  item.style.width = heights[i] + "px"
})
```

### Use CSS Classes Instead of Inline Styles

```javascript
// Bad
this.element.style.display = "none"
this.element.style.opacity = "0"

// Good
this.element.classList.add(this.hiddenClass)
```

### Minimize Target Queries

```javascript
// Bad - queries DOM every time
showAll() {
  this.itemTargets.forEach(item => item.hidden = false)
}

hideAll() {
  this.itemTargets.forEach(item => item.hidden = true)
}

// Good - cache if targets don't change
connect() {
  this.cachedItems = this.itemTargets
}

showAll() {
  this.cachedItems.forEach(item => item.hidden = false)
}
```

## Step 5: Optimize Event Listeners

### Use Event Delegation

```html
<!-- Bad - listener on each item -->
<ul>
  <li data-action="click->list#select">Item 1</li>
  <li data-action="click->list#select">Item 2</li>
  <!-- 100 more items... -->
</ul>

<!-- Good - single listener on parent -->
<ul data-action="click->list#select">
  <li data-list-id-param="1">Item 1</li>
  <li data-list-id-param="2">Item 2</li>
</ul>
```

```javascript
select(event) {
  const item = event.target.closest("li")
  if (item) {
    const id = item.dataset.listIdParam
    this.handleSelection(id)
  }
}
```

### Remove Listeners in Disconnect

```javascript
connect() {
  this.handleScroll = this.onScroll.bind(this)
  window.addEventListener("scroll", this.handleScroll, { passive: true })
}

disconnect() {
  window.removeEventListener("scroll", this.handleScroll)
}
```

## Step 6: Optimize Memory Usage

### Clear References in Disconnect

```javascript
disconnect() {
  this.cache = null
  this.observer?.disconnect()
  clearInterval(this.timer)
  clearTimeout(this.timeout)
}
```

### Use WeakMap for Element-Associated Data

```javascript
const elementData = new WeakMap()

export default class extends Controller {
  connect() {
    elementData.set(this.element, { initialized: true })
  }

  // Data is automatically garbage collected when element is removed
}
```

## Step 7: Lazy Load Heavy Dependencies

```javascript
export default class extends Controller {
  async connect() {
    // Load chart library only when needed
    if (this.hasCanvasTarget) {
      const { Chart } = await import("chart.js")
      this.chart = new Chart(this.canvasTarget, this.chartConfig)
    }
  }
}
```

## Step 8: Use Intersection Observer for Lazy Loading

```javascript
import { useIntersection } from "stimulus-use"

export default class extends Controller {
  connect() {
    useIntersection(this, { threshold: 0.1 })
  }

  appear() {
    // Load content only when visible
    this.loadContent()
  }

  async loadContent() {
    const response = await fetch(this.urlValue)
    this.element.innerHTML = await response.text()
  }
}
```

## Step 9: Measure Improvements

```javascript
// Before optimization
console.time("render")
this.render()
console.timeEnd("render")  // 150ms

// After optimization
console.time("render")
this.render()
console.timeEnd("render")  // 20ms
```

Use Lighthouse to measure:
- Time to Interactive
- Total Blocking Time
- Cumulative Layout Shift
</process>

<performance_checklist>
- [ ] Debounce/throttle high-frequency events
- [ ] Batch DOM reads and writes
- [ ] Use CSS classes instead of inline styles
- [ ] Use event delegation for repeated elements
- [ ] Clean up in disconnect()
- [ ] Lazy load heavy dependencies
- [ ] Use Intersection Observer for off-screen content
- [ ] Cache expensive computations
- [ ] Use passive event listeners for scroll/touch
</performance_checklist>

<success_criteria>
Performance optimized when:
- No janky scrolling or input lag
- Time to Interactive improved
- Memory doesn't grow over time
- CPU usage reasonable
- Lighthouse scores improved
- User experience feels snappy
</success_criteria>
