-module(state_monad).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

unit(A) -> fun(State) -> {A, State} end.
bind(M, Fun) ->
    fun(X) ->
        {A, Y} = M(X),
        (Fun(A))(Y)
        %{B, Z}
    end
.

tick() ->
    fun(X) ->
        {undefined, X + 1}
    end
.

% arbitrary functions used in unit-tests
k(A) -> fun(State) -> {A * A, State} end.
h(A) -> fun(State) -> {A + 1, State} end.

left_unit_test() ->
    FunA = k(42),
    FunB = bind(unit(42), fun k/1),
    ?assert(FunA(33) =:= FunB(33)).

right_unit_test() ->
    FunA = fun(State) -> {42, State} end,
    FunB = bind(fun(S) -> {42, S} end, fun unit/1),
    ?assert(FunA(33) =:= FunB(33)).

associative_test() ->
    FunA = bind(unit(42), fun(X) -> bind(k(X), fun(Y) -> h(Y) end) end),
    FunB = bind(bind(unit(42), fun(X) -> k(X) end), fun(Y) -> h(Y) end),
    ?assert(FunA(33) =:= FunB(33))
.