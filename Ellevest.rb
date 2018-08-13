module StateMachine

  def cancel
    StateMachine::Canceled.new()
  end


  class CommandError < StandardError
    def message(article, command)
      "#{command.upcase} is not a valid command for articles with a #{article.status.class.to_s.split("::")[1].upcase} status"
    end
  end


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



class Article

  include StateMachine
  attr_accessor :status, :status_state

  def initialize()
    @status = StateMachine::Creation.new()
    # @status_state = @status.class.to_s.split("::").
  end

  def update_status(command)
    if self.status.respond_to?(command)
      if command === "cancel"
        self.status = self.cancel
        self.freeze
      else
        x = self.status.method(command)
        self.status = x.call
      end
    else
      begin
        raise CommandError
      rescue CommandError => error
        puts error.message(self,command)
      end
    end
  end

  def get_options
    self.status.methods - Object.methods
  end

end
