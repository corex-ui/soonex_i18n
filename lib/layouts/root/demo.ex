defmodule SoonexI18n.Layouts.Root.Demo do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Accessibility, only: [accessibility_panel: 1]

  alias SoonexI18n.Locale

  attr(:page, :map, required: true)
  attr(:locale, :any, required: true)
  attr(:mode, :any, required: true)

  def demo_site_controls(assigns) do
    ~H"""
    <div
      role="region"
      aria-label={~t"Demo site controls"}
      class="fixed bottom-space end-space z-50 flex flex-col items-end gap-space"
    >
      <.accessibility_panel />
      <.floating_panel
        id="site-controls"
        class="floating-panel"
        dir={Locale.dir(@locale)}
        size={%{width: 250, height: 200}}
        positioning={
          %Corex.Positioning{
            placement: "bottom-end",
            offset: %Corex.Offset{main_axis: 120, cross_axis: -10}
          }
        }
        resizable={false}
        translation={%Corex.FloatingPanel.Translation{close: ~t"Close"}}
      >
        <:trigger class="button ui-size-sm">
          <.heroicon name="hero-cog-6-tooth" /> {~t"Template Options"}
        </:trigger>
        <:title>{~t"Template Options"}</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" />
        </:close_trigger>
        <:content>
          <div class="flex flex-col gap-size">
            <.select
              id="corex-language-switch"
              class="select ui-size-sm w-full min-w-0"
              dir={Locale.dir(@locale)}
              items={Locale.language_select_items(Locale.current_path(@page))}
              value={Locale.language_select_value(Locale.current_path(@page), @locale)}
              redirect
              on_value_change_client="corex:set-locale"
              positioning={
                %Corex.Positioning{
                  strategy: "fixed",
                  placement: "bottom-start",
                  same_width: true,
                  gutter: 8,
                  slide: false,
                  fit_viewport: false
                }
              }
              translation={%Corex.Select.Translation{placeholder: ~t"Language"}}
            >
              <:label>{~t"Language"}</:label>
              <:trigger>
                <.heroicon name="hero-language" />
              </:trigger>
              <:item_indicator>
                <.heroicon name="hero-check" />
              </:item_indicator>
            </.select>
            <div class="flex flex-row items-end gap-space">
              <.select
                id="theme-switcher"
                class="select ui-size-sm w-full min-w-0"
                dir={Locale.dir(@locale)}
                items={SoonexI18n.Theme.select_items()}
                value={[]}
                close_on_select={false}
                update_trigger={false}
                on_value_change_client="corex:set-theme"
                positioning={
                  %Corex.Positioning{
                    strategy: "fixed",
                    placement: "bottom-start",
                    same_width: true,
                    gutter: 8,
                    slide: false,
                    fit_viewport: false
                  }
                }
                translation={%Corex.Select.Translation{placeholder: ~t"Theme"}}
              >
                <:label>{~t"Theme"}</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
                <:item_indicator>
                  <.heroicon name="hero-check" />
                </:item_indicator>
              </.select>

              <.toggle
                id="mode-switcher"
                class="toggle ui-size-sm"
                data-toggle-dual-label
                pressed={@mode == "dark"}
                dir={Locale.dir(@locale)}
                on_pressed_change_client="corex:set-mode"
              >
                <span class="sr-only">{~t"Color mode"}</span>
                <span>
                  <.heroicon name="hero-moon" />
                </span>
                <span data-pressed>
                  <.heroicon name="hero-sun" />
                </span>
              </.toggle>
            </div>
          </div>
        </:content>
      </.floating_panel>
      <.navigate
        to="https://hexdocs.pm/corex"
        class="button ui-accent ui-solid ui-size-sm"
        external
      >
        {~t"Corex docs"} <.heroicon name="hero-arrow-up-right" />
      </.navigate>
    </div>
    """
  end
end
