-module(concurrency).
-compile(export_all).


car_diagnostics() ->
    receive
        velocity -> io:format("80 km/h ~n");
        number_of_kilometers -> io:format("9654 km ~n");
        _ -> io:format("Diagnostic code not recognized ~n")
    end.

car_diagnostics_with_reply_message() ->
    receive
        {From, velocity} -> 
            From ! "80 km/h";
        {From, number_of_kilometers} -> 
            From ! "9654 km";
        _ -> io:format("Diagnostic code not recognized ~n")
    end.

car_diagnostics_with_reply_message_rec() ->
    receive
        {From, velocity} -> 
            From ! "80 km/h",
            car_diagnostics_with_reply_message_rec();
        {From, number_of_kilometers} -> 
            From ! "9654 km",
            car_diagnostics_with_reply_message_rec();
        {From, end_of_diagnostic} -> 
            From ! "End of diagnostic process ~n";
        _ -> io:format("Diagnostic code not recognized ~n"),
             car_diagnostics_with_reply_message_rec()
    end.

car_fuel(FuelUsage) ->
    receive
        {From, {fill_the_fuel, Fuel}} ->
            From ! {self(), fuel_added},
            io:format("Fuel level is ~p ~n", [FuelUsage + Fuel]),
            car_fuel(FuelUsage + Fuel);
        {From, {fuel_consumption, Fuel}} ->
            From ! {self(), fuel_used},
            io:format("Fuel level is ~p ~n", [FuelUsage - Fuel]),
            car_fuel(FuelUsage - Fuel);
        terminate ->
            io:format("The end ~n")
    end.


fridge(FoodList) ->
    receive
        {From, {store, Food}} ->
            From ! {self(), ok},
            fridge([Food|FoodList]);
        {From, {take, Food}} ->
            case lists:member(Food, FoodList) of
                true ->
                    From ! {self(), {ok, Food}},
                    fridge(lists:delete(Food, FoodList));
                false ->
                    From ! {self(), not_found},
                    fridge(FoodList)
            end;
        terminate ->
            ok
    end.