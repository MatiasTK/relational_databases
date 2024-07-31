#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
INSERT_SUCCESS="INSERT 0 1"

#echo $($PSQL "TRUNCATE customers, appointments")
echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "1) Haircut\n2) Manicure\n3) Facial"

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) ADD_APPOINTMENT 1 "haircut" ;;
  2) ADD_APPOINTMENT 2 "manicure" ;;
  3) ADD_APPOINTMENT 3 "facial" ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

ADD_APPOINTMENT() {
  local SERVICE_ID=$1
  local SERVICE_STR=$2

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Verify phone number -> NOT PASSING TESTS
  #if [[ ! $CUSTOMER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]
  #then
  #  MAIN_MENU "That is not a valid phone number."
  #fi

  # get customer info
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    # Add customer
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  # get customer appointment
  APPOINTMENT_ID=$($PSQL "SELECT appointment_id FROM appointments WHERE customer_id=$CUSTOMER_ID AND service_id=$SERVICE_ID")

  # if not found
  if [[ -z $APPOINTMENT_ID ]]
  then
    # Add appointment
    echo -e "\nWhat time would you like your $SERVICE_STR, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # Verify time -> NOT PASSING TESTS
    #if [[ ! $SERVICE_TIME =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]
    #then
    #  MAIN_MENU "That is not a valid time."
    #fi

    ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")


    if [[ $ADD_CUSTOMER_RESULT = $INSERT_SUCCESS && $ADD_APPOINTMENT_RESULT = $INSERT_SUCCESS ]]
    then
      echo -e "\nI have put you down for a $SERVICE_STR at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  else
    # Already have an appointment
    APPOINTMENT_TIME=$($PSQL "SELECT time FROM appointments WHERE customer_id=$CUSTOMER_ID")
    echo -e "\nYou have already an appointment for $SERVICE_STR at:$APPOINTMENT_TIME\n"
  fi
}

EXIT() {
  echo -e "\n Thank you for stopping in.\n"
}

MAIN_MENU "Welcome to My Salon, how can I help you?\n"
