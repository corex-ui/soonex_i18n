import {
  bindStoredPreference,
  documentRoot,
  firstDetailValue,
  parseList,
} from "./controls-shared.js"

const themes = () => parseList("data-themes")

const defaultTheme = () =>
  documentRoot().getAttribute("data-default-theme") || themes()[0] || "neo"

const resolveTheme = (raw) => {
  const allowed = themes()
  return raw && allowed.includes(raw) ? raw : defaultTheme()
}

bindStoredPreference({
  attr: "data-theme",
  controlId: "theme-switcher",
  resolve: resolveTheme,
  syncControl: (theme) => {
    const root = document.getElementById("theme-switcher")
    if (!root || !theme) return
    const current = root.getAttribute("data-value") || ""
    if (current.split(",").map((s) => s.trim()).includes(theme)) return
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [theme] } }),
    )
  },
  clientEvent: "corex:set-theme",
  parseClientEvent: (event) => firstDetailValue(event) || defaultTheme(),
})
