defmodule Project3.Node do
  use GenServer

  def start_link args do
    {node_no, _, _, _} = args
    GenServer.start_link __MODULE__, args, name: :"#{node_no}"
  end

  def init args do
    schedule_request()
    {node_no, num_requests, num_nodes, m} = args
    {:ok, {node_no, num_requests, num_nodes, m}}
  end

  #TODO convert to call for bonus
  def handle_cast {:send, {dest, hop_count}}, state do
    {node_no, _, _, _} = state

    if dest == node_no do
      GenServer.cast :Server, {:message_delivered, hop_count}
    else
      # TODO hop_count++ & forward message
    end
    {:noreply, state}
  end

  def handle_info :new_request, state do
    {node_no, num_requests, num_nodes, m} = state

    if num_requests == 0 do
      GenServer.cast :Server, :node_finished
      {:noreply, state}
    else
      dest = Enum.random 1..num_nodes
      GenServer.cast String.to_atom("#{node_no}"), {:send, {dest, 1}}

      schedule_request()
      new_state = {node_no, num_requests-1, num_nodes, m}
      {:noreply, new_state}
    end
  end

  defp schedule_request do
    Process.send_after self(), :new_request, 1000
  end
end
