-module(listy).

-export([amax/1,
         amin/1,
         bubbleSort/1,
         conv_temp/2,
         decreasingList/1,
         generate/1,
         len/1,
         lmin_max/1,
         mergeSort/1,
         pola/1,
         tmin_max/1]).

-import(powrot_do_liceum, [pole/1]).

len([]) -> 0;
len([_ | T]) -> 1 + len(T).

min1(A, brak) -> A;
min1(A, B) when A =< B -> A;
min1(A, B) when A > B -> B.

amin([]) -> brak;
amin([H | T]) -> min1(H, amin(T)).

max1(A, brak) -> A;
max1(A, B) when A >= B -> A;
max1(A, B) when A < B -> B.

amax([]) -> brak;
% W ten sposob mozna porownac liste dwu elementowa o jednakowych elementach
% amax([H, H]) -> H;
amax([H | T]) -> max1(H, amax(T)).

tmin_max([]) -> brak;
tmin_max(L) -> {amin(L), amax(L)}.

lmin_max([]) -> brak;
lmin_max(L) -> [amin(L), amax(L)].

pola([]) -> [];
pola([H | T]) -> [pole(H)] ++ pola(T).

decreasingList(1) -> [1];
decreasingList(N) when N > 0 ->
    [N] ++ decreasingList(N - 1);
decreasingList(_) -> error.

% Konwerter Temperatur
% c - celcius, k - kelvin, f - fahrenheit, r - rankine scale
conv_temp({InputType, Value}, c) ->
    if InputType =:= c -> {c, Value};
       InputType =:= k -> {c, Value - 2.731e+2};
       InputType =:= f -> {c, (Value - 32) * (5 / 9)};
       InputType =:= r -> {c, (Value - 4.9167e+2) * (5 / 9)};
       true -> error
    end;
conv_temp({InputType, Value}, f) ->
    if InputType =:= f -> {f, Value};
       InputType =:= c -> {f, Value * (9 / 5) + 32};
       true -> conv_temp(conv_temp({InputType, Value}, c), f)
    end;
conv_temp({InputType, Value}, k) ->
    if InputType =:= k -> {k, Value};
       InputType =:= c ->
           {k, Value + 2.73149999999999977263e+2};
       true -> conv_temp(conv_temp({InputType, Value}, c), k)
    end;
conv_temp({InputType, Value}, r) ->
    if InputType =:= r -> {r, Value};
       InputType =:= c -> {r, Value * (9 / 5) + 4.9167e+2};
       true -> conv_temp(conv_temp({InputType, Value}, c), r)
    end;
conv_temp(_, _) -> error.

% Generator listy o zadanej dlugosci
generate(0) -> [];
% Alternatywna mozliwosc zapisu
%generate(N) when N > 0 -> [1] ++ generate(N - 1);
generate(N) when N > 0 -> [1 | generate(N - 1)];
generate(_) -> error.

% Sortowanie

%Bubble Sort
bubbleSort([]) -> [];
bubbleSort(L) -> bubbleSortHelper(L, [], true).

%last([]) -> error;
%last([E]) -> E;
%last([_ | T]) -> last(T).

revert([], Accumulator) -> Accumulator;
revert([H | T], Accumulator) ->
    revert(T, [H] ++ Accumulator).

revert([H | T]) -> revert(T, [H] ++ []).

bubbleSortHelper([F, S | T], Accumulator, Bool) ->
    if F >= S ->
           bubbleSortHelper([S | T], Accumulator ++ [F], Bool);
       true ->
           bubbleSortHelper([F | T], Accumulator ++ [S], false)
    end;
bubbleSortHelper([E], [], _) -> E;
bubbleSortHelper([E], Accumulator, Bool) ->
    bubbleSortHelper([], Accumulator ++ [E], Bool);
bubbleSortHelper([], [], _) -> [];
bubbleSortHelper([], Accumulator, false) ->
    bubbleSortHelper(Accumulator, [], true);
bubbleSortHelper([], Accumulator, true) ->
    revert(Accumulator).

split(List) -> split(List, List, []).

% Merge Sort
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

mergeSort([]) -> [];
mergeSort([A]) -> [A];
mergeSort([A, B]) ->
    if A >= B -> [A, B];
       true -> [B, A]
    end;
mergeSort(L) ->
    {L1, L2} = split(L),
    merge(mergeSort(L1), mergeSort(L2)).

% Dlaczego lista [11,12] i [12,11] niepoprawnie sie wypisuja? -Sortuje poprawnie, ale efektem wypisania jest "\v\f" i "\f\v"

