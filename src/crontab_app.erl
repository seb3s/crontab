%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc
%%% @copyright
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%_* Module declaration ===============================================
-module(crontab_app).
-behaviour(application).

%%%_* Exports ==========================================================
-export([ start/2
        , stop/1
        ]).

%%%_* Code =============================================================
start(normal, Args) ->
  case crontab_sup:start_link(Args) of 
    {of, Pid} -> 
      setup(), 
      {ok, Pid};
    Error -> 
      Error
  end.

stop(_S) ->
  ok.


setup() ->
  case application:get_env(crontab, jobs) of 
    {ok, Crontab} ->
      lists:foreach(fun([Name, Spec, MFA]) ->
        crontab:add(Name, Spec, MFA) 
      end,
      Crontab);
    undefined ->
      ok
  end.

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
