# frozen_string_literal: true

# Application mixins
require_relative "../../mixins/jsonable"
require_relative "../../mixins/jsonable_constructor"

# RPGVXAce Data Structures (RPGVXAce.chm::/rgss/g_rpg_data.html)
require_relative "./rpg/map"
require_relative "./rpg/map_encounter"
require_relative "./rpg/map_info"

require_relative "./rpg/event"
require_relative "./rpg/event_page"
require_relative "./rpg/event_page_condition"
require_relative "./rpg/event_page_graphic"

require_relative "./rpg/event_command"

require_relative "./rpg/move_route"
require_relative "./rpg/move_command"

require_relative "./rpg/base_item"
require_relative "./rpg/actor"
require_relative "./rpg/class"
require_relative "./rpg/usable_item"
require_relative "./rpg/skill"
require_relative "./rpg/item"
require_relative "./rpg/equip_item"
require_relative "./rpg/weapon"
require_relative "./rpg/armor"
require_relative "./rpg/enemy"
require_relative "./rpg/state"

require_relative "./rpg/base_item_feature"

require_relative "./rpg/usable_item_damage"
require_relative "./rpg/usable_item_effect"

require_relative "./rpg/class_learning"

require_relative "./rpg/enemy_drop_item"
require_relative "./rpg/enemy_action"

require_relative "./rpg/troop"
require_relative "./rpg/troop_member"
require_relative "./rpg/troop_page"
require_relative "./rpg/troop_page_condition"

require_relative "./rpg/animation"
require_relative "./rpg/animation_frame"
require_relative "./rpg/animation_timing"

require_relative "./rpg/tileset"

require_relative "./rpg/common_event"

require_relative "./rpg/system"
require_relative "./rpg/system_vehicle"
require_relative "./rpg/system_terms"
require_relative "./rpg/system_test_battler"

require_relative "./rpg/audio_file"
require_relative "./rpg/bgm"
require_relative "./rpg/bgs"
require_relative "./rpg/me"
require_relative "./rpg/se"
