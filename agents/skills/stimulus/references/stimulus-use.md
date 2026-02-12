<overview>
stimulus-use is a collection of composable behaviors (mixins) for Stimulus controllers. It adds new lifecycle callbacks, observers, and utilities without inheritance complexity.
</overview>

<installation>
## Installation

**With npm/yarn (Node-based bundlers):**
```bash
npm install stimulus-use
# or
yarn add stimulus-use
```

**With importmap (Rails default):**
```bash
bin/importmap pin stimulus-use
```

This adds to `config/importmap.rb`:
```ruby
pin "stimulus-use" # @0.52.2
```

**Version compatibility:**
- stimulus-use 0.50.0+ → Stimulus 3 (@hotwired/stimulus)
- stimulus-use 0.41.0 → Stimulus 2 (stimulus package)
</installation>

<usage_patterns>
## Two Usage Patterns

**Pattern 1: Compose with mixins (preferred)**
```javascript
import { Controller } from "@hotwired/stimulus"
import { useClickOutside, useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["search"]

  connect() {
    useClickOutside(this)
    useDebounce(this, { wait: 300 })
  }

  search() {
    // Debounced
  }

  clickOutside(event) {
    // Called when clicking outside
  }
}
```

**Pattern 2: Extend built-in controllers**
```javascript
import { IntersectionController } from "stimulus-use"

export default class extends IntersectionController {
  appear(entry) {
    // Called when element enters viewport
  }
}
```
</usage_patterns>

<observer_mixins>
## Observer Mixins

<mixin name="useClickOutside">
**Purpose:** Detect clicks outside the controller element.

```javascript
import { useClickOutside } from "stimulus-use"

export default class extends Controller {
  connect() {
    useClickOutside(this)
  }

  clickOutside(event) {
    this.close()
  }
}
```

**Options:**
- `element`: Element to detect clicks outside of (default: controller element)
- `events`: Events to listen for (default: ["click", "touchend"])
</mixin>

<mixin name="useIntersection">
**Purpose:** Detect when element enters/exits viewport.

```javascript
import { useIntersection } from "stimulus-use"

export default class extends Controller {
  connect() {
    useIntersection(this, {
      threshold: 0.5  // 50% visible triggers callback
    })
  }

  appear(entry) {
    // Element is visible
    this.loadContent()
  }

  disappear(entry) {
    // Element is hidden
    this.pauseVideo()
  }
}
```

**Options:**
- `threshold`: 0-1, how much must be visible
- `rootMargin`: Margin around root
</mixin>

<mixin name="useResize">
**Purpose:** Detect element resize.

```javascript
import { useResize } from "stimulus-use"

export default class extends Controller {
  connect() {
    useResize(this)
  }

  resize({ width, height }) {
    if (width < 768) {
      this.switchToMobileLayout()
    }
  }
}
```
</mixin>

<mixin name="useVisibility">
**Purpose:** Detect page visibility changes.

```javascript
import { useVisibility } from "stimulus-use"

export default class extends Controller {
  connect() {
    useVisibility(this)
  }

  visible() {
    // Tab became visible
    this.resumePolling()
  }

  invisible() {
    // Tab hidden
    this.pausePolling()
  }
}
```
</mixin>

<mixin name="useWindowFocus">
**Purpose:** Detect window focus/blur.

```javascript
import { useWindowFocus } from "stimulus-use"

export default class extends Controller {
  connect() {
    useWindowFocus(this)
  }

  focus() {
    // Window gained focus
  }

  unfocus() {
    // Window lost focus
  }
}
```
</mixin>

<mixin name="useWindowResize">
**Purpose:** Detect window resize.

```javascript
import { useWindowResize } from "stimulus-use"

export default class extends Controller {
  connect() {
    useWindowResize(this)
  }

  windowResize({ width, height }) {
    this.updateLayout()
  }
}
```
</mixin>

<mixin name="useMutation">
**Purpose:** Detect DOM mutations.

```javascript
import { useMutation } from "stimulus-use"

export default class extends Controller {
  connect() {
    useMutation(this, {
      childList: true,
      subtree: true
    })
  }

  mutate(mutations) {
    // DOM changed
    this.recalculate()
  }
}
```
</mixin>

<mixin name="useHover">
**Purpose:** Detect mouse hover.

```javascript
import { useHover } from "stimulus-use"

export default class extends Controller {
  connect() {
    useHover(this)
  }

  mouseEnter() {
    this.showTooltip()
  }

  mouseLeave() {
    this.hideTooltip()
  }
}
```
</mixin>

<mixin name="useIdle">
**Purpose:** Detect user inactivity.

