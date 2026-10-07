defmodule SoonexI18n.HomePage.Logos do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  def logos(assigns) do
    assigns = assign(assigns, :tech, tech_items())

    ~H"""
    <section
      id="logos"
      data-section="logos"
      class={"#{Shell.section_compact()} bg-root"}
      aria-labelledby="soonex-logos-heading"
    >
      <div class={Shell.stage_wide()}>
        <h2 id="soonex-logos-heading" class={"#{Shell.eyebrow()} mb-8 text-center"}>
          {~t"Built on the tools Phoenix teams already trust"}
        </h2>
        <.marquee
          id="soonex-tech-marquee"
          class="marquee ui-width-full"
          duration={28}
          spacing="2.5rem"
          pause_on_interaction
          dir={Locale.dir(Locale.current())}
          items={@tech}
        >
          <:item :let={item}>
            <img src={SoonexI18n.Public.path(item.src)} alt="" width="32" height="32" />
            <span>{item.name}</span>
          </:item>
        </.marquee>
      </div>
    </section>
    """
  end

  defp tech_items do
    [
      %{name: "Elixir", src: "/images/tech/elixir.svg"},
      %{name: "Phoenix", src: "/images/tech/phoenixframework.svg"},
      %{name: "Tableau", src: "/images/tech/tableau.jpg"},
      %{name: "Tailwind", src: "/images/tech/tailwindcss.svg"},
      %{name: "HTML5", src: "/images/tech/html5.svg"},
      %{name: "JavaScript", src: "/images/tech/javascript.svg"},
      %{name: "TypeScript", src: "/images/tech/typescript.svg"},
      %{name: "Hex", src: "/images/tech/hex.svg"}
    ]
  end
end
