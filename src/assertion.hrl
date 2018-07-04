-author("abrinza").

-define(assertionError, fun() -> error('Assertion Error') end).
-define(assertEquals, fun(Expected, Actual) ->
  case Expected == Actual of
    true -> ok;
    false -> ?assertionError()
  end end).

-define(assertTrue, fun(Value) -> case Value of
                                    true -> ok;
                                    false -> ?assertionError()
                                  end end).
-define(assertFalse, fun(Value) -> case Value of
                                     false -> ok;
                                     true -> ?assertionError()
                                   end end).