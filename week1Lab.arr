use context starter2024

# 1 T-shirt shop

# 1.1 Calculating Costs
# Five identical T-Shirts
3 + (12 * 5)

# Seven identical T-shirts
3 + (12 * 7)

#| 
   The cost for 5 identical T-shirts is 63£
   The cost for 7 identical T-shirts is 87£
|#

# 1.2 Rectangular Poster

# Perimeter of Poster
2 * (420 + 594)

# Calculating cost of Poster
0.10 * (2 * (420 + 594))

#| 
   When I forget parentheses around the width + height,
   I get an error.
|#

# 2 String Suprises

# 2.1 Saving a Tagline

"Designs for everyone!"

#|
   is not finished; you may be missing closing         punctuation. If you intended to write a multi-line string, use ``` instead of quotation marks.
|#

# 2.2 Colour Inventory

"red" + "blue"

#|
 Adding two strings is valid, however, adding a string  and an integer results in an error. 
|#

# 3 Make a Traffic Light
lights = above(circle(15, "solid", "red"),(above(circle(15, "solid", "yellow"), circle(15, "solid", "green"))))

overlay-xy(lights, -5, -5, rectangle(40, 100, "solid", "black"))

# Challenge pole

below(rectangle(10, 100, "solid", "grey"), overlay-xy(lights, -5, -5, rectangle(40, 100, "solid", "black")))

# 4 Broken Code Hunt

#| 
   rectangle(50, "solid", 20, "black")

   failed because the 2ⁿᵈ argument evaluated to an unexpected value.

An annotation, NumNonNegative, in <builtin image-untyped>

was not satisfied by the value

"solid"
|#

# Corrected Code

rectangle(50, 20, "solid", "black")


#| 
   circle(30, solid, "red")
   
   It is used but not previously defined. You may need to run the program, or check dashes and capitalization in the name.
|#

# Corrected Code

circle(30, "solid", "red")

# 5 Create a Flag or Shield

background = rectangle(100, 60, "solid", "white")
left_stripe = rectangle(15, 60, "solid", "orange")
right_stripe = rectangle(15, 60, "solid", "blue")

# Final Flag
overlay-xy(right_stripe, -85, 0, overlay-xy(left_stripe, 0, 0, overlay(circle(25, "solid", "red"), background)))
