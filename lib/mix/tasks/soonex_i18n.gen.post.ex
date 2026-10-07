defmodule Mix.Tasks.SoonexI18n.Gen.Post do
  use Mix.Task

  @shortdoc "Generate a new post in every locale"
  @moduledoc """
  #{@shortdoc}.

      mix soonex_i18n.gen.post My new post

  Writes one Markdown file per locale under `_posts/`, each with a
  `/<locale>/blog/<slug>/` permalink. The default locale file has no suffix.
  """

  @locales ~w(en ar fr)
  @default_locale "en"

  @doc false
  def run(argv) do
    if argv == [] do
      Mix.raise("Missing argument: post title")
    end

    post_title = Enum.join(argv, " ")
    post_date = Date.utc_today()

    slug =
      post_title
      |> String.downcase()
      |> String.replace(~r/[\s_]+/, "-")
      |> String.replace(~r/[^a-z0-9\-]/, "")

    for locale <- @locales do
      suffix = if locale == @default_locale, do: "", else: "-#{locale}"
      file_path = "./_posts/#{post_date}-#{slug}#{suffix}.md"

      if File.exists?(file_path) do
        Mix.raise("File already exists: #{file_path}")
      end

      File.write!(file_path, """
      ---
      layout: SoonexI18n.PostLayout
      title: "#{post_title}"
      date: #{post_date} 09:00:00 +0000
      permalink: /#{locale}/blog/#{slug}/
      description: ""
      tags: []
      ---
      """)

      Mix.shell().info("Created #{file_path}")
    end
  end
end
