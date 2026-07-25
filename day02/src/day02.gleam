import gleam/int
import gleam/io
import gleam/list
import iv
import lib

// pub fn answer_2() -> List(#(Int, Int)) {
//   use noun <- list.map(
//     list.reverse(int.range(from: 0, to: 6, with: [], run: list.prepend)),
//   )
//   use verb <- list.flat_map(
//     list.reverse(int.range(from: 0, to: 6, with: [], run: list.prepend)),
//   )
//   #(noun, verb)
// }

// pub fn tester() -> List(#(String, Int)) {
//   use letter <- list.flat_map(["a", "b", "c"])
//   use number <- list.map([1, 2, 3])
//   #(letter, number)
// }

pub fn candidate_pairs() -> List(#(Int, Int)) {
  let nouns =
    list.reverse(int.range(from: 0, to: 4, with: [], run: list.prepend))
  let verbs =
    list.reverse(int.range(from: 10, to: 14, with: [], run: list.prepend))
  use noun <- list.flat_map(nouns)
  use verb <- list.map(verbs)
  #(noun, verb)
}

fn run_a_candidate_pair(candidate_pair: #(Int, Int)) -> #(#(Int, Int), Int) {
  let result =
    lib.run_op_code(
      lib.IntCode(
        pointer: 0,
        memory: lib.updated_memory(
          candidate_pair.0,
          candidate_pair.1,
          make_this_memory(),
        ),
        actions: [],
      ),
    )
  #(candidate_pair, iv.get_or_default(from: result.memory, at: 0, or: -1))
}

fn map_over_pairs() -> List(#(#(Int, Int), Int)) {
  let pairs = candidate_pairs()
  list.map(pairs, run_a_candidate_pair)
}

fn make_this_memory() -> lib.Memory {
  let memory_as_csv_string =
    "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,2,9,19,23,2,13,23,27,1,6,27,31,2,6,31,35,2,13,35,39,1,39,10,43,2,43,13,47,1,9,47,51,1,51,13,55,1,55,13,59,2,59,13,63,1,63,6,67,2,6,67,71,1,5,71,75,2,6,75,79,1,5,79,83,2,83,6,87,1,5,87,91,1,6,91,95,2,95,6,99,1,5,99,103,1,6,103,107,1,107,2,111,1,111,5,0,99,2,14,0,0"
  lib.make_memory(memory_as_csv_string)
}

pub fn main() {
  echo map_over_pairs()
  let initial_state =
    lib.IntCode(
      pointer: 0,
      memory: lib.updated_memory(12, 2, make_this_memory()),
      actions: [],
    )

  // Part A
  let final_state_a = lib.run_op_code(initial_state)
  let answer_1 = iv.get_or_default(from: final_state_a.memory, at: 0, or: -1)
  io.println("\nPart A: " <> int.to_string(answer_1) <> ", correct: 2890696")
  echo list.reverse(final_state_a.actions)
  // Part B
  // echo candidate_pairs()
  // let nouns =
  //   list.reverse(int.range(from: 0, to: 4, with: [], run: list.prepend))
  // let verbs =
  //   list.reverse(int.range(from: 10, to: 14, with: [], run: list.prepend))
  // use noun <- list.flat_map(nouns)
  // use verb <- list.map(verbs)
  // let candidate_intcode =
  //   lib.run_op_code(
  //     lib.IntCode(
  //       pointer: 0,
  //       memory: lib.updated_memory(noun, verb, first_memory),
  //       actions: [],
  //     ),
  //   )
  // let candidate =
  //   iv.get_or_default(from: candidate_intcode.memory, at: 0, or: -1)
  // case candidate {
  // c if c == 19_690_720 -> (100 * noun) + verb
  // s if s >= 80 -> "B"
  // s if s >= 70 -> "C"
  // _ -> "F" // The underscore matches any other value (default/else)
}
// [
//   #("a", 1), #("a", 2), #("a", 3),
//   #("b", 1), #("b", 2), #("b", 3),
//   #("c", 1), #("c", 2), #("c", 3),
// ]
// let nouns_verbs =
//   list.reverse(int.range(from: 1, to: 6, with: [], run: list.prepend))
// echo {
//   int.range(from: 1, to: 4, with: "", run: fn(acc, i) {
//     acc <> int.to_string(i)
//   })
// }
// echo numbers
// use letter <- list.map(["a", "b", "c"])
// use number <- list.map([1, 2, 3])
// echo #(letter, number)