```javascript
import { useIdle } from "stimulus-use"

export default class extends Controller {
  connect() {
    useIdle(this, { ms: 60000 }) // 1 minute
  }

  away() {
    // User idle for 1 minute
    this.showIdleWarning()
  }

  back() {
    // User active again
    this.hideIdleWarning()
  }
}
```
</mixin>
</observer_mixins>

<utility_mixins>
## Utility Mixins

<mixin name="useDebounce">
**Purpose:** Debounce method calls.

```javascript
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["search", "validate"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  search() {
    // Called at most every 300ms
  }
}
```
</mixin>

<mixin name="useThrottle">
**Purpose:** Throttle method calls.

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
</mixin>

<mixin name="useTransition">
**Purpose:** CSS transitions with enter/leave states.

```javascript
import { useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    useTransition(this, {
      element: this.menuTarget,
      enterActive: "transition ease-out duration-200",
      enterFrom: "opacity-0 scale-95",
      enterTo: "opacity-100 scale-100",
      leaveActive: "transition ease-in duration-150",
      leaveFrom: "opacity-100 scale-100",
      leaveTo: "opacity-0 scale-95"
    })
  }

  show() {
    this.enter()  // Added by useTransition
  }

  hide() {
    this.leave()  // Added by useTransition
  }
}
```
</mixin>

<mixin name="useHotkeys">
**Purpose:** Keyboard shortcuts.

```javascript
import { useHotkeys } from "stimulus-use"

export default class extends Controller {
  static hotkeys = {
    "ctrl+s": "save",
    "ctrl+k": "search",
    "esc": "close"
  }

  connect() {
    useHotkeys(this)
  }

  save(event) {
    event.preventDefault()
    this.saveDocument()
  }

  search(event) {
    event.preventDefault()
    this.openSearch()
  }
}
```

**Requires:** `npm install hotkeys-js` or `bin/importmap pin hotkeys-js`
</mixin>

<mixin name="useMatchMedia">
**Purpose:** Respond to media queries.

```javascript
import { useMatchMedia } from "stimulus-use"

export default class extends Controller {
  static mediaQueries = {
    mobile: "(max-width: 767px)",
    desktop: "(min-width: 768px)"
  }

  connect() {
    useMatchMedia(this)
  }

  isMobile() {
    // Matches mobile query
    this.useMobileLayout()
  }

  notMobile() {
    // Doesn't match mobile query
    this.useDesktopLayout()
  }

  mobileChanged(matches) {
    // Media query changed
  }
}
```
</mixin>
</utility_mixins>

<debugging>
## Debugging

Enable globally:
```javascript
// application.js
application.stimulusUseDebug = true
// or
application.stimulusUseDebug = process.env.NODE_ENV === "development"
```

Enable per mixin:
```javascript
useClickOutside(this, { debug: true })
useIntersection(this, { debug: true })
```

Debug output shows:
- When mixins connect/disconnect
- When callbacks are triggered
- Event details
</debugging>

<combining_mixins>
## Combining Multiple Mixins

```javascript
import { Controller } from "@hotwired/stimulus"
import {
  useClickOutside,
  useTransition,
  useDebounce,
  useHotkeys
} from "stimulus-use"

export default class extends Controller {
  static targets = ["menu", "search"]
  static debounces = ["search"]
  static hotkeys = {
    "esc": "close",
    "/": "focusSearch"
  }

  connect() {
    useClickOutside(this)
    useTransition(this, { element: this.menuTarget })
    useDebounce(this, { wait: 300 })
    useHotkeys(this)
  }

  clickOutside() {
    this.close()
  }

  close() {
    this.leave()
  }

  open() {
    this.enter()
  }

  search() {
    // Debounced
  }

  focusSearch(event) {
    event.preventDefault()
    this.searchTarget.focus()
  }
}
```
</combining_mixins>

<custom_mixins>
## Creating Custom Mixins

```javascript
// mixins/use_local_storage.js
export const useLocalStorage = (controller, options = {}) => {
  const { key } = options

  Object.assign(controller, {
    saveToStorage(data) {
      localStorage.setItem(key, JSON.stringify(data))
    },

    loadFromStorage() {
      const data = localStorage.getItem(key)
      return data ? JSON.parse(data) : null
    },

    clearStorage() {
      localStorage.removeItem(key)
    }
  })
}

// Usage
import { useLocalStorage } from "../mixins/use_local_storage"

export default class extends Controller {
  connect() {
    useLocalStorage(this, { key: "user_preferences" })
    this.preferences = this.loadFromStorage() || {}
  }

  save() {
    this.saveToStorage(this.preferences)
  }
}
```
</custom_mixins>
