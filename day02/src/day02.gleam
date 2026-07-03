import gleam/int
import gleam/io
import iv
import lib

pub fn main() {
  let input = "10, 22, 30, invalid, 40"
  let tester = lib.make_memory(input)
  echo tester
  // 2. Perform the lookup
  let lookup_result = iv.get(from: tester, at: 1)

  // 3. Handle the result
  case lookup_result {
    Ok(my_num) -> io.println("Found number: " <> int.to_string(my_num))
    Error(Nil) -> io.println("Number not found")
  }

  let lookup_result_2 = iv.get(from: tester, at: 11)
  case lookup_result_2 {
    Ok(my_num) -> io.println("Found number: " <> int.to_string(my_num))
    Error(Nil) -> io.println("Number not found")
  }

  io.println("")

  let vv = lib.make_instruction(1234)
  echo vv
}
