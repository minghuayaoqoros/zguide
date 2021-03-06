defmodule Tasksink do
  @moduledoc """
  Generated by erl2ex (http://github.com/dazuma/erl2ex)
  From Erlang source: (Unknown source file)
  At: 2019-12-20 13:57:36

  """

  def main() do
    {:ok, context} = :erlzmq.context()
    {:ok, receiver} = :erlzmq.socket(context, :pull)
    :ok = :erlzmq.bind(receiver, 'tcp://*:5558')
    {:ok, _} = :erlzmq.recv(receiver)
    start = :erlang.now()
    process_confirmations(receiver, 100)
    :io.format('Total elapsed time: ~b msec~n', [div(:timer.now_diff(:erlang.now(), start), 1000)])
    :ok = :erlzmq.close(receiver)
    :ok = :erlzmq.term(context)
  end


  def process_confirmations(_receiver, 0) do
    :ok
  end

  def process_confirmations(receiver, n) when n > 0 do
    {:ok, _} = :erlzmq.recv(receiver)
    case(n - rem(1, 10)) do
      0 ->
        :io.format(':')
      _ ->
        :io.format('.')
    end
    process_confirmations(receiver, n - 1)
  end

end

Tasksink.main
