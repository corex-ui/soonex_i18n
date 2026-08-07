const stickyRevealPx = 96

export function scrollProgress01() {
  const lenis = globalThis.__landingLenis
  if (lenis && typeof lenis.progress === "number") {
    return Math.min(1, Math.max(0, lenis.progress))
  }
  const doc = document.documentElement
  const maxScroll = Math.max(1, doc.scrollHeight - window.innerHeight)
  return Math.min(1, Math.max(0, window.scrollY / maxScroll))
}

export function bindLandingScrollChrome(stickyBar, heroBoundary, progressFill) {
  const stickyEl = stickyBar instanceof HTMLElement ? stickyBar : null
  const boundaryEl = heroBoundary instanceof HTMLElement ? heroBoundary : null
  const progressOk = progressFill instanceof HTMLElement

  if (!stickyEl && !progressOk) {
    return () => {}
  }

  if (stickyEl) {
    stickyEl.style.transition =
      "opacity 0.25s ease-out, transform 0.25s ease-out"
  }

  let alive = true
  let rafId = null

  const pastReveal = () => {
    if (boundaryEl) {
      const r = boundaryEl.getBoundingClientRect()
      return boundaryEl.hasAttribute("data-hero-sentinel")
        ? r.top <= stickyRevealPx
        : r.bottom <= stickyRevealPx
    }
    return window.scrollY > stickyRevealPx
  }

  const tick = () => {
    if (!alive) {
      return
    }
    if (stickyEl) {
      const show = pastReveal()
      stickyEl.style.opacity = show ? "1" : "0"
      stickyEl.style.transform = show
        ? "translate3d(0, 0, 0)"
        : "translate3d(0, -100%, 0)"
      stickyEl.style.pointerEvents = show ? "auto" : "none"
    }
    if (progressOk) {
      const p = scrollProgress01()
      progressFill.style.transform = `scaleX(${p})`
      progressFill.style.transformOrigin = "left center"
    }
    rafId = requestAnimationFrame(tick)
  }

  rafId = requestAnimationFrame(tick)

  return () => {
    alive = false
    if (rafId != null) {
      cancelAnimationFrame(rafId)
    }
  }
}
