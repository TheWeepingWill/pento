defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok,
     assign(
       socket,
       score: 0,
       message: "Guess a number.",
       time: time(),
       rand_number: rand(),
       user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
       session_id: session["live_socket_id"]
     )}
  end

  def rand() do
    to_string(:rand.uniform(10))
  end

  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
    <%= @message %>
    It's <%= @time %>
    </h2>

    <h6> <%= @rand_number %> </h6>

    <h2>
    <%= for n <- 1..10 do %>
    <a href"#" phx-click="guess" phx-value-number="<%= n %>"> <%= n %> </a>
    <% end %>
    </h2>
    <pre>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event(
        "guess",
        %{"number" => current} = data,
        %{assigns: %{rand_number: current}} = socket
      ) do
    message = "Weanner weanner chicken dinner"
    score = socket.assigns.score + 1

    {:noreply, assign(socket, score: score, message: message, time: time(), rand_number: rand())}
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again."
    score = socket.assigns.score - 1
    {:noreply, assign(socket, score: score, message: message, time: time())}
  end
end
