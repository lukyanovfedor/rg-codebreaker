require 'spec_helper'

module Codebreaker
  describe Game do
    subject(:game) { Game.new }

    context ".new" do
      it "sets secret code" do
        expect(game.instance_variable_get(:@code)).not_to be_empty
      end

      it "sets 4 numbers secret code" do
        expect(game.instance_variable_get(:@code)).to have(4).items
      end

      it "sets secret code with numbers from 1 to 6" do
        expect(game.instance_variable_get(:@code)).to match /[1-6]+/
      end

      it "sets number of attempts eq 10" do
        expect(game.attempts_number).to eq 10
      end

      it "sets humber of attempts, that is not 0" do
        expect(game.attempts_number).not_to eq 0
      end

      it "sets number of hints eq 1" do
        expect(game.hints_number).to eq 1
      end

      it "sets initial number of attempts to eq 10" do
        expect(game.instance_variable_get(:@attempts_initial)).to eq 10
      end

      it "sets win status to false" do
        expect(game.instance_variable_get(:@win)).to eq false
      end
    end

    context "#gues" do
      before(:each) do
        allow_any_instance_of(Game).to receive(:generate_code).and_return("1234")
      end

      it "should raise ArgumentError, when no argumets" do
        expect { game.gues }.to raise_error(ArgumentError)
      end

      it "should raise TypeError, when argument is not a String" do
        expect { game.gues(1234) }.to raise_error(TypeError)
      end

      it "decreases attempts number by one" do
        initial = game.attempts_number
        game.gues("5555")
        expect(game.attempts_number).to eq(initial - 1)
      end

      it "returns nil, when no attempts avaible" do
        10.times { game.gues("5555") }
        expect(game.gues("5555")).to be_nil
      end

      it "returns empty string, when all numbers are wrong" do
        expect(game.gues("5555")).to be_empty
      end

      it "sets win status to true, when you all gues" do
        game.gues "1234"
        expect(game.instance_variable_get(:@win)).to eq true
      end

      data = [
        ["1234", "1555", "+"],
        ["1234", "1225", "++"],
        ["1234", "1235", "+++"],
        ["1234", "1234", "++++"],
        ["1234", "4321", "----"],
        ["1234", "4325", "---"],
        ["1234", "4355", "--"],
        ["1234", "4555", "-"],
        ["1335", "3346", "+-"],
        ["1134", "1335", "++"],
        ["1234", "1455", "+-"],
        ["3346", "1334", "+-"]
      ]

      data.each do |d|
        it "returns #{d[2]}, when attempt is #{d[1]} and code is #{d[0]}" do
          allow_any_instance_of(Game).to receive(:generate_code).and_return(d[0])
          expect(game.gues d[1]).to eq(d[2])
        end
      end
    end

    context "#hint" do
      it "returns 1***, when code 1234, and hint first char" do
        allow_any_instance_of(Game).to receive(:generate_code).and_return("1234")
        allow_any_instance_of(Game).to receive(:rand).and_return(0)
        expect(game.hint).to eq("1***")
      end

      it "decreases avaible hints number by one" do
        initial = game.hints_number
        game.hint
        expect(game.hints_number).to eq(initial - 1)
      end

      it "returns nil, when no hint avaible" do
        game.hint
        expect(game.hint).to be_nil
      end
    end

    context "#save_result" do
      after(:all) do
        File.delete "#{__dir__}/../../files/test.bin"
      end

      it "saves file with name 'test.bin'" do
        game.save_result("john dou", "test.bin")
        expect(File.exist? "#{__dir__}/../../files/test.bin").to eq true
      end

      it "raise TypeError, when username not string" do
        expect { game.save_result(1234) }.to raise_error(TypeError)
      end

      it "raise TypeError, when filename not string" do
        expect { game.save_result("john", 1234) }.to raise_error(TypeError)
      end

      it "raise ArgumentError, when no username given" do
        expect { game.save_result }.to raise_error(ArgumentError)
      end

      it "saves history array in file 'test.bin'" do
        game.save_result("john dou", "test.bin")

        history = File.read "#{__dir__}/../../files/test.bin"
        history = Marshal.load history

        expect(history).to be_kind_of(Array)
      end

      it "saves result, with fields name, status, used" do
        game.save_result("john dou", "test.bin")

        history = File.read "#{__dir__}/../../files/test.bin"
        history = Marshal.load history

        expect(history.sample).to include(:name, :status, :used)
      end
    end

    context "#load_result" do
      after(:all) do
        File.delete "#{__dir__}/../../files/test.bin"
      end

      it "raise TypeError, when filename not string" do
        expect { game.save_result 1234 }.to raise_error(TypeError)
      end

      it "load history array from file 'test.bin'" do
        game.save_result("john dou", "test.bin")

        history = game.load_result "test.bin"

        expect(history).to be_kind_of(Array)
      end
    end
  end
end