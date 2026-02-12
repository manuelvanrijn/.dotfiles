<overview>
CSS Classes let you define CSS class names as configurable values on your controller, making styling customizable from HTML.
</overview>

<defining_classes>
## Defining Classes

```javascript
export default class extends Controller {
  static classes = ["active", "loading", "hidden", "error"]
}
```

Each class creates properties:

| Property | Type | Description |
|----------|------|-------------|
| `this.activeClass` | String | The class name |
| `this.activeClasses` | String[] | Array of class names (space-separated) |
| `this.hasActiveClass` | Boolean | Whether attribute exists |
</defining_classes>

<html_syntax>
## HTML Syntax

```html
<div data-controller="tabs"
     data-tabs-active-class="bg-blue-500 text-white"
     data-tabs-loading-class="opacity-50 pointer-events-none">
  <button data-tabs-target="tab">Tab 1</button>
  <button data-tabs-target="tab">Tab 2</button>
</div>
```

Pattern: `data-{controller}-{className}-class="{CSS classes}"`
</html_syntax>

<using_classes>
## Using Classes

```javascript
export default class extends Controller {
  static classes = ["active", "loading"]
  static targets = ["tab"]

  selectTab(event) {
    // Remove active class from all tabs
    this.tabTargets.forEach(tab => {
      tab.classList.remove(this.activeClass)
    })

    // Add active class to clicked tab
    event.currentTarget.classList.add(this.activeClass)
  }

  async load() {
    // Add loading class
    this.element.classList.add(this.loadingClass)

    await this.fetchData()

    // Remove loading class
    this.element.classList.remove(this.loadingClass)
  }
}
```
</using_classes>

<multiple_classes>
## Multiple Classes

A single class attribute can contain multiple CSS classes:

```html
<div data-controller="alert"
     data-alert-success-class="bg-green-100 border-green-500 text-green-700">
</div>
```

```javascript
export default class extends Controller {
  static classes = ["success"]

  showSuccess() {
    // Adds all three classes
    this.element.classList.add(...this.successClasses)
  }

  hideSuccess() {
    // Removes all three classes
    this.element.classList.remove(...this.successClasses)
  }
}
```

**Note:** Use `successClasses` (plural) to get array, `successClass` for space-separated string.
</multiple_classes>

<optional_classes>
## Optional Classes with Defaults

```javascript
export default class extends Controller {
  static classes = ["active"]

  select(event) {
    // Check if class is configured
    if (this.hasActiveClass) {
      event.currentTarget.classList.add(this.activeClass)
    } else {
      // Fallback to default
      event.currentTarget.classList.add("selected")
    }
  }

  // Or with a getter
  get effectiveActiveClass() {
    return this.hasActiveClass ? this.activeClass : "active"
  }
}
```
</optional_classes>

<toggle_pattern>
## Toggle Pattern

```javascript
export default class extends Controller {
  static classes = ["open"]
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle(this.openClass)
  }

  get isOpen() {
    return this.contentTarget.classList.contains(this.openClass)
  }

  open() {
    if (!this.isOpen) {
      this.contentTarget.classList.add(this.openClass)
    }
  }

  close() {
    if (this.isOpen) {
      this.contentTarget.classList.remove(this.openClass)
    }
  }
}
```

```html
<div data-controller="dropdown"
     data-dropdown-open-class="block"
     data-dropdown-closed-class="hidden">
  <button data-action="dropdown#toggle">Menu</button>
  <div data-dropdown-target="content" class="hidden">
    Menu content
  </div>
</div>
```
</toggle_pattern>

<classes_vs_hardcoded>
## Classes API vs Hardcoded

**Use Classes API when:**
- Styling might vary between instances
- Want to allow customization from HTML
- Class names depend on CSS framework

**Use hardcoded classes when:**
- Classes are fixed and internal
- No customization needed
- Classes are structural, not stylistic

```javascript
export default class extends Controller {
  // Customizable via Classes API
  static classes = ["active", "loading"]

  select(event) {
    // Structural class - always needed
    event.currentTarget.classList.add("selected")

    // Stylistic class - customizable
    event.currentTarget.classList.add(this.activeClass)
  }
}
```
</classes_vs_hardcoded>

<with_tailwind>
## With TailwindCSS

```html
<div data-controller="alert"
     data-alert-success-class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4"
     data-alert-error-class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4"
     data-alert-warning-class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4">
  <div data-alert-target="message"></div>
</div>
```

```javascript
export default class extends Controller {
  static classes = ["success", "error", "warning"]
  static targets = ["message"]

  show(message, type = "success") {
    // Clear previous classes
    this.clearClasses()

    // Add appropriate class
    const classProperty = `${type}Classes`
    if (this[classProperty]) {
      this.element.classList.add(...this[classProperty])
    }

    this.messageTarget.textContent = message
  }

  clearClasses() {
    ["success", "error", "warning"].forEach(type => {
      const classProperty = `${type}Classes`
      if (this[`has${type.charAt(0).toUpperCase() + type.slice(1)}Class`]) {
        this.element.classList.remove(...this[classProperty])
      }
    })
  }
}
```
</with_tailwind>

<common_class_names>
## Common Class Patterns

```javascript
// Visibility
static classes = ["hidden", "visible"]

// State
static classes = ["active", "disabled", "loading", "error", "success"]

// Animation
static classes = ["entering", "leaving", "entered", "left"]

// Position
static classes = ["open", "closed", "expanded", "collapsed"]
```
</common_class_names>

<anti_patterns>
## Anti-Patterns

**Don't hardcode classes that should be configurable:**
```javascript
// Bad - can't customize
element.classList.add("bg-blue-500")

// Good - configurable
element.classList.add(this.activeClass)
```

**Don't forget to handle missing classes:**
```javascript
// Bad - throws if class not configured
element.classList.add(this.activeClass)

// Good
if (this.hasActiveClass) {
  element.classList.add(this.activeClass)
}
```
</anti_patterns>
