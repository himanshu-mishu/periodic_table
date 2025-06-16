#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# No argument
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Determine query type (atomic_number, symbol, or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1;")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';")
fi

# If element not found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse and format result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
##for final commit