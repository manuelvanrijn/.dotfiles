<overview>
UI patterns for Stimulus applications. **Always check if a pre-built component exists before writing custom code.** The stimulus-components library provides battle-tested, accessible implementations for most common patterns.
</overview>

<use_existing_first>
## Use Existing Components First

Before writing a custom controller, check if stimulus-components already solves the problem:

**With npm/yarn:**
```bash
npm install @stimulus-components/[component-name]
```

**With importmap (Rails default):**
```bash
bin/importmap pin @stimulus-components/dialog
bin/importmap pin @stimulus-components/dropdown
```

**Registration:**
```javascript
// app/javascript/controllers/index.js
import Dialog from "@stimulus-components/dialog"
import Dropdown from "@stimulus-components/dropdown"
import Clipboard from "@stimulus-components/clipboard"

application.register("dialog", Dialog)
application.register("dropdown", Dropdown)
application.register("clipboard", Clipboard)
```

**Benefits of using existing components:**
- Battle-tested and maintained
- Accessible by default
- Consistent API patterns
- Extendable when you need customization
</use_existing_first>

<stimulus_components_reference>
## stimulus-components Library

Complete reference of available components.

**Installation:**
- npm: `npm install @stimulus-components/[name]`
- importmap: `bin/importmap pin @stimulus-components/[name]`

### UI Components

| Component | Package | Use Case |
|-----------|---------|----------|
| **Dialog** | `@stimulus-components/dialog` | Modals using native `<dialog>` element |
| **Dropdown** | `@stimulus-components/dropdown` | Animated dropdown menus |
| **Popover** | `@stimulus-components/popover` | Popovers with local or remote content |
| **Notification** | `@stimulus-components/notification` | Auto-dismissing toast notifications |
| **Reveal** | `@stimulus-components/reveal` | Toggle visibility of elements |
| **Read More** | `@stimulus-components/read-more` | Expandable/collapsible text |
| **Lightbox** | `@stimulus-components/lightbox` | Image gallery (uses lightgallery.js) |
| **Carousel** | `@stimulus-components/carousel` | Sliders/carousels (uses Swiper) |

### Form Components

| Component | Package | Use Case |
|-----------|---------|----------|
| **Auto Submit** | `@stimulus-components/auto-submit` | Auto-submit forms on input change |
| **Character Counter** | `@stimulus-components/character-counter` | Count input characters with limits |
| **Checkbox Select All** | `@stimulus-components/checkbox-select-all` | Select/deselect all checkboxes |
| **Password Visibility** | `@stimulus-components/password-visibility` | Toggle password show/hide |
| **Rails Nested Form** | `@stimulus-components/rails-nested-form` | Dynamic nested attributes |
| **Textarea Autogrow** | `stimulus-textarea-autogrow` | Auto-expanding textareas |
| **Color Picker** | `@stimulus-components/color-picker` | Color selection (uses Pickr) |
| **Places Autocomplete** | `stimulus-places-autocomplete` | Google Places address input |
| **Confirmation** | `@stimulus-components/confirmation` | Require confirmation before action |

### Data & Content

| Component | Package | Use Case |
|-----------|---------|----------|
| **Clipboard** | `@stimulus-components/clipboard` | Copy text to clipboard |
| **Content Loader** | `@stimulus-components/content-loader` | Lazy load HTML via AJAX |
| **Animated Number** | `@stimulus-components/animated-number` | Animate counting numbers |
| **Timeago** | `@stimulus-components/timeago` | Relative time display |
| **Chartjs** | `@stimulus-components/chartjs` | Charts (uses Chart.js) |
| **Sortable** | `@stimulus-components/sortable` | Drag-and-drop reordering |
| **Remote Rails** | `@stimulus-components/remote-rails` | Rails UJS AJAX handling |

### Navigation & Scroll

| Component | Package | Use Case |
|-----------|---------|----------|
| **Scroll To** | `@stimulus-components/scroll-to` | Smooth scroll to anchors |
| **Scroll Progress** | `@stimulus-components/scroll-progress` | Reading progress bar |
| **Scroll Reveal** | `@stimulus-components/scroll-reveal` | Animate on scroll into view |
| **Prefetch** | `@stimulus-components/prefetch` | Prefetch links on hover |

### Effects

| Component | Package | Use Case |
|-----------|---------|----------|
| **Glow** | `stimulus-glow` | Mouse-tracking glow effect |
| **Sound** | `@stimulus-components/sound` | Audio playback control |
</stimulus_components_reference>

