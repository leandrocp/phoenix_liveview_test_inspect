defmodule PhoenixLiveViewTestBrowser do
  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.{Element, View}

  def open_browser(%View{} = view) do
    view |> render() |> open_browser()
    view
  end

  def open_browser(%Element{} = element) do
    element |> render() |> open_browser()
    element
  end

  def open_browser(raw_html) when is_binary(raw_html) do
    {file, path} =
      raw_html
      |> maybe_inject_html_element()
      |> inject_css_style()
      |> write_html_file()

    cmd_open_browser(path)

    raw_html
  end

  defp maybe_inject_html_element(raw_html) do
    {:ok, html} = Floki.parse_document(raw_html)

    case Floki.find(html, "html") do
      [] ->
        [
          "<!DOCTYPE html>",
          "<html lang=\"en\">",
          "<head>",
          "<meta charset=\"utf-8\"/>",
          "</head>",
          "<body>",
          raw_html,
          "</body>",
          "</html>"
        ]
        |> IO.iodata_to_binary()

      _ ->
        raw_html
    end
  end

  defp inject_css_style(raw_html) do
    {:ok, html} = Floki.parse_document(raw_html)

    html
    |> Floki.traverse_and_update(fn
      {"head", attrs, children} ->
        children = children ++ [{"link", [{"rel", "stylesheet"}, {"href", css_file_path()}], []}]
        {"head", attrs, children}

      node ->
        node
    end)
    |> Floki.raw_html()
  end

  defp css_file_path do
    {:ok, cwd} = File.cwd()
    Path.join([cwd, "priv/static/css/app.css"])
  end

  defp write_html_file(raw_html) do
    path = Path.join([System.tmp_dir!(), random_html_filename()])

    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, raw_html)
    File.close(file)

    {file, path}
  end

  def random_html_filename do
    "plvtb-"
    |> Kernel.<>(random_encoded_bytes())
    |> String.replace(["/", "+"], "-")
    |> Kernel.<>(".html")
  end

  defp random_encoded_bytes do
    binary = <<
      System.system_time(:nanosecond)::64,
      :erlang.phash2({node(), self()})::16,
      :erlang.unique_integer()::16
    >>

    Base.url_encode64(binary)
  end

  defp cmd_open_browser(path) do
    cmd =
      case :os.type() do
        {:win32, _} ->
          "start"

        {:unix, :darwin} ->
          "open"

        {:unix, _} ->
          "xdg-open"
      end

    System.cmd(cmd, [path])
  end
end
