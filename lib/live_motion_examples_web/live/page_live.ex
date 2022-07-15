defmodule LiveMotionExamplesWeb.PageLive do
  use LiveMotionExamplesWeb, :live_view

  alias LiveMotion

  def mount(_params, _session, socket) do
    meta_attrs =
      LiveMotionExamplesWeb.SeoMeta.seo_meta_attrs(%LiveMotionExamplesWeb.SeoMeta{
        title: "LiveMotion Examples",
        description: "Little example page for LiveMotion.",
        url: Routes.live_path(socket, __MODULE__)
      })

    {:ok,
     socket
     |> assign(:meta_attrs, meta_attrs)
     |> assign_initial_examples()}
  end

  def handle_event(
        "example_change",
        %{"example_1" => %{"transform" => transform}},
        socket
      ) do
    {:noreply,
     assign(
       socket,
       :example_1,
       Keyword.merge(socket.assigns[:example_1], animate: [transform: transform])
     )}
  end

  def handle_event(
        "example_change",
        %{
          "example_2" => %{"rotate" => rotate, "x" => x, "scale" => scale}
        },
        socket
      ) do
    rotate = if rotate == "", do: 0, else: String.to_integer(rotate)
    x = if x == "", do: 0, else: String.to_integer(x)
    scale = if scale == "", do: 1, else: Float.parse(scale) |> elem(0)

    {:noreply,
     assign(socket, :example_2,
       animate: [rotate: rotate, x: x, scale: scale],
       transition: [duration: 1.0]
     )}
  end

  def handle_event(
        "example_change",
        %{
          "example_3" => %{"duration" => duration, "repeat" => repeat, "rotate" => rotate}
        },
        socket
      ) do
    rotate = if rotate == "", do: 0, else: String.to_integer(rotate)
    duration = if duration == "", do: 0, else: Float.parse(duration) |> elem(0)
    repeat = if repeat == "", do: 0, else: String.to_integer(repeat)

    {:noreply,
     assign(socket, :example_3,
       animate: [rotate: rotate],
       transition:
         Keyword.merge(socket.assigns[:example_3][:transition], duration: duration, repeat: repeat)
     )}
  end

  def handle_event("reset_example", %{"value" => value}, socket) do
    {:noreply, assign_initial_example(socket, String.to_existing_atom(value))}
  end

  def render(assigns) do
    ~H"""
    <div class="m-auto max-w-screen-md py-6 space-y-16">
      <img src={Routes.static_path(@socket, "/images/logo.png")} alt="LiveMotion" class="mb-12 h-32" />
      <div>
        <h2 class="mb-4 text-3xl font-bold">Basic animation</h2>
        <p>
          Using the LiveMotion.motion component you can create simple animations.
          The following animation is set via assigns on the server, but the animation
          is performed on the client (the browser).
        </p>
        <p class="mt-4 mb-8">
          Try changing the transform value in the input field to see it in action.
        </p>

        <.example_1
          animate={@example_1[:animate]}
          transition={@example_1[:transition]}
          seed={@example_1[:seed]}
        />
      </div>

      <div>
        <p class="mb-8">
          You can also animate individual transforms via shorthands (e.g. x, y, scale, rotate).
        </p>

        <.example_2
          animate={@example_2[:animate]}
          transition={@example_2[:transition]}
          seed={@example_2[:seed]}
        />
      </div>

      <div>
        <h2 class="mb-4 text-3xl font-bold">Transition</h2>
        <p class="mb-8">
          Transition options can be used to change things like duration, the easing curve
          and delay. The options are passed to the <%= link("animate",
            to: "https://motion.dev/dom/animate#options",
            target: "_blank",
            class: "text-benvp-green hover:underline underline-offset-1"
          ) %> function from Motion One.
        </p>

        <.example_3
          animate={@example_3[:animate]}
          transition={@example_3[:transition]}
          seed={@example_3[:seed]}
        />
      </div>

      <div>
        <h2 class="mb-4 text-3xl font-bold">Keyframes</h2>
        <p class="mb-8">
          You can also specify animation values as an array of values. These values will then
          be animated in sequence. In addition, an offset can be specified to determine on what point in time a certain
          keyframe should be reached.
        </p>

        <.example_4
          animate={@example_4[:animate]}
          transition={@example_4[:transition]}
          seed={@example_4[:seed]}
        />
      </div>

      <div>
        <h2 class="mb-4 text-3xl font-bold">Triggering animations client-side</h2>
        <p>
          Some animations do not require a round trip to the server. A common example
          is showing or hiding a modal dialog. The animation itself behaves the same
          as it is always performed on the client - it does not matter if it has been
          defined on the server before.
        </p>
        <p class="mt-4">
          Please refer to <%= link("LiveMotion.JS",
            to: "https://hexdocs.pm/live_motion/LiveMotion.JS.html",
            target: "_blank",
            class: "text-benvp-green hover:underline underline-offset-1"
          ) %> docs. More examples will follow.
        </p>
      </div>
    </div>
    """
  end

  defp example_1(assigns) do
    ~H"""
    <div>
      <div class="pr-4 mb-4 flex justify-between items-end">
        <.form let={f} for={:example_1} phx-change="example_change" class="flex space-x-4">
          <div>
            <%= label(f, :transform, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :transform,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @animate[:transform]
            ) %>
          </div>
        </.form>

        <.reset_button value="example_1" />
      </div>

      <.example id="example-1" code={example_1_code(assigns)}>
        <LiveMotion.motion
          id={"example-1-rectangle-#{@seed}"}
          class="w-24 h-24 bg-purple-600 rounded-lg"
          animate={@animate}
          transition={@transition}
        >
        </LiveMotion.motion>
      </.example>
    </div>
    """
  end

  defp example_1_code(assigns) do
    """
    <LiveMotion.motion
      id="example-1-rectangle"
      class="w-24 h-24 bg-purple-600 rounded-lg"
      animate={[transform: "#{assigns[:animate][:transform]}"]}
      transition={[duration: 0.5]}
    >
    </LiveMotion.motion>
    """
  end

  defp example_2(assigns) do
    ~H"""
    <div>
      <div class="pr-4 mb-4 flex justify-between items-end">
        <.form let={f} for={:example_2} phx-change="example_change" class="flex space-x-4">
          <div>
            <%= label(f, :rotate, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :rotate,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @animate[:rotate]
            ) %>
          </div>

          <div>
            <%= label(f, :x, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :x,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @animate[:x]
            ) %>
          </div>

          <div>
            <%= label(f, :scale, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :scale,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @animate[:scale]
            ) %>
          </div>
        </.form>

        <.reset_button value="example_2" />
      </div>

      <.example id="example-2" code={example_2_code(assigns)}>
        <LiveMotion.motion
          id={"example-2-rectangle-#{@seed}"}
          class="w-24 h-24 bg-purple-600 rounded-lg"
          animate={@animate}
          transition={@transition}
        >
        </LiveMotion.motion>
      </.example>
    </div>
    """
  end

  defp example_2_code(assigns) do
    """
    <LiveMotion.motion
      id="example-2-rectangle"
      class="w-24 h-24 bg-purple-600 rounded-lg"
      animate={[
        x: #{assigns[:animate][:x]},
        rotate: #{assigns[:animate][:rotate]},
        scale: #{assigns[:animate][:scale]}
      ]}
      transition={[duration: #{assigns[:transition][:duration]}]}
    >
    </LiveMotion.motion>
    """
  end

  defp example_3(assigns) do
    ~H"""
    <div>
      <div class="pr-4 mb-4 flex justify-between items-end">
        <.form let={f} for={:example_3} phx-change="example_change" class="flex space-x-4">
          <div>
            <%= label(f, :rotate, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :rotate,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @animate[:rotate]
            ) %>
          </div>

          <div>
            <%= label(f, :duration, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :duration,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @transition[:duration]
            ) %>
          </div>

          <div>
            <%= label(f, :repeat, class: "block text-sm font-medium text-gray-400") %>
            <%= text_input(f, :repeat,
              type: :number,
              class:
                "mt-1 px-2 py-1 block bg-black rounded-lg border border-gray-800 focus:ring-benvp-green focus:border-benvp-green",
              value: @transition[:repeat]
            ) %>
          </div>
        </.form>

        <.reset_button value="example_3" />
      </div>

      <.example id="example-3" code={example_3_code(assigns)}>
        <LiveMotion.motion
          id={"example-3-rectangle-#{@seed}"}
          class="w-24 h-24 bg-purple-600 rounded-lg"
          animate={@animate}
          transition={@transition}
        >
        </LiveMotion.motion>
      </.example>
    </div>
    """
  end

  defp example_3_code(assigns) do
    """
    <LiveMotion.motion
      id="example-3-rectangle"
      class="w-24 h-24 bg-purple-600 rounded-lg"
      animate={[rotate: #{assigns[:animate][:rotate]}]}
      transition={[
        duration: #{assigns[:transition][:duration]},
        repeat: #{assigns[:transition][:repeat]},
        easing: "#{assigns[:transition][:easing]}",
        direction: "#{assigns[:transition][:direction]}",
      ]}
    >
    </LiveMotion.motion>
    """
  end

  defp example_4(assigns) do
    ~H"""
    <div>
      <div class="pr-4 mb-4 flex justify-between items-end">
        <div></div>
        <.reset_button value="example_4" />
      </div>

      <.example id="example-4" code={example_4_code(assigns)}>
        <LiveMotion.motion
          id={"example-4-rectangle-#{@seed}"}
          class="w-24 h-24 bg-purple-600 rounded-lg"
          animate={@animate}
          transition={@transition}
        >
        </LiveMotion.motion>
      </.example>
    </div>
    """
  end

  defp example_4_code(assigns) do
    """
    <LiveMotion.motion
      id="example-4-rectangle"
      class="w-24 h-24 bg-purple-600 rounded-lg"
      animate={[
        x: [#{Enum.join(assigns[:animate][:x], ", ")}]
      ]}
      transition={[
        duration: #{assigns[:transition][:duration]},
        offset: [#{Enum.join(assigns[:transition][:offset], ", ")}]
      ]}
    >
    </LiveMotion.motion>
    """
  end

  defp reset_button(assigns) do
    ~H"""
    <button type="button" name="reset" phx-click="reset_example" value={@value}>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-5 w-5 text-gray-600 hover:text-gray-300"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        stroke-width="2"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6"
        />
      </svg>
    </button>
    """
  end

  defp example(assigns) do
    ~H"""
    <div class="flex flex-col rounded-lg border border-gray-800">
      <div class="flex flex-1">
        <div class="flex-1 border-r border-gray-800">
          <div class="border-b border-gray-800 px-4 py-2 text-gray-400 text-sm font-bold">
            HEEx
          </div>
          <div class="px-5 py-4">
            <pre id={@id} class="language-elixir" phx-hook="Prism">
              <code><%= @code %></code>
            </pre>
          </div>
        </div>

        <div class="flex flex-col flex-1 p-2">
          <div class="flex flex-1 justify-center items-center overflow-hidden">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp assign_initial_examples(socket) do
    socket
    |> assign_initial_example(:example_1)
    |> assign_initial_example(:example_2)
    |> assign_initial_example(:example_3)
    |> assign_initial_example(:example_4)
  end

  defp assign_initial_example(socket, :example_1 = key) do
    assign(socket, key,
      seed: seed(),
      animate: [transform: "rotate(45deg)"],
      transition: [duration: 0.5]
    )
  end

  defp assign_initial_example(socket, :example_2 = key) do
    assign(socket, key,
      seed: seed(),
      animate: [rotate: 90, x: 65, scale: 1.1],
      transition: [duration: 1]
    )
  end

  defp assign_initial_example(socket, :example_3 = key) do
    assign(socket, key,
      seed: seed(),
      animate: [rotate: 90],
      transition: [
        duration: 1,
        repeat: 3,
        easing: "ease-in-out",
        direction: "alternate"
      ]
    )
  end

  defp assign_initial_example(socket, :example_4 = key) do
    assign(socket, key,
      seed: seed(),
      animate: [x: [0, -80, 80, 0]],
      transition: [duration: 2, offset: [0, 0.25, 0.75]]
    )
  end

  defp seed, do: Enum.random(1..1000)
end
