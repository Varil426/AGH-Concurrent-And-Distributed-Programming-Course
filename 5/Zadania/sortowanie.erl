-module(sortowanie).

-compile(export_all).

% Aby przetestowac nalezy uruchomic main podajac jako argument liste do posortowania

% Merge Sort - wziete z lab3
split(List) -> split(List, List, []).

split([], Back, Front) -> {revert(Front), Back};
split([_], Back, Front) -> {revert(Front), Back};
split([_, _ | Counter], [H | T], Result) ->
    split(Counter, T, [H | Result]).

merge([], []) -> [];
merge([], L2) -> L2;
merge(L1, []) -> L1;
merge([H1 | T1], [H2 | T2]) ->
    if H1 >= H2 -> [H1 | merge(T1, [H2 | T2])];
       true -> [H2 | merge(T2, [H1 | T1])]
    end.

revert([], Accumulator) -> Accumulator;
revert([H | T], Accumulator) ->
    revert(T, [H] ++ Accumulator).

revert([H | T]) -> revert(T, [H] ++ []).

mergeSortSequential([]) -> [];
mergeSortSequential([A]) -> [A];
mergeSortSequential([A, B]) ->
    if A >= B -> [A, B];
       true -> [B, A]
    end;
mergeSortSequential(L) ->
    {L1, L2} = split(L),
    merge(mergeSortSequential(L1), mergeSortSequential(L2)).

mergeSortConcurrent(List) ->
    spawn(sortowanie, mergeSortConcurrent, [List, self()]),
    receive {done, A} -> printList(A) end.

mergeSortConcurrent([], Parent) -> Parent ! {done, []};
mergeSortConcurrent([A], Parent) ->
    Parent ! {done, [A]};
mergeSortConcurrent([A, B], Parent) ->
    if A >= B -> Parent ! {done, [A, B]};
       true -> Parent ! {done, [B, A]}
    end;
mergeSortConcurrent(L, Parent) ->
    {L1, L2} = split(L),
    spawn(sortowanie, mergeSortConcurrent, [L1, self()]),
    spawn(sortowanie, mergeSortConcurrent, [L2, self()]),
    receive
        {done, L1Done} ->
            receive
                {done, L2Done} -> Parent ! {done, merge(L1Done, L2Done)}
            end
    end.

main(List) ->
    io:format("Sekwencyjnie~n"),
    {Time1, SortedList} = timer:tc(sortowanie,
                                   mergeSortSequential,
                                   [List]),
    printList(SortedList),
    io:format("Czas: ~w ~n", [Time1]),
    io:format("Wspolbieznie~n"),
    {Time2, _} = timer:tc(sortowanie,
                          mergeSortConcurrent,
                          [List]),
    io:format("Czas: ~w ~n", [Time2]).

printList(List) ->
    io:format("["),
    printListHelper(List).

printListHelper([]) -> io:format("]~n");
printListHelper([H | T]) ->
    io:format("~w, ", [H]),
    printListHelper(T).
