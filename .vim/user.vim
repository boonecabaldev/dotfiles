# user_module.vim - Defines a User struct and functions acting on it

vim9script

# 1. Define the User struct
# It contains fields for name (string) and age (number).
export struct User
  name: string
  age: number
endstruct

# 2. Define a function that operates on a User struct instance.
# We name the first argument 'self' by convention.
# This acts like a "method" on a User object.
export def GetUserGreeting(self: User): string
  return $"Hello, my name is {self.name} and I am {self.age} years old."
enddef

# Another function acting on User
export def IsAdult(self: User): bool
  return self.age >= 18
enddef

echo "User module loaded."
