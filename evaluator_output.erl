-module(evaluator_output).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

% http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf
% (Page 5) 2.1. Variation three: Output.

eval(Arg = {con, A}) -> {line(Arg, A), A};
eval(Term = {divide, T, U}) ->
    {X, A} = eval(T),
    {Y, B} = eval(U),
    {X ++ Y ++ line(Term, A div B), A div B}.

line(T, A) -> "eval (" ++ term(T) ++ ") <= " ++ int(A) ++ "\n".

term({con, A}) -> "{con, " ++ int(A) ++ "}";
term({divide, T, U}) -> "{div " ++ int(T) ++ ", " ++ int(U) ++ "}".

int(A) -> lists:flatten(io_lib:format("~p", [A])).

% EUnit

eval_con_test() ->
    {"eval ({con, 42}) <= 42\n", 42} = eval({con, 42})
.

eval_div_test() ->
    {
        "eval ({con, 1972}) <= 1972\n"
        "eval ({con, 2}) <= 2\n"
        "eval ({div {con,1972}, {con,2}}) <= 986\n"
        "eval ({con, 23}) <= 23\n"
        "eval ({div {divide,{con,1972},{con,2}}, {con,23}}) <= 42\n",
        42
    } = eval({divide, {divide, {con, 1972}, {con, 2}}, {con, 23}})
.
