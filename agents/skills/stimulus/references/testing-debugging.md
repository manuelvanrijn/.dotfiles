<overview>
Testing and debugging approaches for Stimulus controllers, from unit tests to integration tests.
</overview>

<debugging_basics>
## Enable Debug Mode

```javascript
// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Enable debug mode
application.debug = true

// Access from console
window.Stimulus = application
```

With debug mode enabled, Stimulus logs:
- Controller connections/disconnections
- Action invocations
- Target connections
</debugging_basics>

<console_debugging>
## Console Debugging

**Access controllers from console:**
```javascript
// Get controller instance
const element = document.querySelector('[data-controller="search"]')
const controller = Stimulus.getControllerForElementAndIdentifier(element, "search")

// Inspect controller
console.log(controller)
console.log(controller.targets)
console.log(controller.element)

// Access properties
console.log(controller.queryValue)
console.log(controller.inputTarget)
console.log(controller.hasResultsTarget)

// Call methods
controller.search()
controller.clear()
```

**Add debugging to controller:**
```javascript
export default class extends Controller {
  connect() {
    console.log(`${this.identifier} connected`, this.element)
    console.log("Targets:", this.constructor.targets)
    console.log("Values:", this.constructor.values)
  }

  search() {
    console.time("search")
    // ... search logic
    console.timeEnd("search")
  }
}
```
</console_debugging>

<stimulus_use_debugging>
## stimulus-use Debug Mode

```javascript
// Enable globally
application.stimulusUseDebug = true

// Or per environment
application.stimulusUseDebug = process.env.NODE_ENV === "development"

// Or per mixin
import { useClickOutside } from "stimulus-use"

connect() {
  useClickOutside(this, { debug: true })
}
```
</stimulus_use_debugging>

<common_debug_issues>
## Common Issues & Debugging

**Controller not connecting:**
```javascript
// Check 1: Is the controller registered?
console.log(Stimulus.router.modulesByIdentifier)

// Check 2: Is the attribute correct?
document.querySelector('[data-controller="search"]') // Should find element

// Check 3: Any JavaScript errors before Stimulus loads?
// Check browser console for errors
```

**Targets not found:**
```javascript
connect() {
  console.log("Has input target:", this.hasInputTarget)
  console.log("Input targets:", this.inputTargets)
  console.log("Scope:", this.scope.element)
}
```

**Actions not firing:**
```javascript
myAction(event) {
  console.log("Action fired!")
  console.log("Event type:", event.type)
  console.log("Event target:", event.target)
  console.log("Current target:", event.currentTarget)
}
```

**Values incorrect:**
```javascript
connect() {
  console.log("URL value:", this.urlValue)
  console.log("Has URL value:", this.hasUrlValue)
  console.log("Data attribute:", this.element.dataset)
}
```
</common_debug_issues>

<unit_testing_jest>
## Unit Testing with Jest

**Note:** Jest requires a Node-based bundler (esbuild, webpack). For Rails apps using importmap, prefer Rails system tests (see below).

**Setup (with npm/yarn bundler):**
```bash
npm install --save-dev jest @testing-library/dom mutationobserver-shim
# or
yarn add --dev jest @testing-library/dom mutationobserver-shim
```

```javascript
// jest.config.js
module.exports = {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/test/javascript/setup.js"]
}
```

```javascript
// test/javascript/setup.js
import "mutationobserver-shim"
```

**Basic test:**
```javascript
// test/javascript/controllers/clipboard_controller.test.js
import { Application } from "@hotwired/stimulus"
import ClipboardController from "../../../app/javascript/controllers/clipboard_controller"

describe("ClipboardController", () => {
  let application

  beforeEach(() => {
    application = Application.start()
    application.register("clipboard", ClipboardController)
  })

  afterEach(() => {
    application.stop()
    document.body.innerHTML = ""
  })

  test("connects to element", async () => {
    document.body.innerHTML = `
      <div data-controller="clipboard">
        <input data-clipboard-target="source" value="test">
      </div>
    `

    // Wait for Stimulus MutationObserver
    await new Promise(r => setTimeout(r, 0))

    const element = document.querySelector('[data-controller="clipboard"]')
    expect(element).toBeTruthy()
  })

  test("copies to clipboard", async () => {
    const writeText = jest.fn().mockResolvedValue(undefined)
    Object.assign(navigator, { clipboard: { writeText } })

    document.body.innerHTML = `
      <div data-controller="clipboard">
        <input data-clipboard-target="source" value="Hello">
        <button data-action="click->clipboard#copy">Copy</button>
      </div>
    `

    await new Promise(r => setTimeout(r, 0))

    document.querySelector("button").click()
    expect(writeText).toHaveBeenCalledWith("Hello")
  })
})
```
</unit_testing_jest>

