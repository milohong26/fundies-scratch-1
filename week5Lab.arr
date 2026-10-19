use context dcic2024
include csv
include data-source

    
    #|
       1. Plan a data-cleaning strategy.
       
       2. Fix common problems (missing values, formatting, outliers, duplicates).

       3. Normalise categorical values like airline codes.

       4. Transform time data into a consistent format.

       5. Visualise and analyse cleaned data with charts and summary statistics.

    |#
#|
   plan 1. 
   inputs: tailnum has missing values with empty strings
   outputs: replace the missing values in tailnum with "UNKNOWN"
   steps: Use a transform column with a lambda function to detect empty strings, and replace it with "UNKNOWN" 

   plan 2.
   inputs: dep_delay and arr_delay should not have negative values
   outputs: negative values for dep_delay and arr_delay are changed to 0
   steps: use nested transform columns for dep_delay and arr_delay with a lambda function to detect negative values and change them with 0. 
   plan 3.
   inputs: flights, dep_delay, and carriers should not have duplicates, and should have a single string identifier
   outputs: remove duplicate entries and create a row that concatenates the three values into one string
   steps: combine flight, carrier, and dep_time into a single column to remove duplicates, then create a dedup_key and use a lambda to noramlise the data set
   
   
   
   
|#
 
    flights_53 = load-table:
  rownames :: Number,
  dep_time :: Number,
  sched_dep_time :: Number,
  dep_delay :: Number,
  arr_time :: Number,
  sched_arr_time :: Number,
  arr_delay :: Number,
  carrier :: String,
  flight :: Number,
  tailnum :: String,
  origin :: String,
  dest :: String,
  air_time :: Number,
  distance :: Number,
  hour :: Number,
  minute :: Number,
  time_hour :: String
  

  source: csv-table-file("flights_sample53.csv", default-options)
  sanitize rownames using num-sanitizer
  sanitize dep_time using num-sanitizer
  sanitize sched_dep_time using num-sanitizer
  sanitize dep_delay using num-sanitizer
  sanitize arr_time using num-sanitizer
  sanitize sched_arr_time using num-sanitizer
  sanitize arr_delay using num-sanitizer
  sanitize flight using num-sanitizer
  sanitize air_time using num-sanitizer
  sanitize distance using num-sanitizer
  sanitize hour using num-sanitizer
  sanitize minute using num-sanitizer
end

flights_53-1 = transform-column(flights_53,"tailnum",lam(x): if x == "": "UNKNOWN" else: x end end)

flights_53-2 = transform-column(transform-column(flights_53-1, "dep_delay", lam(x): if x < 0: 0 else: x end end), "arr_delay", lam(x): if x < 0: 0 else: x end end)

fun trim(s :: String) -> String:
  doc: "Remove spaces from the given string."
  n = string-length(s)
  if n == 0:
    ""
  else:
    string-replace(s, " ", "")
  end
end

fun time_conversion(n :: Number) -> String:
  doc: "Converts dep_time numbers into properly formatted HH:MM time."
  modulated_num = num-to-string(num-modulo(n, 100))
  num_length = string-length(num-to-string(n))
  if num_length == 3:
    hour = string-append("0", (string-substring(num-to-string(n), 0, 1)))
    time = string-append(hour + ":", modulated_num)
    if string-length(time) == 4:
      "0" + time
    else:
      time
    end
  else:
    time = string-append(string-substring(num-to-string(n), 0, 2) + ":", modulated_num)
    if string-length(time) == 4:
      "0" + time
    else:
      time
    end
end
where:
  time_conversion(514) is "05:14"
  time_conversion(1235) is "12:35"
end


#|
  Applying transformations to flights, carriers, and dep_time, to get it ready for creating the dedup_key column.  
|#
flights_53-3 = 
  transform-column(transform-column(transform-column(flights_53-2, "flight", lam(x): num-to-string(x) end), "carrier", trim),"dep_time" , time_conversion)

#|
  Creating the dedup_key column by combining flights, carriers, and dep_time, each separated by a "-"
|#
flights_53-4 = build-column(flights_53-3, "dedup_key", lam(x): x["flight"] + "-" + x["carrier"] + "-" + x["dep_time"] end)

# Using the group and count functions 
flights-grouped = group(flights_53-4, "dedup_key")
flights-counted = count(flights_53-4, "dedup_key")
flights-counted

freq-bar-chart(flights_53-4, "carrier")
histogram(flights_53-4, "distance", 500)
scatter-plot(flights_53-4, "air_time", "distance")

distance-column = flights_53-4.get-column("distance")
distance-column
