defmodule SoonexI18n.Locale do
  @moduledoc false

  alias Corex.List, as: CorexList
  alias Corex.List.Item

  def locales, do: SoonexI18n.Gettext.locales()

  def default_locale_string, do: SoonexI18n.Gettext.default_locale()

  def current, do: Gettext.get_locale(SoonexI18n.Gettext)

  def current(page) when is_map(page) do
    perm = permalink_for_current(page)

    inner =
      perm
      |> String.replace_prefix("/", "")
      |> String.replace_suffix("/", "")

    case String.split(inner, "/", trim: true) do
      [] ->
        default_locale_string()

      [first | _] ->
        if first in locales(), do: first, else: default_locale_string()
    end
  end

  defp permalink_for_current(%{permalink: perm}) when is_binary(perm), do: perm
  defp permalink_for_current(%{"permalink" => perm}) when is_binary(perm), do: perm
  defp permalink_for_current(_), do: "/"

  def lang(locale) when is_binary(locale), do: locale
  def lang(_), do: default_locale_string()

  def dir(locale) do
    loc = lang(locale)

    case Localize.Locale.get(loc, [:layout, :character_order], fallback: true) do
      {:ok, :rtl} -> "rtl"
      {:ok, :ltr} -> "ltr"
      _ -> if loc == "ar", do: "rtl", else: "ltr"
    end
  end

  def label(loc) when is_atom(loc), do: label(Atom.to_string(loc))

  def label(loc) when is_binary(loc) do
    case Localize.Locale.display_name(loc, locale: loc) do
      {:ok, name} -> name
      _ -> String.upcase(loc)
    end
  end

  def swap_path(request_path, target_locale) do
    target = to_string(target_locale)
    supported = locales()
    segs = trimmed_path_segments(request_path)
    rest = segments_after_locale_prefix(segs, supported)
    default = default_locale_string()
    built = prefixed_locale_path(target, rest)
    home_default?(rest, target, default, built)
  end

  defp trimmed_path_segments(request_path) do
    inner =
      request_path
      |> to_string()
      |> String.trim()
      |> String.replace_prefix("/", "")
      |> String.replace_suffix("/", "")

    if inner == "", do: [], else: String.split(inner, "/", trim: true)
  end

  defp segments_after_locale_prefix(segs, supported) do
    case segs do
      [first | tail] -> if(first in supported, do: tail, else: segs)
      _ -> segs
    end
  end

  defp prefixed_locale_path(target, rest) do
    base = "/" <> target

    case rest do
      [] -> base <> "/"
      parts -> base <> "/" <> Enum.join(parts, "/") <> "/"
    end
  end

  defp home_default?([], target, default, _built) when target == default, do: "/"
  defp home_default?(_rest, _target, _default, built), do: built

  def current_path(%{permalink: perm}) when is_binary(perm) do
    if String.starts_with?(perm, "/"), do: perm, else: "/" <> perm
  end

  def current_path(_), do: "/"

  def language_select_items(current_path) do
    items =
      Enum.map(locales(), fn loc ->
        dest = swap_path(current_path, loc)

        Item.new(%{
          id: dest,
          to: dest,
          label: label(loc)
        })
      end)

    CorexList.new(items)
  end

  def language_select_value(current_path, locale) do
    [swap_path(current_path, locale)]
  end

  def selected_path(page, locale) do
    page |> current_path() |> swap_path(locale)
  end
end
