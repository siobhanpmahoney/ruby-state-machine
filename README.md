# ruby-state-machine

See it in action with a simple CLI [here](https://repl.it/@siobhanpmahoney/Ellevest-State-Machine).

# Overview:

State is represented as an attribute of an `Article` instance (`raw_status`).

Each State option is represented by a class, which are all grouped together in the `StateMachine` module. The respective steps available for a given state are represented by instance methods.

## State Updates

Article instances are initialized with a `raw_status` set to `Creation.new()`.

Subsequent state updates are handled by the `#update_status` method, which accepts an action as an argument.

Using the `raw_status` attribute and the method that matches the action argument, the article state will be operated on accordingly. After the state is operated on, a string representing its current state will be returned.

If the respective class does not have a method that aligns with the supplied action, an error will be raised.

Additional article methods include:
* `@article#get_options`: returns array of possible actions available given an @article's current state
* `@article#status`: returns string representing current state
