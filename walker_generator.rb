#!/usr/bin/env ruby

require 'gosu'

Line_Length = 5

Seed_Size = 6
Initial_Seed = 123456

Multiplier = 11
Increment = 7
Modulus = 101
Prime_Product = Increment * Multiplier

def forked_random_walker(new_random)
    new_random = new_random.to_i
    new_entry = Array.new
    new_entry.push(Math.cos((new_random * Math::PI)/5) * Line_Length)
    new_entry.push(Math.sin((new_random * Math::PI)/5) * Line_Length)
    return new_entry
    # pi/5 rad = 36 dig = 360 / 10
end

#? middle square method
def mid_sq(seed)
    seed_sq = (seed.to_i * seed.to_i).to_s

    while seed_sq.size < (Seed_Size * 2)
        seed_sq = "0" + seed_sq
    end
    
    start_val = Seed_Size / 2
    end_val = start_val + Seed_Size
    mid_value = seed_sq[start_val...end_val]
    
    return mid_value
end

#? middle square with weyl sequence
def weyl_mid_sq(seed)
    seed_sq = (seed.to_i * seed.to_i)
    seed_weyl = (seed_sq + 13091206342165455529).to_s

    while seed_weyl.size < (Seed_Size * 2)
        seed_weyl = “0” + seed_weyl
    end

    start_val = (seed_weyl.size - Seed_Size) / 2
    end_val = start_val + Seed_Size
    mid_value = seed_weyl[start_val .. end_val]

    return mid_value
end

#? Linear congruential generator
def linear_cong(new_random)
    new_random = ((Multiplier * new_random.to_i) + Increment) % Modulus
    return new_random.to_s
end

#? blum blum shub method
def blum2_shub(new_random)
    new_random = (new_random.to_i * new_random.to_i) % Prime_Product
    return new_random
end

class Graph < Gosu::Window
    def initialize()
        super 1900, 1000, false
        @increment_values = [[0, 0]]
        @repeated_values = Array.new
        @values_generated = Array.new
        @mid_value = Initial_Seed
        @generate_values = true
    end

    def update
        if @generate_values
            #!== um-comment the line for the algo to use ==!#
            @mid_value = mid_sq(@mid_value)
            #@mid_value = weyl_mid_sq(@mid_value)
            #@mid_value = linear_cong(@mid_value)
            #@mid_value = blum2_shub(@mid_value)

            if @values_generated.include?(@mid_value)
                if @repeated_values.include?(@mid_value)
                    puts("period is #{@repeated_values.size()}, repeation started after #{@values_generated.size()} with value #{@repeated_values[0]}")
                    #puts @repeated_values
                    #@generate_values = false
                else
                    @repeated_values.push(@mid_value)
                end
            else
                @values_generated.push(@mid_value)
            end

            new_entry = forked_random_walker(@mid_value[0])
            @increment_values.push(new_entry)
        end
    end
    
    def needs_cursor?
        true
    end

    def draw
        Gosu.draw_rect(0, 0, 1900, 1000, 0xff_0F0D0E, 0)
        start_cords = final_cords = [950, 500]
        for i in 0...@increment_values.size()
            final_cords[0]+= @increment_values[i][0]
            final_cords[1]+= @increment_values[i][1]
            draw_line(start_cords[0], start_cords[1], 0xff_00ff00, final_cords[0], final_cords[1], 0xff_00ff00, 1)
            start_cords = final_cords.clone()
        end
    end

    def button_down(id)
        close if id == Gosu::KB_ESCAPE
        if id == Gosu::KB_SPACE
            if @generate_values #window will close when escape is pressed twice
                puts "generated #{@values_generated.size} values"
                @generate_values = false
            else
                @generate_values = true
            end
        end
    end
end
Graph.new.show()
