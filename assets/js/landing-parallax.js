import { scroll } from "motion"

export function runLandingParallax(root, reducedMotion) {
  const stops = []
  if (reducedMotion) return stops

  const parallax = root.querySelectorAll("[data-parallax]")
  parallax.forEach((el) => {
    if (!(el instanceof HTMLElement)) return
    const stop = scroll((_p, _info) => {
      const r = el.getBoundingClientRect()
      const mid = r.top + r.height * 0.5
      const offset = (window.innerHeight * 0.5 - mid) * 0.05
      el.style.transform = `translate3d(0, ${offset.toFixed(2)}px, 0)`
    })
    stops.push(stop)
  })
  return stops
}
