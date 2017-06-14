-module(libhoney_event).
-author("Christopher S. Meiklejohn <christopher.meiklejohn@gmail.com>").

-export([new/0, add/3, send/1]).

%% @doc Generate a new event.
new() ->
    TeamWritekey = libhoney_config:get(team_writekey, undefined),
    case TeamWritekey of
        undefined ->
            exit({error, no_team_writekey_configured});
        _ ->
            ok
    end,

    Dataset = libhoney_config:get(dataset, undefined),
    case Dataset of
        undefined ->
            exit({error, no_dataset_configured});
        _ ->
            ok
    end,

    APIHost = libhoney_config:get(apihost, <<"https://api.honeycomb.io">>),
    SampleRate = libhoney_config:get(sample_rate, 1),
    Timestamp = timestamp(),

    #{<<"team_writekey">> => TeamWritekey,
      <<"dataset">> => Dataset,
      <<"apihost">> => APIHost,
      <<"sample_rate">> => SampleRate,
      <<"timestamp">> => Timestamp}.

%% @doc Add a field to the event.
add(Key, Value, Event) when is_binary(Key) ->
    Event#{Key => Value}.

%% @doc Send a event to the API endpoint.
send(Event) ->
    libhoney_dispatcher:send(Event).

%% @private
timestamp() ->
    {Mega, Sec, Micro} = os:timestamp(),
    (Mega*1000000 + Sec)*1000 + round(Micro/1000).
