defmodule SoonexI18n.Layouts.Root.Demo do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  attr(:page, :map, required: true)
  attr(:locale, :any, required: true)
  attr(:mode, :any, required: true)

  def demo_site_controls(assigns) do
    ~H"""
    <div
      role="region"
      aria-label={gettext("Demo site controls")}
      class="fixed bottom-space end-space z-50 flex flex-col items-end gap-space"
    >
      <.floating_panel
        id="site-controls"
        class="floating-panel"
        dir={SoonexI18n.Locale.dir(@locale)}
        size={%{width: 250, height: 230}}
        positioning={
          %Corex.Positioning{
            placement: "bottom-end",
            offset: %Corex.Offset{main_axis: 100, cross_axis: -10}
          }
        }
        resizable={false}
        translation={%Corex.FloatingPanel.Translation{close: gettext("Close")}}
      >
        <:trigger class="button button--sm">
          <.heroicon name="hero-cog-6-tooth" />
          {gettext("Template Options")}
        </:trigger>
        <:title>{gettext("Template Options")}</:title>
        <:close_trigger>
          <.heroicon name="hero-x-mark" />
        </:close_trigger>
        <:content>
          <div class="flex flex-col gap-size">
            <.select
              id="corex-language-switch"
              class="select select--sm w-full min-w-0"
              dir={SoonexI18n.Locale.dir(@locale)}
              items={SoonexI18n.Locale.language_select_items(SoonexI18n.Locale.current_path(@page))}
              value={
                SoonexI18n.Locale.language_select_value(
                  SoonexI18n.Locale.current_path(@page),
                  @locale
                )
              }
              redirect
              on_value_change_client="corex:set-locale"
              translation={%Corex.Select.Translation{placeholder: gettext("Language")}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:label>{gettext("Language")}</:label>
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
                class="select select--sm w-full min-w-0"
                dir={SoonexI18n.Locale.dir(@locale)}
                items={SoonexI18n.Theme.select_items()}
                value={[]}
                close_on_select={false}
                update_trigger={false}
                on_value_change_client="corex:set-theme"
                translation={%Corex.Select.Translation{placeholder: gettext("Theme")}}
              >
                <:label>{gettext("Theme")}</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
                <:item_indicator>
                  <.heroicon name="hero-check" />
                </:item_indicator>
              </.select>

              <.toggle_group
                id="mode-switcher"
                class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
                multiple={false}
                deselectable={true}
                value={SoonexI18n.Mode.toggle_value(@mode)}
                dir={SoonexI18n.Locale.dir(@locale)}
                on_value_change_client="corex:set-mode"
              >
                <:label class="sr-only">{gettext("Color mode")}</:label>
                <:item
                  value="dark"
                  aria_label={gettext("Toggle color mode")}
                >
                  {SoonexI18n.Mode.dual_icon()}
                </:item>
              </.toggle_group>
            </div>
          </div>
        </:content>
      </.floating_panel>
      <.navigate
        to="https://corex.gigalixirapp.com/templates"
        class="button button--accent button--sm"
        external
      >
        {gettext("Made with Corex")}
        <.heroicon name="hero-arrow-down-tray" />
      </.navigate>
    </div>
    """
  end
end
