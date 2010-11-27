# -*- coding: utf-8 -*-

module TermColor
  class << self
    def prepare_parse(text)
      text.gsub(/<(\/?)(\d+|[0-9a-fA-F]{6})>/, '<\1_\2>')
    end
  end

  class MyListener
    def to_esc_seq(name)
      if (HighLine.const_defined?(name.upcase) rescue false)
        HighLine.const_get(name.upcase)
      else
        case name
        when /^[^0-9]?([0-9a-f]{6})$/i
          r, g, b = $1[0..1].to_i(16), $1[2..3].to_i(16), $1[4..5].to_i(16)
          color = 16 + (6 * (r / 256.0)).to_i * 36 + (6 * (g / 256.0)).to_i * 6 + (6 * (b / 256.0)).to_i
          "\e[38;5;#{color}m"
        when /^([fb])(\d+)$/
          fb = $1 == 'f' ? 38 : 48
          color = $2.size == 3 ? 16 + $2.to_i(6) : 232 + $2.to_i
          "\e[#{fb};5;#{color}m"
        when /^[^0-9]?(\d+)$/
          "\e[#{$1}m"
        end
      end
    end
  end
end

module Termtter
  class StdOut < Hook

    def color_of_screen_name(screen_name)
      return color_of_screen_name_cache[screen_name] if color_of_screen_name_cache.key?(screen_name)
      color = config.plugins.stdout.instance_eval {
        sweets.include?(screen_name) ?
          sweet_color :
            (0..2).map{|n| (screen_name.hash.abs % (64 - n) * 3 + 64 + (n * 3)).to_s(16) }.join
      }
      color_of_screen_name_cache[screen_name] = color
      color_of_screen_name_cache[screen_name]
    end

  end
end
