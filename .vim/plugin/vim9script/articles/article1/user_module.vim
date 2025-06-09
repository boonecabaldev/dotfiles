vim9script

# 1. Define the User struct
# It contains fields for name (string) and age (number). (Using class for broader Vim version compatibility)
export class User
  var name: string
  var age: number
endclass

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

#echo "User module loaded."
