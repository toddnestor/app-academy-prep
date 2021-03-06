class Board < Abstract
  attr_accessor :missed_letters, :word, :maximum_misses

  def initialize(word_length)
    word_length ||= 0
    @missed_letters = []
    @word = Array.new(word_length)
    @maximum_misses = 6
  end

  def length
    @word.length
  end

  def fill_in_letter(letter, indexes=[])
    letter = letter.upcase

    if indexes.length > 0
      indexes.each {|index| @word[index] = letter}
    else
      @missed_letters << letter
    end
  end

  def print
    display_gallows
    puts
    puts "               Here is the word:"
    display_word
    puts
    puts "               Here are the letters you have guessed that were wrong:"
    display_misses
    puts
  end

  def word_length
    @word.length
  end

  def blank_spaces
    @word.count {|e| e.nil?}
  end

  def solved?
    @word.all? {|l| !l.nil?}
  end

  def lost?
    @missed_letters.length >= @maximum_misses
  end

  def index_of_blank_spot(num)
    count = 0
    @word.each_with_index do |letter, index|
      count += 1 if letter.nil?
      return index if count == num
    end
  end

  def not_guessed?(letter)
    !@missed_letters.include?(letter) && !@word.include?(letter)
  end

  def solved_word
    if solved?
      @word.join('')
    else
      ""
    end
  end

  def missed_more_than(num)
    @missed_letters.length > num
  end

  def display_word(with_numbers = false)
    puts "               #{@word.inject("") {|final_word, letter| final_word += letter ? letter : "_"}.chars.join(' ')}"
    if with_numbers
      count = 1
      numbers = @word.inject("") do |final, letter|
        if letter
          final += " "
        else
          final += count.to_s
          count += 1
        end

        final
      end

      puts "               #{numbers.chars.join(' ')}"
    end
  end

  def display_misses
    puts "               " + @missed_letters.join("   ") if @missed_letters.length > 0
    puts "               You haven't missed any letters yet." unless @missed_letters.length > 0
  end

  def display_gallows
    puts gallows.join("\n")
  end

  def gallows
    lines = [
      "                                  ___________.._______",
      "                            | .__________))______|",
      "                            | | / /      ||",
      "                            | |/ /       ||"
    ]

    if missed_more_than(0)
      lines += [
        "                            | | /        ||.-''.",
        "                            | |/         |/  _  \\",
        "                            | |          ||  `/,|",
        "                            | |          (\\\\`_.'",
        "                            | |         .-`--'."
      ]
    else
      lines += [
        "                            | | /        ||",
        "                            | |/         ||",
        "                            | |          ||_",
        "                            | |          (  \\\\",
        "                            | |           `--'"
      ]
    end

    case
    when missed_more_than(3)
      lines += [
        "                            | |        /Y . . Y\\",
        "                            | |       // |   | \\\\",
        "                            | |      //  | . |  \\\\",
        "                            | |     ')   |   |   (`"
      ]
    when missed_more_than(2)
      lines += [
        "                            | |        /Y . .  ",
        "                            | |       // |   |    ",
        "                            | |      //  | . |    ",
        "                            | |     ')   |   |    "
      ]
    when missed_more_than(1)
      lines += [
        "                            | |           . .  ",
        "                            | |          |   |    ",
        "                            | |          | . |    ",
        "                            | |          |   |    "
      ]
    else
      lines += [
        "                            | |                   ",
        "                            | |                   ",
        "                            | |                   ",
        "                            | |                   "
      ]
    end

    case
    when missed_more_than(5)
      lines += [
        "                            | |          ||'||",
        "                            | |          || ||",
        "                            | |          || ||",
        "                            | |          || ||",
        "                            | |         / | | \\",
        "                            \"\"\"\"\"\"\"\"\"\"|_`-' `-' |\"\"\"|"
      ]
    when missed_more_than(4)
      lines += [
        "                            | |          ||'  ",
        "                            | |          ||   ",
        "                            | |          ||   ",
        "                            | |          ||   ",
        "                            | |         / |   ",
        "                            \"\"\"\"\"\"\"\"\"\"|_`-'     |\"\"\"|",
      ]
    else
      lines += [
        "                            | |               ",
        "                            | |               ",
        "                            | |               ",
        "                            | |               ",
        "                            | |               ",
        "                            \"\"\"\"\"\"\"\"\"\"|_        |\"\"\"|",
      ]
    end

    lines += [
      "                            |\"|\"\"\"\"\"\"\"\\ \\       '\"|\"|",
      "                            | |        \\ \\        | |",
      "                            : :         \\ \\       : :  ",
      "                            . .          `'       . ."
    ]

    lines
  end
end
