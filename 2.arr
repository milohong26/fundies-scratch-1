use context starter2024
fun addSum(a :: NumInteger, b :: NumInteger):
  doc: "returns the sum of two numbers."
  a + b
end

check:
  addSum(4, 6) is 10
end
