import { animate, inView, stagger } from "motion"

export function runLandingReveal(root, easeOut) {
  const stops = []
  const reveals = root.querySelectorAll("[data-reveal]")
  reveals.forEach((section) => {
    if (!(section instanceof HTMLElement)) return
    const stop = inView(
      section,
      () => {
        const children = section.querySelectorAll("[data-stagger] > *")
        const targets = children.length ? children : [section]
        animate(
          targets,
          { opacity: [0, 1], y: [20, 0] },
          {
            duration: 0.6,
            delay: children.length ? stagger(0.07) : 0,
            ease: easeOut,
          },
        )
      },
      { margin: "-10% 0px -10% 0px", amount: 0.15 },
    )
    stops.push(stop)
  })
  return stops
}
