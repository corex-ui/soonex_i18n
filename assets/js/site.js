import "./mode.js"
import "./theme.js"
import "./locale.js"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import { FloatingPanel } from "corex/floating-panel"
import { Toast } from "corex/toast"
import { Select } from "corex/select"
import { Toggle } from "corex/toggle"
import { Dialog } from "corex/dialog"
import { ToggleGroup } from "corex/toggle-group"
import { Menu } from "corex/menu"
import { Clipboard } from "corex/clipboard"
import { Marquee } from "corex/marquee"
import { initWaitlistForm } from "./waitlist.js"
import { initPager } from "./pager.js"
import "./cookie-consent.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    FloatingPanel,
    Toast,
    Select,
    Toggle,
    Dialog,
    ToggleGroup,
    Menu,
    Clipboard,
    Marquee,
    ...hooks({
      Tabs: () => import("corex/tabs"),
      Timer: () => import("corex/timer"),
      Accordion: () => import("corex/accordion"),
      Checkbox: () => import("corex/checkbox"),
      Pagination: () => import("corex/pagination"),
      Tooltip: () => import("corex/tooltip"),
      Collapsible: () => import("corex/collapsible"),
      Switch: () => import("corex/switch"),
      RadioGroup: () => import("corex/radio-group"),
      TagsInput: () => import("corex/tags-input"),
      NumberInput: () => import("corex/number-input"),
      DatePicker: () => import("corex/date-picker"),
    }),
  },
})

liveSocket.disableDebug()
liveSocket.connect()

initWaitlistForm()
initPager()
