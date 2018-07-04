-module(test).

-compile(export_all).

start() ->
  gen_server:start_link(?MODULE, [], []).

init(_Args) ->
  {ok, undefined}.

dCall(Pid) ->
  gen_server:call(Pid, {sleep, 10000}, 5000).

handle_call({sleep, Ms}, _From, LoopData) ->
  timer:sleep(Ms),
  {reply, ok, LoopData}.
