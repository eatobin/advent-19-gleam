import gleam/dict
import gleam/int
import gleam/list
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

pub fn key_to_key(
  int_code: IntCode,
  pointer_offset_param: PointerOffset,
) -> Key {
  iv.get_or_default(
    from: int_code.memory,
    at: { int_code.pointer + pointer_offset_param },
    or: -1,
  )
}
