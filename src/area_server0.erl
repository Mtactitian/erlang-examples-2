-module(area_server0).
-author("abrinza").

-export([start/0, area/2, loop/0]).

start() -> spawn(?MODULE, loop, []).

area(Pid, What) when is_tuple(What) ->
  rpc(Pid, What).

rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} -> Response
  end.

loop() ->
  receive
    {Pid, {rectangle, Width, Ht}} ->
      Pid ! {self(), Width * Ht},
      loop();
    {Pid, {square, Side}} ->
      Pid ! {self(), Side * Side},
      loop()
  end.