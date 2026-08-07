defmodule SoonexI18n.HomePage.Faq do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  def faq(assigns) do
    ~H"""
    <section
      id="faq"
      class={"#{Shell.section()} border-y border-border"}
      aria-labelledby="soonex_i18n-faq-heading"
    >
      <div class={"#{Shell.stage()} grid grid-cols-1 items-start justify-items-center gap-size-xl lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.2fr)] lg:justify-items-stretch"}>
        <div class="mx-auto flex w-full max-w-2xl flex-col items-center gap-size-md text-center lg:mx-0 lg:max-w-none lg:items-start lg:text-start lg:sticky lg:top-40">
          <h2 id="soonex_i18n-faq-heading" class={Shell.section_heading()}>
            {~t"Lorem"} <span class="text-brand-text">{~t"FAQ"}</span>
          </h2>
          <p class={Shell.lede()}>
            {~t"Ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."}
          </p>
          <p class="m-0 text-sm">
            <.navigate to="#waitlist" class="link ui-brand">{~t"Join the waitlist"}</.navigate>
          </p>
        </div>

        <div class="mx-auto min-w-0 w-full max-w-2xl lg:mx-0 lg:max-w-none">
          <.accordion
            id="soonex_i18n-faq"
            class="accordion ui-accent ui-size-sm sm:ui-size-md lg:ui-size-xl w-full"
            multiple={true}
            value={["stack"]}
            items={faq_items()}
          >
            <:trigger :let={item}>
              <span class="flex min-w-0 items-center gap-space">
                <span class="flex shrink-0 -space-x-2" aria-hidden="true">
                  <span
                    :for={tech <- item.meta.tech}
                    class="inline-flex size-7 items-center justify-center rounded-full border border-border bg-surface p-space-xs"
                  >
                    <img
                      src={SoonexI18n.Public.path(tech.src)}
                      alt=""
                      class="size-4 object-contain"
                      loading="lazy"
                    />
                  </span>
                </span>
                <span class="min-w-0 text-start">{item.label}</span>
              </span>
            </:trigger>
            <:content :let={item}>
              <p class="m-0 leading-relaxed">{item.content}</p>
            </:content>
            <:indicator>
              <.heroicon name="hero-chevron-right" />
            </:indicator>
          </.accordion>
        </div>
      </div>
    </section>
    """
  end

  defp faq_items do
    Corex.Content.new([
      %{
        value: "stack",
        label: ~t"Lorem ipsum dolor sit amet?",
        content:
          ~t"Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
        meta: %{
          tech: [
            %{name: "Tableau", src: "/images/tech/tableau.jpg"},
            %{name: "Elixir", src: "/images/tech/elixir.svg"},
            %{name: "Hex", src: "/images/tech/hex.svg"}
          ]
        }
      },
      %{
        value: "builds",
        label: ~t"Sed do eiusmod tempor?",
        content:
          ~t"Incididunt ut labore et dolore magna aliqua. Quis nostrud exercitation ullamco laboris nisi ut aliquip.",
        meta: %{
          tech: [
            %{name: "Tailwind", src: "/images/tech/tailwind.svg"},
            %{name: "Hex", src: "/images/tech/hex.svg"}
          ]
        }
      },
      %{
        value: "mcp",
        label: ~t"Ut enim ad minim veniam?",
        content:
          ~t"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        meta: %{
          tech: [
            %{name: "Phoenix", src: "/images/tech/phoenix.svg"},
            %{name: "TypeScript", src: "/images/tech/typescript.svg"},
            %{name: "Zag.js", src: "/images/tech/zag.webp"}
          ]
        }
      },
      %{
        value: "themes",
        label: ~t"Excepteur sint occaecat?",
        content:
          ~t"Cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        meta: %{
          tech: [
            %{name: "CSS", src: "/images/tech/css.svg"},
            %{name: "Figma", src: "/images/tech/figma.svg"}
          ]
        }
      },
      %{
        value: "next",
        label: ~t"Anim id est laborum?",
        content:
          ~t"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
        meta: %{
          tech: [
            %{name: "Phoenix", src: "/images/tech/phoenix.svg"},
            %{name: "Zag.js", src: "/images/tech/zag.webp"},
            %{name: "Ecto", src: "/images/tech/ecto.png"}
          ]
        }
      }
    ])
  end
end
