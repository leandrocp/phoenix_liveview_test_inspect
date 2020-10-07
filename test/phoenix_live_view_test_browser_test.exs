defmodule PhoenixLiveViewTestBrowserTest do
  use ExUnit.Case, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  import PhoenixLiveViewTestBrowser
  alias PhoenixLiveViewTestBrowser.Endpoint

  @endpoint Endpoint

  setup do
    {:ok, live, _} = live(Phoenix.ConnTest.build_conn(), "/elements")
    element = element(live, "div")
    html = render(live)
    %{live: live, element: element, html: html}
  end

  describe "open_browser" do
    test "view", %{live: view} do
      assert open_browser(view) == view
    end

    test "element", %{element: element} do
      assert open_browser(element) == element
    end

    test "html", %{html: html} do
      assert open_browser(html) == html
    end
  end
end
