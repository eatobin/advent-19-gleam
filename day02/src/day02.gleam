import gleam/int
import gleam/io
import gleam/list
import gleam/result
import iv
import lib

fn make_this_memory() -> lib.Memory {
  let memory_as_csv_string =
    "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,2,9,19,23,2,13,23,27,1,6,27,31,2,6,31,35,2,13,35,39,1,39,10,43,2,43,13,47,1,9,47,51,1,51,13,55,1,55,13,59,2,59,13,63,1,63,6,67,2,6,67,71,1,5,71,75,2,6,75,79,1,5,79,83,2,83,6,87,1,5,87,91,1,6,91,95,2,95,6,99,1,5,99,103,1,6,103,107,1,107,2,111,1,111,5,0,99,2,14,0,0"
  lib.make_memory(memory_as_csv_string)
}

fn candidate_pairs() -> List(#(Int, Int)) {
  let nouns =
    list.reverse(int.range(from: 0, to: 100, with: [], run: list.prepend))
  let verbs =
    list.reverse(int.range(from: 0, to: 100, with: [], run: list.prepend))
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
  candidate_pairs() |> list.map(run_a_candidate_pair)
}

fn winner_is(candidate: #(#(Int, Int), Int)) -> Bool {
  let #(#(_, _), calculation) = candidate
  calculation == 19_690_720
}

// fn find_winner() -> #(#(Int, Int), Int) {
//   let candidates = map_over_pairs()
//   list.filter(candidates, winner_is)
//   |> list.first
//   |> result.unwrap(#(#(-1, -1), -1))
// }

fn find_winner() -> #(#(Int, Int), Int) {
  map_over_pairs()
  |> list.filter(winner_is)
  |> list.first
  |> result.unwrap(#(#(-1, -1), -1))
}

pub fn main() {
  let initial_state_a =
    lib.IntCode(
      pointer: 0,
      memory: lib.updated_memory(12, 2, make_this_memory()),
      actions: [],
    )

  // Part A
  let final_state_a = lib.run_op_code(initial_state_a)
  let answer_1 = iv.get_or_default(from: final_state_a.memory, at: 0, or: -1)
  io.println("\nPart A: " <> int.to_string(answer_1) <> ", correct: 2890696")
  echo list.reverse(final_state_a.actions)

  // Part B
  let #(#(noun, verb), _) = find_winner()
  let answer_2 = {
    { 100 * noun } + verb
  }
  io.println("\nPart B: " <> int.to_string(answer_2) <> ", correct: 8226")
  let initial_state_b =
    lib.IntCode(
      pointer: 0,
      memory: lib.updated_memory(noun, verb, make_this_memory()),
      actions: [],
    )
  let final_state_b = lib.run_op_code(initial_state_b)
  echo list.reverse(final_state_b.actions)
}
