# Buggs to fix.

# Include instructions. 
# MENU.
# Collisions with wall. Hold shift to move through wall. function. 

require 'rubygems'
require 'gosu'
require 'cmath'
# require './Menu'

module ZOrder
  BACKGROUND, PLAYER, MIDDLE, TOP = *0..3
end
# Global constants. 
# Screen height and width.
WIDTH = 1200
HEIGHT = 800
# Speed of player.
SPEED = 5
# Speed of attack.
BULLET_SPEED = 40
# Spawn rate of powerups. The lower the number the longer the spawn times. 
FREQUENCY_HEALTH = -10000
FREQUENCY_PWR = -5000
# score requirment to progress difficalty. 
LEVELTWO = 10
LEVELTHREE = 20
LEVELFOUR = 0
# Ammo display location. 
AMMO_X = 310
AMMO_Y = 13

class GameWindow < Gosu::Window

# Window configeration
def initialize
	super WIDTH, HEIGHT, false
	self.caption = "Dr. 19"
	
	# Game window background.
	@background_image = Gosu::Image.new("media/LibertyFallen.png")
	@dr19logo = Gosu::Image.new("media/DR19_logo.png")
	# Menu pages.
	@main_menu = Gosu::Image.new("media/menu_space.png")
	@main_options = Gosu::Image.new("media/menu_options.png")
	# @menu_instructions = Gosu::Image.new("media/instructions.png")
	@main_education_p1 = Gosu::Image.new("media/menu_education_p1.png")
	@main_education_p2 = Gosu::Image.new("media/menu_education_p2.png")
	@in_game_menu = Gosu::Image.new("media/menu_button.png")
	@donald = Gosu::Image.new("media/D_trump.png")
	# Menu Pointer.
	@menu_pointer = Gosu::Image.new("media/menu_pointer.png")
	@walltop = Gosu::Image.new("media/wall_black.png")
	@wallbottom = Gosu::Image.new("media/wall_black.png")
	
	# Ammo Rack.
	@ammo_5 = Gosu::Image.new("media/Ammo_rack_5.png")
	@ammo_4 = Gosu::Image.new("media/Ammo_rack_4.png")
	@ammo_3 = Gosu::Image.new("media/Ammo_rack_3.png")
	@ammo_2 = Gosu::Image.new("media/Ammo_rack_2.png")
	@ammo_1 = Gosu::Image.new("media/Ammo_rack_1.png")
	@ammo_reload = Gosu::Image.new("media/Ammo_rack_reload.png")
	# Max ammo count. 
	@ammo = 5

	# First aid.
	@first_aid = Gosu::Image.new("media/FirstAid.png")
	@aid_x = Gosu.random(WIDTH, WIDTH + 1000) 
	@aid_y = Gosu.random(50, 600)

	# Player. 
	@player_image = Gosu::Image.new("media/dr19.png")
	@shield_image = Gosu::Image.new("media/dr19sheild.png")
	@attack = Gosu::Image.new("media/attack.png")
	
	# Music.
	@soundtrack0 = Gosu::Song.new("sounds/soundtrack0.mp3")
	@soundtrack1 = Gosu::Song.new("sounds/soundtrack1.mp3")
	@soundtrack2 = Gosu::Song.new("sounds/soundtrack2.mp3") 

	# Sound effects.
	@attack_sound = Gosu::Sample.new("sounds/whoosh.wav")

	# Player starting location, score and health. 
	@x_player = 200
	@y_player = 400
	@health = 100

	# Attack coords
	@x_attack = 0
	@y_attack = 0
	
	# Defence coords
	@x_defence = 0
	@y_defence = 0

	# Shield/teleport
	@power = 100
	@powerup = Gosu::Image.new("media/DNA_Primer.png")
	@pwr_x = Gosu.random(WIDTH, WIDTH + 1000)
	@pwr_y = Gosu.random(50, 600)

	# Some Juicy Covid
	@covid = Gosu::Image.new("media/CoV_19_2.png")
	
	# Level 1.	
	@cov_x = Gosu.random(WIDTH, WIDTH + 150)
	@cov_y = Gosu.random(50, 600)
	@enemy_speed = Gosu.random(5, 10)

	# Level 2.
	@cov_x_l2 = Gosu.random(WIDTH, WIDTH + 150)
	@cov_y_l2 = Gosu.random(50, 600)
	@enemy_speed_l2 = Gosu.random(7, 11)

	# Level 3.
	@don_x = Gosu.random(WIDTH, WIDTH + 150)
	@don_y = Gosu.random(50, 600)
	@don_speed = Gosu.random(4, 8)

	# Level 4.
	# Upper wall variables
	@wall_x1 = WIDTH + 300
	@wall_y1 = 70
	# Lower wall variables.
	@wall_lower_x1 = WIDTH + 900
	@wall_lower_y1 = 801
	# Wall spped and color generation. 
	@wall_speed = 2


	# Font for score
	@font = Gosu::Font.new(40)
	
	# Debug font
	@debug_font = Gosu::Font.new(20)

	# Score system
	@a_file = File.new("score.txt", "w")
	@i = 0
	@score = 0
