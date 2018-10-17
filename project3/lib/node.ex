defmodule Project3.Node do
  use GenServer

  def start_link args do
    {node_no, _, _, _} = args
    GenServer.start_link __MODULE__, args, name: :"#{node_no}"
  end

  def init args do
    schedule_request
    {node_no, num_requests, num_nodes, m} = args
    {:ok, {node_no, num_requests, num_nodes, m}}
  end

  def handle_info :new_request, state do
    IO.inspect state
    schedule_request
    {node_no, num_requests, num_nodes, m} = state
    new_state = {node_no, num_requests-1, num_nodes, m}
    {:noreply, new_state}
  end

  defp schedule_request do
    Process.send_after self(), :new_request, 1000
  end
end
