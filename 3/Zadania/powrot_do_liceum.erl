-module(powrot_do_liceum).

-export([objetosc/1, pole/1]).

-import(math, [pow/2]).

%To chyba powinien byc prostokat
pole({kwadrat, X, Y}) -> X * Y;
pole({kolo, X}) -> 3.14 * X * X;
%Dodany kod ponizej
pole({trojkat, A, H}) -> A * H / 2;
pole({trapez, A, B, H}) -> (A + B) * H / 2;
%pole({kula, R}) -> 4 * pi * pow(R, 2);
% Kolejnosc obliczen jak powyzej powoduje 'badarith' exception
% Uzycie pi - powoduje error when evaluating - odpowiedz ze stack'a - mozliwe przekroczenie pojemnosci float
pole({kula, R}) -> pow(R, 2) * 3.14 * 4;
pole({szescian, A}) -> pow(A, 2) * 6;
pole({stozek, R, L}) -> 3.14 * pow(R, 2) + 3.14 * R * L.

objetosc({kula, R}) -> 4 / 3 * (3.14 * pow(R, 3));
objetosc({szescian, A}) -> pow(A, 3);
objetosc({stozek, R, H}) ->
    pow(R, 2) * H * (1 / 3) * 3.14.
