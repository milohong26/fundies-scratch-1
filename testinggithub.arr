use context dcic2024

include csv
include data-source

recipes = load-table:
  title :: String,
  servings :: Number,
  prep-time :: Number
  source: csv-table-file("dataset/recipes.csv", default-options)
  sanitize servings using num-sanitizer
  sanitize prep-time using num-sanitizer
end

mean(recipes, "prep-time")

hist-plot = histogram(recipes, 'prep-time', 50)

bp = box-plot(recipes, 'servings')

