defmodule SoonexI18nWeb.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :soonex_i18n

  plug(SoonexI18nWeb.Router)
end
