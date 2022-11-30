defmodule LiveMotionExamplesWeb.ContentUpdateLive do
  use LiveMotionExamplesWeb, :live_view

  import LiveMotion

  @colors %{
    black: "#000000",
    green: "#00FFBF",
    purple: "#8710EB",
    red: "#FC6969"
  }

  def mount(_params, _session, socket) do
    schedule_update()

    {:ok,
     socket
     |> assign(:value_1, 3250)
     |> assign(:value_2, 34)
     |> assign(:value_3, 22)}
  end

  def render(assigns) do
    assigns = assign(assigns, :colors, @colors)

    IO.inspect(assigns)

    ~H"""
    <div class="mt-12 max-w-screen-md m-auto flex justify-center space-y-4 flex-col items-center">
      <div>
        <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
          <div class="relative overflow-hidden border-2 border-benvp-green rounded-lg bg-transparent px-4 py-5 sm:p-6">
            <dt class="truncate text-sm font-medium text-neutral-400">Total Subscribers</dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-50"><%= @value_1 %></dd>
            <.motion
              id={"box-1-highlight-#{@value_1}"}
              class="absolute inset-0 -z-10"
              animate={[background: [@colors.green, "transparent"]]}
              transition={[duration: 2]}
            />
          </div>

          <div class="relative overflow-hidden border-2 border-benvp-red rounded-lg px-4 py-5 sm:p-6">
            <dt class="truncate text-sm font-medium text-neutral-400">Avg. Open Rate</dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-50"><%= @value_2 %>%</dd>
            <.motion
              id={"box-2-highlight-#{@value_2}"}
              class="absolute inset-0 -z-10"
              animate={[background: [@colors.red, "transparent"]]}
              transition={[duration: 2]}
            />
          </div>

          <div class="relative overflow-hidden border-2 border-benvp-purple rounded-lg px-4 py-5 sm:p-6">
            <dt class="truncate text-sm font-medium text-neutral-400">Avg. Click Rate</dt>
            <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-50"><%= @value_3 %>%</dd>
            <.motion
              id={"box-3-highlight-#{@value_3}"}
              class="absolute inset-0 -z-10"
              animate={[background: [@colors.purple, "transparent"]]}
              transition={[duration: 2]}
            />
          </div>
        </dl>
      </div>
    </div>
    """
  end

  def handle_info("update", socket) do
    schedule_update()

    {:noreply,
     socket
     |> assign(:value_1, :rand.uniform(10000))
     |> assign(:value_2, :rand.uniform(100))
     |> assign(:value_3, :rand.uniform(100))}
  end

  defp schedule_update() do
    Process.send_after(self(), "update", 3000)
  end
end
