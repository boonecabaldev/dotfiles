vim9script

# Import the user_module.vim
import "~/.vim/plugin/user_module.vim" as user_mod

echo "Main application running."

# 1. Create instances of the User class
var user1 = user_mod.User.new("Alice", 30)
var user2 = user_mod.User.new("Bob", 15)

# 2. Call the functions (method-like behavior) on the struct instances
echo user_mod.GetUserGreeting(user1)
echo user_mod.GetUserGreeting(user2)

# Check if they are adults
echo $"Is {user1.name} an adult? {user_mod.IsAdult(user1)}"
echo $"Is {user2.name} an adult? {user_mod.IsAdult(user2)}"

echo "Main application finished."
