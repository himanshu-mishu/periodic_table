#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1

# Query to fetch element info by atomic_number, symbol, or name (case insensitive for symbol/name)
ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = '$INPUT' OR LOWER(elements.symbol) = LOWER('$INPUT') OR LOWER(elements.name) = LOWER('$INPUT');")

# Check if element was found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse element info separated by pipe
IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$ELEMENT"

echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
