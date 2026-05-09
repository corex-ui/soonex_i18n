defmodule SoonexI18n.Gettext do
  @moduledoc false

  use Gettext.Backend,
    otp_app: :soonex_i18n,
    default_locale: "en",
    allowed_locales: ~w(en ar fr)

  def default_locale, do: __gettext__(:default_locale)

  def locales, do: Gettext.known_locales(__MODULE__)
end
