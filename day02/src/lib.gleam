import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import iv

type MemoryAsCSVString =
  String

type Memory =
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

fn key_to_key(int_code: IntCode, pointer_offset_param: PointerOffset) -> Key {
  iv.get_or_default(
    from: int_code.memory,
    at: { int_code.pointer + pointer_offset_param },
    or: -1,
  )
}

fn pw(int_code: IntCode, pointer_offset_param: PointerOffset) -> Key {
  key_to_key(int_code, pointer_offset_param)
}

fn pr(int_code: IntCode, pointer_offset_param: PointerOffset) -> Value {
  iv.get_or_default(
    from: int_code.memory,
    at: iv.get_or_default(
      from: int_code.memory,
      at: key_to_key(int_code, pointer_offset_param),
      or: -1,
    ),
    or: -1,
  )
}

fn a_param(instruction: Instruction, int_code: IntCode) -> Int {
  case dict.get(instruction, "a") |> result.unwrap(-1) {
    // a-p-w
    0 -> pw(int_code, pointer_offset_a)
    _ -> -1
  }
}

fn b_param(instruction: Instruction, int_code: IntCode) -> Int {
  case dict.get(instruction, "b") |> result.unwrap(-1) {
    // b-p-r
    0 -> pr(int_code, pointer_offset_b)
    _ -> -1
  }
}

fn c_param(instruction: Instruction, int_code: IntCode) -> Int {
  case dict.get(instruction, "c") |> result.unwrap(-1) {
    // c-p-r
    0 -> pr(int_code, pointer_offset_c)
    _ -> -1
  }
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
  let instruction: Instruction =
    make_instruction(iv.get_or_default(
      from: int_code.memory,
      at: int_code.pointer,
      or: -1,
    ))
  case dict.get(instruction, "e") |> result.unwrap(-1) {
    1 -> run_op_code(add(instruction, int_code))
    2 -> run_op_code(multiply(instruction, int_code))
    9 -> exit(int_code)
    _ -> int_code
  }
}