end
# Closed menu looping system. 1 = Main menu, 3 = Instructions, 4 = Education, 6 = game window, 7 = close.  

# Opening menu. "Press space to continue".
 def menu_open()
 	@main_menu.draw(0, 0, ZOrder::BACKGROUND)
	# enable space if i < 1. 
 	if(@i < 1)
 		if button_down?(Gosu::KbSpace)
 			@i = 1
 		end
 	end
 	if (@i >= 1)
 		menu_options()
 	end	
end

def menu_options()
	# Session high score system.
	read_data_from_file()
	if(@i == 1)
		@font.draw("Previous games score: #{@score_read}", 427, 116, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLUE)
	end
	# Debug font. mouse x/y
	@debug_font.draw("Mouse X: #{@locs[0]}", 1000, 700, ZOrder::TOP)
	@debug_font.draw("Mouse y: #{@locs[1]}", 1000, 720, ZOrder::TOP)
	# Draw menu.
	@main_options.draw(0, 0, ZOrder::BACKGROUND)
	# Menu navigation statements. 
	if(@i == 3)
		menu_instructions()
	end
	if(@i == 4)
		menu_education_p1()
	end
	if (@i == 5)
		menu_education_p2()
	end
	# Menu pointer system. Mouse over area. 
	if(@i == 1)
		# Play
		if ((mouse_x > 430 && mouse_x < 770) && (mouse_y > 443 && mouse_y < 485))
			pointer_draw(365, 772, 415, 415)
		end
		# Instructions
		if ((mouse_x > 193 && mouse_x < 1003) && (mouse_y > 514 && mouse_y < 564))
			pointer_draw(128, 1005, 486, 486)
		end
		# Stay safe
		if ((mouse_x > 147 && mouse_x < 1047) && (mouse_y > 590 && mouse_y < 663))
			pointer_draw(82, 1049, 580, 580)
		end
		# Exit
		if ((mouse_x > 485 && mouse_x < 705) && (mouse_y > 698 && mouse_y < 740))
			pointer_draw(420, 707, 670, 670)
		end
	end
end
# displays menu pointer over defined mouse x/y positions. 
def pointer_draw(x, x1, y, y1)
	@menu_pointer.draw(x, y, ZOrder::MIDDLE)
	@menu_pointer.draw(x1, y1, ZOrder::MIDDLE)
end
# Instructions menu. i = 3. 
def menu_instructions()
	@main_education_p2.draw(0, 0, ZOrder::BACKGROUND)
	# Debug font.
	@debug_font.draw("Mouse X: #{@locs[0]}", 1000, 700, ZOrder::TOP)
	@debug_font.draw("Mouse y: #{@locs[1]}", 1000, 720, ZOrder::TOP)
	# Menu pointer.
	if ((mouse_x > 485 && mouse_x < 705) && (mouse_y > 698 && mouse_y < 740))
		pointer_draw(420, 707, 670, 670)
	end
end
# Education menu. i = 4.
def menu_education_p1()
	@main_education_p1.draw(0, 0, ZOrder::BACKGROUND)
	# Debug font. 
	@debug_font.draw("Mouse X: #{@locs[0]}", 1000, 700, ZOrder::TOP)
	@debug_font.draw("Mouse y: #{@locs[1]}", 1000, 720, ZOrder::TOP)
	# Menu pointer. 
	if ((mouse_x > 464 && mouse_x < 734) && (mouse_y > 718 && mouse_y < 760))
		pointer_draw(399, 736, 690, 690)
		# @attack_sound.play
	end
