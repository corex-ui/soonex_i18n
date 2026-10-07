defmodule SoonexI18n.Layouts.Brand do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.Routes

  attr(:class, :any, default: nil)
  attr(:to, :string, default: nil)

  def lockup(assigns) do
    assigns = assign(assigns, :to, assigns.to || ~p"/")

    ~H"""
    <.navigate
      to={@to}
      type="href"
      class={["link ui-nav ui-size-md flex items-center gap-2 no-underline", @class]}
    >
      <span class="soonex-mark-wrap inline-flex shrink-0 text-[2rem] leading-none">
        <.mark class="soonex-mark" />
      </span>
      <span class="display text-lg font-medium tracking-tight text-ink">Soonex</span>
    </.navigate>
    """
  end

  attr(:class, :any, default: "soonex-mark")

  def mark(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 32 32"
      fill="currentColor"
      class={@class}
      aria-hidden="true"
    >
      <path
        fill-rule="evenodd"
        d="M8 2h16a6 6 0 0 1 6 6v16a6 6 0 0 1-6 6H8a6 6 0 0 1-6-6V8a6 6 0 0 1 6-6Zm8.2 5.15c2.85 0 4.7 1.2 5.45 3l-2.1 1.2c-.4-1.05-1.5-1.8-3.2-1.8-1.6 0-2.6.7-2.6 1.8 0 .85.55 1.35 2.4 1.95l1.9.6c2.95.9 4.35 2.4 4.35 4.7 0 2.95-2.5 4.75-6.2 4.75-3 0-5.15-1.3-6.05-3.3l2.15-1.25c.55 1.25 1.85 2.15 3.8 2.15 1.75 0 2.95-.8 2.95-2.05 0-.95-.6-1.5-2.6-2.1l-1.85-.55C11.2 16.7 9.75 15.15 9.75 13c0-2.65 2.25-4.4 6.05-4.4Z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end
end
