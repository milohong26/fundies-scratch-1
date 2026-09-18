use context starter2024
a = 'Hello World'

# must overwrite variables in pyrite, unlike python 

b = a + ' '
#to get length of string
string-length(b)
#to repeat string
string-repeat(b, 3)
#adding strings
"CS" + "2000"
#to convert all string characters into uppercase
string-to-upper("hello cs2000!")

#to convert all string characters to lower case
string-to-lower("HELLO CS2000!")

#to get a substring
string-substring("Welcome to London",0 , 7)

sample_string = "Hello, how are you? My name is Jeff, and I am from London"

#function to check if certain characters exist in a string
string-contains(sample_string, "Jeff")
#Case-Sensitive Example
string-contains(sample_string, "jeff")
#Non-Case-Sensitive Example
string-contains(string-to-lower(sample_string), "jeff")

x = circle(30, "solid", "blue")
y = rectangle(80, 40, "solid", "red")
z = triangle(50, "solid", "red")

#composition, each of these takes 2 images and gives back one image

overlay(x, y)

above(x, y)
below(x, y)
beside(y, x)

u = triangle(