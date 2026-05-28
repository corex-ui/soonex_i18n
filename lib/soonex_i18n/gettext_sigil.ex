defmodule SoonexI18n.GettextSigil do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Gettext, backend: SoonexI18n.Gettext
      use GettextSigils, backend: SoonexI18n.Gettext
    end
  end
end
