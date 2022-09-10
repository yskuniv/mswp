require "thor"

module MSwp
  class CLI < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    option :m, :type => :numeric,
               :required => true,
               :desc => "number of mines"
    option :auto, :type => :boolean,
                  :default => false,
                  :desc => "enable auto mode :)"
    desc "start size1 size2", "start a game"
    def start(*size)
      mines_count = options[:m]
      auto = options[:auto]
      size_ = size.map(&:to_i).reverse

      begin
        CursesGame.start(size_, mines_count, auto)
      rescue MSwp::IllegalMinesCountSpecified
        abort("Error: illegal mines count specified")
      rescue MSwp::TooManyMinesCountSpecified
        abort("Error: too many mines count specified")
      rescue MSwp::IllegalSizeSpecified, CursesGame::IllegalSizeSpecified
        abort("Error: illegal size specified")
      end
    end
  end
end
