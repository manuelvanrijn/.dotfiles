<overview>
Actions connect DOM events to controller methods. They define how user interactions trigger behavior.
</overview>

<basic_syntax>
## Basic Syntax

```html
<button data-action="click->clipboard#copy">Copy</button>
```

Pattern: `{event}->{controller}#{method}`

Components:
- `click` - The DOM event type
- `clipboard` - The controller identifier
- `copy` - The method to call
</basic_syntax>

<default_events>
## Default Events

Some elements have default events:

| Element | Default Event |
|---------|---------------|
| `<button>` | click |
| `<input type="submit">` | click |
| `<form>` | submit |
| `<input>` | input |
| `<textarea>` | input |
| `<select>` | change |
| `<a>` | click |
| `<details>` | toggle |

```html
<!-- These are equivalent -->
<form data-action="submit->search#perform">
<form data-action="search#perform">

<button data-action="click->dialog#close">
<button data-action="dialog#close">

<input data-action="input->search#filter">
<input data-action="search#filter">
```
</default_events>

<event_object>
## Event Object

Actions receive the event as the first parameter:

```javascript
export default class extends Controller {
  copy(event) {
    event.preventDefault()
    event.stopPropagation()

    console.log(event.type)           // "click"
    console.log(event.target)         // Element that triggered event
    console.log(event.currentTarget)  // Element with data-action
  }
}
```
</event_object>

<action_parameters>
## Action Parameters

Pass data from HTML to actions:

```html
<button data-action="items#delete"
        data-items-id-param="123"
        data-items-name-param="Widget">
  Delete Widget
</button>
```

```javascript
export default class extends Controller {
  delete({ params }) {
    console.log(params.id)    // "123" (string)
    console.log(params.name)  // "Widget"

    if (confirm(`Delete ${params.name}?`)) {
      this.removeItem(params.id)
    }
  }

  // Or destructure
  delete({ params: { id, name } }) {
    console.log(id, name)
  }
}
```

**Note:** Params are always strings. Cast if needed:
```javascript
const id = parseInt(params.id, 10)
```
</action_parameters>

<multiple_actions>
## Multiple Actions

Multiple actions on one element:

```html
<input data-action="input->search#filter focus->search#expand blur->search#collapse">
```

Multiple controllers:

```html
<button data-action="click->clipboard#copy click->tooltip#hide">
  Copy
</button>
```
</multiple_actions>

<event_modifiers>
## Event Modifiers

### Stop Propagation
```html
<button data-action="click->menu#toggle:stop">
```
Equivalent to `event.stopPropagation()`

### Prevent Default
```html
<a data-action="click->modal#open:prevent" href="/fallback">
```
Equivalent to `event.preventDefault()`

### Combine Modifiers
```html
<form data-action="submit->form#save:prevent:stop">
```

### Self (only direct clicks)
```html
<div data-action="click->modal#close:self">
  <!-- Only closes if clicking this div, not children -->
</div>
```
</event_modifiers>

<keyboard_events>
## Keyboard Events

Filter by key:

```html
<!-- Specific keys -->
<input data-action="keydown.enter->search#submit">
<div data-action="keydown.esc->modal#close">
<input data-action="keydown.space->player#toggle">

<!-- Arrow keys -->
<div data-action="keydown.up->menu#previous keydown.down->menu#next">

<!-- With modifiers -->
<input data-action="keydown.ctrl+s->document#save">
<input data-action="keydown.meta+enter->form#submit">
```

Available key filters:
- Letters: `a` through `z`
- Numbers: `0` through `9`
- Special: `enter`, `tab`, `esc`, `space`, `up`, `down`, `left`, `right`, `home`, `end`
- Modifiers: `ctrl`, `alt`, `shift`, `meta` (combine with `+`)
</keyboard_events>

<global_events>
## Global Events

Listen to window/document events:

```html
<!-- Window events -->
<div data-controller="scroll"
     data-action="scroll@window->scroll#update resize@window->scroll#recalculate">
</div>

<!-- Document events -->
<div data-controller="shortcuts"
     data-action="keydown@document->shortcuts#handle">
</div>
```

Pattern: `{event}@{target}->{controller}#{method}`

Targets: `window`, `document`
</global_events>

<turbo_events>
## Turbo Events

Listen to Turbo lifecycle:

```html
<div data-controller="analytics"
     data-action="turbo:load@document->analytics#trackPage
                  turbo:before-render@document->analytics#beforeRender">
</div>
```

Common Turbo events:
- `turbo:load` - Page fully loaded
- `turbo:before-visit` - Before navigation
- `turbo:frame-load` - Frame loaded
- `turbo:submit-start` - Form submission started
- `turbo:submit-end` - Form submission ended
</turbo_events>

<custom_events>
## Custom Events

Dispatch and listen to custom events:

```javascript
// Dispatching controller
export default class extends Controller {
  save() {
    // Using Stimulus dispatch helper
    this.dispatch("saved", {
      detail: { id: 123, name: "Widget" }
    })
  }
}
```

```html
<!-- Listening in HTML -->
<div data-controller="list"
     data-action="form:saved->list#refresh">
  <!-- form:saved = {controller}:{eventName} -->
</div>
```

**Event naming:** `{dispatchingController}:{eventName}`
</custom_events>

<once_modifier>
## Once Modifier

Run action only once:

```html
<button data-action="click->onboarding#showTip:once">
  Show tip (only first click)
</button>
```

The action is automatically removed after first invocation.
</once_modifier>

<passive_modifier>
## Passive Modifier

For better scroll/touch performance:

```html
<div data-action="scroll->infinite#loadMore:passive">
```

Tells browser the handler won't call `preventDefault()`, allowing smoother scrolling.
</passive_modifier>

<action_options>
## Action Options Object

Access full options in controller:

```javascript
export default class extends Controller {
  handleClick(event) {
    // Standard event properties
    console.log(event.type)
    console.log(event.target)

    // Action params
    console.log(event.params)  // Same as destructured params
  }
}
```
</action_options>

<common_patterns>
## Common Action Patterns

**Form submission:**
```html
<form data-action="submit->form#save:prevent">
```

**Debounced search:**
```html
<input data-action="input->search#filter">
```

**Click outside to close:**
```html
<div data-controller="dropdown"
     data-action="click@window->dropdown#closeIfOutside">
```

**Keyboard shortcuts:**
```html
<body data-controller="shortcuts"
      data-action="keydown.ctrl+k@document->shortcuts#openSearch
                   keydown.esc@document->shortcuts#closeAll">
```

**Prevent navigation:**
```html
<a href="/old-page" data-action="click->router#navigate:prevent">
```
</common_patterns>

<anti_patterns>
## Anti-Patterns

**Don't add listeners manually when actions work:**
```javascript
// Bad
connect() {
  this.buttonTarget.addEventListener("click", this.handleClick)
}

// Good - use data-action in HTML
<button data-action="example#handleClick">
```

**Don't forget to prevent default for links:**
```html
<!-- Bad - navigates AND runs action -->
<a href="/page" data-action="modal#open">

<!-- Good -->
<a href="/page" data-action="modal#open:prevent">
```

**Don't use inline handlers:**
```html
<!-- Bad -->
<button onclick="handleClick()">

<!-- Good -->
<button data-action="controller#handleClick">
```
</anti_patterns>
