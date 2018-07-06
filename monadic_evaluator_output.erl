-module(monadic_evaluator_output).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

eval(S = {con, A}) ->
    output_monad:bind(
        output_monad:output(line(S, A)),
        fun(_) -> output_monad:unit(A) end);
eval(S = {divide, T, U}) ->
    output_monad:bind(eval(T), fun(A) -> 
        output_monad:bind(eval(U), fun(B) ->
            output_monad:bind(
                output_monad:output(line(S, A div B)),
                fun(_) -> output_monad:unit(A div B) end)
            end)
        end)
.

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
