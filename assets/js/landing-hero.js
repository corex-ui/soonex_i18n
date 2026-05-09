import { animate, stagger } from "motion"

export function runLandingHero(root, reducedMotion, easeOut) {
  if (reducedMotion) {
    root.querySelectorAll("[data-hero-word]").forEach((el) => {
      if (el instanceof HTMLElement) el.style.opacity = "1"
    })
    return
  }

  const heroWords = root.querySelectorAll("[data-hero] [data-hero-word]")
  if (heroWords.length) {
    animate(
      heroWords,
      { opacity: [0, 1], y: [24, 0], filter: ["blur(8px)", "blur(0px)"] },
      { duration: 0.85, delay: stagger(0.06, { start: 0.1 }), ease: easeOut },
    )
  }

  const heroSiblings = root.querySelectorAll(
    "[data-hero] > :not(h1):not(:has([data-hero-word]))",
  )
  if (heroSiblings.length) {
    animate(
      heroSiblings,
      { opacity: [0, 1], y: [16, 0] },
      { duration: 0.7, delay: stagger(0.08, { start: 0.55 }), ease: easeOut },
    )
  }
}
