const YEARLY_DISCOUNT = 0.8

function formatUsdWhole(amount) {
  return `$${Math.round(amount)}`
}

function applyTierPricing(section, yearly) {
  const suffixMonthly = section.dataset.pricingSuffixMonthly || "/mo"
  const suffixYearly = section.dataset.pricingSuffixYearly || "/yr"
  section.querySelectorAll("[data-pricing-tier]").forEach((tierEl) => {
    const kind = tierEl.getAttribute("data-pricing-tier")
    const priceEl = tierEl.querySelector("[data-pricing-price]")
    const periodEl = tierEl.querySelector("[data-pricing-period]")
    const studioFromEl = tierEl.querySelector("[data-pricing-studio-from]")

    if (kind === "free") return

    if (kind === "pro" && priceEl && periodEl) {
      const monthly = Number(tierEl.getAttribute("data-monthly-usd") || "0")
      if (yearly) {
        const yearlyTotal = monthly * 12 * YEARLY_DISCOUNT
        priceEl.textContent = formatUsdWhole(yearlyTotal)
        periodEl.textContent = suffixYearly
      } else {
        priceEl.textContent = formatUsdWhole(monthly)
        periodEl.textContent = suffixMonthly
      }
      return
    }

    if (kind === "studio" && studioFromEl) {
      const monthlyFrom = tierEl.getAttribute("data-studio-from-monthly") || ""
      const yearlyFrom = tierEl.getAttribute("data-studio-from-yearly") || ""
      studioFromEl.textContent = yearly ? yearlyFrom : monthlyFrom
    }
  })
}

export function initPricing() {
  const section = document.querySelector("[data-soonex-pricing]")
  const switchRoot = document.getElementById("soonex-pricing-yearly")
  if (!(section instanceof HTMLElement) || !(switchRoot instanceof HTMLElement)) return

  applyTierPricing(section, false)

  switchRoot.addEventListener("soonex-pricing-billing", (event) => {
    const checked =
      event.detail && typeof event.detail.checked === "boolean"
        ? event.detail.checked
        : false
    applyTierPricing(section, checked)
  })
}
