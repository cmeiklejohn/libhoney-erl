-module(libhoney_event).
-author("Christopher S. Meiklejohn <christopher.meiklejohn@gmail.com>").

-export([new/0, add/3, send/1]).

new() ->
    TeamWritekey = libhoney_config:get(team_writekey),
    Dataset = libhoney_config:get(dataset),
    APIHost = libhoney_config:get(apihost),
    SampleRate = libhoney_config:get(sample_rate),
    Timestamp = timestamp(),

    #{"team_writekey" => TeamWritekey,
      "dataset" => Dataset,
      "apihost" => APIHost,
      "sample_rate" => SampleRate,
      "timestamp" => Timestamp}.

add(Key, Value, Event) ->
    Event#{Key => Value}.

%% TODO: Sampling happens in the send() function - if the Sample Rate is
%% an integer greater than 1, send() should only send events with a
%% probability of 1/Sample Rate.
send(_Event) ->
    {error, not_implemented}.

%% @private
timestamp() ->
    {Mega, Sec, Micro} = os:timestamp(),
    (Mega*1000000 + Sec)*1000 + round(Micro/1000).
