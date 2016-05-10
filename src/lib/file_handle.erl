-module (file_handle).
-export ([readlines/1, get_all_lines/1,split/2,split_handle/1,
            list_head/1,drop_end/1,app_start/1]).
-import (file, [open/2,close/1]).
-import (string, [
                    tokens/2,
                    len/1,
                    join/2
                    ]).

-import (lists, [last/1,append/2]).


readlines(FileName) ->
    {ok, Device} = open(FileName, [read]),
    try 
        get_all_lines(Device)
    after 
        close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  ->
            [];
        Line ->
            Line ++ get_all_lines(Device)
    end.

split(String,Kw) ->
    tokens(String,Kw).


split_handle([]) ->
    [];
split_handle([H|T]) ->
    ResultList = split(H,"\t:"),
    if
        length(ResultList) =:= 0 ->
            [{none,none}];
        length(ResultList) =:= 1 ->
            [{list_head(last(ResultList)),none}];
        length(ResultList) =:= 2 ->
            [S,E] = ResultList,
            [{list_head(S),E} | split_handle(T)];
        length(ResultList) > 2 ->
            [HH,TT] = zip_list(ResultList),
            [{list_head(HH),TT} | split_handle(TT)]
    end.

zip_list(List) ->
    [H|T] = List,
    case length(List) > 2 of
        true ->
            append([list_to_atom(H)], list_add(T));
        false ->
            List
    end.

list_add([]) ->
    [];
list_add([H|T]) ->
    [H ++ list_add(T)].


list_head(X) ->
    HeadList = split(X," "),
    if
        length(HeadList) =:= 2 ->
            join(HeadList,"_");
        length(HeadList) =/= 2 ->
            X
    end.

drop_end([]) ->
    [];
drop_end([H|T]) ->
    case is_tuple(H) of
        true ->
            {A,B,_} = H,
            append([{A,B}],drop_end(T));
        false ->
            []
    end.


app_start(A) ->
    case application:start(A) of
        ok ->
            ok;
        error ->
            error
    end.