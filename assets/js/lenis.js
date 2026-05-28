import Lenis from "lenis"

const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)").matches

export function initLenis() {
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
