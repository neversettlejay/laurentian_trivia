# Snake Game with Bird

### A fun terminal-based Snake game built using Bash, where the player controls a snake to eat food, avoid self-collisions, and navigate around walls. The game also features a bird that circles around the food, and if the snake collides with the bird, the game is over.

# Features:
### Snake Movement: The snake moves in 4 directions (up, down, left, right).
### Food: The snake eats food to grow longer and increase the score.
### Bird: A bird circles around the food, and if the snake collides with the bird, the game ends.
### Difficulty Levels: Choose from 4 difficulty levels that affect snake length, speed, and bird radius:
#### Easy
#### Medium
#### Hard
#### Extra Hard
### Wall Collisions: If the snake hits the wall, the game ends.
### Self-Collision: If the snake collides with itself, the game ends.
### Replay Option: After the game ends, the player can choose to play again or quit.
# Requirements:
### Linux or macOS terminal (for running Bash scripts).
#### Zenity (for graphical dialog boxes for selecting the difficulty level and replay option).
#### Make sure you have Zenity installed. On most Linux distributions, you can install it with the following command:

git clone https://github.com/your-username/snake-game-with-bird.git
Navigate to the game directory:

bash
Copy code
cd snake-game-with-bird
Make the script executable:

bash
Copy code
chmod +x snake_game.sh
Run the game:
### How to Play:
#### After starting the game, a Zenity dialog will appear asking you to choose the difficulty level (Easy, Medium, Hard, Extra Hard).
#### The game will display the score and control the snake’s movement using the following keys:
#### w to move up
#### s to move down
#### a to move left
#### d to move right
#### The snake eats food, which makes it grow longer and increase the score.
#### A bird will revolve around the food. If the snake touches the bird, the game will end.
#### The game will also end if the snake hits a wall or collides with its own body.
#### After the game ends, you will be asked if you want to play again.
### Game Over:
#### If you hit a wall, collide with the bird, or run into your own body, the game will end, and you will see your final score.
#### You can choose to play again or exit the game when prompted.
### Game Controls:
#### Move Snake: Use the w, a, s, d keys to control the snake's movement.
#### Difficulty Levels: Choose from 4 difficulty levels (Easy, Medium, Hard, Extra Hard).
#### Replay Option: After a game over, choose whether to play again or exit.
#### Example Output:
#### Score: 0  Level: Easy
------------------------------------------------------------
|       |       |       |       |       |       |       |
|       |       |       |       |       |       |       |
|       |       |       |       |       |       |       |
------------------------------------------------------------
### Game Over! You collided with the bird!
#### Final Score: 5
#### Play again? [Yes/No]
### How It Works:
### Game Setup: The game initializes the terminal window, sets up walls around the game area, and places the snake and food.
### Snake Movement: The snake moves in the direction indicated by the player's keystrokes. The game continuously updates the snake’s position and checks for collisions.
### Food and Snake Growth: Each time the snake eats food, the snake's length increases and the speed increases slightly.
### Bird Movement: The bird moves in a circular pattern around the food. If the snake collides with the bird, the game ends.
### Collision Detection: The game checks for wall collisions, snake self-collisions, and collisions with the bird.
### Troubleshooting:
#### Zenity not installed: If Zenity is not installed, the game may not launch. Install Zenity using your system's package manager (e.g., sudo apt install zenity).
#### Terminal Size: The game adapts to the terminal size using tput. Ensure that your terminal is large enough to display the game.
### Contributing:
#### Feel free to fork the repository, create issues, or submit pull requests with improvements, fixes, or new features!



