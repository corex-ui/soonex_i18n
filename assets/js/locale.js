import { parseList, whenControlReady, firstDetailValue } from "./controls-shared.js"

;(() => {
  const html = () => document.documentElement

  const validLocales = () => parseList("data-locales")

  const rtlLocales = () => new Set(parseList("data-rtl-locales"))

  const directionForLocale = (loc) =>
    loc && rtlLocales().has(loc) ? "rtl" : "ltr"

  const resolvedLocale = () => {
    const pathLoc = localeFromPathname()
    if (pathLoc) return pathLoc
    const docLoc = html().getAttribute("data-locale")
    if (docLoc && validLocales().includes(docLoc)) return docLoc
    const stored = localStorage.getItem("data-locale")
    if (stored && validLocales().includes(stored)) return stored
    return ""
  }

  const syncDocumentLocale = () => {
    const loc = resolvedLocale()
    if (!loc || !validLocales().includes(loc)) return
    html().setAttribute("lang", loc)
    html().setAttribute("data-locale", loc)
    html().setAttribute("dir", directionForLocale(loc))
  }

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

  const publicPathPrefix = () => {
    const raw = html().getAttribute("data-public-path-prefix") || ""
    return raw.replace(/\/+$/, "")
  }

  const localeFromPathname = () => {
    let pathname = window.location.pathname
    const pre = publicPathPrefix()
    if (pre && pathname.startsWith(pre)) {
      pathname = pathname.slice(pre.length) || "/"
    }
    const segs = pathname.split("/").filter(Boolean)
    const first = segs[0] || ""
    return validLocales().includes(first) ? first : ""
  }

  const syncLangFromDocument = () => {
    const path = html().getAttribute("data-locale-selected-path")
    syncLangSelect(path)
  }

  const pathLocale = localeFromPathname()
  if (pathLocale) setLocale(pathLocale)

  syncDocumentLocale()

  whenControlReady("corex-language-switch", () => {
    syncDocumentLocale()
    syncLangFromDocument()
  })

  window.addEventListener("storage", (e) => {
    if (e.key === "data-locale" && e.newValue) {
      setLocale(e.newValue)
      syncDocumentLocale()
    }
  })

  window.addEventListener("corex:set-locale", (e) => {
    const raw = firstDetailValue(e)
    const s = raw != null ? String(raw) : ""
    const seg = s.replace(/^\/+|\/+$/g, "").split("/")[0] || ""
    const allowed = validLocales()
    if (allowed.includes(seg)) {
      setLocale(seg)
      html().setAttribute("lang", seg)
      html().setAttribute("data-locale", seg)
      html().setAttribute("dir", directionForLocale(seg))
    }
  })

  window.addEventListener("pageshow", () => {
    syncDocumentLocale()
    syncLangFromDocument()
  })
})()
