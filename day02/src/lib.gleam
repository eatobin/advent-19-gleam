import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import iv

// Instruction:
// ABCDE
// 01234
// 01002
// 34(DE) - two-digit opcode,      02 == opcode 2
//  2(C) - mode of 1st parameter,  0 == position mode
//  1(B) - mode of 2nd parameter,  1 == immediate mode
//  0(A) - mode of 3rd parameter,  0 == position mode,
//                                   omitted due to being a leading zero
// 0 1 or 2 = left-to-right position after 2 digit opcode
// p i or r = position, immediate or relative mode
// r or w = read or write

type MemoryAsCSVString =
  String

pub type Memory =
  iv.Array(Int)

type Key =
  Int

type Value =
  Int

type Instruction =
  dict.Dict(String, Int)

type Pointer =
  Int

pub type IntCodeAction {
  Add
  Multiply
  Exit
}

type Actions =
  List(IntCodeAction)

pub type IntCode {
  IntCode(pointer: Pointer, memory: Memory, actions: Actions)
}

type Candidate =
  Int

type CandidatePair =
  #(Candidate, Candidate)

type CandidatePairList =
  List(CandidatePair)

type Winner =
  Int

type PairAndWinner =
  #(CandidatePair, Winner)

type PairAndWinnerList =
  List(PairAndWinner)

type PointerOffset =
  Int

const pointer_offset_c: PointerOffset = 1

const pointer_offset_b: PointerOffset = 2

const pointer_offset_a: PointerOffset = 3

pub fn make_memory(memory_as_csv_string_param: MemoryAsCSVString) -> Memory {
  let values: List(Int) =
    memory_as_csv_string_param
    |> string.split(",")
    |> list.map(string.trim)
    |> list.filter_map(int.parse)
  iv.from_list(values)
}

pub fn make_instruction(op: Int) -> Instruction {
  let keys: List(String) = ["a", "b", "c", "d", "e"]
  let op_as_string: String = int.to_string(op)
  let padded_op: String = string.pad_start(op_as_string, to: 5, with: "0")
  let values: List(Int) =
    padded_op |> string.to_graphemes |> list.filter_map(int.parse)
  dict.from_list(list.zip(keys, values))
}

pub fn updated_memory(noun: Int, verb: Int, mem: Memory) -> Memory {
  mem
  |> iv.try_set(at: 1, to: noun)
  |> iv.try_set(at: 2, to: verb)
}

// For example, if your Intcode computer encounters 1,10,20,30,
// it should read the values at positions 10 and 20, add those values,
// and then overwrite the value at position 30 with their sum.

// address will be 10, 20 or 30 or key will be 10, 20 or 30
fn key_to_key(int_code: IntCode, pointer_offset_param: PointerOffset) -> Key {
  let assert Ok(key) =
    iv.get(from: int_code.memory, at: {
      int_code.pointer + pointer_offset_param
    })
    as "key_to_key error"
  key
}

// write to position 30
pub fn pw(int_code: IntCode, pointer_offset_param: PointerOffset) -> Key {
  key_to_key(int_code, pointer_offset_param)
}

// read value at position 10 or 20
pub fn pr(int_code: IntCode, pointer_offset_param: PointerOffset) -> Value {
  let key = key_to_key(int_code, pointer_offset_param)
  let assert Ok(value) = iv.get(from: int_code.memory, at: key) as "pr error"
  value
}

// write to position 30
pub fn a_param(instruction: Instruction, int_code: IntCode) -> Int {
  let assert Ok(instruction_result) = dict.get(instruction, "a") as "dict error"
  let assert Ok(a_param_result) = case instruction_result {
    // a-p-w
    0 -> Ok(pw(int_code, pointer_offset_a))
    _ -> Error(Nil)
  }
    as "a_param error"
  a_param_result
}

