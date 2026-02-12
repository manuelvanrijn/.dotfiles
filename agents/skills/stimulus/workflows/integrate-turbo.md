# Workflow: Integrate with Turbo

<required_reading>
**Read these reference files NOW:**
1. references/turbo-integration.md
2. references/architecture.md
3. references/performance.md
</required_reading>

<process>
## Step 1: Understand Turbo Events

Turbo dispatches events you can listen to in Stimulus:

| Event | When |
|-------|------|
| `turbo:before-visit` | Before Turbo navigates |
| `turbo:visit` | Immediately after visit starts |
| `turbo:before-render` | Before rendering the new page |
| `turbo:render` | After rendering |
| `turbo:load` | After page is fully loaded |
| `turbo:frame-load` | After a Turbo Frame loads |
| `turbo:before-stream-render` | Before Turbo Stream is rendered |
| `turbo:before-morph-element` | Before morphing an element |
| `turbo:morph` | After morphing completes |

## Step 2: Listen to Turbo Events

```javascript
// controllers/analytics_controller.js
export default class extends Controller {
  connect() {
    this.boundTrackPage = this.trackPage.bind(this)
    document.addEventListener("turbo:load", this.boundTrackPage)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.boundTrackPage)
  }

  trackPage() {
    analytics.track("pageview", { url: window.location.href })
  }
}
```

Or use data-action on document:
```html
<body data-controller="analytics"
      data-action="turbo:load@document->analytics#trackPage">
```

## Step 3: Handle Turbo Frame Loading

```javascript
// controllers/frame_loader_controller.js
export default class extends Controller {
  static targets = ["frame", "spinner"]

  connect() {
    this.element.addEventListener("turbo:before-fetch-request", this.showSpinner.bind(this))
    this.element.addEventListener("turbo:frame-load", this.hideSpinner.bind(this))
  }

  showSpinner() {
    this.spinnerTarget.classList.remove("hidden")
  }

  hideSpinner() {
    this.spinnerTarget.classList.add("hidden")
  }
}
```

```html
<div data-controller="frame-loader">
  <turbo-frame id="content" data-frame-loader-target="frame" src="/content">
    Loading...
  </turbo-frame>
  <div data-frame-loader-target="spinner" class="hidden">
    <!-- Spinner SVG -->
  </div>
</div>
```

## Step 4: Refresh Turbo Frames from Stimulus

```javascript
// controllers/refresher_controller.js
export default class extends Controller {
  static targets = ["frame"]

  refresh() {
    // Method 1: Reload frame
    this.frameTarget.reload()

    // Method 2: Change src to trigger reload
    this.frameTarget.src = this.frameTarget.src

    // Method 3: Fetch and replace
    this.frameTarget.src = "/new-content"
  }

  // Auto-refresh on interval
  connect() {
    this.timer = setInterval(() => this.refresh(), 30000)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
```

```html
<div data-controller="refresher">
  <button data-action="refresher#refresh">Refresh</button>
  <turbo-frame id="notifications" data-refresher-target="frame" src="/notifications">
  </turbo-frame>
</div>
```

## Step 5: Handle Turbo Streams

```javascript
// controllers/toast_controller.js
export default class extends Controller {
  connect() {
    // Auto-dismiss toast after 5 seconds
    this.timeout = setTimeout(() => this.dismiss(), 5000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.remove()
  }
}
```

```erb
<%# From server - broadcasts toast via Turbo Stream %>
<turbo-stream action="append" target="toasts">
  <template>
    <div data-controller="toast" class="toast">
      Message saved!
      <button data-action="toast#dismiss">&times;</button>
    </div>
  </template>
</turbo-stream>
```

## Step 6: Work with Turbo Morphing

When using `turbo-refresh-method="morph"`, Stimulus controllers persist. Handle this:

```javascript
export default class extends Controller {
  static values = { initialized: Boolean }

  connect() {
    // Only run once, even if element is morphed
    if (!this.initializedValue) {
      this.setup()
      this.initializedValue = true
    }
  }

  // Or listen to morph events
  initialize() {
    this.element.addEventListener("turbo:before-morph-element", this.beforeMorph.bind(this))
    this.element.addEventListener("turbo:morph", this.afterMorph.bind(this))
  }

  beforeMorph(event) {
    // Save state before morph
    this.savedState = this.getState()
  }

  afterMorph() {
    // Restore state after morph
    this.restoreState(this.savedState)
  }
}
```

## Step 7: Prevent Turbo on Specific Links

```html
<!-- Disable Turbo for this link -->
<a href="/download" data-turbo="false">Download PDF</a>

<!-- Disable Turbo for form -->
<form data-turbo="false">

<!-- Or via Stimulus -->
<a href="/download" data-action="click->downloader#handle">Download</a>
```

```javascript
export default class extends Controller {
  handle(event) {
    // Do something before navigation
    event.preventDefault()

    // Then navigate without Turbo
    window.location.href = event.currentTarget.href
  }
}
```

## Step 8: Submit Forms to Turbo Frames

```html
<turbo-frame id="search-results">
  <form data-controller="search"
        data-action="input->search#submit"
        data-turbo-frame="search-results">
    <input type="search" name="q" data-search-target="input">
  </form>

  <div id="results">
    <!-- Results appear here -->
  </div>
</turbo-frame>
```

```javascript
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static targets = ["input"]
  static debounces = ["submit"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  submit() {
    this.element.requestSubmit()
  }
}
```

## Step 9: Handle Third-Party Libraries with Turbo

```javascript
// controllers/chart_controller.js
export default class extends Controller {
  static values = { data: Array }

  connect() {
    this.initChart()
  }

  disconnect() {
    // Critical: destroy chart to prevent memory leaks
    this.chart?.destroy()
  }

  initChart() {
    this.chart = new Chart(this.element, {
      type: "line",
      data: this.dataValue
    })
  }

  // Handle Turbo cache
  turboBeforeCache() {
    this.chart?.destroy()
  }
}
```

```html
<canvas data-controller="chart"
        data-chart-data-value='[1,2,3,4,5]'
        data-action="turbo:before-cache@document->chart#turboBeforeCache">
</canvas>
```
</process>

<turbo_patterns>
**Loading states:** Show spinners during frame loads
**Auto-refresh:** Refresh frames on interval or event
**Form submission:** Submit to specific frame
**Morphing:** Preserve controller state during morph
**Third-party cleanup:** Destroy libraries in disconnect
**Cache handling:** Clean up before Turbo caches page
</turbo_patterns>

<success_criteria>
Turbo integration complete when:
- Controller survives navigation
- No memory leaks after navigation
- Frames load and update correctly
- Streams append/replace as expected
- Third-party libraries work with Turbo
- Loading states provide feedback
</success_criteria>
