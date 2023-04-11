#!/bin/bash
# Number guessing game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read username

USER=$($PSQL "SELECT username FROM users WHERE username = '$username'")
if [[ -z $USER ]]
then
  echo "Welcome, $username! It looks like this is your first time here."
  NEWUSER=$($PSQL "INSERT INTO users(username) VALUES('$username')")
#fi
else
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$username'")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$username'")
echo "Welcome back, $username! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."  
fi
# get a random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
TRIES=0
echo "Guess the secret number between 1 and 1000:"
read GUESS


if [[ ! $GUESS =~ [0-9] ]]
then
  echo "That is not an integer, guess again:" 
fi
#TRIES=0
while [[ $GUESS != $SECRET_NUMBER ]]
do
  TRIES=$(( TRIES + 1 ))
  if [[ $GUESS > $SECRET_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read GUESS
  else 
    echo "It's higher than that, guess again:"
    read GUESS
  fi
  done

TRIES=$(( TRIES + 1 ))
echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"

function UPDATE_USERS() {
  NEWGAMES=$(( GAMES_PLAYED + 1 ))
  NEWGAMEUP=$($PSQL "UPDATE users SET games_played = $NEWGAMES WHERE username = '$username'")
  
if [[ $TRIES -lt $BEST_GAME || $BEST_GAME -eq 0 ]]
then
  NEWBEST=$($PSQL "UPDATE users SET best_game = $TRIES WHERE username = '$username'")
fi
}
UPDATE_USERS
