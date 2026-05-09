export function parseList(attr) {
  const html = document.documentElement
  const raw = html.getAttribute(attr) || ""
  return raw
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)
}

export function whenControlReady(id, run) {
  const iv = window.setInterval(() => {
    const root = document.getElementById(id)
    if (root && !root.hasAttribute("data-loading")) {
      window.clearInterval(iv)
      run()
    }
  }, 10)
  window.setTimeout(() => window.clearInterval(iv), 10_000)
}

export function firstDetailValue(e) {
  const value = e.detail?.value
  return Array.isArray(value) && value[0] ? value[0] : null
}