end
# Education menu 2. i = 5.
def menu_education_p2()
	@main_education_p2.draw(0, 0, ZOrder::BACKGROUND)
	# Debug font
	@debug_font.draw("Mouse X: #{@locs[0]}", 1000, 700, ZOrder::TOP)
	@debug_font.draw("Mouse y: #{@locs[1]}", 1000, 720, ZOrder::TOP)
	# Menu pointer. 
	if ((mouse_x > 464 && mouse_x < 734) && (mouse_y > 718 && mouse_y < 760))
		@menu_pointer.draw(399, 690, ZOrder::MIDDLE)
		@menu_pointer.draw(736, 690, ZOrder::MIDDLE)
	end
end
# close window. i = 7.
def close()
	window.close
end
# Music control system. 
def music()
	# Menu music
	if ((@i == 1) || (@i == 2) || (@i == 3) || (@i == 4) || (@i == 5))
		@soundtrack0.play
		@soundtrack1.stop
		@soundtrack2.stop
	end
	# Level 1 - 3 music
	if (@i == 6 && @score < LEVELFOUR)
		@soundtrack0.stop
		@soundtrack1.play
		@soundtrack2.stop
	end
	# Level 4 music. 
	if (@i == 6 && @score == LEVELFOUR)
		@soundtrack0.stop
		@soundtrack1.stop
		@soundtrack2.play
	end
end
# Detects for mouse Location. 
def area_clicked(mouse_x, mouse_y)
	# Play
	if (button_down?(Gosu::MsLeft) && @i == 1) 
		if ((mouse_x > 430 && mouse_x < 770) && (mouse_y > 443 && mouse_y < 485))
			@i = 6
			@x_player = 200
			@health = 100
			@score = 0
		end
	end
		# Close menu
	if (button_down?(Gosu::MsLeft) && @i == 1)  
		if ((mouse_x > 485 && mouse_x < 705) && (mouse_y > 698 && mouse_y < 740))
			close()
		end
	end
	# Instructions
	if (button_down?(Gosu::MsLeft) && @i == 1) 
		if ((mouse_x > 193 && mouse_x < 1003) && (mouse_y > 514 && mouse_y < 564))
			@i = 3
		end
	end
	# Education page 1
	if (button_down?(Gosu::MsLeft) && @i == 1) 
		if ((mouse_x > 147 && mouse_x < 1047) && (mouse_y > 590 && mouse_y < 663))
			@i = 4
		end
	end
	# Education page 1 to page 2
	 if (button_down?(Gosu::MsLeft) && @i == 4) 
	 	if ((mouse_x > 464 && mouse_x < 734) && (mouse_y > 718 && mouse_y < 760))
	 		@i = 5
	 	end
	end
	# Education page 2 to home
	if (button_down?(Gosu::MsLeft) && @i == 5)  
		if ((mouse_x > 464 && mouse_x < 734) && (mouse_y > 718 && mouse_y < 760))
			@i = 1
		end
	end
	# Instructions move to main
	if (button_down?(Gosu::MsLeft) && @i == 3) 
		if ((mouse_x > 485 && mouse_x < 705) && (mouse_y > 698 && mouse_y < 740))
			@i = 1
		end
	end
	# In game menu
	if (button_down?(Gosu::MsLeft) && @i == 6) 
		if ((mouse_x > 1128 && mouse_x < 1170) && (mouse_y > 9 && mouse_y < 60))
			@i = 1
			write_score()
		end
	end
end
def button_down(id)
	case id
		when Gosu::MsLeft
			@locs = [mouse_x, mouse_y]
			area_clicked(mouse_x, mouse_y)
    end
end
# ####### Game Logic ######## #
def process_attack()
	@x_attack += BULLET_SPEED
end
# Player defence being drawn and alligned at player x, y position. 
def player_defence()
	use_shield()
	@x_defence = @x_player-40
	@y_defence = @y_player-25 
	@shield_image.draw(@x_player, @y_player, ZOrder::PLAYER)
end
# Player attack. Initial position being drawn at the player x, y position. 
def draw_attack()
	@attack.draw(@x_attack, @y_attack, ZOrder::PLAYER)
