import { whenControlReady, firstDetailValue } from "./controls-shared.js"

;(() => {
  const html = () => document.documentElement

  const readStoredMode = () => localStorage.getItem("data-mode")

  const getSystemMode = () =>
    window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"

  const syncModeToggle = (mode) => {
    const root = document.getElementById("mode-switcher")
    if (!root) return
    const value = mode === "dark" ? ["dark"] : []
    root.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", { detail: { value } }),
    )
  }

  const applyMode = (mode) => {
    const resolved =
      mode === "dark" || mode === "light" ? mode : getSystemMode()
    localStorage.setItem("data-mode", resolved)
    html().setAttribute("data-mode", resolved)
    return resolved
  }

  const syncModeFromDocument = () => {
    const m = html().getAttribute("data-mode") || getSystemMode()
    syncModeToggle(m === "dark" || m === "light" ? m : getSystemMode())
  }

  applyMode(
    readStoredMode() || html().getAttribute("data-mode") || getSystemMode(),
  )

  whenControlReady("mode-switcher", syncModeFromDocument)

  window.addEventListener("storage", (e) => {
    if (e.key === "data-mode" && e.newValue) {
      applyMode(e.newValue)
      whenControlReady("mode-switcher", syncModeFromDocument)
    }
  })

  window.addEventListener("corex:set-mode", (e) => {
    const raw = e.detail?.value
    const isDark = Array.isArray(raw) && raw.includes("dark")
    applyMode(isDark ? "dark" : "light")
    whenControlReady("mode-switcher", syncModeFromDocument)
  })
})()
