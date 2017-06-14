# libhoney-erl

## Usage

### Configure your application environment.

```
{libhoney,
  [{team_writekey, <<"YOUR_WRITEKEY">>},
   {dataset, <<"YOUR_DATASET">>]}.
```

### Create an event.

```
Event = libhoney_event:new(),
ok = libhoney_event:send(Event).
```
