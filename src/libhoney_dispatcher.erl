%% TODO: Need clarification on this:
%%
%% Sampling happens in the send() function - if the Sample Rate is an
%% integer greater than 1, send() should only send events with a
%% probability of 1/Sample Rate.
%%

-module(libhoney_dispatcher).
-author("Christopher S. Meiklejohn <christopher.meiklejohn@gmail.com>").

-behavior(gen_server).

-include("libhoney.hrl").

%% API
-export([start_link/0,
         blocking_send/1,
         send/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(state, {}).
-type state() :: #state{}.

%% @doc Same as start_link([]).
-spec start_link() -> {ok, pid()} | ignore | {error, term()}.
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @doc Send an event.
blocking_send(Event) ->
    gen_server:call(?MODULE, {send, Event}, infinity).

%% @doc Send an event.
send(Event) ->
    gen_server:cast(?MODULE, {send, Event}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
-spec init([]) -> {ok, state()}.
init([]) ->
    {ok, #state{}}.

%% @private
-spec handle_call(term(), {pid(), term()}, state()) ->
    {reply, term(), state()}.
handle_call({send, Event}, _From, State) ->
    Result = internal_send(Event),
    {reply, Result, State};
handle_call(Msg, _From, State) ->
    lager:warning("Unhandled messages: ~p", [Msg]),
    {reply, ok, State}.

%% @private
-spec handle_cast(term(), state()) -> {noreply, state()}.
handle_cast({send, Event}, State) ->
    internal_send(Event),
    {noreply, State};
handle_cast(Msg, State) ->
    lager:warning("Unhandled messages: ~p", [Msg]),
    {noreply, State}.

%% @private
-spec handle_info(term(), state()) -> {noreply, state()}.
handle_info(Msg, State) ->
    lager:warning("Unhandled messages: ~p", [Msg]),
    {noreply, State}.

%% @private
-spec terminate(term(), state()) -> term().
terminate(_Reason, _State) ->
    ok.

%% @private
-spec code_change(term() | {down, term()}, state(), term()) -> {ok, state()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

internal_send(#{<<"team_writekey">> := TeamWritekey,
                <<"dataset">> := Dataset,
                <<"apihost">> := APIHost,
                <<"sample_rate">> := SampleRate,
                <<"timestamp">> := Timestamp} = Event) ->

    %% Encode message as JSON.
    Body = jsx:encode(Event),

    %% Generate request.
    Url = binary_to_list(APIHost) ++ "/1/events/" ++ binary_to_list(Dataset),

    Headers = [{"Content-Type", "application/json"},
               {"X-Honeycomb-Team", binary_to_list(TeamWritekey)},
               {"X-Honeycomb-Event-Time", integer_to_list(Timestamp)},
               {"X-Honeycomb-Samplerate", integer_to_list(SampleRate)},
               {"User-Agent", "libhoneycomb-erl" ++ ?VERSION}],

    Options = [{ssl,[{verify,0}]}],

    Profile = [],

    %% Dispatch the event.
    {ok, _Response} = httpc:request(post,
                                    {Url, Headers, "application/json", Body},
                                    Options,
                                    Profile),

    ok.
