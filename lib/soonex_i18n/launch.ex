defmodule SoonexI18n.Launch do
  @moduledoc false

  alias SoonexI18n.Locale

  @target ~U[2026-12-01 00:00:00Z]

  def target, do: @target

  def label, do: Locale.format_date(@target, :MMMMd)

  def year_label, do: Locale.format_date(@target)

  def countdown_ms do
    max(DateTime.diff(@target, DateTime.utc_now(), :millisecond), 0)
  end
end
