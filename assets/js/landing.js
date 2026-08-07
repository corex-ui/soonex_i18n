import { bindLandingScrollChrome } from "./landing-scroll-chrome.js"
import { runLandingParallax } from "./landing-parallax.js"

export function initLanding() {
  const root = document.querySelector("[data-landing]")
  if (!(root instanceof HTMLElement)) {
    return () => {}
  }

  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)")
    .matches
  const stickyBar = document.querySelector("[data-sticky-bar]")
  const heroBoundary =
    root.querySelector("[data-hero-sentinel]") ||
    root.querySelector("[data-hero-boundary]") ||
    root.querySelector("[data-hero]")
  const progressFill = document.querySelector("[data-scroll-progress-fill]")

  const stops = []

  stops.push(bindLandingScrollChrome(stickyBar, heroBoundary, progressFill))
  stops.push(...runLandingParallax(root, reducedMotion))

  function teardown() {
    stops.forEach((fn) => {
      if (typeof fn === "function") fn()
    })
  }

  window.addEventListener("pagehide", teardown, { once: true })

  return teardown
}
