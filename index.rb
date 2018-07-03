#!/usr/bin/env ruby

require "./pinyin"
require "./correct_case"

class ExampleSentence
	attr_accessor :page
	attr_accessor :keyword
	attr_accessor :chinese
	attr_accessor :english
	def initialize
		@page = 0
		@keyword = nil
		@chinese = nil
		@english = []
	end
	def chinese_header
		case @chinese
		when /^[A-Za-z0-9]/
			@chinese[/^[A-Za-z0-9]+/]
		when /^“/
			@chinese[/^“.+?”/]
		else
			"#{@chinese[0..1]}……#{@chinese[-3..-1]}"
		end
	end
	def ref(this = "")
		if this.upcase == @keyword.upcase
			@page.to_s
		else
			"\\myindexref{#{@page}}{#{@keyword}}"
		end
	end
end

File.open("output.tex", "wb") do |fout|
	page = nil
	all = []
	a = ExampleSentence.new
	File.open("data.txt", "r") do |fin|
		fin.each_line do |line|
			line.chomp!
			case line
			when /^\[(\d+)\]$/
				page = $1.to_i
			when /^$/
				all << a
				a = ExampleSentence.new
			else
				if not a.keyword
					a.page = page
					a.keyword = line
				elsif not a.chinese
					a.chinese = line
				else
					line.gsub!("‘", "`")
					line.gsub!("’", "'")
					line.gsub!("“", "``")
					line.gsub!("”", "''")
					a.english << line
				end
			end
		end
		all << a
	end

	fout.puts "\\section{首字（末字）音序索引}"
	fout.puts "\\begin{multicols}{3}"
	pinyin_index = Hash.new { |hash, key| hash[key] = [] }
	all.each do |a|
		pinyin = PINYIN[a.chinese[0]].to_s.upcase
		case pinyin
		when "WO", "TA", "ZHE"
			pinyin = "#{pinyin} \\ldots{} #{PINYIN[a.chinese[-2]].to_s[0..0].upcase}"
		end
		pinyin_index[pinyin] << a
	end
	pinyin_index.keys.sort.each do |k|
		fout.puts "\\subsection{#{k.empty? ? "字母和符号" : k}}"
		pinyin_index[k].sort! { |a, b| a.chinese <=> b.chinese }
		pinyin_index[k].each do |a|
			fout.puts "\\myindexitem{#{a.chinese_header}}{#{a.ref}}"
		end
	end
	fout.puts "\\end{multicols}"

	fout.puts "\\section{单词索引}"
	fout.puts "\\begin{multicols}{4}"
	word_index = Hash.new { |hash, key| hash[key] = [] }
	all.each do |a|
		words = []
		a.english.each do |s|
			words.concat(s.scan(/\b[A-Za-z0-9']+\b/))
		end
		words.uniq!
		words.each do |w|
			word_index[w.upcase] << a
		end
	end
	alpha = nil
	fout.puts "\\subsection{数字}"
	word_index.keys.sort.each do |w|
		word_index[w].uniq! { |a| a.keyword }
		next if word_index[w].size > 1
		next if w.size == 1
		if (alpha.nil? and w[0] == "A") or (not alpha.nil? and alpha != w[0])
			alpha = w[0]
			fout.puts "\\subsection{#{alpha}}"
		end
		fout.puts "\\myindexitem{#{CORRECT_CASE[w] or w.downcase}}{#{word_index[w].map { |a| a.ref(w) }.join(", ")}}"
	end
	fout.puts "\\end{multicols}"
end
exec "xelatex publication.tex"
