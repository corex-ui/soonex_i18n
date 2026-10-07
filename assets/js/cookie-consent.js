/** Site cookie consent banner + preferences dialog */

const STORAGE_KEY = "soonex:cookie-consent"
const BANNER_ID = "cookie-consent-banner"
const DIALOG_ID = "cookie-consent-dialog"
const SWITCHES = {
  analytics: "cookie-consent-analytics",
  marketing: "cookie-consent-marketing",
}

function readConsent() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return null
    const parsed = JSON.parse(raw)
    if (!parsed || typeof parsed !== "object") return null
    return {
      necessary: true,
      analytics: Boolean(parsed.analytics),
      marketing: Boolean(parsed.marketing),
      version: parsed.version || 1,
    }
  } catch (_e) {
    return null
  }
}

function writeConsent(consent) {
  const next = {
    necessary: true,
    analytics: Boolean(consent.analytics),
    marketing: Boolean(consent.marketing),
    version: 1,
    updatedAt: new Date().toISOString(),
  }
  localStorage.setItem(STORAGE_KEY, JSON.stringify(next))
  document.documentElement.dataset.cookieConsent = "set"
  document.documentElement.dataset.cookieAnalytics = next.analytics ? "1" : "0"
  document.documentElement.dataset.cookieMarketing = next.marketing ? "1" : "0"
  return next
}

function setSwitch(id, checked) {
  const el = document.getElementById(id)
  if (!el) return
  el.dispatchEvent(
    new CustomEvent("corex:switch:set-checked", {
      bubbles: false,
      detail: {checked},
    })
  )
}

function isSwitchChecked(id) {
  const el = document.getElementById(id)
  if (!el) return false
  const input = el.querySelector('input[type="checkbox"]')
  if (input) return input.checked
  return Boolean(el.querySelector('[data-state="checked"]'))
}

function syncSwitches(consent) {
  const apply = () => {
    setSwitch(SWITCHES.analytics, Boolean(consent?.analytics))
    setSwitch(SWITCHES.marketing, Boolean(consent?.marketing))
  }
  apply()
  window.setTimeout(apply, 50)
  window.setTimeout(apply, 250)
}

let revealTimer = 0

function showBanner() {
  const banner = document.getElementById(BANNER_ID)
  if (!banner) return
  document.documentElement.dataset.cookieConsent = "pending"
  window.clearTimeout(revealTimer)
  const reveal = () => {
    banner.hidden = false
  }
  // Defer until after first paint so the banner cannot become LCP.
  window.requestAnimationFrame(() => {
    revealTimer = window.setTimeout(reveal, 1200)
  })
}

function hideBanner() {
  const banner = document.getElementById(BANNER_ID)
  if (!banner) return
  window.clearTimeout(revealTimer)
  document.documentElement.dataset.cookieConsent = "set"
  banner.hidden = true
}

function setDialogOpen(open) {
  const dialog = document.getElementById(DIALOG_ID)
  if (!dialog) return
  dialog.dispatchEvent(
    new CustomEvent("corex:dialog:set-open", {
      bubbles: false,
      detail: {id: DIALOG_ID, open: Boolean(open)},
    })
  )
}

function openPreferences() {
  const consent = readConsent() || {analytics: false, marketing: false}
  syncSwitches(consent)
  setDialogOpen(true)
}

function applyChoice(action) {
  let consent
  if (action === "accept") {
    consent = writeConsent({analytics: true, marketing: true})
  } else if (action === "reject") {
    consent = writeConsent({analytics: false, marketing: false})
  } else if (action === "save") {
    consent = writeConsent({
      analytics: isSwitchChecked(SWITCHES.analytics),
      marketing: isSwitchChecked(SWITCHES.marketing),
    })
  } else {
    return
  }

  syncSwitches(consent)
  hideBanner()
  setDialogOpen(false)
}

function initCookieConsent() {
  const banner = document.getElementById(BANNER_ID)
  if (!banner) return

  const existing = readConsent()
  if (existing) {
    writeConsent(existing)
    syncSwitches(existing)
    hideBanner()
  } else {
    syncSwitches({analytics: false, marketing: false})
    showBanner()
  }

  document.addEventListener("click", (event) => {
    const button = event.target.closest("[data-cookie-consent]")
    if (!button) return
    const action = button.getAttribute("data-cookie-consent")
    if (action === "open") {
      event.preventDefault()
      openPreferences()
      return
    }
    if (action === "reset") {
      event.preventDefault()
      syncSwitches({analytics: false, marketing: false})
      return
    }
    applyChoice(action)
  })
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initCookieConsent)
} else {
  initCookieConsent()
}
