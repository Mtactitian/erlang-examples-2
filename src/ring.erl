-module(ring).
-author("abrinza").

%% API
-export([start/0, send/2, start2/1, sleep/1]).

start() ->
  register(first, spawn(?MODULE, send, ["1", second])),
  register(second, spawn(?MODULE, send, ["2", third])),
  register(third, spawn(?MODULE, send, ["3", fourth])),
  register(fourth, spawn(?MODULE, send, ["4", first])),
  first ! [].

start2(N) ->
  register_processes(N, first),
  first ! go.

register_processes(1, LastPid) ->
  'All processes are successefully registered',
  register(first, spawn(?MODULE, send, [integer_to_list(1), LastPid]));

register_processes(Count, LastPid) ->
  Pid = spawn(?MODULE, send, [integer_to_list(Count), LastPid]),
  register_processes(Count - 1, Pid).

send(RingName, NextRingPid) ->
  receive
    _Any -> io:fwrite(RingName ++ " Messaged Received\n"),
      sleep(3),
      NextRingPid ! next,
      send(RingName, NextRingPid)
  end.

sleep(Seconds) ->
  receive
  after Seconds * 1000 ->
    ok
  end.