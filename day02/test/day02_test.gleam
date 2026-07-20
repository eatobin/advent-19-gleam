import gleam/dict
import gleeunit
import gleeunit/should
import lib

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn stand_alone_test() {
  assert 1 + 1 == 2
}

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
// let instruction1 = Map [ ('a', 0); ('b', 0); ('c', 0); ('d', 0); ('e', 6) ]
// let instruction3 = Map [ ('a', 0); ('b', 0); ('c', 4); ('d', 5); ('e', 6) ]
// let instruction5 = Map [ ('a', 2); ('b', 3); ('c', 4); ('d', 5); ('e', 6) ]
// let memoryAsCSVString = "10,11,1"
// let thisMemory: PersistentVector<int> = PersistentVector.ofSeq [ 10; 11; 1 ]
