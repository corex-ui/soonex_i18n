defmodule Mix.Tasks.Project.Rename do
  @moduledoc false

  use Mix.Task

  @shortdoc "Rename OTP application and module namespaces"

  @extensions ~w(.ex .exs .heex .md .po .pot)

  @skip_dirs ~w(_build deps .git _site assets/node_modules)

  @walk_dirs ~w(lib config test priv)

  def run(argv) do
    case argv do
      [target] when is_binary(target) ->
        target = String.trim(target)
        run_rename(target)

      _ ->
        Mix.raise("Usage: mix project.rename <otp_app>   (example: mix project.rename acme)")
    end
  end

  defp run_rename(to_otp_str) do
    validate_otp_target!(to_otp_str)
    validate_mix_project_present!()

    from_otp = Mix.Project.config()[:app]
    from_otp_str = Atom.to_string(from_otp)

    if from_otp_str == to_otp_str do
      Mix.raise("Target OTP name is already #{inspect(from_otp)}.")
    end

    from_camel = Macro.camelize(from_otp_str)
    to_camel = Macro.camelize(to_otp_str)
    root = File.cwd!()

    paths = rename_paths(root, from_otp_str, to_otp_str)

    if File.exists?(paths.lib_to) or File.exists?(paths.web_to) do
      Mix.raise("Refusing to overwrite existing lib/#{paths.to_otp} or lib/#{paths.to_otp}_web.")
    end

    Mix.shell().info(
      "Renaming OTP app :#{from_otp_str} -> :#{to_otp_str} (#{from_camel} -> #{to_camel})..."
    )

    transform_walked_directories!(root, from_otp_str, to_otp_str, from_camel, to_camel)
    transform_root_files!(root, from_otp_str, to_otp_str, from_camel, to_camel)
    transform_post_layouts!(root, from_camel, to_camel)

    rename_dir(paths.lib_from, paths.lib_to)
    rename_dir(paths.web_from, paths.web_to)
    rename_dir(paths.test_from, paths.test_to)
    rename_dir(paths.test_web_from, paths.test_web_to)
    rename_mix_task_files(root, from_otp_str, to_otp_str)

    Mix.shell().info("Done. Run mix format && mix compile.")
  end

  defp validate_otp_target!(to_otp_str) do
    unless Regex.match?(~r/^[a-z][a-z0-9_]*$/, to_otp_str) do
      Mix.raise(
        "Invalid OTP name #{inspect(to_otp_str)}. Use lowercase letters, digits, and underscores only."
      )
    end
  end

  defp validate_mix_project_present! do
    if Mix.Project.get() == nil do
      Mix.raise("Run this task from the application root (where mix.exs lives).")
    end
  end

  defp rename_paths(root, from_otp_str, to_otp_str) do
    %{
      lib_from: Path.join(root, "lib/#{from_otp_str}"),
      lib_to: Path.join(root, "lib/#{to_otp_str}"),
      web_from: Path.join(root, "lib/#{from_otp_str}_web"),
      web_to: Path.join(root, "lib/#{to_otp_str}_web"),
      test_from: Path.join(root, "test/#{from_otp_str}"),
      test_to: Path.join(root, "test/#{to_otp_str}"),
      test_web_from: Path.join(root, "test/#{from_otp_str}_web"),
      test_web_to: Path.join(root, "test/#{to_otp_str}_web"),
      to_otp: to_otp_str
    }
  end

  defp transform_walked_directories!(root, from_otp_str, to_otp_str, from_camel, to_camel) do
    for dir <- @walk_dirs do
      path = Path.join(root, dir)
      if File.dir?(path), do: walk_transform(path, from_otp_str, to_otp_str, from_camel, to_camel)
    end
  end

  defp transform_root_files!(root, from_otp_str, to_otp_str, from_camel, to_camel) do
    mix_exs = Path.join(root, "mix.exs")

    if File.exists?(mix_exs) do
      transform_file(mix_exs, from_otp_str, to_otp_str, from_camel, to_camel, :code)
    end

    for json <- [Path.join(root, "package.json"), Path.join(root, "assets/package.json")] do
      if File.exists?(json) do
        transform_file(json, from_otp_str, to_otp_str, from_camel, to_camel, :json)
      end
    end

    lock = Path.join(root, "package-lock.json")

    if File.exists?(lock) do
      transform_file(lock, from_otp_str, to_otp_str, from_camel, to_camel, :lock)
    end
  end

  defp transform_post_layouts!(root, from_camel, to_camel) do
    posts_dir = Path.join(root, "_posts")

    if File.dir?(posts_dir) do
      transform_post_markdown_layouts!(posts_dir, from_camel, to_camel)
    end
  end

  defp transform_post_markdown_layouts!(posts_dir, from_camel, to_camel) do
    case File.ls(posts_dir) do
      {:ok, names} ->
        names
        |> Enum.filter(&String.ends_with?(&1, ".md"))
        |> Enum.each(fn name ->
          path = Path.join(posts_dir, name)
          transform_post_layout_file!(path, from_camel, to_camel)
        end)

      {:error, _} ->
        :ok
    end
  end

  defp transform_post_layout_file!(path, from_camel, to_camel) do
    content = File.read!(path)
    pattern = ~r/^layout:\s*#{Regex.escape(from_camel)}\./m
    new = Regex.replace(pattern, content, "layout: #{to_camel}.")

    if new != content do
      File.write!(path, new)
      Mix.shell().info("  updated #{Path.relative_to(path, File.cwd!())}")
    end
  end

  defp walk_transform(dir, from_otp_str, to_otp_str, from_camel, to_camel) do
    dir
    |> list_all_files()
    |> Enum.each(fn path ->
      if Path.extname(path) in @extensions do
        transform_file(path, from_otp_str, to_otp_str, from_camel, to_camel, :code)
      end
    end)
  end

  defp list_all_files(dir) do
    case File.ls(dir) do
      {:ok, names} ->
        Enum.flat_map(names, fn name ->
          full = Path.join(dir, name)
          list_entry_paths(full, name)
        end)

      {:error, _} ->
        []
    end
  end

  defp list_entry_paths(full, name) do
    cond do
      name in @skip_dirs -> []
      File.dir?(full) -> list_all_files(full)
      File.regular?(full) -> [full]
      true -> []
    end
  end

  defp transform_file(path, from_otp_str, to_otp_str, from_camel, to_camel, mode) do
    content = File.read!(path)
    new = apply_transforms(content, from_otp_str, to_otp_str, from_camel, to_camel, mode)

    if new != content do
      File.write!(path, new)
      Mix.shell().info("  updated #{Path.relative_to(path, File.cwd!())}")
    end
  end

  defp apply_transforms(content, from_otp_str, to_otp_str, _from_camel, _to_camel, :lock) do
    String.replace(content, ~s["name": "#{from_otp_str}"], ~s["name": "#{to_otp_str}"])
  end

  defp apply_transforms(content, from_otp_str, to_otp_str, from_camel, to_camel, mode) do
    from_web = from_camel <> "Web"
    to_web = to_camel <> "Web"
    mix_from = "Mix.Tasks." <> from_camel <> "."
    mix_to = "Mix.Tasks." <> to_camel <> "."

    content =
      content
      |> String.replace(mix_from, mix_to)
      |> String.replace(from_web, to_web)
      |> String.replace(from_camel, to_camel)

    content =
      Regex.replace(~r/:#{Regex.escape(from_otp_str)}\b/u, content, ":#{to_otp_str}")

    content =
      String.replace(content, from_otp_str <> ".", to_otp_str <> ".")

    content =
      if mode == :json do
        String.replace(content, from_otp_str <> "-template", to_otp_str <> "-template")
      else
        Regex.replace(~r/\b#{Regex.escape(from_otp_str)}\b/u, content, to_otp_str)
      end

    String.replace(content, "lib/#{from_otp_str}/", "lib/#{to_otp_str}/")
  end

  defp rename_dir(from, to) do
    if File.exists?(from) do
      case File.rename(from, to) do
        :ok ->
          Mix.shell().info(
            "  moved #{Path.relative_to(from, File.cwd!())} -> #{Path.relative_to(to, File.cwd!())}"
          )

        {:error, reason} ->
          Mix.raise("Could not rename #{from} to #{to}: #{inspect(reason)}")
      end
    end
  end

  defp rename_mix_task_files(root, from_otp_str, to_otp_str) do
    tasks_dir = Path.join(root, "lib/mix/tasks")

    if File.dir?(tasks_dir) do
      for name <- File.ls!(tasks_dir), String.ends_with?(name, ".ex") do
        full = Path.join(tasks_dir, name)
        maybe_rename_mix_task(full, name, tasks_dir, from_otp_str, to_otp_str)
      end
    end
  end

  defp maybe_rename_mix_task(full, "post.ex", tasks_dir, _from_otp_str, to_otp_str) do
    new_name = to_otp_str <> ".gen.post.ex"
    try_rename_task_file(full, tasks_dir, "post.ex", new_name)
  end

  defp maybe_rename_mix_task(full, name, tasks_dir, from_otp_str, to_otp_str) do
    if String.starts_with?(name, from_otp_str <> ".") do
      rest = String.replace_leading(name, from_otp_str <> ".", "")
      new_name = to_otp_str <> "." <> rest
      try_rename_task_file(full, tasks_dir, name, new_name)
    end
  end

  defp try_rename_task_file(full, tasks_dir, old_name, new_name) do
    new_full = Path.join(tasks_dir, new_name)

    if full != new_full do
      case File.rename(full, new_full) do
        :ok ->
          Mix.shell().info("  moved lib/mix/tasks/#{old_name} -> lib/mix/tasks/#{new_name}")

        {:error, _} ->
          :ok
      end
    end
  end
end
