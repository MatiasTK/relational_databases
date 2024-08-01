#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELEMENT=$1

get_element(){
  local COMPARISON=$1
  echo "$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $COMPARISON")"
}

# Check if there are any parameter
if [[ -z $ELEMENT ]];then
  echo "Please provide an element as an argument."
  exit 0
fi

# Check if parameter is a number
if [[ $ELEMENT =~ ^[0-9]+$ ]];then
  GET_ELEMENT_RESULT=$(get_element "atomic_number=$ELEMENT")
# Check if element is a letter
elif [[ ${#ELEMENT} -le 2 ]];then
  GET_ELEMENT_RESULT=$(get_element "symbol='$ELEMENT'")
# Element is a name
else
  GET_ELEMENT_RESULT=$(get_element "name='$ELEMENT'")
fi

# Not found
if [[ -z $GET_ELEMENT_RESULT ]];then
  echo "I could not find that element in the database."
  exit 0
fi

# Turn result (GET_ELEMENT_RESULT) into array (ELEMENT_DATA)
IFS='|' read -r -a ELEMENT_DATA <<< "$GET_ELEMENT_RESULT"

echo "The element with atomic number ${ELEMENT_DATA[0]} is ${ELEMENT_DATA[1]} (${ELEMENT_DATA[2]}). It's a ${ELEMENT_DATA[3]}, with a mass of ${ELEMENT_DATA[4]} amu. ${ELEMENT_DATA[1]} has a melting point of ${ELEMENT_DATA[5]} celsius and a boiling point of ${ELEMENT_DATA[6]} celsius."
