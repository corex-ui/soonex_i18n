defmodule SoonexI18n.Layouts.Shell do
  @moduledoc false

  def section, do: "scroll-mt-24 w-full py-20 sm:py-28 lg:py-32"

  def section_compact, do: "scroll-mt-24 w-full py-14 sm:py-16"

  def section_hero, do: "relative w-full pb-16 pt-16 sm:pb-24 sm:pt-24 lg:pt-28"

  def stage, do: "mx-auto w-full max-w-6xl px-6 lg:px-8"

  def stage_wide, do: "mx-auto w-full max-w-7xl px-6 lg:px-8"

  def intro, do: "max-w-2xl lg:max-w-3xl"

  def intro_center, do: "mx-auto max-w-2xl text-center"

  def body, do: "mt-16 w-full sm:mt-20"

  def body_tight, do: "mt-10 w-full sm:mt-12"

  def sticky_grid, do: "grid grid-cols-1 items-start gap-16 lg:grid-cols-12 lg:gap-16"

  def sticky_intro, do: "max-w-xl lg:sticky lg:top-28 lg:col-span-5"

  def sticky_body, do: "w-full min-w-0 lg:col-span-7"

  def eyebrow,
    do: "soonex-eyebrow m-0 text-xs/6 font-medium tracking-[0.18em] text-ink-muted uppercase"

  def display_heading,
    do:
      "display m-0 text-balance text-5xl font-medium tracking-tighter text-ink sm:text-6xl lg:text-[5.5rem] lg:leading-[0.98]"

  def hero_heading, do: display_heading()

  def section_heading,
    do: "display mt-3 text-pretty text-2xl font-medium tracking-tight text-ink sm:text-3xl"

  def section_heading_lg,
    do:
      "display mt-3 text-balance text-4xl font-medium tracking-tighter text-ink sm:text-5xl lg:max-w-3xl lg:text-[3.5rem] lg:leading-[1.02]"

  def page_heading,
    do: "display mt-2 text-pretty text-2xl font-medium tracking-tight text-ink sm:text-3xl"

  def lede, do: "mt-5 max-w-xl text-pretty text-base/7 text-ink-muted sm:text-lg/8"

  def lede_wide, do: "mt-5 max-w-2xl text-pretty text-base/7 text-ink-muted sm:text-lg/8"

  def panel, do: "relative overflow-hidden rounded-2xl border border-border bg-surface p-6 sm:p-8"

  def panel_open,
    do: "relative overflow-visible rounded-2xl border border-border bg-surface p-6 sm:p-8"

  def frame, do: "relative overflow-hidden rounded-2xl border border-border bg-surface"

  def tile,
    do: "relative flex flex-col overflow-hidden rounded-3xl border border-border bg-surface"

  def photo_frame, do: "relative isolate overflow-hidden rounded-3xl bg-ink"

  def photo_fill, do: "absolute inset-0 -z-10 size-full object-cover"

  def scrim, do: "absolute inset-0 -z-10 bg-linear-to-t from-black/80 via-black/45 to-black/10"

  def on_photo_heading,
    do:
      "display m-0 text-balance text-4xl font-medium tracking-tighter text-white sm:text-5xl lg:text-6xl lg:leading-[1.02]"

  def on_photo_body, do: "mt-5 max-w-xl text-pretty text-base/7 text-white/85 sm:text-lg/8"

  def data_list, do: "data-list ui-accent ui-size-md w-full max-w-none"

  def primary_button, do: "button ui-accent ui-solid ui-size-sm"

  def primary_button_md, do: "button ui-accent ui-solid ui-size-md"

  def secondary_button_md, do: "button ui-ghost ui-size-md"

  def column_grid, do: "soonex-columns grid grid-cols-1 gap-12 lg:grid-cols-3 lg:gap-0"
end
