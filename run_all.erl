-module(run_all).
-export([
    run_all/0,
    run_all/1
]).

run_all() ->
    evaluator:test(),
    evaluator_state:test(),
    evaluator_exceptions:test(),
    evaluator_output:test()
.
run_all(monads) ->
    monadic_evaluator:test(),
    monadic_evaluator_exceptions:test(),
    monadic_evaluator_state:test(),
    monadic_evaluator_output:test();
run_all(tests) ->
    identity_monad:test(),
    exceptions_monad:test(),
    state_monad:test(),
    output_monad:test()
.