# Requirements

Please implement a game of 3x3x3 [connect-four](https://en.wikipedia.org/wiki/Connect_Four) (win by placing 3 pieces in a row on a 3x3 board) in Ruby 2.5.0 or higher. Additionally, please structure your code so that it's easy to change the size of your board and the number of pieces in a row required to win (it should be obvious to me how to change the game to any arbitrary config, such as 6x7x4).

Your game needs to provide a computer player, who will always go first. This computer player must implement at least 2 different strategies (for example, random walk and minimax). At least one of your implemented strategies must play reasonably well against its human opponent, which means AI should **never** lose on smaller boards, and changing board size shouldn't affect loss rate (or make an argument why that's not possible). It's ok, however, for your AI to take a long time on larger boards.

At the beginning of the game, please prompt human player to select one of the implemented strategies. The player who first succeeds in placing the required number of consecutive marks in a horizontal, vertical, or diagonal row wins the game.

We expect your game to be executed in the terminal (command line interface). The simplest representation of the game board and communication to prompt human player for moves should be sufficient.

A very important quality for professional software engineer is the ability to write concise and expressive code. Please structure your code to model the problem domain in a way that's easy to understand. Your submission will be judged on its structure, clarity, and correctness.

Please also include appropriate tests for your code (see below for more details).

# Guideline

* Feel free to make assumptions about anything that's not stated above - but please state your assumptions in a project read-me.
* Design carefully but please refrain from over-engineering. A simple solution is often a good solution.
* You can use any algorithm and/or heuristic functions for your computer player. If you are unsure, we recommend starting with a strategy that makes random moves before adding a second strategy that implements Minimax.
* Please make incremental commits as you progress so that we can retrace your steps when reviewing your submission.

# Testing

For testing, we recommend using rspec. An initial setup has already been included in the project though you are not required to use this setup. To use the provided setup:

1. `gem install bundler` installs bundler.
2. `bundle install` installs rspec and other dependencies.
3. `bundle exec rspec` run all tests in the `spec/` directory.

All of your tests should be added under the `spec/` directory. There are lots of online resources for writing tests in rspec. Feel free to look at any of them. If you have never written test before, [this](https://blog.teamtreehouse.com/an-introduction-to-rspec) seems like a decent one to start with.

# Submission

Please fork this repository or create your own repo. Then checkout a branch and open a PR **against the master branch of your own fork (do NOT open your PR against the master upstream)**. If we have any question regarding your submission, we will be communicate via PR comments. When you are done, please email us a link to your pull request. If you make it a private repo, please share it with `zinosama`. For any question, please feel free to email zino@chowbus.com.
