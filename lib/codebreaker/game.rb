module Codebreaker
  class Game
    attr_reader :hints_number, :attempts_number

    def initialize (hints_number = 1, attempts_number = 10)
      @code = generate_code
      @hints_number = hints_number
      @attempts_number = attempts_number
      @attempts_initial = attempts_number
      @win = false
    end

    def gues (attempt)
      raise TypeError, "attempt is not a string" unless attempt.is_a? String
      return nil unless @attempts_number > 0

      @attempts_number = @attempts_number - 1

      attempt, code = attempt.split(""), @code.split("")
      out = ""

      attempt.each_with_index do |c, i|
        next unless code[i] == c

        out << "+"
        code[i] = ""
        attempt[i] = ""
      end

      attempt.delete("")
      code.delete("")

      attempt.each_with_index do |c, i|
        next unless code.include? c

        code[code.index(c)] = ""
        out << "-"
      end

      @win = out == "++++" ? true : @win;

      out
    end

    def save_result (username, filename = "result.bin")
      raise TypeError, "username is not a string" unless username.is_a? String
      raise TypeError, "filename is not a string" unless filename.is_a? String

      file = "#{__dir__}/../../files/#{filename}"

      begin
        if File.exist? file
          history = Marshal.load(File.open(file));
        else
          raise
        end
      rescue
        history = []
      end

      result = {}
      result[:name] = username
      result[:status] = @win ? "Win" : "Lose"
      result[:used] = @attempts_initial - @attempts_number
      result[:code] = @code

      history << result

      history = Marshal.dump history

      File.open(file, "w") do |file|
        file.write history
      end
    end

    def self.load_result (filename = "result.bin")
      raise TypeError, "filename is not a string" unless filename.is_a? String

      file = "#{__dir__}/../../files/#{filename}"

      begin
        result = File.read file

        Marshal.load result
      rescue
        []
      end
    end

    def hint
      return nil unless @hints_number > 0

      @hints_number = @hints_number - 1;

      hint = "****"
      indx = rand(4)

      hint[indx] = @code[indx]

      hint
    end

    private
      def generate_code
        numbers = (1..6).to_a
        code = ""

        4.times { code << numbers.sample.to_s }

        code
      end
  end
end