end
# Player function. 
def player()
	@player_image.draw(@x_player, @y_player, ZOrder::PLAYER)
	# Calls the player health, power and ammo. 
	player_health()
	player_power()
	ammo()
	# Player Defence
	# Detects keyboard input for player shield. 
	if(@power > 0)
		if button_down?(Gosu::KbLeftShift)
			player_defence()
		end	
	end
	# Detects keyboard input for player attack. Will only fire if ammo is greater then 0. 
	if((@ammo > 0) && (@x_attack == @x_player) || (@ammo > 0) && (@x_attack > @x_player + 1000))
		if button_down?(Gosu::KbSpace)
			@attack_sound.play
			@x_attack = @x_player + 21
			@y_attack = @y_player + 37
			@ammo -= 1
		end
	end
	if(@ammo == 0)
		if button_down?(Gosu::KbR)
			@ammo = 5
		end
	end
	draw_attack()
end
# button_down?(Gosu::KbR)
def ammo()
	if(@ammo == 5)
		@ammo_5.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
	if(@ammo == 4)
		@ammo_4.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
	if(@ammo == 3)
		@ammo_3.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
	if(@ammo == 2)
		@ammo_2.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
	if(@ammo == 1)
		@ammo_1.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
	if(@ammo == 0)
		@ammo_reload.draw(AMMO_X, AMMO_Y, ZOrder::TOP)
	end
end

def background()
	@background_image.draw(0, 0, ZOrder::BACKGROUND)
	@dr19logo.draw(10, 10, ZOrder::TOP)
	Gosu.draw_rect(0, 0, WIDTH, 70, Gosu::Color.argb(0xff_000000), ZOrder::MIDDLE, mode=:default)
	@font.draw_text("Score: #{@score}", 920, 20, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLUE)
	@font.draw_text("Health  ", 685, 18, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLUE)
	@font.draw_text("Power  ", 400, 18, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLUE)
	@in_game_menu.draw(1120, 10, ZOrder::MIDDLE)
end

def player_health()
	Gosu.draw_rect(800, 28, @health, 20, Gosu::Color::RED, ZOrder::MIDDLE, mode=:default)
end
def player_power()
	Gosu.draw_rect(515, 28, @power, 20, Gosu::Color::BLUE, ZOrder::MIDDLE, mode=:default)
end
# Player movement wrap
def wrap
	if (@x_player > WIDTH + 63)
		@x_player = 0 - 40
	end	
	if (@x_player < 0 - 63)
		@x_player = WIDTH
	end	
	if (@y_player > HEIGHT + 40)
		@y_player = 0
	end	
	if (@y_player < 0)
		@y_player = HEIGHT + 40
	end
end

def move()
	if button_down?(Gosu::KbA)
		@x_player -= SPEED
	end
	
	if button_down?(Gosu::KbD)
		@x_player += SPEED
	end

	if button_down?(Gosu::KbW) 
		@y_player -= SPEED
	end

	if button_down?(Gosu::KbS) 
		@y_player += SPEED
	end
	wrap()
end

def remove_attack()
	@x_attack = 2000
	@y_attack = -100
end

def check_attack()
	if (@x_attack > WIDTH + 30)
		remove_attack()
	end
end

