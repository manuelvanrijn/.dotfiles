<overview>
Stimulus and Turbo are designed to work together as part of Hotwire. Understanding their integration is essential for building modern Rails applications.
</overview>

<hierarchy>
## When to Use What

The Hotwire decision hierarchy:
1. **HTML** - Can you solve it with just HTML?
2. **CSS** - Can CSS transitions/animations handle it?
3. **Turbo Frames** - Need to update part of the page?
4. **Turbo Streams** - Need to update multiple parts?
5. **Stimulus** - Need client-side interactivity?
6. **Other JS** - Complex requirements?

Stimulus is for interactivity that can't be handled by Turbo.
</hierarchy>

<turbo_events>
## Turbo Events Reference

**Navigation Events:**
| Event | When | Use Case |
|-------|------|----------|
| `turbo:click` | Link clicked | Cancel navigation |
| `turbo:before-visit` | Before navigation | Save state |
| `turbo:visit` | Navigation started | Show loading |
| `turbo:before-render` | Before rendering | Prepare DOM |
| `turbo:render` | After rendering | Update UI |
| `turbo:load` | Page loaded | Initialize analytics |

**Frame Events:**
| Event | When | Use Case |
|-------|------|----------|
| `turbo:before-frame-render` | Before frame renders | Modify response |
| `turbo:frame-render` | After frame renders | Update related UI |
| `turbo:frame-load` | Frame loaded | Hide spinner |
| `turbo:frame-missing` | Target frame not found | Handle error |

**Form Events:**
| Event | When | Use Case |
|-------|------|----------|
| `turbo:submit-start` | Form submitting | Show loading |
| `turbo:submit-end` | Form submitted | Hide loading |

**Stream Events:**
| Event | When | Use Case |
|-------|------|----------|
| `turbo:before-stream-render` | Before stream renders | Modify stream |

**Morph Events (Turbo 8):**
| Event | When | Use Case |
|-------|------|----------|
| `turbo:before-morph-element` | Before element morphs | Save state |
| `turbo:before-morph-attribute` | Before attribute morphs | Prevent changes |
| `turbo:morph` | After morphing | Restore state |
</turbo_events>

<listening_to_events>
## Listening to Turbo Events

**Via data-action (recommended):**
```html
<div data-controller="analytics"
     data-action="turbo:load@document->analytics#trackPage">
</div>
```

**Via JavaScript:**
```javascript
export default class extends Controller {
  connect() {
    this.boundTrackPage = this.trackPage.bind(this)
    document.addEventListener("turbo:load", this.boundTrackPage)
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.boundTrackPage)
  }

  trackPage() {
    analytics.track("pageview")
  }
}
```
</listening_to_events>

<frame_integration>
## Working with Turbo Frames

**Loading state for frames:**
```javascript
export default class extends Controller {
  static targets = ["frame", "loading"]

  connect() {
    this.element.addEventListener("turbo:before-fetch-request", () => {
      this.loadingTarget.classList.remove("hidden")
    })

    this.element.addEventListener("turbo:frame-load", () => {
      this.loadingTarget.classList.add("hidden")
    })
  }
}
```

**Refreshing frames:**
```javascript
export default class extends Controller {
  static targets = ["frame"]

  refresh() {
    // Method 1: reload()
    this.frameTarget.reload()

    // Method 2: Update src
    this.frameTarget.src = this.frameTarget.src

    // Method 3: Navigate to different URL
    this.frameTarget.src = "/new-content"
  }
}
```

**Submitting to specific frame:**
```html
<form data-controller="search"
      data-turbo-frame="results"
      data-action="input->search#submit">
  <input name="q" type="search">
</form>

<turbo-frame id="results">
  <!-- Results load here -->
</turbo-frame>
```
</frame_integration>

<stream_integration>
## Working with Turbo Streams