<testing_helpers>
## Testing Helpers

```javascript
// test/javascript/helpers/stimulus_helper.js
import { Application } from "@hotwired/stimulus"

export async function startStimulus(controllers = {}) {
  const application = Application.start()

  for (const [name, controller] of Object.entries(controllers)) {
    application.register(name, controller)
  }

  // Wait for MutationObserver
  await nextTick()

  return application
}

export async function nextTick() {
  return new Promise(resolve => setTimeout(resolve, 0))
}

export function getController(element, identifier) {
  return window.Stimulus?.getControllerForElementAndIdentifier(element, identifier)
}
```

**Usage:**
```javascript
import { startStimulus, nextTick, getController } from "../helpers/stimulus_helper"
import SearchController from "../../../app/javascript/controllers/search_controller"

test("performs search", async () => {
  const app = await startStimulus({ search: SearchController })

  document.body.innerHTML = `
    <div data-controller="search">
      <input data-search-target="input" value="test">
    </div>
  `

  await nextTick()

  const element = document.querySelector('[data-controller="search"]')
  const controller = getController(element, "search")

  expect(controller.inputTarget.value).toBe("test")

  app.stop()
})
```
</testing_helpers>

<integration_testing_rails>
## Integration Testing with Rails

**System tests (recommended):**
```ruby
# test/system/search_test.rb
require "application_system_test_case"

class SearchTest < ApplicationSystemTestCase
  test "filters results as user types" do
    visit search_path

    fill_in "Search", with: "widget"

    # Wait for debounced search
    sleep 0.5

    assert_selector ".result", count: 3
    assert_text "Widget A"
  end

  test "dropdown closes on click outside" do
    visit page_with_dropdown_path

    click_button "Options"
    assert_selector ".dropdown-menu", visible: true

    # Click outside
    find("body").click

    assert_no_selector ".dropdown-menu", visible: true
  end

  test "modal traps focus" do
    visit modal_demo_path

    click_button "Open Modal"
    assert_selector "[role='dialog']", visible: true

    # Tab should stay within modal
    send_keys :tab
    expect(page.evaluate_script("document.activeElement")).to be_within_modal
  end
end
```

**Precompile assets for tests:**
```bash
# If Stimulus changes aren't reflected in tests
RAILS_ENV=test rails assets:clobber assets:precompile
```
</integration_testing_rails>

<testing_turbo_integration>
## Testing Turbo Integration

```ruby
# test/system/turbo_stimulus_test.rb
require "application_system_test_case"

class TurboStimulusTest < ApplicationSystemTestCase
  test "controller survives Turbo navigation" do
    visit page_one_path

    # Interact with controller
    click_button "Increment"
    assert_text "Count: 1"

    # Navigate with Turbo
    click_link "Page Two"
    click_link "Back to Page One"

    # Controller should work
    click_button "Increment"
    assert_text "Count: 1"  # Reset because state is in HTML
  end

  test "controller connects after Turbo Frame load" do
    visit frame_demo_path

    # Frame loads content with controller
    click_button "Load Content"

    # Wait for frame
    assert_selector "turbo-frame#content [data-controller='loaded']"

    # Controller should be connected
    click_button "Controller Action"
    assert_text "Action worked!"
  end
end
```
</testing_turbo_integration>

<test_patterns>
## Testing Patterns

**Test controller connection:**
```javascript
expect(element.dataset.controller).toContain("search")
```

**Test action was called:**
```javascript
const spy = jest.spyOn(controller, "search")
button.click()
expect(spy).toHaveBeenCalled()
```

**Test DOM was updated:**
```javascript
button.click()
await nextTick()
expect(output.textContent).toBe("Updated!")
```

**Test value changes:**
```javascript
element.dataset.searchCountValue = "5"
await nextTick()
expect(controller.countValue).toBe(5)
```

**Test custom events:**
```javascript
const handler = jest.fn()
element.addEventListener("search:complete", handler)
controller.search()
expect(handler).toHaveBeenCalled()
```

**Test missing targets gracefully:**
```javascript
// Controller should handle missing optional targets
document.body.innerHTML = `
  <div data-controller="search">
    <!-- No targets -->
  </div>
`
await nextTick()
expect(controller.hasInputTarget).toBe(false)
// No error thrown
```
</test_patterns>

<debugging_tools>
## Browser DevTools Tips

**Elements panel:**
- Inspect data attributes
- Verify targets are within scope
- Check for typos in attribute names

**Console:**
- Access `window.Stimulus`
- Call controller methods directly
- Check for errors during load

**Network:**
- Verify Stimulus JS is loaded
- Check import map resolution
- Look for 404s on controller files

**Performance:**
- Profile connect/disconnect calls
- Look for excessive DOM operations
- Check for memory leaks
</debugging_tools>