// read value at position 20
pub fn b_param(instruction: Instruction, int_code: IntCode) -> Int {
  let assert Ok(instruction_result) = dict.get(instruction, "b") as "dict error"
  let assert Ok(b_param_result) = case instruction_result {
    // b-p-r
    0 -> Ok(pr(int_code, pointer_offset_b))
    _ -> Error(Nil)
  }
    as "b_param error"
  b_param_result
}

// read value at position 10
pub fn c_param(instruction: Instruction, int_code: IntCode) -> Int {
  let assert Ok(instruction_result) = dict.get(instruction, "c") as "dict error"
  let assert Ok(c_param_result) = case instruction_result {
    // c-p-r
    0 -> Ok(pr(int_code, pointer_offset_c))
    _ -> Error(Nil)
  }
    as "c_param error"
  c_param_result
}

pub fn add(instruction: Instruction, int_code: IntCode) -> IntCode {
  IntCode(
    pointer: int_code.pointer + 4,
    memory: iv.try_set(
      in: int_code.memory,
      at: a_param(instruction, int_code),
      to: { c_param(instruction, int_code) + b_param(instruction, int_code) },
    ),
    actions: [Add, ..int_code.actions],
  )
}

pub fn multiply(instruction: Instruction, int_code: IntCode) -> IntCode {
  IntCode(
    pointer: int_code.pointer + 4,
    memory: iv.try_set(
      in: int_code.memory,
      at: a_param(instruction, int_code),
      to: { c_param(instruction, int_code) * b_param(instruction, int_code) },
    ),
    actions: [Multiply, ..int_code.actions],
  )
}

pub fn exit(int_code: IntCode) -> IntCode {
  IntCode(..int_code, actions: [Exit, ..int_code.actions])
}

pub fn run_op_code(int_code: IntCode) -> IntCode {
  let assert Ok(instruction_value) =
    iv.get(from: int_code.memory, at: int_code.pointer)
    as "instruction value error"
  let instruction = make_instruction(instruction_value)
  let assert Ok(instruction_map_value) = dict.get(instruction, "e")
    as "instruction map error"
  case instruction_map_value {
    1 -> run_op_code(add(instruction, int_code))
    2 -> run_op_code(multiply(instruction, int_code))
    9 -> exit(int_code)
    _ -> int_code
  }
}

pub fn make_this_memory(memory_as_csv_string: MemoryAsCSVString) -> Memory {
  make_memory(memory_as_csv_string)
}

pub fn make_candidate_pairs() -> CandidatePairList {
  let nouns: List(Int) =
    list.reverse(int.range(from: 0, to: 100, with: [], run: list.prepend))
  let verbs: List(Int) =
    list.reverse(int.range(from: 10, to: 100, with: [], run: list.prepend))
  // outer loop
  use noun <- list.flat_map(nouns)
  // inner loop
  use verb <- list.map(verbs)
  #(noun, verb)
}

fn run_a_candidate_pair(
  memory: Memory,
  candidate_pair: CandidatePair,
) -> PairAndWinner {
  let result =
    run_op_code(
      IntCode(
        pointer: 0,
        memory: updated_memory(candidate_pair.0, candidate_pair.1, memory),
        actions: [],
      ),
    )
  let assert Ok(result_memory) = iv.get(from: result.memory, at: 0)
    as "result memory error"
  #(candidate_pair, result_memory)
}

fn map_over_pairs(
  pairs: CandidatePairList,
  memory: Memory,
) -> PairAndWinnerList {
  pairs |> list.map(run_a_candidate_pair(memory, _))
}

fn winner_is(candidate_pw: PairAndWinner) -> Bool {
  let #(#(_, _), calculation) = candidate_pw
  calculation == 19_690_720
}

pub fn find_winner(pairs: CandidatePairList, memory: Memory) -> PairAndWinner {
  let maybe_pw =
    map_over_pairs(pairs, memory)
    |> list.filter(winner_is)
    |> list.first
  let assert Ok(pw) = maybe_pw as "pw error"
  pw
}
