# -*- coding: utf-8 -*-

#
# ~/.termtter/config
# 
# config.plugins.stdout.gray   = 245
# config.plugins.stdout.colors =
#  [ 1..6, 9..14, 104..123, 130..159, 165..195, 200..230 ].map(&:to_a).flatten + [ 245 ]
#
class TermColor::MyListener
  def to_esc_seq(name)
    if (HighLine.const_defined?(name.upcase) rescue false)
      HighLine.const_get(name.upcase)
    else
      case name
      when /^([fb])(\d+)$/
        fb = $1 == 'f' ? 38 : 48
        "\e[#{fb};5;#{color}m"
      when /^[^0-9]?(\d+)$/
        "\e[38;5;#{$1.to_i}m"
      end
    end
  end
end