def collission()
	# Level 1 Covid.
	if(((@cov_x >= @x_player) && (@cov_x <= @x_player + 63)) && ((@cov_y >= @y_player) && (@cov_y <= @y_player + 77)) ||  
	((@cov_x >= @x_player - 63) && (@cov_x <= @x_player)) && ((@cov_y >= @y_player - 77) && (@cov_y <= @y_player)))
		if (!button_down?(Gosu::KbLeftShift))
			@cov_x = Gosu.random(WIDTH, WIDTH + 150)
			puts 'hello!!!!'
			@cov_y = Gosu.random(50, 600)
			@health -= 20
		end
	end
	# Level 2 Covid. 
	if(((@cov_x_l2 >= @x_player) && (@cov_x_l2 <= @x_player + 63)) && ((@cov_y_l2 >= @y_player) && (@cov_y_l2 <= @y_player + 77)) ||  
		((@cov_x_l2 >= @x_player - 63) && (@cov_x_l2 <= @x_player)) && ((@cov_y_l2 >= @y_player - 77) && (@cov_y_l2 <= @y_player)))
		if (!button_down?(Gosu::KbLeftShift))
			@cov_x_l2 = Gosu.random(WIDTH, WIDTH + 150)
			@cov_y_l2 = Gosu.random(50, 600)
			@health -= 10
		end
	end
	# Level 3 Don
	if(((@don_x >= @x_player) && (@don_x <= @x_player + 63)) && ((@don_y >= @y_player) && (@don_y <= @y_player + 77)) ||  
		((@don_x >= @x_player - 63) && (@don_x <= @x_player)) && ((@don_y >= @y_player - 77) && (@don_y <= @y_player)))
		if (!button_down?(Gosu::KbLeftShift))
			@don_x = Gosu.random(WIDTH, WIDTH + 150)
			@don_y = Gosu.random(50, 600)
			@health -= 50
		end
	end
	# Level 4
	if (((@x_player >= @wall_x1) && (@x_player <= @wall_x1 + 30)) && ((@y_player >= @wall_y1) && (@y_player <= @wall_y1 + 300)) ||  
		((@x_player >= @wall_x1 - 30) && (@x_player <= @wall_x1)) && ((@y_player >= @wall_y1 - 300) && (@y_player <= @wall_y1)))
		@x_player = 200
		@health -= 10
	end	
	
	if (((@x_player >= @wall_lower_x1) && (@x_player <= @wall_lower_x1 + 30)) && ((@y_player >= @wall_lower_y1) && (@y_player <= @wall_lower_y1 + 300)) ||  
		((@x_player >= @wall_lower_x1 - 30) && (@x_player <= @wall_lower_x1)) && ((@y_player >= @wall_lower_y1 - 300) && (@y_player <= @wall_lower_y1)))
		@x_player = 200
		@health -= 10
	end	

	if(((@aid_x >= @x_player) && (@aid_x <= @x_player + 63)) && ((@aid_y >= @y_player) && (@aid_y <= @y_player + 77)) ||  
		((@aid_x >= @x_player - 63) && (@aid_x <= @x_player)) && ((@aid_y >= @y_player - 77) && (@aid_y <= @y_player)))
		if (@health <= 90)
			@health += 10
			@aid_x = 1000
			@aid_y = Gosu::random(50, 750)	
		end
	end
	if(((@pwr_x >= @x_player) && (@pwr_x <= @x_player + 63)) && ((@pwr_y >= @y_player) && (@pwr_y <= @y_player + 77)) ||  
		((@pwr_x >= @x_player - 63) && (@pwr_x <= @x_player)) && ((@pwr_y >= @y_player - 77) && (@pwr_y <= @y_player)))
		@power += 10
		@pwr_x = 1000
		@pwr_y = Gosu::random(50, 750)
		if (@power <= 100)
			@power += 10
		end
	end 
	# Syringe detection. Covid Level 1.
	if(((@x_attack >= @cov_x) && (@x_attack <= @cov_x + 50)) && ((@y_attack >= @cov_y) && (@y_attack <= @cov_y + 50)) ||  
		((@x_attack >= @cov_x - 50) && (@x_attack <= @cov_x)) && ((@y_attack >= @cov_y - 50) && (@y_attack <= @cov_y)) && (!button_down?(Gosu::KbLeftShift)))		
		@cov_x = Gosu.random(WIDTH, WIDTH + 150)
		@cov_y = Gosu.random(50, 600)
		@score += 1 
		remove_attack()
	end
	# Syringe detection. Covid Level 2.
	if	(((@x_attack >= @cov_x_l2) && (@x_attack <= @cov_x_l2 + 50)) && ((@y_attack >= @cov_y_l2) && (@y_attack <= @cov_y_l2 + 50)) ||  
		((@x_attack >= @cov_x_l2 - 50) && (@x_attack <= @cov_x_l2)) && ((@y_attack >= @cov_y_l2 - 50) && (@y_attack <= @cov_y_l2)) && (!button_down?(Gosu::KbLeftShift)))			
		@cov_x_l2 = Gosu.random(WIDTH, WIDTH + 150)
		@cov_y_l2 = Gosu.random(50, 600)
		@score += 1 
		remove_attack()
	end
	# Syringe detection. Don Level 3.
	if	(((@x_attack >= @don_x) && (@x_attack <= @don_x + 45)) && ((@y_attack >= @don_y) && (@y_attack <= @don_y + 45)) ||  
		((@x_attack >= @don_x - 45) && (@x_attack <= @don_x)) && ((@y_attack >= @don_y - 45) && (@y_attack <= @don_y)) && (!button_down?(Gosu::KbLeftShift)))			
		@don_x = Gosu.random(WIDTH, WIDTH + 150)
		@don_y = Gosu.random(50, 600)
		@score += 1 
		remove_attack()
	end
	# If health is less thhen or equal to 0 return to the main menu. restore health to 100 and reset ammo count to 5. 
	if(@health <= 0)
		@i = 1
		@health = 100
		@power = 100
		@ammo = 5
	end
