-module (wolf_drawn_main_controller,[Req]).
-export([index/2]).
-import (sys_info, [cpu_info/1,memory_info/0,operating_info/0]).


index('GET', []) ->
    O = operating_info(),
    M = memory_info(),
    C = cpu_info("/proc/cpuinfo"),
    {ok, M++C++O }.


graph('GET',[]) ->
	{ok,[]}.


oops('GET', []) ->
  {ok, []}.

about('GET', []) ->
  {ok, []}.

