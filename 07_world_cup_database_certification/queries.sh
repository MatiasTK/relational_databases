#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT GREATEST((SELECT MAX(winner_goals) FROM games), (SELECT MAX(opponent_goals) FROM games))")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(CASE WHEN winner_goals > 2 THEN 1 ELSE NULL END) FROM games")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE year=2018 AND round='Final')")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE year=2014 AND round='Eigghth-Final') OR team_id IN (SELECT opponent_id FROM games WHERE year=2014 AND round='Eigghth-Final')")"

echo -e "\nList of unique winning team names in the whole data set:"
echo

echo -e "\nYear and team name of all the champions:"
echo

echo -e "\nList of teams that start with 'Co':"
echo
