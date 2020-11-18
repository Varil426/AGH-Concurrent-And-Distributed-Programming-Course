-module(lab5).

-compile(export_all).

-import(rand, [uniform/1]).

zad1(N) ->
    Receiver = spawn(lab5, receiver, []),
    Middleman = spawn(lab5, middleman, [Receiver]),
    producent(N, Middleman).

receiver() ->
    receive
        {1, Msg} -> io:format("Wiadomosc: ~w ~n", [Msg]);
        {_, Msg} ->
            io:format("Wiadomosc: ~w ~n", [Msg]),
            receiver()
    end.

middleman(Receiver) ->
    receive
        {1, Msg} -> Receiver ! {1, Msg};
        {N, Msg} ->
            Receiver ! {N, Msg},
            middleman(Receiver)
    end.

producent(0, _) -> pass;
producent(N, Middleman) ->
    Middleman ! {N, uniform(10)},
    producent(N - 1, Middleman).

zad2(Data, N) ->
    Receiver = spawn(lab5, receivingBuffer, [[]]),
    Processes = startProcesses(N, [], Receiver),
    dataProcessing(Data, Processes),
    stopProcessing(Processes),
    Receiver ! fin,
    % sleep dodany aby dane wypisaly sie w calosci bez "ok" w srodku
    timer:sleep(200).

dataProcessing([], _) ->
    io:format("Koniec przetwarzania strumienia wejsciowego ~n");
dataProcessing(Data, Processes) ->
    SelectedProcess = lists:nth(length(Data) rem
                                    length(Processes)
                                    + 1,
                                Processes),
    [H | T] = Data,
    SelectedProcess ! H,
    dataProcessing(T, Processes).

receivingBuffer(Buffer) ->
    receive
        fin ->
            io:format("Koniec procesu buffora odbierajacego: "
                      "~p ~nDane to: ~n",
                      [self()]),
            printList(Buffer);
        Data -> receivingBuffer(Buffer ++ [Data])
    end.

printList(List) ->
    io:format("["),
    printListHelper(List).

printListHelper([]) -> io:format("]~n");
printListHelper([H | T]) ->
    io:format("~w, ", [H]),
    printListHelper(T).

startProcesses(0, Processes, _) -> Processes;
startProcesses(N, Processes, Receiver) ->
    startProcesses(N - 1,
                   Processes ++ [spawn(lab5, processData, [Receiver])],
                   Receiver).

processData(Receiver) ->
    receive
        fin ->
            io:format("Koniec procesu przetwarzajacego: ~p ~n",
                      [self()]);
        Data ->
            Receiver ! Data * 2,
            processData(Receiver)
    end.

stopProcessing([]) ->
    io:format("Zatrzymano procesy przetwarzajace dane ~n");
stopProcessing([H | T]) ->
    H ! fin,
    stopProcessing(T).
