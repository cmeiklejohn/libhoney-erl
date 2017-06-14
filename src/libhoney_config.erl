-module(libhoney_config).
-author("Christopher Meiklejohn <christopher.meiklejohn@gmail.com>").

-define(APP, libhoney).

-export([set/2,
         get/1,
         get/2]).

get(Key) ->
    libhoney_mochiglobal:get(Key).

get(Key, Default) ->
    libhoney_mochiglobal:get(Key, Default).

set(Key, Value) ->
    application:set_env(?APP, Key, Value),
    libhoney_mochiglobal:put(Key, Value).
