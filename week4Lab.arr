use context dcic2024

include csv
include data-source

flights = load-table:
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
  

  source: csv-table-file("flights.csv", default-options)
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

fun is_long_flight(row :: Row) -> Boolean:
  doc: "This function returns true if the row's distance is greater than 1500"
  if row["distance"] >= 1500:
    true
  else:
    false
  end
where:
  is_long_flight(flights.row-n(10)) is false
  is_long_flight(flights.row-n(3)) is true
end

# Filtering out flights under 1500km
filter-with(flights, is_long_flight)

# Ordering flights by descending air time
order-by(flights, "air_time", false)

#| 
   Extracting "carrier, origin, and dest" from the flight with the largest air time
|#
largest-air-time = flights.row-n(0)
largest-air-time["carrier"]
largest-air-time["origin"]
largest-air-time["dest"]

fun is_delayed_departure(row :: Row) -> Boolean:
  doc: "Returns true if the departure delay is >= 30"
  if row["dep_delay"] >= 30:
    true
  else:
    false
  end
where: 
  is_delayed_departure(flights.row-n(4)) is false
  is_delayed_departure(flights.row-n(55)) is true
end
  
fun is_morning_scheduled_dep(row :: Row) -> Boolean:
  doc: "Returns true if the scheduled departure time is less than 1200"
  if row["sched_dep_time"] < 1200:
    true
  else:
    false
  end
where: 
  is_delayed_departure(flights.row-n(4)) is false
  is_delayed_departure(flights.row-n(55)) is true
end


delayed-afternoon-flights = filter-with(filter-with(flights, lam(row): row["dep_delay"] >= 30 end),lam(row): row["sched_dep_time"] < 1200 end)

delayed-afternoon-flights-500km = filter-with(delayed-afternoon-flights, lam(row): row["distance"] > 500 end)

order-by(delayed-afternoon-flights-500km, "dep_delay", false)

worst-delayed-flight = delayed-afternoon-flights-500km.row-n(0)

worst-delayed-flight["flight"]
worst-delayed-flight["origin"]
worst-delayed-flight["dep_delay"]

transform-column(flights, "dep_delay", lam(x): if x < 0: 0 else: x end end)
transform-column(flights, "arr_delay", lam(x): if x < 0: 0 else: x end end)

effective-speed-flights = build-column(flights, "effective_speed", lam(x): if x["air_time"] > 0: x["distance"] / ((x["air_time"] / 60)) else: 0 end end)

descending-effective-speed = order-by(effective-speed-flights, "effective_speed", false)
fastest-flight = descending-effective-speed.row-n(0)
fastest-flight["carrier"]
fastest-flight["origin"]
fastest-flight["dest"]


fun apply-arrival-discount(t :: Table) -> Table:
  doc: ""
  transform-column(t, "arr_delay", lam(x): if (x >= 0) and (x <= 45): x * 0.8 else: x end end)
  
where: 
  test-table = 
    table: arr_delay
      row: -10
      row: 0
      row: 30
      row: 60
    end
  apply-arrival-discount(test-table) is
  table: arr_delay
    row: -10
    row: 0 * 0.8
    row: 30 * 0.8
    row: 60
end
end

apply-arrival-discount(flights)




