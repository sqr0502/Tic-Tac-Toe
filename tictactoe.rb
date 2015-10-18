#check location is empty, if not return false
def chk_board(x, y, input, gameboard)
  check = {
    space: false,
    gameboard: gameboard
    }
  if check[:gameboard][y][x] == ""
    check[:gameboard][y][x] = input
  else
    chk_space = true
  end
  check
end

#set_location is what the user inputs, and check if the location has not been used
#returns gameboard
def set_location(user_input, gameboard)
  chk_input = true
  while chk_input
    location = gets.chomp
    if location.include? ","
      location = location.split(",")
      if location.length == 2
        location_x = location[0].to_i
        location_y = location[1].to_i
        #check that location is in range
        if location_x >= 0 && location_x <= 2 && location_y >= 0 && location_y <= 2
          #check if space is available
          check = chk_board(location_x, location_y, user_input, gameboard)
          #apply changes to game board
          gameboard = check[:gameboard]
          #assign the return value of check space
          chk_input = check[:space]
        else
          #check range, and redo
          puts "Try again! Enter coordinates
          of desired position:"
          redo
        end
      else
        #check for input split, and redo
        puts "Whoops! That's not a coordinate! Enter coordinates of position, (i.e. [1, 2]):"
        redo
      end
    else
      #check for comma, and redo
      puts "Do you know what coordinates look like? Try again! (i.e. [1, 2]): "
      redo
    end
  end
  gameboard
end

#computer player, random tokens display
#returns gameboard
def comp_location(comp_input, gameboard)
  chk_comp_input = true
  while chk_comp_input
    c_location_x = rand(0..2)
    c_location_y = rand(0..2)
    #break loop if true, check space is available and set it
    check = chk_board(c_location_x, c_location_y, comp_input, gameboard)
    gameboard = check[:gameboard]
    chk_comp_input = check[:space]
  end
  gameboard
end

#display gameboard, if column is empty display '_|' otherwise display '|'
def draw_board(gameboard)
  board = ''
  gameboard.each do |row|
    row.each do |column|
      if column == ""
        board += "_|"
      else
        board += "#{column}|"
      end
    end
    board += "\n"
  end
  puts board
end

#winner token count
#index[0] is player, index[1] is comp
def get_winner(gameboard,tokens)
  won = false
  user_token = tokens[0]
  comp_token = tokens[1]
  #check horizontally
  gameboard.each do |row|
    computer = 0
    user = 0
    #loop through row for columns
    row.each do |column|
      if column == user_token
        user += 1
      elsif column == comp_token
        computer += 1
      end
    end
    #check to see if user won
    if user == 3
      won = true
    end
  end # end horizontal check

  i = 0
  #check vertically, for user token
  while i < gameboard.length
    if gameboard[i][0] == user_token && gameboard[i][1] == user_token && gameboard[i][2] == user_token
      won = true
    end
    i += 1
  end

  #check diagonal, for user token
  if gameboard[0][0] == user_token && gameboard[1][1] == user_token && gameboard[2][2] == user_token
    won = true
  elsif gameboard[0][2] == user_token && gameboard[1][1] == user_token && gameboard[2][0] == user_token
    won = true
  end

  won
end

#player chooses token "x" or "o", returns array
#index[0] is player, index[1] is comp
def set_token
  choice = gets.chomp
  tokens = ["",""]
  if choice == "x"
    tokens[0] = "x"
    tokens[1] = "o"
  elsif choice == "o"
    tokens[0] = "o"
    tokens[1] = "x"
  end
  tokens
end

#generate empty gameboard
def get_gameboard
  gameboard = [["","",""], ["","",""], ["","",""]]
  gameboard
end

#main method, pieces to display on board
#index[0] is player, index[1] is comp
def game
  gameboard = get_gameboard

  puts "Welcome! Let's play Tic-Tac-Toe!"
  puts "To start: Choose if you want to play as X or O. Press x or o."
  tokens = set_token()
  playgame = true
  while playgame
    continue = ''
    puts "Your turn. Now pick your location, by choosing your coordinates, x and y. (i.e. [1, 2])"
    #modify gameboard after computer input
    gameboard = comp_location(tokens[1], gameboard)
    #redraw gameboard
    draw_board(gameboard)
    #modify gameboard after user input
    gameboard = set_location(tokens[0], gameboard)
    #redraw modified gameboard
    draw_board(gameboard)

    won = get_winner(gameboard,tokens)
    #who won
    if won
      `say -v agnes "Winner winner, chicken dinner"`
      puts "Winner winner, chicken dinner"
      puts "Do you wish to play again? Y/N"
      continue = gets.chomp.upcase
    end

    #check if player wants to continue
    if continue == "Y"
      gameboard = get_gameboard
      redo
    elsif continue == "N"
      break
    end
  end
end

game()
