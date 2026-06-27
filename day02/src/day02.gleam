import gleam/int
import gleam/list
import gleam/string

pub fn main() {
  let input = "1, 2, 3, invalid, 4"

  let ints =
    input
    |> string.split(",")
    |> list.map(string.trim)
    // filter_map automatically drops any Error(Nil) results
    |> list.filter_map(int.parse)

  echo ints
  // Output: [1, 2, 3, 4]
}
