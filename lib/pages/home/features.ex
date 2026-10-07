defmodule SoonexI18n.HomePage.Features do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Layouts.Section, only: [block: 1]

  alias SoonexI18n.Layouts.Shell

  def features(assigns) do
    assigns = assign(assigns, :tiles, tiles())

    ~H"""
    <.block
      id="capabilities"
      section="capabilities"
      labelledby="soonex-capabilities-heading"
      eyebrow={~t"Product"}
      heading_size={:large}
    >
      <:title>
        {~t"Everything a launch page needs. Nothing it doesn't."}
      </:title>
      <:lede>
        {~t"A focused set of building blocks that cover the first impression, the signup, and the story you tell while you build."}
      </:lede>

      <div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4 lg:grid-rows-2">
        <article class={"#{Shell.tile()} md:col-span-2 lg:row-span-2"}>
          <div class="relative aspect-[4/3] overflow-hidden lg:aspect-auto lg:flex-1">
            <img
              src={SoonexI18n.Public.path("/images/photos/ribbons.jpg")}
              alt=""
              width="1400"
              height="1400"
              loading="lazy"
              decoding="async"
              class="absolute inset-0 size-full object-cover"
            />
          </div>
          <div class="p-8 sm:p-10">
            <.heroicon name="hero-swatch" class="size-6 text-ink" />
            <h3 class="display mt-5 text-2xl font-medium tracking-tight text-ink sm:text-3xl">
              {~t"Design tokens that stay readable."}
            </h3>
            <p class="mt-3 max-w-md text-sm/6 text-ink-muted sm:text-base/7">
              {~t"Palettes are generated from seeds, so light mode, dark mode, and high contrast all stay legible without hand-tuned color stacks."}
            </p>
          </div>
        </article>

        <article :for={tile <- @tiles} class={"#{Shell.tile()} p-8"}>
          <.heroicon name={tile.icon} class="size-6 text-ink" />
          <h3 class="display mt-8 text-lg font-medium tracking-tight text-ink">{tile.title}</h3>
          <p class="mt-2 text-sm/6 text-ink-muted">{tile.body}</p>
        </article>
      </div>
    </.block>
    """
  end

  defp tiles do
    [
      %{
        icon: "hero-bolt",
        title: ~t"Static and fast",
        body: ~t"Tableau renders plain HTML you can host anywhere, from GitHub Pages to a CDN."
      },
      %{
        icon: "hero-cursor-arrow-rays",
        title: ~t"Live components",
        body:
          ~t"Tabs, accordions, selects, and timers hydrate in the browser with full keyboard support."
      },
      %{
        icon: "hero-envelope",
        title: ~t"Waitlist built in",
        body:
          ~t"A validated signup form with role select and toast feedback, ready for your provider."
      },
      %{
        icon: "hero-newspaper",
        title: ~t"A journal that ships",
        body: ~t"Markdown posts with tags, RSS, and pagination keep early followers in the loop."
      }
    ]
  end
end
