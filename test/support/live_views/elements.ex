defmodule PhoenixLiveViewTestBrowser.ElementsLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div id="elements">
      <p>element</p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
