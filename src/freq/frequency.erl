-module(frequency).
-author("abrinza").

%% API
-export([init/1, handle_call/3, deallocate/1, return/2, handle_cast/2, start/1, handle_info/2]).

start(No_of_freq) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, No_of_freq, []).

init(No_of_freq) ->
  Frequencies = get_frequencies(No_of_freq),
  {ok, Frequencies}.

deallocate(Pid) ->
  gen_server:call(Pid, allocate, 5000).

return(Pid, Value) ->
  gen_server:cast(Pid, {deallocate, Value}).

handle_call(allocate, _From, []) ->
  {reply, {error, no_frequency}, []};
handle_call(allocate, _From, Frequencies) ->
  {reply, {ok, hd(Frequencies)}, tl(Frequencies)}.

handle_cast({deallocate, Value}, Frequencies) ->
  {noreply, [Value | Frequencies]}.

get_frequencies(No_of_freq) ->
  lists:seq(1, No_of_freq).

handle_info(_Info, State) ->
  {noreply, State}.