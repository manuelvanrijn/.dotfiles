# Workflow: Handle Forms

<required_reading>
**Read these reference files NOW:**
1. references/actions.md
2. references/values.md
3. references/turbo-integration.md
</required_reading>

<process>
## Step 1: Identify Form Pattern

| Pattern | Use Case |
|---------|----------|
| Auto-submit | Submit on input change |
| Validation | Client-side validation |
| Character count | Live count with limit |
| Dependent fields | Show/hide based on selection |
| Dynamic fields | Add/remove form fields |
| File upload | Preview, progress |
| Auto-save | Save drafts automatically |

---

## Auto-Submit Pattern

```javascript
// controllers/auto_submit_controller.js
import { Controller } from "@hotwired/stimulus"
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

```html
<form data-controller="auto-submit"
      data-action="input->auto-submit#submit"
      data-turbo-frame="results">
  <input type="search" name="q" placeholder="Search...">
</form>

<turbo-frame id="results">
  <!-- Results -->
</turbo-frame>
```

---

## Client-Side Validation Pattern

```javascript
// controllers/validation_controller.js
export default class extends Controller {
  static targets = ["input", "error", "submit"]

  validate(event) {
    const input = event.target
    const error = this.errorTargets.find(e =>
      e.dataset.validationFor === input.name
    )

    const message = this.validateInput(input)

    if (message) {
      input.classList.add("border-red-500")
      error.textContent = message
      error.classList.remove("hidden")
    } else {
      input.classList.remove("border-red-500")
      error.classList.add("hidden")
    }

    this.updateSubmitButton()
  }

  validateInput(input) {
    if (input.validity.valueMissing) {
      return "This field is required"
    }
    if (input.validity.typeMismatch) {
      return `Please enter a valid ${input.type}`
    }
    if (input.validity.tooShort) {
      return `Minimum ${input.minLength} characters required`
    }
    if (input.validity.patternMismatch) {
      return input.dataset.patternMessage || "Invalid format"
    }
    return null
  }

  updateSubmitButton() {
    const isValid = this.inputTargets.every(input => input.checkValidity())
    this.submitTarget.disabled = !isValid
  }

  submit(event) {
    let valid = true
    this.inputTargets.forEach(input => {
      if (!input.checkValidity()) {
        valid = false
        this.validate({ target: input })
      }
    })

    if (!valid) {
      event.preventDefault()
    }
  }
}
```

```html
<form data-controller="validation"
      data-action="submit->validation#submit">
  <div>
    <input data-validation-target="input"
           data-action="blur->validation#validate"
           name="email"
           type="email"
           required>
    <p data-validation-target="error"
       data-validation-for="email"
       class="hidden text-red-500 text-sm"></p>
  </div>

  <div>
    <input data-validation-target="input"
           data-action="blur->validation#validate"
           name="password"
           type="password"
           required
           minlength="8"
           pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
           data-pattern-message="Must contain uppercase, lowercase, and number">
    <p data-validation-target="error"
       data-validation-for="password"
       class="hidden text-red-500 text-sm"></p>
  </div>

  <button data-validation-target="submit" type="submit" disabled>
    Submit
  </button>
</form>
```

---

## Character Count Pattern

```javascript
// controllers/character_count_controller.js
export default class extends Controller {
  static targets = ["input", "count"]
  static values = { max: Number }

  connect() {
    this.update()
  }

  update() {
    const length = this.inputTarget.value.length
    const remaining = this.maxValue - length

    this.countTarget.textContent = `${length}/${this.maxValue}`

    if (remaining < 0) {
      this.countTarget.classList.add("text-red-500")
      this.inputTarget.classList.add("border-red-500")
    } else if (remaining < 20) {
      this.countTarget.classList.remove("text-red-500")
      this.countTarget.classList.add("text-yellow-500")
      this.inputTarget.classList.remove("border-red-500")
    } else {
      this.countTarget.classList.remove("text-red-500", "text-yellow-500")
      this.inputTarget.classList.remove("border-red-500")
    }
  }
}
```

```html
<div data-controller="character-count" data-character-count-max-value="280">
  <textarea data-character-count-target="input"
            data-action="input->character-count#update"
            maxlength="280"></textarea>
  <span data-character-count-target="count" class="text-gray-500 text-sm"></span>
