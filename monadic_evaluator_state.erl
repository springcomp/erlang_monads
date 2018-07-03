-module(monadic_evaluator_state).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 9) 2.8. Variation two: State.

eval({con, A}) -> state_monad:unit(A);
eval({divide, T, U}) ->
    state_monad:bind(eval(T), fun(A) -> 
        state_monad:bind(eval(U), fun(B) ->
            state_monad:bind(state_monad:tick(), fun(_) ->
                state_monad:unit(A div B)
                end)
            end)
        end)
.

% EUnit

eval_test() ->
    M = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}}),
    {42, 2} = M(0)
.