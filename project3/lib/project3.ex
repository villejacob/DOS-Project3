defmodule Project3 do
  alias Project3.Node
  use GenServer

  def start_link args do
    GenServer.start_link __MODULE__, args, name: :Server
  end

  def init args do
    {entry_pid, num_nodes, num_requests} = args
    # state = {entry_pid, num_nodes, num_requests, total_hops}
    {:ok, {entry_pid, num_nodes, num_requests, 0}}
  end

  def start num_nodes, num_requests, pid do
    num_nodes = num_nodes |> String.to_integer
    num_requests = num_requests |> String.to_integer

    start_link {pid, num_nodes, num_requests}
    create_network num_nodes, num_requests
  end

  def create_network num_nodes, num_requests do
    Enum.each 1..num_nodes, fn node_no ->
      Node.start_link {node_no, num_requests, num_nodes}
    end
  end

  def handle_cast {:message_delivered, hop_count}, state do
    {p, n, r, total_hops} = state
    new_state = {p, n, r, total_hops + hop_count}
    {:noreply, new_state}
  end

  def handle_cast {:node_finished, total_nodes}, state do
    {entry_pid, num_nodes, num_requests, total_hops} = state
    remaining_nodes = num_nodes - 1

    if remaining_nodes == 0 do
      avg_hops = total_hops / (total_nodes * num_requests)
      IO.puts "#{avg_hops}"
      send entry_pid, :done
      Process.exit self(), :normal
    end

    new_state = {entry_pid, remaining_nodes, num_requests, total_hops}
    {:noreply, new_state}
  end
end
