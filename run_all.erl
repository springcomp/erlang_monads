-module(run_all).
-export([run_all/0]).

run_all() ->
    evaluator:test(),
    evaluator_state:test(),
    evaluator_exceptions:test(),
    evaluator_output:test()
.