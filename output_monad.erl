-module(output_monad).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

unit(A) -> {"", A}.
bind(M, Fun) ->
    {X, A} = M,
    {Y, B} = Fun(A),
    {X ++ Y, B}
.

output(S) ->
    {S, undefined}
.

% arbitrary functions used in unit-tests
k(A) -> {"", A * A}.
h(A) -> {"H", A + 1}.

left_unit_test() ->
    ?assert(k(42) =:= bind(unit(42), fun k/1)).

right_unit_test() ->
    ?assert({"42", 42} =:= bind({"42", 42}, fun unit/1)).

associative_test() ->
    ?assert(
        bind({"42", 42}, fun(X) -> bind(k(X), fun(Y) -> h(Y) end) end) =:=
        bind(bind({"42", 42}, fun(X) -> k(X) end), fun(Y) -> h(Y) end)
    )
.