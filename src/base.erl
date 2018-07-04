-module(base).
-author("abrinza").

%% API
-compile(export_all).


worker(Value) ->
  io:fwrite("I'm Alive" ++ integer_to_list(Value)),
  exit(gg).

create_workers(N) -> [spawn_monitor(fun() -> timer:sleep(3000), worker(Val) end) || Val <- lists:seq(1, N)].

start_and_recap() ->
  spawn(fun() -> Pid_List = lists:map(fun({Pid, _}) -> Pid end, create_workers(10)),
    receive
      {'DOWN', _MonitorReference, process, _Pid, gg} -> lists:foreach(fun(Val) -> exit(Val, gg) end, Pid_List),
        start_and_recap()
    end end).