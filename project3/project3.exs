[numNodes, numRequests] = System.argv()

Project3.start numNodes, numRequests, self()

receive do
  :done ->
    IO.puts "finished"
    :ok
end
