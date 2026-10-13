use context dcic2024
include csv
include data-source
import lists as L

# Problem 1 
fun is-leap-year(year :: Number) -> Boolean:
  doc: "This function returns true if the year is a leap year, and false otherwise."
  if num-modulo(year, 100) == 0:
    if num-modulo(year, 400) == 0:
      true
    else:
      false
    end
    else if num-modulo(year, 4) == 0:
    true
  else:
    false
  end
  where:
  is-leap-year(1900) is false
  is-leap-year(2000) is true
  is-leap-year(2004) is true
  is-leap-year(2020) is true
  is-leap-year(1995) is false
end

# Problem 2
# invalid inputs will be set to 0 by default. 
fun tick(second :: Number) -> Number:
  doc: "This function returns the next second of the input number, and returns 0 if invalid input"
  
  if (second > 58) or (second < 0):
    0
  else:
    second + 1
  end
where:
  tick(10) is 11
  tick(59) is 0
  tick(100) is 0
  tick(-10) is 0
end

# Problem 3
fun rock-paper-scissors(p1 :: String, p2 :: String) -> String:
  doc: "This function determines the winner of a rock, paper, scissors game. If the input is invalid, the function will return 'invalid input.'"
  valid = [L.list: "rock", "paper", "scissors"]
  if (valid.member(p1) and valid.member(p2)) == false:
    "invalid choice"
  else if (p1 == "scissors") and (p2 == "paper"):
    "player 1"
  else if (p1 == "rock") and (p2 == "scissors"):
    "player 1"
  else if (p1 == "paper") and (p2 == "rock"):
    "player 1"
  else if p1 == p2:
    "tie"
  else:
    "player 2"
  end
where:
  rock-paper-scissors("rock", "paper") is "player 2"
  rock-paper-scissors("rock", "rock") is "tie"
  rock-paper-scissors("roc", "paper") is "invalid choice"
  rock-paper-scissors("scissors", "paper") is "player 1"
end

# Problem 4
# Table of planets and their distances from the Sun in astronomical units
planets = table: Planet :: String, Distance :: Number
  row: "Mercury", 0.39
  row: "Venus", 0.72
  row: "Earth", 1
  row: "Mars", 1.52
  row: "Jupiter", 5.2
  row: "Saturn", 9.54
  row: "Uranus", 19.2
  row: "Neptune", 30.06
end

# Extracting row 3 and assigning it to "mars"
mars = planets.row-n(3)
# Extracting the distance from the variable "mars"
mars["Distance"]


# Problem 5
something = load-table:
  year :: Number,
  day :: Number,
  month :: String,
  rate :: Number
  source: csv-table-file("boe_rates.csv", default-options)
  sanitize year using num-sanitizer
  sanitize day using num-sanitizer
  sanitize rate using num-sanitizer
end

something.length() # number of rows = 835
median(something, "rate") # median rate = 5
modes(something, "rate") # => 4
something.increasing-by("rate") # min = 0.1
something.decreasing-by("rate") # max = 17
