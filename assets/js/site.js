import "./theme.js"
import "./mode.js"
import "./locale.js"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import Lenis from "lenis"
import { initLanding } from "./landing.js"
import { initPricing } from "./pricing.js"
import { hooks } from "corex/hooks"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Select: () => import("corex/select"),
      ToggleGroup: () => import("corex/toggle-group"),
      Tabs: () => import("corex/tabs"),
      Timer: () => import("corex/timer"),
      Marquee: () => import("corex/marquee"),
      Accordion: () => import("corex/accordion"),
      Checkbox: () => import("corex/checkbox"),
      Avatar: () => import("corex/avatar"),
      FloatingPanel: () => import("corex/floating-panel"),
      Switch: () => import("corex/switch"),
      Toast: () => import("corex/toast"),
      Clipboard: () => import("corex/clipboard"),
    }),
  },
})

const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches

function initLenis() {
  if (reducedMotion) {
    document.documentElement.classList.remove("lenis")
    globalThis.__landingLenis = undefined
    return
  }

  const lenis = new Lenis({
    duration: 1.1,
    smoothWheel: true,
    easing: (t) => 1 - Math.pow(1 - t, 3),
  })

  globalThis.__landingLenis = lenis

  function raf(time) {
    lenis.raf(time)
    requestAnimationFrame(raf)
  }

  requestAnimationFrame(raf)

  document.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener("click", (event) => {
      const href = link.getAttribute("href")
      if (!href || href === "#") return
      const target = document.querySelector(href)
      if (!target) return
      event.preventDefault()
      lenis.scrollTo(target, { offset: 0 })
    })
  })
}

initLenis()
liveSocket.connect()

if (document.querySelector("[data-landing]")) {
  initLanding()
}

initPricing()

function dispatchLayoutToast(detail) {
  const root = document.getElementById("layout-toast")
  if (!(root instanceof HTMLElement)) return
  root.dispatchEvent(
    new CustomEvent("toast:create", { bubbles: true, detail })
  )
}

function bindWaitlistForm(waitlistForm) {
  if (!(waitlistForm instanceof HTMLFormElement)) return
  waitlistForm.addEventListener("submit", (event) => {
    event.preventDefault()
    if (!waitlistForm.reportValidity()) return
    const title = waitlistForm.dataset.waitlistToastTitle
    const description = waitlistForm.dataset.waitlistToastDescription
    if (!title || !description) return
    dispatchLayoutToast({
      title,
      description,
      type: "success",
      duration: "6000",
    })
  })
}

const waitlistForm = document.querySelector(
  "form[data-waitlist-toast-title]"
)
if (waitlistForm instanceof HTMLFormElement) {
  bindWaitlistForm(waitlistForm)
}
