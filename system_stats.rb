#!/usr/bin/env ruby -E utf-8
#<Encoding:UTF-8>

require 'colorize'

width_menubar = 5
width_menu = 12
show_top_processes = 6
$markers = {
	"empty" => "○",
	"filled" => "●︎"
}
cpu_count = `sysctl -n hw.ncpu`.to_f
cpu_percent_total = `ps aux  | awk 'BEGIN { sum = 0 }  { sum += $3 }; END { print sum }'`.to_f
mem_percent_total = `ps aux  | awk 'BEGIN { sum = 0 }  { sum += $4 }; END { print sum }'`.to_f
system_load_avg = `sysctl -n vm.loadavg | awk '{print $2,$3,$4}'`.split

load_percent_current = system_load_avg[0].to_f / cpu_count * 100
load_direction = ""
if system_load_avg[0] > system_load_avg[1]
	load_direction = "⬆"
elsif system_load_avg[0] < system_load_avg[1]
	load_direction = "⬇︎"
end

mem_percent_rounded = mem_percent_total.round

cpu_used = cpu_percent_total / cpu_count / 100
cpu_percent_adjusted = (cpu_used * 100)
cpu_percent_rounded = cpu_percent_adjusted.round

top_cpu = %x{ps -arcwwwxo "command %cpu"|iconv -c -f utf-8 -t utf-8}.split("\n")
top_cpu_out = ""
top_cpu.each do |line|	
	line = line.split
	cpu_percent = line[line.length-1]
	cpu_text = "[#{cpu_percent}%]"
	process = line[0..(line.length-2)].join(' ')

	if cpu_percent.to_f > 70
		cpu_text = cpu_text.red
	end

	top_cpu_out += "#{process} #{cpu_text}\n"
end
top_cpu_out = top_cpu_out.split("\n")

def paint_dots(percent, width)
	if percent > 100
		percent = 100
	end
	filled_dots = (percent / 100.0 * width).round
	empty_dots = width - filled_dots
	filled = ""
	empty = ""
	if filled_dots > 0
		i = 0
		begin
			i += 1
			filled = "#{filled}#{$markers["filled"]}"
		end while i < filled_dots
	end
	if empty_dots > 0
		i = 0
		begin
			i += 1
			empty = "#{empty}#{$markers["empty"]}"
		end while i < empty_dots
	end

	filled_colorized = filled.green
	if percent > 70
		filled_colorized = filled.yellow
	elsif percent > 90
		filled_colorized = filled.red
	end
	return "#{filled_colorized}#{empty}"
end

# cpu_dots = paint_dots(cpu_percent_rounded, width_menubar)
puts "#{load_direction} #{paint_dots(load_percent_current, width_menubar)}"
# puts "#{paint_dots(load_percent_current, width_menu)} LOAD #{system_load_avg[0]}"
puts "LOAD: #{system_load_avg[0]}, #{system_load_avg[1]}, #{system_load_avg[2]}"
puts "#{paint_dots(cpu_percent_rounded, width_menu)} CPU #{cpu_percent_rounded}%"
puts "#{paint_dots(mem_percent_rounded, width_menu)} RAM #{mem_percent_rounded}%"
puts "---"
puts top_cpu_out[1..show_top_processes]
