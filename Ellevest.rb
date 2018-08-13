=begin
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

=end

module StateMachine


# command accessible to all States
  def cancel
    StateMachine::Canceled.new()
  end


  class CommandError < StandardError
    def message(article, command)
      "#{command.upcase} is not a valid command for articles with #{article.raw_status.class.to_s.split("::")[1].upcase} status"
    end
  end


# begin State class definitions

  class Creation
    include StateMachine

    def update_copy
      self
    end
    def accept
      StateMachine::Writing.new()
    end
    def reject
      self
    end
  end


  class Writing
    include StateMachine

    def update_copy
      self
    end

    def accept
      StateMachine::ArtReview.new()
    end

    def reject
      self
    end
  end


  class ArtReview
    include StateMachine

    def accept_art
      StateMachine::Preview.new()
    end

    def reject_art
      StateMachine::Writing.new()
    end
  end


  class Preview
    include StateMachine

    def state
      StateMachine::FinalReview.new()
    end
  end


  class FinalReview
    include StateMachine

    def update_copy
      StateMachine::Writing.new()
    end

    def accept
      StateMachine::ReadyToPublish.new()
    end

    def reject
      StateMachine::Writing.new()
    end

  end


  class ReadyToPublish
    include StateMachine

    def publish
      StateMachine::Published.new()
    end
  end


  class Published
    include StateMachine
  end


  class Canceled
  end

end

# end State class definitions


class Article
  include StateMachine
  attr_accessor :raw_status

  def initialize()
    # initialize with raw_status set to a new instance of the Creation class
    @raw_status = StateMachine::Creation.new()
  end

  def update_status(command)
    if @raw_status.respond_to?(command)
      if command === "cancel"
        @raw_status = self.cancel
        # preventing future updates to Article instance if #cancel called
        self.freeze
      else
        #dynamically calling method based on current state and provided action
        x = @raw_status.method(command)
        @raw_status = x.call
      end
      status
    else
      begin
        raise CommandError
      rescue CommandError => error
        puts error.message(self,command)
      end
    end
  end


# get actions available to article in its current state
  def get_options
    @raw_status.methods - Object.methods
  end

  
# print current state in easy-to-read format
  def status
    @raw_status.class.to_s.split("::")[1]
  end

end