<extending_components>
## Extending Existing Components

When you need custom behavior, extend rather than rewrite:

```javascript
import Dialog from "@stimulus-components/dialog"

export default class extends Dialog {
  // Add custom behavior
  open() {
    super.open()
    this.trackAnalytics("modal_opened")
  }

  trackAnalytics(event) {
    // Custom tracking logic
  }
}
```
</extending_components>

<when_to_build_custom>
## When to Build Custom

Build a custom controller when:
- No existing component fits your use case
- You need significantly different behavior
- The existing component has dependencies you don't want
- You're learning Stimulus (then refactor to use libraries)

The following sections show custom implementations for reference and learning.
</when_to_build_custom>

<modal_pattern>
## Modal / Dialog (Custom Implementation)

**Prefer:** `@stimulus-components/dialog`

**Custom implementation using native dialog:**

```javascript
// controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.showModal()
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.dialogTarget.close()
    document.body.classList.remove("overflow-hidden")
  }

  clickBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
```

```html
<div data-controller="modal">
  <button data-action="modal#open">Open Modal</button>

  <dialog data-modal-target="dialog"
          data-action="click->modal#clickBackdrop"
          class="backdrop:bg-black/50 rounded-lg p-0 max-w-lg w-full">
    <div class="p-6">
      <h2 class="text-lg font-semibold">Modal Title</h2>
      <p class="mt-2">Modal content here...</p>

      <div class="mt-4 flex justify-end gap-2">
        <button data-action="modal#close" class="px-4 py-2 bg-gray-200 rounded">
          Cancel
        </button>
        <button data-action="modal#close" class="px-4 py-2 bg-blue-500 text-white rounded">
          Confirm
        </button>
      </div>
    </div>
  </dialog>
</div>
```
</modal_pattern>

<dropdown_pattern>
## Dropdown Menu (Custom Implementation)

**Prefer:** `@stimulus-components/dropdown`

**Custom implementation with transitions:**

```javascript
// controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"
import { useClickOutside, useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["menu", "button"]
  static values = { open: Boolean }

  connect() {
    useClickOutside(this)
    useTransition(this, {
      element: this.menuTarget,
      enterActive: "transition ease-out duration-100",
      enterFrom: "opacity-0 scale-95",
      enterTo: "opacity-100 scale-100",
      leaveActive: "transition ease-in duration-75",
      leaveFrom: "opacity-100 scale-100",
      leaveTo: "opacity-0 scale-95"
    })
  }

  toggle() {
    this.openValue = !this.openValue
  }

  openValueChanged() {
    if (this.openValue) {
      this.menuTarget.classList.remove("hidden")
      this.enter()
      this.buttonTarget.setAttribute("aria-expanded", "true")
    } else {
      this.leave().then(() => {
        this.menuTarget.classList.add("hidden")
      })
      this.buttonTarget.setAttribute("aria-expanded", "false")
    }
  }

  clickOutside() {
    this.openValue = false
  }
}
```

```html
<div data-controller="dropdown" class="relative inline-block">
  <button data-dropdown-target="button"
          data-action="dropdown#toggle"
          aria-haspopup="true"
          aria-expanded="false">
    Options ▼
  </button>

  <div data-dropdown-target="menu"
       role="menu"
       class="hidden absolute right-0 mt-2 w-48 bg-white rounded shadow-lg border z-50">
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100">Account</a>
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100">Settings</a>
    <hr class="my-1">
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100 text-red-600">Sign out</a>
  </div>
</div>
```
</dropdown_pattern>

<tabs_pattern>
## Tabs (Custom Implementation)

**No direct stimulus-components equivalent** - this is a good candidate for custom implementation.

```javascript
// controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { index: { type: Number, default: 0 } }
  static classes = ["activeTab", "inactiveTab"]

  connect() {
    this.showTab()
  }

  select(event) {
    this.indexValue = this.tabTargets.indexOf(event.currentTarget)
  }

  indexValueChanged() {
    this.showTab()
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const isActive = index === this.indexValue
      tab.classList.toggle(this.activeTabClass, isActive)
      tab.classList.toggle(this.inactiveTabClass, !isActive)
      tab.setAttribute("aria-selected", isActive)
    })

    this.panelTargets.forEach((panel, index) => {
      panel.hidden = index !== this.indexValue
    })
  }
}
```

