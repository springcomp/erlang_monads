-module(evaluator_state).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 3) 2.1. Variation zero: The basic evaluator.

eval(T) -> eval(T, 0).

eval({con, A}, X) -> {A, X};
eval({divide, T, U}, X) ->
    {A, Y} = eval(T, X),
    {B, Z} = eval(U, Y),
    {A div B, Z + 1}.

% EUnit

eval_test() ->
    {42, 2} = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.