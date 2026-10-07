defmodule SoonexI18n.HomePage.Proof do
  @moduledoc false

  use Phoenix.Component
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell

  def proof(assigns) do
    assigns = assign(assigns, :stats, stats())

    ~H"""
    <section
      id="proof"
      data-section="proof"
      class={"#{Shell.section()} bg-root"}
      aria-labelledby="soonex-proof-heading"
    >
      <div class={Shell.stage_wide()}>
        <div class="grid grid-cols-1 gap-12 lg:grid-cols-12 lg:gap-16">
          <div class="lg:col-span-5">
            <p class={Shell.eyebrow()}>{~t"Why Soonex"}</p>
            <h2 id="soonex-proof-heading" class={Shell.section_heading_lg()}>
              {~t"Small surface. Serious polish."}
            </h2>
          </div>
          <div class="lg:col-span-7 lg:pt-10">
            <p class="display m-0 text-pretty text-2xl/snug font-medium tracking-tight text-ink sm:text-3xl/snug">
              {~t"A launch page is the first product your users touch. It should be as accessible, fast, and considered as the thing you are about to ship."}
            </p>
            <p class="mt-6 text-sm/6 text-ink-muted">{~t"The idea behind Soonex"}</p>
          </div>
        </div>

        <ul class="mt-20 grid list-none grid-cols-2 gap-px overflow-hidden rounded-3xl border border-border bg-border p-0 lg:grid-cols-4">
          <li :for={stat <- @stats} class="flex flex-col justify-between gap-6 bg-surface p-8 sm:p-10">
            <p class="display m-0 text-5xl font-medium tracking-tighter text-ink sm:text-6xl">
              {stat.value}
            </p>
            <p class="m-0 text-sm/6 text-ink-muted">{stat.label}</p>
          </li>
        </ul>
      </div>
    </section>
    """
  end

  defp stats do
    [
      %{value: "4", label: ~t"Themes, each with light and dark modes"},
      %{value: "0", label: ~t"npm packages to install or audit"},
      %{value: "1", label: ~t"Config block for your whole brand"},
      %{value: "100%", label: ~t"Static HTML, hostable anywhere"}
    ]
  end
end
