import gleam/dict
import gleeunit
import gleeunit/should
import iv
import lib

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn string_test() {
  let name = "Gleam"
  assert "Hello, " <> name == "Hello, Gleam"
}

pub fn math_test() {
  1 + 1 |> should.equal(2)
}

pub fn make_an_instruction_1_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  lib.make_instruction(6) |> should.equal(instruction_1)
}

pub fn make_an_instruction_3_test() {
  let instruction_3 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 4), #("d", 5), #("e", 6)])
  lib.make_instruction(456) |> should.equal(instruction_3)
}

pub fn make_an_instruction_5_test() {
  let instruction_5 =
    dict.from_list([#("a", 2), #("b", 3), #("c", 4), #("d", 5), #("e", 6)])
  lib.make_instruction(23_456) |> should.equal(instruction_5)
}

pub fn make_a_memory_test() {
  let memory_as_csv_string = "10,11,1"
  let this_memory = iv.from_list([10, 11, 1])
  lib.make_memory(memory_as_csv_string) |> should.equal(this_memory)
}
