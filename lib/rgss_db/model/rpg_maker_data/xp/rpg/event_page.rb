# frozen_string_literal: true

module RPG
  class Event
    #
    # Data class for the event page.
    #
    class Page
      include RgssDb::Jsonable
      extend RgssDb::JsonableConstructor

      def initialize
        @condition = RPG::Event::Page::Condition.new
        @graphic = RPG::Event::Page::Graphic.new
        @move_type = 0
        @move_speed = 3
        @move_frequency = 3
        @move_route = RPG::MoveRoute.new
        @walk_anime = true
        @step_anime = false
        @direction_fix = false
        @through = false
        @always_on_top = false
        @trigger = 0
        @list = [RPG::EventCommand.new]
      end

      attr_accessor :condition, :graphic, :move_type, :move_speed, :move_frequency, :move_route, :walk_anime,
                    :step_anime, :direction_fix, :through, :always_on_top, :trigger, :list
    end
  end
end
