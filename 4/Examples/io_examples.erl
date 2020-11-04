-module(io_examples).
-export([numbers/1]).
-export([float_numbers/1]).
-export([string/1]).
-export([standard_syntax_w/1]).
-export([standard_syntax_p/1]).

numbers(N) -> io:format("Numbers is ~p \n", [N]), the_end_here.

float_numbers(N) -> io:format("The float number is ~f \n", [N]).

string(N) -> io:format("The entered string data is ~s ~n", [N]).

% --- Writes data with the standard syntax. This is used to output Erlang terms.

standard_syntax_w(N) -> io:format("The entered data is ~w ~n", [N]).

standard_syntax_p(N) -> io:format("The entered data is ~p ~n", [N]).


