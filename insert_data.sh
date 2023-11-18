#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

filename="games.csv"

echo $($PSQL "TRUNCATE TABLE games, teams")

cat $filename | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if (( $YEAR != 'year' ))
    then 
      # =================== SEARCH FOR TEAM NAME IN DB AND ADD A ENTRY RECORD IF IT DOES NOT EXIST ===================
      WINNER_SEARCH=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      
      echo $WINNER_SEARCH

      if [[ -z $WINNER_SEARCH  ]]
      then
        echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        WINNER_SEARCH=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi

      OPPONENT_SEARCH=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      
      echo $OPPONENT_SEARCH

      if [[ -z $OPPONENT_SEARCH  ]]
      then
        echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        OPPONENT_SEARCH=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi

      # ===============================================================================================================

      echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_SEARCH, $OPPONENT_SEARCH, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
done