```html
<div data-controller="tabs"
     data-tabs-active-tab-class="border-blue-500 text-blue-600"
     data-tabs-inactive-tab-class="border-transparent text-gray-500">

  <div role="tablist" class="flex border-b">
    <button data-tabs-target="tab" data-action="tabs#select" role="tab">Tab 1</button>
    <button data-tabs-target="tab" data-action="tabs#select" role="tab">Tab 2</button>
    <button data-tabs-target="tab" data-action="tabs#select" role="tab">Tab 3</button>
  </div>

  <div data-tabs-target="panel" role="tabpanel">Panel 1</div>
  <div data-tabs-target="panel" role="tabpanel" hidden>Panel 2</div>
  <div data-tabs-target="panel" role="tabpanel" hidden>Panel 3</div>
</div>
```
</tabs_pattern>

<reveal_pattern>
## Reveal / Toggle Visibility

**Prefer:** `@stimulus-components/reveal`

```bash
npm install @stimulus-components/reveal
# or
bin/importmap pin @stimulus-components/reveal
```

```javascript
import Reveal from "@stimulus-components/reveal"
application.register("reveal", Reveal)
```

```html
<div data-controller="reveal" data-reveal-hidden-class="hidden">
  <button data-action="reveal#toggle">Toggle Content</button>
  <div data-reveal-target="item" class="hidden">
    This content toggles visibility
  </div>
</div>
```
</reveal_pattern>

<clipboard_pattern>
## Clipboard

**Prefer:** `@stimulus-components/clipboard`

```bash
npm install @stimulus-components/clipboard
# or
bin/importmap pin @stimulus-components/clipboard
```

```javascript
import Clipboard from "@stimulus-components/clipboard"
application.register("clipboard", Clipboard)
```

```html
<div data-controller="clipboard"
     data-clipboard-success-content="Copied!">
  <input data-clipboard-target="source" value="Text to copy">
  <button data-action="clipboard#copy"
          data-clipboard-target="button">
    Copy
  </button>
</div>
```
</clipboard_pattern>

<notification_pattern>
## Notifications / Toasts

**Prefer:** `@stimulus-components/notification`

```bash
npm install @stimulus-components/notification
# or
bin/importmap pin @stimulus-components/notification
```

```javascript
import Notification from "@stimulus-components/notification"
application.register("notification", Notification)
```

```html
<div data-controller="notification"
     data-notification-delay-value="3000"
     class="fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded">
  <p>Success! Your changes were saved.</p>
  <button data-action="notification#hide">×</button>
</div>
```
</notification_pattern>

<sortable_pattern>
## Sortable / Drag and Drop

**Prefer:** `@stimulus-components/sortable`

```bash
npm install @stimulus-components/sortable sortablejs
# or
bin/importmap pin @stimulus-components/sortable sortablejs
```

```javascript
import Sortable from "@stimulus-components/sortable"
application.register("sortable", Sortable)
```

```html
<ul data-controller="sortable"
    data-sortable-handle-value=".handle"
    data-sortable-animation-value="150">
  <li>
    <span class="handle">☰</span>
    Item 1
  </li>
  <li>
    <span class="handle">☰</span>
    Item 2
  </li>
</ul>
```

For Rails, automatically updates position via AJAX:

```html
<ul data-controller="sortable"
    data-sortable-resource-name-value="item"
    data-sortable-param-name-value="position">
  <li data-sortable-update-url="/items/1/move">Item 1</li>
  <li data-sortable-update-url="/items/2/move">Item 2</li>
</ul>
```
</sortable_pattern>

<content_loader_pattern>
## Content Loader / Lazy Loading

**Prefer:** `@stimulus-components/content-loader`

```bash
npm install @stimulus-components/content-loader
# or
bin/importmap pin @stimulus-components/content-loader
```

```javascript
import ContentLoader from "@stimulus-components/content-loader"
application.register("content-loader", ContentLoader)
```

```html
<!-- Load on connect -->
<div data-controller="content-loader"
     data-content-loader-url-value="/comments">
  <p>Loading...</p>
</div>

<!-- Load on demand -->
<div data-controller="content-loader"
     data-content-loader-url-value="/comments"
     data-content-loader-lazy-loading-value="true">
  <button data-action="content-loader#load">Load Comments</button>
</div>
```
</content_loader_pattern>

<accessibility_checklist>
## Accessibility Requirements

