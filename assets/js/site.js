import "./theme.js"
import "./mode.js"
import "./locale.js"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import { FloatingPanel } from "corex/floating-panel"
import { Toast } from "corex/toast"
import { Select } from "corex/select"
import { Toggle } from "corex/toggle"
import { initLenis } from "./lenis.js"
import { initLanding } from "./landing.js"
import { initWaitlistForm } from "./waitlist.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

// Eager chrome (every page) — Template Options + language switch are instant.
// Lazy page hooks — Timer, Marquee, Accordion, etc. only when present.
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    FloatingPanel,
    Toast,
    Select,
    Toggle,
    ...hooks({
      Tabs: () => import("corex/tabs"),
      Timer: () => import("corex/timer"),
      Marquee: () => import("corex/marquee"),
      Accordion: () => import("corex/accordion"),
      Checkbox: () => import("corex/checkbox"),
      Avatar: () => import("corex/avatar"),
      Clipboard: () => import("corex/clipboard"),
      Switch: () => import("corex/switch"),
    }),
  },
})

liveSocket.disableDebug()
initLenis()
liveSocket.connect()

if (document.querySelector("[data-landing]")) {
  initLanding()
}

initWaitlistForm()
