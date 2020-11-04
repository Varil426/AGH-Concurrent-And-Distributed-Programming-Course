-module(binaryTree).

-export([empty/0,
         generate/1,
         insert/3,
         lookup/2,
         treeFromList/1,
         treeToList/1]).

% Drzewo to krotka {node, {Key,Val, Smaller, Larger}}

empty() -> {node, nil}.

insert(Key, Val, {node, nil}) ->
    {node, {Key, Val, empty(), empty()}};
insert(NewKey, NewVal,
       {node, {Key, Val, Smaller, Larger}})
    when NewKey < Key ->
    {node,
     {Key, Val, insert(NewKey, NewVal, Smaller), Larger}};
insert(NewKey, NewVal,
       {node, {Key, Val, Smaller, Larger}})
    when NewKey > Key ->
    {node,
     {Key, Val, Smaller, insert(NewKey, NewVal, Larger)}};
insert(Key, Val, {node, {Key, _, Smaller, Larger}}) ->
    {node, {Key, Val, Smaller, Larger}}.

lookup(_, {node, nil}) -> undefined;
lookup(Key, {node, {Key, Val, _, _}}) -> {ok, Val};
lookup(Key, {node, {NodeKey, _, Smaller, _}})
    when Key < NodeKey ->
    lookup(Key, Smaller);
lookup(Key, {node, {_, _, _, Larger}}) ->
    lookup(Key, Larger).

generate(0) -> empty();
generate(Size) -> generateHelper(Size, empty()).

generateHelper(0, Root) -> Root;
generateHelper(Size, Root) ->
    NewRoot = insert(rand:uniform(100),
                     rand:uniform(100),
                     Root),
    generateHelper(Size - 1, NewRoot).

treeFromList([]) -> empty();
treeFromList(L) -> treeFromListHelper(L, empty()).

treeFromListHelper([], Root) -> Root;
treeFromListHelper([{Key, Val} | T], Root) ->
    NewRoot = insert(Key, Val, Root),
    treeFromListHelper(T, NewRoot).

treeToList({node, nil}) -> [];
treeToList({node, {Key, Val, Smaller, Larger}}) ->
    treeToList(Smaller) ++
        [{Key, Val}] ++ treeToList(Larger).
