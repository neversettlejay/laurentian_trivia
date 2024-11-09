#!/bin/bash

# ANSI color codes for colored blocks
RED_BG='\033[41m'       # Red background for walls
GREEN_BG='\033[42m'     # Green background for the snake
YELLOW_BG='\033[43m'    # Yellow background for food
CYAN_BG='\033[46m'      # Cyan background for the bird's body
RESET='\033[0m'         # Reset color

# Get terminal size dynamically
WIDTH=$(tput cols)      # Get the terminal's width
HEIGHT=$(tput lines)    # Get the terminal's height

# GUI for selecting difficulty level using Zenity
LEVEL=$(zenity --list --title="Select Difficulty Level" \
    --text="Choose the difficulty level for Snake Game" \
    --column="Level" "Easy" "Medium" "Hard" "Extra Hard" --width=300 --height=250)

# Set initial game parameters based on difficulty
case "$LEVEL" in
    "Easy") SNAKE_LENGTH=5; BASE_SPEED=0.15; BIRD_RADIUS=5; BIRD_SPEED=5 ;;
    "Medium") SNAKE_LENGTH=10; BASE_SPEED=0.1; BIRD_RADIUS=6; BIRD_SPEED=4 ;;
    "Hard") SNAKE_LENGTH=15; BASE_SPEED=0.07; BIRD_RADIUS=8; BIRD_SPEED=3 ;;
    "Extra Hard") SNAKE_LENGTH=20; BASE_SPEED=0.05; BIRD_RADIUS=10; BIRD_SPEED=2 ;;
    *) zenity --error --text="No level selected. Exiting."; exit 1 ;;
esac
SPEED=$BASE_SPEED

# Initialize game variables
SNAKE_X=$((WIDTH / 2))         # Initial snake X position
SNAKE_Y=$((HEIGHT / 2))        # Initial snake Y position
SNAKE_BODY=()                  # Snake's body coordinates array
DIRECTION="RIGHT"              # Initial movement direction
FOOD_X=$((RANDOM % (WIDTH - 4) + 2))  # Random X position for food
FOOD_Y=$((RANDOM % (HEIGHT - 4) + 2)) # Random Y position for food
SCORE=0                        # Initial score
BIRD_X=$FOOD_X                 # Initial bird position (same as food)
BIRD_Y=$FOOD_Y
BIRD_ANGLE=0                   # Angle for bird's circular movement

# Hide cursor
tput civis

# Function to set cursor position
set_cursor() {
    echo -ne "\033[$1;${2}H"
}

# Function to draw a cell with a specific color
draw_cell() {
    set_cursor "$1" "$2"    # Set cursor position
    echo -ne "$3 \033[0m"    # Draw the cell with the specified color and reset
}

# Initialize game area with static walls and initial food
init_game_area() {
    clear
    echo -e "Score: $SCORE  Level: $LEVEL"
    # Draw top and bottom walls
    for ((x=1; x<=WIDTH; x++)); do
        draw_cell 1 "$x" "$RED_BG"
        draw_cell "$HEIGHT" "$x" "$RED_BG"
    done
    # Draw left and right walls
    for ((y=1; y<=HEIGHT; y++)); do
        draw_cell "$y" 1 "$RED_BG"
        draw_cell "$y" "$WIDTH" "$RED_BG"
    done
    draw_cell "$FOOD_Y" "$FOOD_X" "$YELLOW_BG" # Draw the food
}