**Auto-dismiss notifications:**
```javascript
// Controller attached by stream-inserted element
export default class extends Controller {
  connect() {
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

**Server-side broadcast:**
```ruby
# In Rails
Turbo::StreamsChannel.broadcast_append_to(
  "notifications",
  target: "notifications",
  partial: "notifications/toast",
  locals: { message: "Saved!" }
)
```
</stream_integration>

<morph_integration>
## Working with Morphing (Turbo 8)

When using `turbo-refresh-method="morph"`, Stimulus controllers persist across morphs. Handle this:

**Preserve state:**
```javascript
export default class extends Controller {
  static values = { scrollPosition: Number }

  connect() {
    document.addEventListener("turbo:before-morph-element", this.saveState.bind(this))
    document.addEventListener("turbo:morph", this.restoreState.bind(this))
  }

  saveState(event) {
    if (event.target === this.element) {
      this.scrollPositionValue = this.element.scrollTop
    }
  }

  restoreState() {
    this.element.scrollTop = this.scrollPositionValue
  }
}
```

**Skip initialization on morph:**
```javascript
export default class extends Controller {
  static values = { initialized: Boolean }

  connect() {
    if (!this.initializedValue) {
      this.setup()
      this.initializedValue = true
    }
  }

  setup() {
    // Only runs once, even after morph
  }
}
```
</morph_integration>

<third_party_libraries>
## Third-Party Libraries with Turbo

Third-party libraries often need cleanup when Turbo navigates:

```javascript
// controllers/chart_controller.js
export default class extends Controller {
  static values = { data: Object }

  connect() {
    this.initChart()
  }

  disconnect() {
    // Critical: destroy to prevent memory leaks
    this.chart?.destroy()
    this.chart = null
  }

  initChart() {
    this.chart = new Chart(this.element, {
      type: "bar",
      data: this.dataValue
    })
  }

  // Optional: clean up before Turbo caches
  turboBeforeCache() {
    this.chart?.destroy()
  }
}
```

```html
<canvas data-controller="chart"
        data-chart-data-value='{"labels":["A","B"],"values":[1,2]}'
        data-action="turbo:before-cache@document->chart#turboBeforeCache">
</canvas>
```
</third_party_libraries>

<disable_turbo>
## Disabling Turbo

**For specific elements:**
```html
<a href="/download" data-turbo="false">Download (full page)</a>
<form action="/upload" data-turbo="false">...</form>
```

**Via Stimulus:**
```javascript
export default class extends Controller {
  submit(event) {
    event.preventDefault()
    // Do something, then navigate without Turbo
    window.location.href = "/destination"
  }
}
```

**For specific frame:**
```html
<turbo-frame id="sidebar" data-turbo="false">
  <!-- Links in here won't use Turbo -->
</turbo-frame>
```
</disable_turbo>

<common_patterns>
## Common Integration Patterns

**Auto-refresh frame on interval:**
```javascript
export default class extends Controller {
  static targets = ["frame"]
  static values = { interval: { type: Number, default: 30000 } }

  connect() {
    this.startRefreshing()
  }

  disconnect() {
    this.stopRefreshing()
  }

  startRefreshing() {
    this.timer = setInterval(() => {
      this.frameTarget.reload()
    }, this.intervalValue)
  }

  stopRefreshing() {
    clearInterval(this.timer)
  }
}
```

**Debounced frame submission:**
```javascript
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["submit"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  submit() {
    this.element.requestSubmit()
  }
}
```

**Flash messages from stream:**
```erb
<%= turbo_stream.append "flashes" do %>
  <div data-controller="flash" data-flash-timeout-value="5000">
    <%= message %>
    <button data-action="flash#dismiss">×</button>
  </div>
<% end %>
```
</common_patterns>

<troubleshooting>
## Troubleshooting

**Controller connects multiple times:**
- Make sure you're cleaning up in `disconnect()`
- Check for duplicate controller registrations

**Controller doesn't connect after frame load:**
- Verify the HTML includes `data-controller`
- Check that controller is registered

**Events fire twice:**
- Remove listeners in `disconnect()`
- Use `{ once: true }` for one-time listeners

**Third-party library breaks on navigation:**
- Destroy instance in `disconnect()`
- Consider `turbo:before-cache` cleanup
</troubleshooting>
