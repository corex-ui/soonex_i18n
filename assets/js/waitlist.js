function dispatchLayoutToast(detail) {
  const root = document.getElementById("layout-toast")
  if (!(root instanceof HTMLElement)) return
  root.dispatchEvent(
    new CustomEvent("toast:create", { bubbles: true, detail }),
  )
}

export function initWaitlistForm() {
  const form = document.querySelector("form[data-waitlist-toast-title]")
  if (!(form instanceof HTMLFormElement)) return

  form.addEventListener("submit", (event) => {
    event.preventDefault()
    if (!form.reportValidity()) return
    const title = form.dataset.waitlistToastTitle
    const description = form.dataset.waitlistToastDescription
    if (!title || !description) return
    dispatchLayoutToast({
      title,
      description,
      type: "success",
      duration: "6000",
    })
  })
}
