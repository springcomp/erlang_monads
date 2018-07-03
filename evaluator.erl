-module(evaluator).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 3) 2.1. Variation zero: The basic evaluator.

eval({con, A}) -> A;
eval({divide, T, U}) -> eval(T) div eval(U).

% EUnit

eval_test() ->
    42 = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.