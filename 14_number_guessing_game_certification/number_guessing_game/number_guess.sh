#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"
echo -n "Enter your username: "
read -r USERNAME

# Get info
USERNAME_INFO=$($PSQL "SELECT user_id, name, games_played, best_game FROM users WHERE name='$USERNAME'")

# Parse info
IFS='|' read -r USER_ID NAME GAMES_PLAYED BEST_GAME <<< "$USERNAME_INFO"

# Check if users exists
if [[ -n $USERNAME_INFO ]];then
  echo "Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  # Add user to DB
  ADD_RESULT=$($PSQL "INSERT INTO users(name, games_played,best_game) VALUES('$USERNAME', 0, 0)")

  # Refresh info
  USERNAME_INFO=$($PSQL "SELECT user_id, name, games_played, best_game FROM users WHERE name='$USERNAME'")
  IFS='|' read -r USER_ID NAME GAMES_PLAYED BEST_GAME <<< "$USERNAME_INFO"

  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

# Get random number between 0 and 1000
RANDOM_NUMBER=$(($RANDOM%1000))

# Declare as integer
declare -i GUESSES_COUNT

try_guess(){
  local INFO=$1

  echo -n "$INFO"
  read -r GUESS

  # Check if guess is a number
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    try_guess "That is not an integer, guess again: "
  fi

  GUESSES_COUNT+=1

  if [[ $GUESS -gt $RANDOM_NUMBER ]]; then
    try_guess "It's lower than that, guess again: "
  elif [[ $GUESS -lt $RANDOM_NUMBER ]]; then
    try_guess "It's higher than that, guess again: "
  fi
}

try_guess "Guess the secret number between 1 and 1000: "

# Update games played
UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE user_id=$USER_ID")

# Update best game
if [[ $BEST_GAME -eq 0 || $GUESSES_COUNT -lt $BEST_GAME ]];then
  UPDATE_BEST_RESULT=$($PSQL "UPDATE users SET best_game=$GUESSES_COUNT WHERE user_id=$USER_ID")
fi

echo "You guessed it in $GUESSES_COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
