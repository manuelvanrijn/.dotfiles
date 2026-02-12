# Workflow: Implement UI Pattern

<required_reading>
**Read these reference files NOW:**
1. references/ui-patterns.md
2. references/actions.md
3. references/stimulus-use.md
</required_reading>

<process>
## Step 1: Identify the Pattern

| Pattern | Use Case |
|---------|----------|
| Modal/Dialog | Overlays requiring focus trap |
| Dropdown | Click-outside dismissible menus |
| Tabs | Content switching |
| Accordion | Collapsible sections |
| Toggle | Show/hide single element |
| Reveal | Progressive disclosure |
| Slideover | Side panel overlay |
| Popover | Contextual tooltips |

## Step 2: Choose Implementation Approach

**Option A: Use existing library**
- `@stimulus-components/dialog` - Modals with native dialog
- `@stimulus-components/dropdown` - Dropdowns with transitions
- `tailwindcss-stimulus-components` - Full component set for Tailwind

**Option B: Build from scratch**
Better for learning, custom requirements, or minimal dependencies.

---

## Modal/Dialog Pattern

```javascript
// controllers/dialog_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  // Close on backdrop click
  backdropClose(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
```

```html
<div data-controller="dialog"
     data-action="click->dialog#backdropClose keydown.esc->dialog#close">
  <button data-action="dialog#open">Open Modal</button>

  <dialog data-dialog-target="dialog" class="backdrop:bg-black/50 rounded-lg p-6">
    <h2>Modal Title</h2>
    <p>Modal content here</p>
    <button data-action="dialog#close" autofocus>Close</button>
  </dialog>
</div>
```

---

## Dropdown Pattern

```javascript
// controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"
import { useClickOutside, useTransition } from "stimulus-use"

export default class extends Controller {
  static targets = ["menu"]
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
      this.enter()
    } else {
      this.leave()
    }
  }

  clickOutside() {
    this.openValue = false
  }

  // Keyboard navigation
  nextItem(event) {
    this.focusItem(1)
  }

  previousItem(event) {
    this.focusItem(-1)
  }

  focusItem(direction) {
    const items = this.menuTarget.querySelectorAll("[role='menuitem']")
    const current = document.activeElement
    const index = Array.from(items).indexOf(current)
    const next = items[index + direction] || items[direction > 0 ? 0 : items.length - 1]
    next?.focus()
  }
}
```

```html
<div data-controller="dropdown"
     data-action="keydown.down->dropdown#nextItem keydown.up->dropdown#previousItem keydown.esc->dropdown#toggle">
  <button data-action="dropdown#toggle" aria-haspopup="true">
    Options
  </button>

  <div data-dropdown-target="menu"
       class="hidden absolute mt-2 w-48 bg-white rounded shadow-lg"
       role="menu">
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100">Account</a>
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100">Settings</a>
    <a href="#" role="menuitem" class="block px-4 py-2 hover:bg-gray-100">Sign out</a>
  </div>
</div>
```

---

## Tabs Pattern

```javascript
// controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { index: { type: Number, default: 0 } }
  static classes = ["active"]

  connect() {
    this.showTab()
  }

  change(event) {
    this.indexValue = this.tabTargets.indexOf(event.currentTarget)
  }

  indexValueChanged() {
    this.showTab()
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const isActive = index === this.indexValue
      tab.classList.toggle(this.activeClass, isActive)
      tab.setAttribute("aria-selected", isActive)
    })

    this.panelTargets.forEach((panel, index) => {
      panel.hidden = index !== this.indexValue
    })
  }
}
```

```html
<div data-controller="tabs" data-tabs-active-class="border-blue-500 text-blue-600">
  <div role="tablist" class="flex border-b">
    <button data-tabs-target="tab"
            data-action="tabs#change"
            role="tab"
            class="px-4 py-2 border-b-2">
      Tab 1
    </button>
    <button data-tabs-target="tab"
            data-action="tabs#change"
            role="tab"
            class="px-4 py-2 border-b-2">
      Tab 2
    </button>
  </div>

  <div data-tabs-target="panel" role="tabpanel" class="p-4">Panel 1 content</div>
  <div data-tabs-target="panel" role="tabpanel" class="p-4" hidden>Panel 2 content</div>
</div>
```

---

## Accordion Pattern

```javascript
// controllers/accordion_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = { allowMultiple: { type: Boolean, default: false } }

  toggle(event) {
    const item = event.currentTarget.closest("[data-accordion-target='item']")
    const isOpen = item.hasAttribute("open")

    if (!this.allowMultipleValue && !isOpen) {
      this.closeAll()
    }

    item.toggleAttribute("open")
  }

  closeAll() {
    this.itemTargets.forEach(item => item.removeAttribute("open"))
  }
}
```

```html
<div data-controller="accordion">
  <details data-accordion-target="item">
    <summary data-action="click->accordion#toggle:prevent" class="cursor-pointer p-4 bg-gray-100">
      Section 1
    </summary>
    <div class="p-4">Content 1</div>
  </details>

  <details data-accordion-target="item">
    <summary data-action="click->accordion#toggle:prevent" class="cursor-pointer p-4 bg-gray-100">
      Section 2
    </summary>
    <div class="p-4">Content 2</div>
  </details>
</div>
```

---

## Toggle/Reveal Pattern

```javascript
// controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static classes = ["hidden"]

  toggle() {
    this.contentTarget.classList.toggle(this.hiddenClass)
  }

  show() {
    this.contentTarget.classList.remove(this.hiddenClass)
  }

  hide() {
    this.contentTarget.classList.add(this.hiddenClass)
  }
}
```

```html
<div data-controller="toggle" data-toggle-hidden-class="hidden">
  <button data-action="toggle#toggle">Toggle FAQ</button>

  <div data-toggle-target="content" class="hidden">
    Answer to frequently asked question...
  </div>
</div>
```

## Step 3: Add Accessibility

| Pattern | Requirements |
|---------|--------------|
| Modal | `role="dialog"`, `aria-modal="true"`, focus trap |
| Dropdown | `aria-haspopup`, `aria-expanded`, `role="menu"` |
| Tabs | `role="tablist"`, `role="tab"`, `aria-selected` |
| Accordion | `aria-expanded`, `aria-controls` |

## Step 4: Add Animations (Optional)

Use stimulus-use transitions or CSS:

```css
.dropdown-enter {
  transition: opacity 100ms ease-out, transform 100ms ease-out;
}

.dropdown-enter-from {
  opacity: 0;
  transform: scale(0.95);
}

.dropdown-enter-to {
  opacity: 1;
  transform: scale(1);
}
```
</process>

<success_criteria>
UI pattern complete when:
- Works with mouse and keyboard
- Accessible (proper ARIA attributes)
- Works with Turbo navigation
- Animations are smooth (if applicable)
- Click-outside closes (if applicable)
- Escape key closes (if applicable)
</success_criteria>