# Move snake based on the current direction
move_snake() {
    case $DIRECTION in
        UP) ((SNAKE_Y--)) ;;     # Move up
        DOWN) ((SNAKE_Y++)) ;;   # Move down
        LEFT) ((SNAKE_X--)) ;;   # Move left
        RIGHT) ((SNAKE_X++)) ;;  # Move right
    esac

    # Check for boundary collisions (walls)
    [[ $SNAKE_X -le 1 || $SNAKE_X -ge $WIDTH || $SNAKE_Y -le 1 || $SNAKE_Y -ge $HEIGHT ]] && end_game "You hit the wall!"

    SNAKE_BODY=("$SNAKE_X,$SNAKE_Y" "${SNAKE_BODY[@]}") # Add new head to snake body

    # Check if the snake eats the food
    if [[ $SNAKE_X -eq $FOOD_X && $SNAKE_Y -eq $FOOD_Y ]]; then
        ((SCORE++))  # Increment score
        FOOD_X=$((RANDOM % (WIDTH - 4) + 2)) # Move food to new random position
        FOOD_Y=$((RANDOM % (HEIGHT - 4) + 2))
        draw_cell "$FOOD_Y" "$FOOD_X" "$YELLOW_BG" # Draw new food
        
        # Increase snake length and speed
        ((SNAKE_LENGTH++))
        SPEED=$(awk "BEGIN {print $SPEED * 0.95}")  # Increase speed by 5%

        # Move the bird to the new food position
        BIRD_X=$FOOD_X
        BIRD_Y=$FOOD_Y
    else
        # Remove the snake's tail
        tail="${SNAKE_BODY[-1]}"
        IFS="," read -r tail_x tail_y <<< "$tail"
        draw_cell "$tail_y" "$tail_x" " "
        SNAKE_BODY=("${SNAKE_BODY[@]:0:$SNAKE_LENGTH}")  # Remove last tail segment
    fi
    draw_cell "$SNAKE_Y" "$SNAKE_X" "$GREEN_BG"  # Draw snake head
}

# Move bird in a circular pattern around the food
move_bird() {
    # Convert angle to radians
    BIRD_ANGLE_RAD=$(echo "scale=4; $BIRD_ANGLE * 3.1416 / 180" | bc -l)  # Convert degrees to radians
    
    # Calculate new X and Y positions for the bird using cosine and sine functions
    BIRD_X=$(echo "scale=0; $FOOD_X + $BIRD_RADIUS * c($BIRD_ANGLE_RAD)" | bc -l)
    BIRD_Y=$(echo "scale=0; $FOOD_Y + $BIRD_RADIUS * s($BIRD_ANGLE_RAD)" | bc -l)
    
    # Increase angle for the next frame (rotate the bird around the food)
    BIRD_ANGLE=$((BIRD_ANGLE + BIRD_SPEED))
    if (( BIRD_ANGLE >= 360 )); then
        BIRD_ANGLE=0  # Reset angle after a full circle
    fi
    
    # Draw the bird near the food in cyan color
    draw_cell "$BIRD_Y" "$BIRD_X" "$CYAN_BG"
}

# Change direction based on user input
change_direction() {
    read -rsn1 -t "$SPEED" key  # Read user input with a delay based on speed
    case $key in
        w) [[ $DIRECTION != "DOWN" ]] && DIRECTION="UP" ;;  # Move up
        s) [[ $DIRECTION != "UP" ]] && DIRECTION="DOWN" ;;  # Move down
        a) [[ $DIRECTION != "RIGHT" ]] && DIRECTION="LEFT" ;; # Move left
        d) [[ $DIRECTION != "LEFT" ]] && DIRECTION="RIGHT" ;; # Move right
    esac
}

# Collision detection with bird and self
check_collisions() {
    for ((i=1; i<${#SNAKE_BODY[@]}; i++)); do
        [[ "${SNAKE_BODY[0]}" == "${SNAKE_BODY[i]}" ]] && end_game "You collided with yourself!" # Self-collision
    done
    # Check if the snake collides with the bird
    if [[ $SNAKE_X -eq $BIRD_X && $SNAKE_Y -eq $BIRD_Y ]]; then
        end_game "The bird caught you!" # Collision with the bird
    fi
}

# End game with prompt to replay
end_game() {
    clear
    echo -e "${RED_BG}Game Over!${RESET} $1"
    echo -e "Final Score: $SCORE"
    play_again=$(zenity --question --text="Play again?" --title="Game Over" --width=200 --height=150)
    if [[ $? -eq 0 ]]; then
        exec "$0"  # Restart the game
    else
        tput cnorm  # Show cursor again on exit
        exit 0
    fi
}

# Main game loop
init_game_area
while true; do
    change_direction
    move_snake
    move_bird
    check_collisions
done

# Show cursor again on exit
tput cnorm

