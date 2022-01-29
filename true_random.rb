#!/usr/bin/env ruby

require 'gosu'

class Dashboard < Gosu::Window
    def initialize()
        super 450, 80, false
        @mouse_move = false
        @sequence = ''
        @tracker = [[0, 0], [mouse_x, mouse_y]]
    end

    def needs_cursor?
        true
    end
    
    def store_movement()
        unless (@tracker[1][0] == mouse_x) || (@tracker[1][1] == mouse_y)
            @tracker[0] = @tracker[1]
            @tracker[1] = [mouse_x, mouse_y]
            @mouse_move = true
        else
            @mouse_move = false
        end
    end
    
    def gen_random()
        angle = (@tracker[0][0] - @tracker[1][0]) / (@tracker[0][1] - @tracker[1][1])
        angle *= -1 if angle < 0
        generated_random = angle.to_s[1..3].delete('.')
        @sequence += generated_random #if generated_random != "nfi"
        puts "\e[H\e[2J"
        puts @sequence
    end

    def update()
        store_movement()
        gen_random() if @mouse_move
    end

    def draw()
        (Gosu::Font.new(30)).draw_text(" Generating Numbers from\nRandom Mouse Movement", 50, 10, 0, 1.0, 1.0, 0xff_ffffff)
    end

    def button_down(id)
        close if id == Gosu::KB_ESCAPE
    end
end

Dashboard.new.show()