</div>
```

---

## Dependent Fields Pattern

```javascript
// controllers/dependent_fields_controller.js
export default class extends Controller {
  static targets = ["select", "dependentGroup"]
  static values = { map: Object }

  connect() {
    this.toggle()
  }

  toggle() {
    const selected = this.selectTarget.value

    this.dependentGroupTargets.forEach(group => {
      const showFor = group.dataset.showFor?.split(",") || []
      group.hidden = !showFor.includes(selected)

      // Disable hidden inputs so they don't submit
      group.querySelectorAll("input, select, textarea").forEach(input => {
        input.disabled = group.hidden
      })
    })
  }
}
```

```html
<form data-controller="dependent-fields">
  <select data-dependent-fields-target="select"
          data-action="change->dependent-fields#toggle"
          name="delivery_method">
    <option value="pickup">Pickup</option>
    <option value="delivery">Delivery</option>
    <option value="shipping">Shipping</option>
  </select>

  <div data-dependent-fields-target="dependentGroup"
       data-show-for="delivery,shipping"
       hidden>
    <input name="address" placeholder="Address">
    <input name="city" placeholder="City">
  </div>

  <div data-dependent-fields-target="dependentGroup"
       data-show-for="shipping"
       hidden>
    <input name="tracking_email" placeholder="Email for tracking">
  </div>
</form>
```

---

## Dynamic Fields Pattern (Add/Remove)

```javascript
// controllers/dynamic_fields_controller.js
export default class extends Controller {
  static targets = ["template", "container", "item"]
  static values = { index: Number }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      this.indexValue
    )
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.indexValue++
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest("[data-dynamic-fields-target='item']")

    // For nested attributes, mark for destruction
    const destroyInput = item.querySelector("input[name*='_destroy']")
    if (destroyInput) {
      destroyInput.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }
}
```

```html
<div data-controller="dynamic-fields" data-dynamic-fields-index-value="0">
  <template data-dynamic-fields-target="template">
    <div data-dynamic-fields-target="item" class="flex gap-2">
      <input name="items[NEW_RECORD][name]" placeholder="Item name">
      <input name="items[NEW_RECORD][quantity]" type="number" placeholder="Qty">
      <button data-action="dynamic-fields#remove" type="button">&times;</button>
    </div>
  </template>

  <div data-dynamic-fields-target="container">
    <!-- Items appear here -->
  </div>

  <button data-action="dynamic-fields#add" type="button">
    Add Item
  </button>
</div>
```

---

## Auto-Save Pattern

```javascript
// controllers/auto_save_controller.js
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static targets = ["status"]
  static values = { url: String }
  static debounces = ["save"]

  connect() {
    useDebounce(this, { wait: 1000 })
  }

  save() {
    this.statusTarget.textContent = "Saving..."

    const formData = new FormData(this.element)

    fetch(this.urlValue, {
      method: "PATCH",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => {
      if (response.ok) {
        this.statusTarget.textContent = "Saved"
        setTimeout(() => this.statusTarget.textContent = "", 2000)
      } else {
        this.statusTarget.textContent = "Save failed"
      }
    })
    .catch(() => {
      this.statusTarget.textContent = "Save failed"
    })
  }
}
```

```html
<form data-controller="auto-save"
      data-auto-save-url-value="/drafts/123"
      data-action="input->auto-save#save">
  <textarea name="content"></textarea>
  <span data-auto-save-target="status" class="text-gray-500 text-sm"></span>
</form>
```
</process>

<success_criteria>
Form handling complete when:
- Form submits correctly (with or without Turbo)
- Validation provides clear feedback
- Dynamic fields work with Rails nested attributes
- Auto-save doesn't flood server
- Dependent fields disable when hidden
- Accessible (proper labels, error announcements)
</success_criteria>
