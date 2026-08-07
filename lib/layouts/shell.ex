defmodule SoonexI18n.Layouts.Shell do
  @moduledoc false

  def stage, do: "mx-auto w-full max-w-7xl px-space-xl"

  def card, do: "blog__card"

  def section,
    do: "flex min-h-dvh w-full flex-col justify-center py-size-xl"

  def stack, do: "flex flex-col gap-size-xl"

  def lede, do: "m-0 max-w-2xl text-pretty text-lg text-ink-muted"

  def section_heading,
    do: "display m-0 text-balance text-3xl tracking-tighter text-ink sm:text-4xl lg:text-5xl"
end
