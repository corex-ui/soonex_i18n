import "./theme.js"
import "./mode.js"
import "./locale.js"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import { initLenis } from "./lenis.js"
import { initLanding } from "./landing.js"
import { initPricing } from "./pricing.js"
import { initWaitlistForm } from "./waitlist.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Select: () => import("corex/select"),
      Toggle: () => import("corex/toggle"),
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

initLenis()
liveSocket.connect()

if (document.querySelector("[data-landing]")) {
  initLanding()
}

initPricing()
initWaitlistForm()
