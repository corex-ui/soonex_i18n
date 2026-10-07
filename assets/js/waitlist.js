function dispatchLayoutToast(detail) {
  const root = document.getElementById("layout-toast")
  if (!(root instanceof HTMLElement)) return
  root.dispatchEvent(
    new CustomEvent("corex:toast:create", {
      bubbles: true,
      detail: { group_id: "layout-toast", ...detail },
    }),
  )
}

export function initWaitlistForm() {
  const forms = document.querySelectorAll("form[data-waitlist-toast-title]")

  forms.forEach((form) => {
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
        duration: 6000,
      })
    })
  })
}