end
# Covid attack recignition. 
def attacked()
	if(@x_attack == @cov_x) || (@y_attack == @cov_y) || (@x_attack == @cov_x + 50) || (@y_attack == @cov_y + 50)
		@cov_y == Gosu::random(50, HEIGHT - 50)
	end
end
# Covid spawning system.
def covid()
	@covid.draw(@cov_x, @cov_y, ZOrder::PLAYER)
	@cov_x -= @enemy_speed
end
# Covid level two. 
def covid_l2()
	@covid.draw(@cov_x_l2, @cov_y_l2, ZOrder::PLAYER)
	@cov_x_l2 -= @enemy_speed_l2
end
# Covid level three.
def don()
	@donald.draw(@don_x, @don_y, ZOrder::PLAYER)
	@don_x -= @don_speed
end
# Level four spawning system. 
def wall()
	@walltop.draw(@wall_x1, @wall_y1, ZOrder::PLAYER)
end

def wall_lower()
	@wallbottom.draw(@wall_lower_x1, @wall_lower_y1, ZOrder::PLAYER)
end

def process_walls()
	@wall_lower_x1 -= @wall_speed
	@wall_x1 -= @wall_speed
	
	if @wall_x1 < -50 
		@wall_x1  = WIDTH + 300
	end
	if @wall_lower_x1 < -50 
		@wall_lower_x1  = WIDTH + 900
	end
end

# Health spawn system. 
def first_aid()
	@first_aid.draw(@aid_x, @aid_y, ZOrder::PLAYER)
	@aid_x -= 10
end
# Powerup spawn system
def power()
	@powerup.draw(@pwr_x, @pwr_y, ZOrder::PLAYER)
	@pwr_x -= 10
end
# Power drain. 
def use_shield()
	@power -= 0.5
end
# Covid spawning system. Player score determines the level. 
def spawn()
	covid()
	first_aid()
	power()
	# Level 1 spawn criteria.
	if @cov_x < -50 
		@cov_x = Gosu.random(WIDTH, WIDTH + 150)
		@cov_y = Gosu.random(50, 600)

	end
	# Level 2 spawn criteria
	if (@score > LEVELTWO)
		covid_l2()
		if @cov_x_l2 < 25
			@cov_x_l2  = Gosu.random(WIDTH, WIDTH + 150)
			@cov_y_l2  = Gosu.random(50, 600)
	
		end
	end
	# Level 3 spawning system.
	if (@score > LEVELTHREE)
		don()
		if @don_x < -50 
			@don_x  = Gosu.random(WIDTH, WIDTH + 150)
			@don_y  = Gosu.random(50, 600)
		end
	end
	# Level 4 spawning system. 
	if (@score > LEVELFOUR)
		wall()
		wall_lower()
	end
	# Set health spawn criteria.
	if @aid_x < FREQUENCY_HEALTH
		@aid_x = Gosu.random(WIDTH, WIDTH + 150)
		@aid_y = Gosu.random(50, 600)
	end
	# Set powerup spawn frequency. 
	if @pwr_x < FREQUENCY_PWR
		@pwr_x = Gosu.random(WIDTH, WIDTH + 150)
		@pwr_y = Gosu.random(50, 600)
	end
end
# Session High score saving system. 
# Read score.
def read_data_from_file()
	@a_file = File.open('score.txt')
	@score_read = @a_file.gets
	@a_file.close
	print "#{@score_read}"
end
# Write data to save score.
def write_score()
	# if(@health <= 10)
		#  && (@score > @high_score)
		@a_file = File.open("score.txt", "w") 
		@a_file.puts(@score)
	# end
end

# ################################################ #
# Process calculations. Called 60 fps. 
def update	
	move()
	music()
	# Spawning system for covid - bugged
	if(@health <= 0)
		write_score()
	end
	# Player Attack
	process_walls()
	process_attack()
	check_attack()
	collission()
	# Mouse location
	@locs = [mouse_x, mouse_y]
end

# the visual game window
def draw
	menu_open()
	# Game window. i = 6.
	if (@i == 6)
		background()    
		player()
		attacked()
		spawn()
	end
end

# Allow mouse curser within window
def needs_cursor?
  true
end

end
window = GameWindow.new
window.show
