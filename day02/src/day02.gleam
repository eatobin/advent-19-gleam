import gleam/dict
import gleam/int
import gleam/io
import lib

pub fn main() {
  let input = "10, 22, 30, invalid, 40"
  let tester = lib.make_memory(input)
  echo tester
  // 2. Perform the lookup
  let lookup_result = dict.get(tester, 1)

  // 3. Handle the result
  case lookup_result {
    Ok(my_num) -> io.println("Found number: " <> int.to_string(my_num))
    Error(Nil) -> io.println("Number not found")
  }
}
