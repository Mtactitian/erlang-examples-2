-module(lib_misc).
-author("abrinza").
-include("assertion.hrl").
-compile(export_all).


start(Time, Fun) -> spawn(fun() -> timer(Time, Fun) end).
cancel(Pid) -> Pid ! cancel.

do(_Function, 0) -> done;
do(Function, Times) ->
  Function(),
  do(Function, Times - 1).

start2() ->
  FirstPid = spawn(?MODULE:do(fun() -> io:fwrite("called first pid function\n") end, 3)),
  SecondPid = spawn(?MODULE:do(fun() -> io:fwrite("called second pid function\n") end, 2)),
  [FirstPid, SecondPid].

timer(Time, Fun) ->
  receive
    cancel -> void
  after Time -> Fun()
  end.

seconds_to_millis(Seconds) -> Seconds * 1000.

start_ping_pong(Times) ->
  PingPid = spawn(?MODULE, ping, [Times]),
  PongPid = spawn(?MODULE, pong, []),
  PingPid ! {"Pong", PongPid},
  ok.

ping(0) -> io:fwrite("Finished Ping Pong\n");
ping(Times) ->
  receive
    {Msg, Pid} -> io:fwrite(Msg),
      Pid ! {"Ping\n", self()},
      ping(Times - 1)
  end.

pong() ->
  receive
    {Msg, Pid} -> io:fwrite(Msg),
      Pid ! {"Pong\n", self()},
      pong()
  end.

start3(Seconds, Fun) -> register(timer, spawn(?MODULE, tick, [Seconds, Fun])).

tick(Seconds, Fun) ->
  receive
    stop -> ok
  after seconds_to_millis(Seconds) ->
    Fun(),
    tick(Seconds, Fun)
  end.

on_exit(Pid, Fun) ->
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive
      {'Down', Ref, process, Pid, Why} ->
        Fun(Why)
    end
        end).

create_proc() -> spawn(?MODULE, mock_proc, []).

mock_proc() ->
  receive
    {exit, Value} -> exit(Value)
  end.