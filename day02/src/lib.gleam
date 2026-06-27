import gleam/dict
import gleam/int
import gleam/list
import gleam/string

type MemoryAsCSVString =
  String

type Memory =
  dict.Dict(Int, Int)

type Instruction =
  dict.Dict(String, Int)

pub fn make_memory(memory_as_csv_string_param: MemoryAsCSVString) -> Memory {
  let values: List(Int) =
    memory_as_csv_string_param
    |> string.split(",")
    |> list.map(string.trim)
    |> list.filter_map(int.parse)
  dict.from_list(
    list.index_map(values, fn(element, index) { #(index, element) }),
  )
}

pub fn make_instruction(op: Int) -> Instruction {
  let keys: List(String) = ["a", "b", "c", "d", "e"]
  let op_as_string: String = int.to_string(op)
  let padded_op: String = string.pad_start(op_as_string, to: 5, with: "0")
  let values: List(Int) =
    padded_op |> string.to_graphemes |> list.filter_map(int.parse)
  dict.from_list(list.zip(keys, values))
}
