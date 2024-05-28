#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  # Insert WINNER team names in teams table
  if [[ $WINNER != "winner" ]] 
    then 
      # Get team name
      WTEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        # If not found
        if [[ -z $WTEAM_NAME ]]
          then
          INSERT_WTEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            # Call team name
            if [[ $INSERT_WTEAM_NAME == "INSERT 0 1" ]]
              then
                echo "Inserted team $WINNER"
            fi
        fi    
  fi

  # Insert OPPONENT teams
  if [[ $OPPONENT != "opponent" ]] 
    then 
      # Get team name
      OTEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
        #If not found
        if [[ -z $OTEAM_NAME ]]
          then
          INSERT_OTEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            # Call team name
            if [[ $INSERT_OTEAM_NAME == "INSERT 0 1" ]]
              then
                echo "Inserted team $OPPONENT"
            fi
        fi    
  fi

  # Insert games in GAMES
  if [[ $YEAR != "year" ]]
    then
      # Get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      # Get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      # Insert rows
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
        # Echo to know it's inserted
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
          then 
            echo "New GAME added: $YEAR, $ROUND, $WINNER_ID vs $OPPONENT_ID, score $W_GOALS : $O_GOALS"
        fi
  fi

done      