#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat "games.csv" | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Check if WINNER is in TEAMS
  WINNER_SEARCH_RESULT=$($PSQL "SELECT * FROM teams WHERE name='$WINNER';")
  if [[ -z $WINNER_SEARCH_RESULT && $WINNER != "winner" ]]
  then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
    echo Inserted into teams, $WINNER
  fi

  # Check if OPPONENT is in TEAMS
  OPPONENT_SEARCH_RESULT=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT';")
  if [[ -z $OPPONENT_SEARCH_RESULT && $OPPONENT != "opponent" ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
  fi

  # GET WINNER ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

  # GET OPPONENT_ID
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

  # Check if Variables are valid
  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
  then
    # INSERT Game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi

done
