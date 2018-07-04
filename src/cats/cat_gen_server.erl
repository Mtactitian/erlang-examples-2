-module(cat_gen_server).
-behaviour(gen_server).

-record(cat, {name, color, description}).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
  [{init, 1}, {some_fun, 0}, {other, 3}];
behaviour_info(_) -> undefined.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

init(Args) ->
  ok.

order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat) ->
  gen_server:cast(Pid, Cat).

handle_call({order, Name, Color, Description}, _From, State) ->
  case State of
    [] -> {reply, make_cat(Name, Color, Description), []};
    [Cats] -> {reply, hd(Cats), tl(Cats)}
  end;

handle_call(terminate, _From, Cats) ->
  {stop, norma, ok, Cats}.


close_shop(Pid) ->
  gen_server:call(Pid, terminate).

make_cat(Name, Color, Description) ->
  #cat{name = Name, color = Color, description = Description}.

terminate_cats(Cats) ->
  lists:foreach(fun(CatName) -> io:fwrite(atom_to_list(CatName) ++ " is free now\n") end, [C#cat.name || C <- Cats]),
  ok.