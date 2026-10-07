function pageSizeFrom(pager, fallback) {
  const raw =
    pager?.dataset.pageSize || pager?.getAttribute("data-page-size") || fallback
  const size = Number(raw)
  return Number.isFinite(size) && size > 0 ? size : 3
}

function applyPage(items, page, size) {
  const start = (page - 1) * size
  const end = start + size
  items.forEach((el, index) => {
    el.hidden = index < start || index >= end
  })
}

export function initPagination() {
  document.querySelectorAll("[data-soonex-page]").forEach((root) => {
    if (!(root instanceof HTMLElement)) return
    const id = root.dataset.soonexPage
    if (!id) return
    const pager = document.getElementById(id)
    const items = [...root.querySelectorAll("[data-soonex-page-item]")]
    if (items.length === 0) return
    const fallbackSize = root.dataset.soonexPageSize
    const size = pageSizeFrom(pager, fallbackSize)
    applyPage(items, 1, size)

    pager?.addEventListener("pagination-page-changed", (event) => {
      const detail = event.detail || {}
      const page = typeof detail.page === "number" ? detail.page : 1
      const nextSize =
        typeof detail.page_size === "number" ? detail.page_size : size
      applyPage(items, page, nextSize)
    })
  })
}
