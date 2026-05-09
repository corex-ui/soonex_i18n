ExUnit.start(max_cases: 1, timeout: 180_000)

base_url =
  :tableau
  |> Application.fetch_env!(:config)
  |> Keyword.fetch!(:url)
  |> String.trim_trailing("/")

Application.put_env(:wallaby, :base_url, base_url)

{:ok, _} = Application.ensure_all_started(:wallaby)
{:ok, _} = Application.ensure_all_started(:soonex_i18n)
