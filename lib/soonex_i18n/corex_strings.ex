defmodule SoonexI18n.CorexStrings do
  @moduledoc false

  # Corex components translate their built-in labels through the app's Gettext
  # backend at runtime. Listing them here lets `mix gettext.extract` pick them up.

  use Gettext, backend: SoonexI18n.Gettext

  def msgids do
    [
      gettext("Pagination"),
      gettext("Previous page"),
      gettext("Next page"),
      gettext("Page %{page} of %{total_pages}", page: 0, total_pages: 0),
      gettext("Timer"),
      gettext("Close"),
      gettext("Dialog"),
      gettext("Select"),
      gettext("Minimize window"),
      gettext("Maximize window"),
      gettext("Restore window"),
      gettext("Close window"),
      gettext("Info"),
      gettext("Error")
    ]
  end
end
