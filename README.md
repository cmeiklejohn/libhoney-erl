# libhoney-erl

[![Build Status](https://travis-ci.org/cmeiklejohn/libhoney-erl.svg?branch=master)](https://travis-ci.org/cmeiklejohn/libhoney-erl)

Erlang library for sending events to [Honeycomb](https://honeycomb.io/).

Note: this library is not fully featured yet, and only implements the
minimal requirements as specified here in the [SDK Spec](https://honeycomb.io/docs/reference/sdk-spec/).

## Installation

Add a dependency in your ```rebar.config``` file.

```erlang
{deps, [{libhoney, {git, "https://github.com/cmeiklejohn/libhoney.git", {branch, "master"}}}]}.
```

## Example

First, configure your application environment with the key and dataset
information.

```erlang
{libhoney,
  [{team_writekey, <<"YOUR_WRITEKEY">>},
   {dataset, <<"YOUR_DATASET">>]}.
```

Then, create and dispatch an event to Honeycomb.

```erlang
Event = libhoney_event:add(<<"my_custom_attribute">>, 2, libhoney_event:new()),
ok = libhoney_event:send(Event).
```

## Contributions

Features, bug fixes and other changes to libhoney are gladly accepted.
Please open issues or a pull request with your change. Remember to add
your name to the CONTRIBUTORS file!

All contributions will be released under the Apache License 2.0.
