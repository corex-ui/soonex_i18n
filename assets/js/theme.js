import { parseList, whenControlReady, firstDetailValue } from "./controls-shared.js"

;(() => {
  const html = () => document.documentElement

  const validThemes = () => parseList("data-themes")
  const defaultTheme = () =>
    html().getAttribute("data-default-theme") || validThemes()[0] || "neo"

  const readStoredTheme = () => localStorage.getItem("data-theme")

  const syncThemeSelect = (value) => {
    const root = document.getElementById("theme-switcher")
    if (!root || !value) return
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [value] } }),
    )
  }

  const applyTheme = (theme) => {
    const themes = validThemes()
    const dt = defaultTheme()
    const resolved = themes.includes(theme) ? theme : dt
    localStorage.setItem("data-theme", resolved)
    html().setAttribute("data-theme", resolved)
    return resolved
  }

  const syncThemeFromDocument = () => {
    const t = html().getAttribute("data-theme") || defaultTheme()
    const themes = validThemes()
    const dt = defaultTheme()
    syncThemeSelect(themes.includes(t) ? t : dt)
  }

  applyTheme(
    readStoredTheme() || html().getAttribute("data-theme") || defaultTheme(),
  )

  whenControlReady("theme-switcher", syncThemeFromDocument)

  window.addEventListener("storage", (e) => {
    if (e.key === "data-theme" && e.newValue) {
      applyTheme(e.newValue)
      whenControlReady("theme-switcher", syncThemeFromDocument)
    }
  })

  window.addEventListener("corex:set-theme", (e) => {
    const v = firstDetailValue(e)
    applyTheme(v || defaultTheme())
    whenControlReady("theme-switcher", syncThemeFromDocument)
  })
})()
