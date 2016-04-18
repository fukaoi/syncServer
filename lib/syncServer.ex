defmodule SyncServer do
  use Application
  require Logger

  # def start(_type, _args) do
  #   import Supervisor.Spec
  #
  #   children = [
  #     supervisor(Task.Supervisor, [[name: SyncServer.TaskSupervisor]]),
  #     worker(Task, [SyncServer, :accept, [4040]])
  #   ]
  #
  #   opts = [_strategy: :one_for_one, name: SyncServer.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Acceptiong connections on port#{port}"
    loop_acceptor socket
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    # {:ok, pid} = Task.Supervisor.start_child(Supervisor.supervisor(), fn -> serve(client) end)
    # :ok = :gen_tcp.controlling_process(client, pid)
    serve client
    loop_acceptor socket
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line socket

    serve socket
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    Logger.info data
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
