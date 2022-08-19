#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  # check if element exist on the database
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  ELEMENT_INFO=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number = $1 ORDER BY atomic_number")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # show element info
    echo $ELEMENT_INFO | while read ATOMIC BAR NAME BAR SYMBOL BAR MASS BAR MELT BAR BOIL BAR TYPE
    do
     echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi

if ! [[ $1 =~ ^[0-9]+$ ]]
then
  #Check if arg is a character
  n=${#1}
  if [[ $n > 0 ]] && [[ $n < 3 ]]
  then
    #check if element exist
    SYMBOL_CHECK=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    if [[ -z $SYMBOL_CHECK ]]
    then
      echo "I could not find that element in the database."
    else
      #get element info
      ELEMENT_INFO=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE symbol = '$1' ORDER BY atomic_number")
      # show element info
      echo $ELEMENT_INFO | while read ATOMIC BAR NAME BAR SYMBOL BAR MASS BAR MELT BAR BOIL BAR TYPE
      do
      echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
    #Check if arg is a string
  elif [[ $n > 2 ]]
    then
      #check is element existos
      NAME_CHECK=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
      #if doesn't exists
      if [[ -z $NAME_CHECK ]]
      then
        echo "I could not find that element in the database."
      else
        #get element info
      ELEMENT_INFO=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE name = '$1' ORDER BY atomic_number")
      # show element info
      echo $ELEMENT_INFO | while read ATOMIC BAR NAME BAR SYMBOL BAR MASS BAR MELT BAR BOIL BAR TYPE
      do
      echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
      fi
  fi
fi

