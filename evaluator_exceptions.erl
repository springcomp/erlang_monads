-module(evaluator_exceptions).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 3) 2.2. Variation one: Exceptions.

eval({con, A}) -> {return, A};
eval({divide, T, U}) ->
    case eval(T) of
        {raise, ExT} -> {raise, ExT};
        {return, A} -> 
            case eval(U) of
                {raise, ExU} -> {raise, ExU};
                {return, B} ->
                    case B of
                        0 -> {raise, divide_by_zero};
                        _ -> {return, A div B}
                    end
            end
    end
.

% EUnit

eval_test() ->
    {return, 42} = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.
eval_divide_by_zero_test() ->
    {raise, divide_by_zero} =
        eval({divide, {con, 42}, {con, 0}})
.
