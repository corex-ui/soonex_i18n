import { parseList, whenControlReady, firstDetailValue } from "./controls-shared.js"

;(() => {
  const html = () => document.documentElement

  const validLocales = () => parseList("data-locales")

  const setLocale = (loc) => {
    const allowed = validLocales()
    if (!loc || !allowed.includes(loc)) return
    localStorage.setItem("data-locale", loc)
  }

  const syncLangSelect = (path) => {
    const root = document.getElementById("corex-language-switch")
    if (!root || !path) return
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [path] } }),
    )
  }

  const localeFromPathname = () => {
    const segs = window.location.pathname.split("/").filter(Boolean)
    const first = segs[0] || ""
    return validLocales().includes(first) ? first : ""
  }

  const syncLangFromDocument = () => {
    const path = html().getAttribute("data-locale-selected-path")
    syncLangSelect(path)
  }

  const pathLocale = localeFromPathname()
  if (pathLocale) setLocale(pathLocale)

  whenControlReady("corex-language-switch", syncLangFromDocument)

  window.addEventListener("storage", (e) => {
    if (e.key === "data-locale" && e.newValue) {
      setLocale(e.newValue)
    }
  })

  window.addEventListener("corex:set-locale", (e) => {
    const raw = firstDetailValue(e)
    const s = raw != null ? String(raw) : ""
    const seg = s.replace(/^\/+|\/+$/g, "").split("/")[0] || ""
    const allowed = validLocales()
    if (allowed.includes(seg)) setLocale(seg)
  })
})()
