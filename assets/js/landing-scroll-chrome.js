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
  const stickyOk =
    stickyBar instanceof HTMLElement && heroBoundary instanceof HTMLElement
  const progressOk = progressFill instanceof HTMLElement

  if (!stickyOk && !progressOk) {
    return () => {}
  }

  if (stickyOk) {
    stickyBar.style.transition =
      "opacity 0.25s ease-out, transform 0.25s ease-out"
  }

  let alive = true
  let rafId = null

  const tick = () => {
    if (!alive) {
      return
    }
    if (stickyOk) {
      const r = heroBoundary.getBoundingClientRect()
      const pastHero = heroBoundary.hasAttribute("data-hero-sentinel")
        ? r.top <= stickyRevealPx
        : r.bottom <= stickyRevealPx
      stickyBar.style.opacity = pastHero ? "1" : "0"
      stickyBar.style.transform = pastHero
        ? "translate3d(0, 0, 0)"
        : "translate3d(0, -100%, 0)"
      stickyBar.style.pointerEvents = pastHero ? "auto" : "none"
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
