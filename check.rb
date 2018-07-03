#!/usr/bin/env ruby

def no(i, line)
	puts "#{i.to_s} #{line}"
	system "pause"
end

File.open("data.txt", "r") do |f|
	pattern = {
		:page => /^\[\d+\]$/,
		:chinese_sentence => /^[“”A-Za-z0-9]*[一-龠][A-Za-z0-9一-龠，。、；：‘’“”！？·《》（）]+$/,
		:english_sentence => /^[ -~‘’“”]+ [ -~‘’“”]+$/,
		:english_word => /^[A-Za-z]+$/,
		:empty => /^$/,
	}
	permit = {
		:page => true,
		:chinese_sentence => false,
		:english_sentence => false,
		:english_word => false,
		:empty => false,
	}
	i = 0
	f.each_line do |line|
		i += 1
		line.chomp!
		case line
		when pattern[:page]
			if not permit[:page]
				no i, line
			end
			permit[:page] = false
			permit[:chinese_sentence] = false
			permit[:english_sentence] = false
			permit[:english_word] = true
			permit[:empty] = false
		when pattern[:chinese_sentence]
			if not permit[:chinese_sentence]
				no i, line
			end
			permit[:page] = false
			permit[:chinese_sentence] = false
			permit[:english_sentence] = true
			permit[:english_word] = false
			permit[:empty] = false
		when pattern[:english_sentence]
			if not permit[:english_sentence]
				no i, line
			end
			permit[:page] = false
			permit[:chinese_sentence] = false
			permit[:english_sentence] = true
			permit[:english_word] = false
			permit[:empty] = true
		when pattern[:english_word]
			if not permit[:english_word]
				no i, line
			end
			permit[:page] = false
			permit[:chinese_sentence] = true
			permit[:english_sentence] = false
			permit[:english_word] = false
			permit[:empty] = false
		when pattern[:empty]
			if not permit[:empty]
				no i, line
			end
			permit[:page] = true
			permit[:chinese_sentence] = false
			permit[:english_sentence] = false
			permit[:english_word] = true
			permit[:empty] = false
		end
	end
end

no(0, "END")
