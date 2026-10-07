export function initPager() {
  const lists = document.querySelectorAll("[data-soonex-page-list]")

  lists.forEach((list) => {
    const pagerId = list.getAttribute("data-soonex-page-list")
    const pageSize = pageSizeOf(list)
    applyPage(list, 1, pageSize)

    if (!pagerId) {
      return
    }

    const pager = document.getElementById(pagerId)
    if (!pager) {
      return
    }

    pager.addEventListener("soonex:page-change", (event) => {
      const page = Number(event.detail?.page) || 1
      const size = Number(event.detail?.page_size) || pageSize
      applyPage(list, page, size)
    })
  })
}

function pageSizeOf(list) {
  const size = Number(list.getAttribute("data-page-size"))
  return Number.isFinite(size) && size > 0 ? size : 3
}

function applyPage(list, page, pageSize) {
  const items = list.querySelectorAll("[data-soonex-page-item]")
  const start = (page - 1) * pageSize
  const end = start + pageSize

  items.forEach((item, index) => {
    item.hidden = index < start || index >= end
  })
}
