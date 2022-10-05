defmodule LiveMotionExamplesWeb.DevLive do
  use LiveMotionExamplesWeb, :live_view

  require Logger

  alias LiveMotion.JS, as: MotionJS

  def mount(_params, _session, socket) do
    {:ok, assign(socket, visible: true, rotate: 0, index: 0, range: 1..32)}
  end

  def handle_event("update", _params, socket) do
    rotate = if socket.assigns.rotate == 0, do: 90, else: 0
    {:noreply, assign(socket, rotate: rotate)}
  end

  def handle_event("show", _params, socket) do
    {:noreply, assign(socket, visible: true)}
  end

  def handle_event("remove", _params, socket) do
    {:noreply, assign(socket, visible: false)}
  end

  def handle_event("animation_start", _params, socket) do
    Logger.debug("Animation started")
    {:noreply, socket}
  end

  def handle_event("animation_complete", _params, socket) do
    Logger.debug("Animation completed")
    {:noreply, socket}
  end

  def handle_event("some_push", _params, socket) do
    Logger.debug("Random push event")
    {:noreply, socket}
  end

  def handle_event("next", _params, socket) do
    {:noreply, assign(socket, index: socket.assigns.index + 1)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-12 max-w-screen-md m-auto flex justify-center space-y-4 flex-col items-center">
      <div class="my-4 flex flex-wrap items-center justify-center space-x-4">
        <%= if @visible do %>
          <LiveMotion.motion
            id={"rectangle-#{@index}"}
            class="w-24 h-24 bg-benvp-green flex rounded-lg justify-center items-center mb-4"
            initial={[opacity: 0, y: -30, rotate: 0]}
            animate={
              [
                opacity: 1,
                y: 0,
                rotate: @rotate
              ]
            }
            exit={
              [
                opacity: 0,
                y: 30
              ]
            }
            transition={[duration: 2, easing: :spring]}
            hover={[scale: 1.2]}
            press={[scale: 0.9]}
            on_motion_start="animation_start"
            on_motion_complete="animation_complete"
          />
        <% end %>
      </div>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.toggle(to: "#rectangle-#{@index}")}
      >
        Toggle Square
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.animate(to: "#rectangle-#{@index}")}
      >
        Animate Square (JS)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.hide(to: "#rectangle-#{@index}")}
      >
        Hide Square (JS)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.show(to: "#rectangle-#{@index}", display: "flex")}
      >
        Show Square (JS)
      </button>

      <button type="button" class="px-4 py-2 bg-slate-800 rounded" phx-click="remove">
        Hide Square (Server)
      </button>

      <button type="button" class="px-4 py-2 bg-slate-800 rounded" phx-click="show">
        Show Square (Server)
      </button>

      <button type="button" class="px-4 py-2 bg-slate-800 rounded" phx-click="update">
        Update Square (Server)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={MotionJS.show(to: "#love", display: "inline-block")}
      >
        Show some love (non motion div)
      </button>

      <button
        type="button"
        class="px-4 py-2 bg-slate-800 rounded"
        phx-click={
          MotionJS.animate(to: "#rectangle-#{@index}")
          |> MotionJS.show(to: "#love")
          |> Phoenix.LiveView.JS.push("some_push")
        }
      >
        Composed JS actions
      </button>

      <LiveMotion.motion
        id="love"
        class="my-4 justify-center hidden"
        defer
        initial={[y: 20, opacity: 0]}
        animate={[y: 0, opacity: 1]}
      >
        <div class="text-4xl">❤️</div>
      </LiveMotion.motion>
    </div>
    """
  end
end
