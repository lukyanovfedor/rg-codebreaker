# Codebreaker

Codebreaker gem for RubyGarage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'codebreaker', :git => "https://github.com/lukyanovfedor/rg-codebreaker"
```

And then execute:

    $ bundle

## Usage
```ruby
<pre>
	require "bundler/setup"
	require "codebreaker"

	module ConsoleGame
	  def self.start
	    @@game = Codebreaker::Game.new

	    puts "Welcome to Codebreaker game!"
	    puts "Print 4 digit code or press 'h' for help"

	    self.controller
	  end

	  def self.controller
	    attempt = gets.chomp

	    case attempt
	      when /^[1-6]{4}$/
	        self.try attempt
	      when /h/
	        self.help
	      else
	        puts "Wrong input"
	        self.controller
	    end
	  end

	  def self.help
	    hint = @@game.hint

	    case hint
	      when String
	        puts "And a hint is..."
	        puts hint
	        puts "Hope it will help u to win"
	        self.controller
	      else
	        puts "Sry, no more hints avaible"
	        self.controller
	    end
	  end

	  def self.try (attempt)
	    result = @@game.gues attempt

	    case result
	      when "++++"
	        puts "You did it! Good job!"
	        self.game_over
	      when nil
	        puts "Ohhh so sad, game is over :("
	        self.game_over
	      else
	        if @@game.attempts_number > 0
	          puts result
	          self.controller
	        else
	          puts "Ohhh so sad, game is over :("
	          self.game_over
	        end
	    end
	  end

	  def self.game_over
	    self.save

	    self.load

	    self.play_again
	  end

	  def self.save
	    puts "Wanna save result?(y|n)"

	    answer = gets.chomp

	    if answer == "y"
	      puts "Great. Enter your name"
	      name = gets.chomp

	      @@game.save_result name
	    end
	  end

	  def self.play_again
	    puts "Wanna play again?(y|n)"

	    answer = gets.chomp

	    if answer == "y"
	      self.start
	    end
	  end

	  def self.load
	    puts "Wanna see results?(y|n)"

	    answer = gets.chomp

	    if answer == "y"
	      results = @@game.load_result

	      if results.empty?
	        return puts "Sorry no result avaible"
	      end

	      results.each do |r|
	        puts
	        puts "Name: #{r.name}"
	        puts "Result: #{r.status}"
	        puts "Used attempts: #{r.used}"
	        puts
	      end
	    end
	  end
	end

	ConsoleGame.start
</pre>
