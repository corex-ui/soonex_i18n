defmodule SoonexI18n.Layouts.Root.Nav do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.Layouts.Brand, only: [lockup: 1]

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  attr(:page_path, :string, default: "/")
  attr(:locale, :string, required: true)

  def site_nav(assigns) do
    assigns =
      assigns
      |> assign(:nav_select_items, nav_select_items(assigns.page_path))
      |> assign(:desktop_links, desktop_links(assigns.page_path))

    ~H"""
    <header class="sticky top-0 z-50 border-b border-border bg-root/85 backdrop-blur-md">
      <div class={"#{Shell.stage_wide()} flex items-center justify-between gap-4 py-3 lg:py-4"}>
        <div class="flex min-w-0 items-center gap-3">
          <.select
            id="soonex-mobile-nav"
            class="select ui-size-sm ui-width-fit lg:hidden"
            dir={Locale.dir(@locale)}
            redirect
            update_trigger={false}
            positioning={
              %Corex.Positioning{
                placement: "bottom-start",
                same_width: false,
                gutter: 8,
                fit_viewport: true,
                strategy: "fixed"
              }
            }
            translation={%Corex.Select.Translation{placeholder: ~t"Menu"}}
            items={@nav_select_items}
          >
            <:trigger>
              <.heroicon name="hero-bars-3" />
            </:trigger>
          </.select>
          <.lockup />
        </div>

        <nav class="hidden items-center gap-x-8 lg:flex" aria-label={~t"Primary"}>
          <.navigate
            :for={item <- @desktop_links}
            to={item.to}
            class={nav_link_class(@page_path, item)}
          >
            {item.label}
          </.navigate>
        </nav>

        <.navigate to={Locale.home_anchor(@page_path, "waitlist")} class={Shell.primary_button()}>
          {~t"Join waitlist"}
        </.navigate>
      </div>
    </header>
    """
  end

  defp nav_link_class(page_path, item) do
    current? = nav_current?(page_path, item)

    [
      "link ui-nav ui-size-sm",
      if(current?, do: "text-ink", else: "text-ink-muted hover:text-ink")
    ]
  end

  defp nav_current?(page_path, %{id: :journal}) do
    rest = String.replace_prefix(page_path, "/" <> Locale.current(), "")
    String.starts_with?(rest, "/blog") or String.starts_with?(rest, "/tags")
  end

  defp nav_current?(_page_path, _item), do: false

  defp desktop_links(page_path) do
    [
      %{id: :product, label: ~t"Product", to: Locale.home_anchor(page_path, "capabilities")},
      %{id: :how, label: ~t"Workflow", to: Locale.home_anchor(page_path, "spotlight")},
      %{id: :proof, label: ~t"Why Soonex", to: Locale.home_anchor(page_path, "proof")},
      %{id: :journal, label: ~t"Journal", to: ~p"/blog"},
      %{id: :questions, label: ~t"FAQ", to: Locale.home_anchor(page_path, "questions")}
    ]
  end

  defp nav_select_items(page_path) do
    page_path
    |> desktop_links()
    |> Enum.concat([
      %{id: :waitlist, label: ~t"Join waitlist", to: Locale.home_anchor(page_path, "waitlist")}
    ])
    |> Enum.map(fn item ->
      %{label: item.label, value: Atom.to_string(item.id), to: item.to, redirect: :href}
    end)
    |> Corex.List.new()
  end
end
