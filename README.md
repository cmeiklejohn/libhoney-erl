# libhoney-erl

Erlang library for sending events to [Honeycomb](https://honeycomb.io/).

## Installation

Coming soon.

## Example

First, configure your application environment with the key and dataset
information.

```
{libhoney,
  [{team_writekey, <<"YOUR_WRITEKEY">>},
   {dataset, <<"YOUR_DATASET">>]}.
```

Then, create and dispatch an event to Honeycomb.

```
Event = libhoney_event.add(<<"my_custom_attribute">>, 2, libhoney_event:new()),
ok = libhoney_event:send(Event).
```

## Contributions

Features, bug fixes and other changes to libhoney are gladly accepted.
Please open issues or a pull request with your change. Remember to add
your name to the CONTRIBUTORS file!

All contributions will be released under the Apache License 2.0.
