-module(monadic_evaluator).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 8) 2.6. Variation zero revisited: The basic evaluator.

eval({con, A}) -> identity_monad:unit(A);
eval({divide, T, U}) ->
    identity_monad:bind(eval(T), fun(A) -> 
        identity_monad:bind(eval(U), fun(B) ->
            identity_monad:unit(A div B)
            end)
        end)
.

% EUnit

eval_test() ->
    42 = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.