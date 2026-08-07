import { bindStoredPreference } from "./controls-shared.js"

const systemMode = () =>
  matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"

const resolveMode = (raw) =>
  raw === "dark" || raw === "light" ? raw : systemMode()

bindStoredPreference({
  attr: "data-mode",
  controlId: "mode-switcher",
  resolve: resolveMode,
  syncControl: (mode) => {
    const root = document.getElementById("mode-switcher")
    if (!root) return
    const pressed = mode === "dark"
    const button = root.querySelector('[data-scope="toggle"][data-part="root"]')
    if (button && (button.getAttribute("data-state") === "on") === pressed) return
    root.dispatchEvent(
      new CustomEvent("corex:toggle:set-pressed", {
        bubbles: false,
        detail: { pressed },
      }),
    )
  },
  clientEvent: "corex:set-mode",
  parseClientEvent: (event) => {
    const { pressed, value } = event.detail ?? {}
    if (typeof pressed === "boolean") return pressed ? "dark" : "light"
    return Array.isArray(value) && value.includes("dark") ? "dark" : "light"
  },
})
