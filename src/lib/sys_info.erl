-module (sys_info).
-export ([cpu_info/1,memory_info/0,disk_info/0,operating_info/0,index_of/2,index_of/3]).

-import (erlang, [system_info/1, memory/0]).
-import (lists, [last/1,nth/2]).
-import (string, [len/1,left/2,strip/1,to_lower/1,tokens/2]).

-import (file_handle, [readlines/1,split/2,split_handle/1,drop_end/1,app_start/1]).
-define(CPU_INFO_FILE, "/proc/cpuinfo").


cpu_info(?CPU_INFO_FILE) ->
    case len(?CPU_INFO_FILE) < 1 of
        false ->
            Seed = readlines(?CPU_INFO_FILE),
            SeedList = split(Seed,"\n\n"),
            split_handle(SeedList);
        true ->
            {error,?CPU_INFO_FILE}
    end.

memory_info() ->
    memory_list_to_tuple([strip(X) || X <- tokens(os:cmd("cat /proc/meminfo"),":\n")]).

memory_list_to_tuple([]) ->
    [];
memory_list_to_tuple([H,S|T]) ->
    [{list_to_atom(to_lower(H)),S} | memory_list_to_tuple(T)].


index_of(Item, List) -> 
    index_of(Item, List, 1).

index_of(_, [], _) -> 
    not_found;
index_of(Item, [Item|_], Index) -> 
    Index;
index_of(Item, [_|Tl], Index) -> 
    index_of(Item, Tl, Index+1).


disk_info() ->
    _ = app_start(sasl),
    _ = app_start(os_mon),
    drop_end(disksup:get_disk_data()).

operating_info() ->
    [
        {system, left(os:cmd("cat /proc/version"),99)},
        {hostname,os:cmd("cat /etc/hostname")},
        {timezone,os:cmd("cat /etc/timezone")}
    ].

