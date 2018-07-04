-module(cat_fsm).
-author("abrinza").

%% API
-export([start/0, event/2]).

start() -> spawn(fun dont_give_crap/0).

event(Pid, Event) ->
  Ref = make_ref(),
  Pid ! {self(), Ref, Event},
  receive
    {Ref, Msg} -> {ok, Msg}
  after 5000 ->
    {error, timeout}
  end.

dont_give_crap() ->
  receive
    {Pid, Ref, _Msg} -> Pid ! {Ref, meh}
  end,
  io:format("Switching to 'dont_give_crap' state~n"),
  dont_give_crap().