-module(exceptions_monad).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

unit(A) -> {return, A}.
bind(M, Fun) ->
    case M of 
        {raise, Ex} -> {raise, Ex};
        {return, A} -> Fun(A)
    end
.

raise(Ex) -> {raise, Ex}.

% arbitrary functions used in unit-tests
k(A) -> {return, A * A}.
h(A) -> {return, A + 1}.

left_unit_test() ->
    ?assert(k(42) =:= bind(unit(42), fun k/1)).

right_unit_test() ->
    ?assert({return, 42} =:= bind({return, 42}, fun unit/1)).

associative_test() ->
    ?assert(
        bind({return, 42}, fun(X) -> bind(k(X), fun(Y) -> h(Y) end) end) =:=
        bind(bind({return, 42}, fun(X) -> k(X) end), fun(Y) -> h(Y) end)
    )
.