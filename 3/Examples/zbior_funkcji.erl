-module(zbior_funkcji).
-export([moja_funkcja/1]).
-export([moja_druga_funkcja/2]).
-export([liczba_jest_dodatnia_czy_ujemna/1]).
-export([czy_jest_wieksze_niz/2]).
-export([jezyk_programowania/1]).
-export([beach/1]).

% podstawowe operacje arytmetyczne:
moja_funkcja({dodawanie,A,B}) -> A+B;
moja_funkcja({odejmowanie,A,B}) -> A-B;
moja_funkcja({mnozenie,A,B}) -> A*B;
moja_funkcja({dzielenie,A,B}) -> A/B;
moja_funkcja(_) -> io:format("Nic nie robie...").

% obsługa standardowego wyjscia:
moja_druga_funkcja(imie, Name) -> io:format("My name is ~s", [Name]);
moja_druga_funkcja(nazwisko, Surname) -> io:format("My surname is ~s", [Surname]);
moja_druga_funkcja(wiek, Age) -> io:format("My age is ~s", [Age]).

% uzycie dozorow:
liczba_jest_dodatnia_czy_ujemna(Liczba) when Liczba >= 0 -> "Liczba jest dodatnia";
liczba_jest_dodatnia_czy_ujemna(Liczba) when Liczba < 0 -> "Liczba jest ujemna". 

czy_jest_wieksze_niz(X,Y) ->
    if
        X > Y -> true;
        true -> io:format("~p nie jest wieksze niz ~p...", [X,Y]) % dziala jak else
    end.

jezyk_programowania(Jezyk) ->
    Rodzaj = if Jezyk == java  -> "obiektowym";
                Jezyk == haskell -> "funkcyjnym";
                Jezyk == python  -> "skryptowym";
                true -> "nieznanym tutaj"
            end,
    {Jezyk, "jest jezykiem " ++ Rodzaj ++ "!"}.

beach(Temperature) ->
    case Temperature of
        {celsius, N} when N >= 20, N =< 45 -> 'favorable';
        {kelvin, N} when N >= 293, N =< 318 -> 'scientifically favorable';
        {fahrenheit, N} when N >= 68, N =< 113 -> 'favorable in the US';
        _ -> 'avoid beach'
end.

