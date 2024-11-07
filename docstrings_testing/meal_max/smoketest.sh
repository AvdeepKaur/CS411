#!/bin/bash

# Define the base URL for the Flask API
BASE_URL="http://localhost:5001/api"

# Flag to control whether to echo JSON output
ECHO_JSON=false

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
  case $1 in
    --echo-json) ECHO_JSON=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

###############################################
#
# Health checks
#
###############################################

# Function to check the health of the service
check_health() {
  echo "Checking health status..."
  curl -s -X GET "$BASE_URL/health" | grep -q '"status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Service is healthy."
  else
    echo "Health check failed."
    exit 1
  fi
}

# Function to check the database connection
check_db() {
  echo "Checking database connection..."
  curl -s -X GET "$BASE_URL/db-check" | grep -q '"database_status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Database connection is healthy."
  else
    echo "Database check failed."
    exit 1
  fi
}
check_clear() {
    echo "Checking if Combatants get Cleared"
}

##########################################################
#
# Kitchen Management
#
##########################################################

#####clear_meals may need to be changed, refer to kitchen_models.py and app.py

clear_meals() {
  echo "Clearing all the meals..."
  curl -s -X DELETE "$BASE_URL/clear-meals" | grep -q '"status": "success"' 
}

##### create_meal may need to be changed, refer to kitchen_models.py and app.py
create_meal() {
  id=$1
  meal=$2
  cuisine=$3
  price=$4
  difficulty=$5

  echo "Adding meal ($meal - $cuisine, $price) to the Kitchen..."
  response=$(curl -s -X POST "$BASE_URL/create-meal" -H "Content-Type: application/json" \
    -d "{\"id\":\"$id\", \"meal\":\"$meal\", \"cuisine\":\"$cuisine\", \"price\":$price, \"difficulty\":\"$difficulty\"}" | grep -q '"status": "combatant added"')

  echo "$response"

  if [ $? -eq 0 ]; then
    echo "Meal added successfully."
  else
    echo "Failed to add meal."
    exit 1
  fi
}

delete_meal() {
  meal_id=$1

  echo "Deleting meal by ID ($meal_id)..."
  response=$(curl -s -X DELETE "$BASE_URL/delete-meal/$meal_id")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Meal deleted successfully by ID ($meal_id)."
  else
    echo "Failed to delete meal by ID ($meal_id)."
    exit 1
  fi
}

get_leaderboard() {
  echo "Getting all meals in the kitchen..."
  response=$(curl -s -X GET "$BASE_URL/leaderboard")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "All meals retrieved successfully."
    if [ "$ECHO_JSON" = true ]; then
      echo "Meals JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get meals."
    exit 1
  fi
}

get_meal_by_id() {
  meal_id = $1
  echo "Getting meal by ID ($meal_id)..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-id/$meal_id")
  if echo "$respone" | grep -q '"status": "success"'; then
    echo "Meal retrieved successfully by ID ($meal_id)."
    if ["$ECHO_JSON" = true ]; then
      echo "Meal JSON (ID $meal_id):"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get meal by ID ($meal_id)."
    exit 1
  fi
}

get_meal_by_name() {
  meal_name = $1

  echo "Getting meal by name: ('$meal_name')..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-name/$meal_name")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Song retrieved successfully by compound key."
    if [ "$ECHO_JSON" = true ]; then
      echo "Song JSON (by compound key):"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get song by compound key."
    exit 1
  fi
}
#I dont think he provided an update_meal_status so I leave it blank for now

# update_meal_stats() {
#   meal_id = $1
#   result = $2


# }



##########################################################
#
# Battle Management
#
##########################################################

battle() {
  echo "Two meals enter, one meal leaves!"
  response=$(curl -s -X GET "$BASE_URL/battle")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Two meals ready for battle!"
    if [ "$ECHO_JSON" = true ]; then
      echo "Meals JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Meals chickened out."
    exit 1
  fi
}

clear_combatants() {
  echo  "Clearing all combatants..."
  response=$(curl -s X POST "$BASE_URL/clear-combatants")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatants cleared."
    if [ "$ECHO_JSON" = true ]; then
      echo "Clear JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to clear combatants."
    exit 1
  fi
}

get_battle_score() {
  echo  "Clearing all combatants..."
  response=$(curl -s X POST "$BASE_URL/clear-combatants")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatants cleared."
    if [ "$ECHO_JSON" = true ]; then
      echo "Score JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to clear combatants."
    exit 1
  fi
}

get_combatants() {
  echo  "Getting combatants..."
  response=$(curl -s X GET "$BASE_URL/get-combatants")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatants cleared."
    if [ "$ECHO_JSON" = true ]; then
      echo "combatents JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get combatants."
    exit 1
  fi
} 
##get_combatants need to be modded

prep_combatant() {
  meal=$1
  echo  "Preparing combatant: {$meal}"
  response=$(curl -s X POST "$BASE_URL/prep-combatant")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "{$meal} prepared"
    if [ "$ECHO_JSON" = true ]; then
      echo "combatents JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to prepare combatant: {$meal}"
    exit 1
  fi
}

check_db

check_clear clear_meals

create_meal 0 "Naan" "Indian" 5 1 
create_meal 1"Biryani" "Indian" 18 5 
create_meal 2 "Pizza" "Italian" 20 4 
create_meal 3 "Hot Pot" "Chinese" 35 6 
create_meal 4 "Dak Galbi" "Korean" 5 5

delete_meal 0 
get_leaderboard

get_meal_by_id 1
get_meal_by_name "Biryani"

clear_combatants

prep_combatant "Biryani" 
prep_combatant "Pizza"

get_combatants

battle

get_battle_score

clear_combatants