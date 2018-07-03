-module(monadic_evaluator_exceptions).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 8) 2.7. Variation two revisited: Exceptions.

eval({con, A}) -> exceptions_monad:unit(A);
eval({divide, T, U}) ->
    exceptions_monad:bind(eval(T), fun(A) -> 
        exceptions_monad:bind(eval(U), fun(B) ->
            case B of
                0 -> exceptions_monad:raise(divide_by_zero);
                _ -> exceptions_monad:unit(A div B)
            end
        end)
    end)
.

% EUnit

eval_test() ->
    {return, 42} = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.
eval_divide_by_zero_test() ->
    {raise, divide_by_zero} =
        eval({divide, {con, 42}, {con, 0}})
.
