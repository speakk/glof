extends Node

signal brick_hit(brick, by, damage)

signal end_zone_hit(end_zone, by)

signal level_timer_changed(new_time)

signal player_has_moved
signal player_collision_happened(collision_speed)

signal new_game_pressed
signal try_again_pressed
signal level_change_pressed(level_id)

signal level_finished(level_id, time)
