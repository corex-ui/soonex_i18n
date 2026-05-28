export function documentRoot() {
  return document.documentElement
}

export function parseList(attr) {
  const raw = documentRoot().getAttribute(attr) || ""
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

export function firstDetailValue(event) {
  const value = event.detail?.value
  return Array.isArray(value) && value[0] ? value[0] : null
}

export function bindStoredPreference({
  attr,
  controlId,
  resolve,
  syncControl,
  clientEvent,
  parseClientEvent,
}) {
  const read = () =>
    resolve(localStorage.getItem(attr) || documentRoot().getAttribute(attr))

  const commit = (raw) => {
    const value = resolve(raw)
    localStorage.setItem(attr, value)
    documentRoot().setAttribute(attr, value)
    whenControlReady(controlId, () => syncControl(value))
  }

  commit(read())

  window.addEventListener("storage", (event) => {
    if (event.key === attr && event.newValue) commit(event.newValue)
  })

  if (clientEvent && parseClientEvent) {
    window.addEventListener(clientEvent, (event) => {
      commit(parseClientEvent(event))
    })
  }
}
