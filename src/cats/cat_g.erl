-module(cat_g).
-author("abrinza").
-behavior(gen_server).

-record(cat, {name, color = green, description}).

%% API
-compile(export_all).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat = #cat{}) ->
  gen_server:cast(Pid, {deallocate, Cat}).

close_shop(Pid) ->
  gen_server:call(Pid, terminate).

init(Args) ->
  {ok, Args}.

handle_call({order, Name, Color, Description}, _From, Cats) ->
  case Cats of
    [] -> {reply, make_cat(Name, Color, Description), Cats};
    State -> {reply, hd(State), tl(State)}
  end;
handle_call(terminate, _From, Cats) ->
  {stop, normal, ok, Cats}.

handle_cast({deallocate, Cat}, Cats) ->
  {noreply, [Cat | Cats]}.

make_cat(Name, Col, Desc) ->
  #cat{name = Name, color = Col, description = Desc}.

terminate(_Reason, Cats) ->
  [io:format("~p was set free.~n", [C#cat.name]) || C <- Cats],
  ok.

handle_info(Msg, Cats) ->
  io:format("Unexpected message: ~p~n", [Msg]),
  {noreply, Cats}.

code_change(_OldVsn, State, _Extra) ->
  %% No change planned. The function is there for the behavior,
  %% but will not be used.
  {ok, State}.


