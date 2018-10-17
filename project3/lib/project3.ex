defmodule Project3 do
  alias Project3.Node
  use GenServer

  def start_link args do
    GenServer.start_link __MODULE__, args, name: :Server
  end

  def start num_nodes, num_requests, pid do
    num_nodes = num_nodes |> String.to_integer
    num_requests = num_requests |> String.to_integer

    start_link num_nodes
    create_network num_nodes, num_requests
  end

  def init num_nodes do
    {:ok, num_nodes}
  end

  def create_network num_nodes, num_requests do
    m = :math.log(num_nodes)/:math.log(2) |> :math.ceil |> round
    Enum.each 1..num_nodes, fn node_no ->
      Node.start_link {node_no, num_requests, num_nodes, m}
    end
  end
end
