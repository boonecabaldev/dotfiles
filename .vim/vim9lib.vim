vim9script

def Test(name: string, count: number): string
  return $"Hello, {name}! Count: {count}"
enddef

# Call the function and store the result in a variable
var result: string = Test("Vim9", 10)
#echo result

# Call the function directly in echo
#echo Test("World", 5)

def g:Hi(name: string): string
  return $"Hi, {name}!"
enddef
