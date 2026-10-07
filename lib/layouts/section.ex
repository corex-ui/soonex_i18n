defmodule SoonexI18n.Layouts.Section do
  @moduledoc false

  use Phoenix.Component

  alias SoonexI18n.Layouts.Shell

  attr(:id, :string, required: true)
  attr(:labelledby, :string, required: true)
  attr(:eyebrow, :string, default: nil)
  attr(:section, :string, default: nil)
  attr(:tone, :atom, default: :root, values: [:root, :surface, :inverse, :photo])
  attr(:photo, :string, default: nil, doc: "image path, required when tone is :photo")
  attr(:align, :atom, default: :start)
  attr(:layout, :atom, default: :stack, values: [:stack, :sticky, :split])
  attr(:compact, :boolean, default: false)
  attr(:heading_size, :atom, default: :default, values: [:default, :large])

  slot(:title, required: true)
  slot(:lede)
  slot(:actions)
  slot(:inner_block, required: true)

  def block(%{tone: :photo} = assigns) do
    ~H"""
    <section
      id={@id}
      data-section={@section || @id}
      class={"#{section_class(@compact)} bg-root"}
      aria-labelledby={@labelledby}
    >
      <div class={Shell.stage_wide()}>
        <div class={"#{Shell.photo_frame()} px-6 py-16 sm:px-12 sm:py-20 lg:px-16 lg:py-24"}>
          <img
            src={SoonexI18n.Public.path(@photo)}
            alt=""
            class={Shell.photo_fill()}
            loading="lazy"
            decoding="async"
          />
          <div class={Shell.scrim()} aria-hidden="true"></div>
          <div class="max-w-3xl">
            <p :if={@eyebrow} class={"#{Shell.eyebrow()} text-white/75"}>{@eyebrow}</p>
            <h2 id={@labelledby} class={"#{Shell.on_photo_heading()} mt-3"}>
              {render_slot(@title)}
            </h2>
            <p :if={@lede != []} class={Shell.on_photo_body()}>{render_slot(@lede)}</p>
          </div>
          <div class={Shell.body()}>
            {render_slot(@inner_block)}
          </div>
        </div>
      </div>
    </section>
    """
  end

  def block(assigns) do
    ~H"""
    <section
      id={@id}
      data-section={@section || @id}
      class={"#{section_class(@compact)} #{tone_class(@tone)}"}
      aria-labelledby={@labelledby}
    >
      <div class={stage_class(@layout, @tone)}>
        <div :if={@layout != :split} class={intro_class(@layout, @align)}>
          <p :if={@eyebrow} class={eyebrow_class(@tone)}>{@eyebrow}</p>
          <h2 id={@labelledby} class={heading_class(@tone, @heading_size)}>
            {render_slot(@title)}
          </h2>
          <p :if={@lede != []} class={"#{lede_class(@tone)} #{lede_align(@layout, @align)}"}>
            {render_slot(@lede)}
          </p>
          <div
            :if={@actions != []}
            class={"mt-8 flex flex-wrap items-center gap-x-6 gap-y-4 #{actions_align(@layout, @align)}"}
          >
            {render_slot(@actions)}
          </div>
        </div>
        <div :if={@layout == :split} class="grid grid-cols-1 gap-10 lg:grid-cols-12 lg:gap-16">
          <div class="lg:col-span-6">
            <p :if={@eyebrow} class={eyebrow_class(@tone)}>{@eyebrow}</p>
            <h2 id={@labelledby} class={heading_class(@tone, :large)}>
              {render_slot(@title)}
            </h2>
          </div>
          <div class="lg:col-span-6 lg:pt-10">
            <p :if={@lede != []} class={lede_class(@tone)}>
              {render_slot(@lede)}
            </p>
            <div :if={@actions != []} class="mt-8 flex flex-wrap items-center gap-x-6 gap-y-4">
              {render_slot(@actions)}
            </div>
          </div>
        </div>
        <div class={body_class(@layout, @compact, @tone)}>
          {render_slot(@inner_block)}
        </div>
      </div>
    </section>
    """
  end

  defp section_class(true), do: Shell.section_compact()
  defp section_class(false), do: Shell.section()

  defp tone_class(:root), do: "bg-root"
  defp tone_class(:surface), do: "border-y border-border bg-surface"
  defp tone_class(:inverse), do: "soonex-band-inverse bg-accent text-accent-contrast"

  defp stage_class(:split, _tone), do: Shell.stage_wide()
  defp stage_class(:sticky, _tone), do: "#{Shell.stage_wide()} #{Shell.sticky_grid()}"
  defp stage_class(:stack, _tone), do: Shell.stage_wide()

  defp intro_class(:sticky, _align), do: Shell.sticky_intro()
  defp intro_class(:stack, :center), do: Shell.intro_center()
  defp intro_class(:stack, :start), do: Shell.intro()

  defp eyebrow_class(:inverse), do: "#{Shell.eyebrow()} soonex-on-inverse"
  defp eyebrow_class(_tone), do: Shell.eyebrow()

  defp heading_class(:inverse, :large), do: "#{Shell.section_heading_lg()} soonex-on-inverse"
  defp heading_class(:inverse, _size), do: "#{Shell.section_heading()} soonex-on-inverse"
  defp heading_class(_tone, :large), do: Shell.section_heading_lg()
  defp heading_class(_tone, _size), do: Shell.section_heading()

  defp lede_class(:inverse), do: "#{Shell.lede()} soonex-muted-on-inverse"
  defp lede_class(_tone), do: Shell.lede()

  defp lede_align(:sticky, _align), do: ""
  defp lede_align(:stack, :center), do: "mx-auto"
  defp lede_align(:stack, :start), do: ""

  defp actions_align(:sticky, _align), do: ""
  defp actions_align(:stack, :center), do: "justify-center"
  defp actions_align(:stack, :start), do: ""

  defp body_class(:split, _compact, _tone), do: Shell.body_tight()
  defp body_class(:sticky, _compact, _tone), do: Shell.sticky_body()
  defp body_class(:stack, true, _tone), do: Shell.body_tight()
  defp body_class(:stack, false, _tone), do: Shell.body()
end
