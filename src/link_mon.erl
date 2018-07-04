-module(link_mon).
-author("abrinza").

-compile(export_all).

myproc() ->
  timer:sleep(5000),
  exit(reason).

chain(0) ->
  receive
    _ -> ok
  after 3000 -> exit("chain dies here")
  end;
chain(N) ->
  Pid = spawn_link(fun() -> chain(N - 1) end),
  receive
    Value -> Pid ! Value
  end.