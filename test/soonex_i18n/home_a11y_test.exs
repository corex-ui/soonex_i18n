defmodule SoonexI18n.HomeA11yTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :capture_log

  feature "default-language root path has no axe violations", %{session: session} do
    assert_accessible(session, "/")
  end

  feature "english home page has no axe violations", %{session: session} do
    assert_accessible(session, "/en/")
  end

  feature "french home page has no axe violations", %{session: session} do
    assert_accessible(session, "/fr/")
  end

  feature "arabic home page has no axe violations", %{session: session} do
    assert_accessible(session, "/ar/")
  end

  feature "arabic home page renders right-to-left", %{session: session} do
    session
    |> Wallaby.Browser.visit("/ar/")
    |> find(Query.css("html[lang='ar'][dir='rtl']", visible: :any))
  end

  defp assert_accessible(session, path) do
    session = Wallaby.Browser.visit(session, path)
    Process.sleep(2400)

    _ = find(session, Query.css("#main-content"))
    _ = find(session, Query.css(".link.link--skip", visible: :any))

    A11yAudit.Wallaby.assert_no_violations(session)
  end
end