| Pattern | Required Attributes |
|---------|---------------------|
| Modal | `role="dialog"`, `aria-modal="true"`, `aria-labelledby` |
| Dropdown | `aria-haspopup`, `aria-expanded`, `role="menu"`, `role="menuitem"` |
| Tabs | `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected` |
| Accordion | `aria-expanded`, `aria-controls`, `aria-hidden` |
| Toggle | `aria-checked` or use native checkbox |
| Tooltip | `role="tooltip"`, trigger with `aria-describedby` |

**stimulus-components handle accessibility automatically** - another reason to prefer them.
</accessibility_checklist>

<rails_integration_patterns>
## Rails Integration Patterns

These patterns leverage Rails conventions to reduce boilerplate and cleanly pass server-side data to Stimulus controllers.

<meta_tags_pattern>
### Passing Configuration via Meta Tags

**Problem:** Need server-side configuration (environment, feature flags, public API keys) in Stimulus controllers without repeating values in HTML attributes.

**Solution:** Use meta tags rendered by Rails, read by a utility function.

**Rails Layout:**
```erb
<%# app/views/layouts/application.html.erb %>
<head>
  <%= tag :meta, name: :rails_env, content: Rails.env %>
  <%= tag :meta, name: :api_base_url, content: ENV["API_BASE_URL"] %>
  <%= tag :meta, name: :feature_dark_mode, content: feature_enabled?(:dark_mode) %>
</head>
```

**Utility Function:**
```javascript
// app/javascript/helpers/meta.js
export function metaContent(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element && element.content
}
```

**Usage in Controller:**
```javascript
import { Controller } from "@hotwired/stimulus"
import { metaContent } from "../helpers/meta"

export default class extends Controller {
  connect() {
    if (metaContent("rails_env") === "development") {
      this.enableDebugMode()
    }
  }

  get apiBaseUrl() {
    return metaContent("api_base_url")
  }
}
```

**Security Warning:** Meta tag content is visible in page source. Only expose data safe to be public—never secrets, API keys with write access, or sensitive configuration.

**Good uses:** Environment name, feature flags, public API endpoints, CSRF tokens
**Bad uses:** Secret keys, private API tokens, user credentials
</meta_tags_pattern>

<helper_components_pattern>
### Lightweight Components with Helpers

**Problem:** Repetitive Stimulus data attributes scattered across views create maintenance burden and inconsistency.

**Solution:** Wrap Stimulus controller setup in Rails helpers for DRY, readable view code.

**Rails Helper:**
```ruby
# app/helpers/components_helper.rb
module ComponentsHelper
  def hovercard(url, &block)
    content_tag(:div,
      "data-controller": "hovercard",
      "data-hovercard-url-value": url,
      "data-action": "mouseenter->hovercard#show mouseleave->hovercard#hide",
      &block)
  end

  def user_hovercard(user, &block)
    hovercard hovercard_user_path(user), &block
  end

  def copy_button(text, label: "Copy")
    content_tag(:button, label,
      "data-controller": "clipboard",
      "data-clipboard-text-value": text,
      "data-action": "clipboard#copy")
  end

  def auto_submit_form(model, url:, &block)
    form_with(model: model, url: url,
      data: {
        controller: "auto-submit",
        action: "change->auto-submit#submit"
      }, &block)
  end
end
```

**View Usage:**
```erb
<%# Clean, readable view code %>
<%= user_hovercard(@user) do %>
  <%= link_to @user.username, @user %>
<% end %>

<%= copy_button(@invite_code, label: "Copy Invite Code") %>

<%= auto_submit_form(@filter, url: search_path) do |f| %>
  <%= f.select :status, status_options %>
  <%= f.select :category, category_options %>
<% end %>
```

**Benefits:**
- **DRY:** Stimulus configuration lives in one place
- **Flexibility:** Ruby blocks allow per-usage customization
- **Clarity:** View code shows intent, not implementation details
- **Maintainability:** Change controller wiring in one place

**When to use:**
- Component used 3+ times across views
- Complex data attribute setup
- Want to encapsulate default options
- Building a component library for your team
</helper_components_pattern>
</rails_integration_patterns>

<decision_guide>
## Which Approach to Use?

| Scenario | Recommendation |
|----------|----------------|
| Standard UI pattern (modal, dropdown, clipboard) | Use stimulus-components |
| Need slight customization | Extend stimulus-components |
| Completely unique behavior | Build custom |
| Learning Stimulus | Build custom, then refactor |
| Production app | Use stimulus-components |
| Server config needed in JS | Meta tags pattern |
| Repeated Stimulus markup in views | Rails helpers pattern |
| Component used 3+ times | Wrap in helper |
</decision_guide>
