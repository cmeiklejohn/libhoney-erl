-module(libhoney_SUITE).
-author("Christopher S. Meiklejohn <christopher.meiklejohn@gmail.com>").

%% common_test callbacks
-export([%% suite/0,
         init_per_suite/1,
         end_per_suite/1,
         init_per_testcase/2,
         end_per_testcase/2,
         all/0,
         %% groups/0,
         init_per_group/2]).

%% tests
-compile([export_all]).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/inet.hrl").

%% ===================================================================
%% common_test callbacks
%% ===================================================================

init_per_suite(_Config) ->
    _Config.

end_per_suite(_Config) ->
    _Config.

init_per_testcase(Case, _Config) ->
    ct:pal("Beginning test case ~p", [Case]),

    application:ensure_all_started(libhoney),

    _Config.

end_per_testcase(Case, _Config) ->
    ct:pal("Ending test case ~p", [Case]),

    _Config.

init_per_group(_, _Config) ->
    _Config.

end_per_group(_, _Config) ->
    ok.

all() ->
    [dispatch_test].

%% ===================================================================
%% Tests.
%% ===================================================================

dispatch_test(_Config) ->
    Event = libhoney_event:new(),
    ok = libhoney_dispatcher:blocking_send(Event),
    ok.
