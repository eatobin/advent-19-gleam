import gleam/dict
import gleam/int
import gleam/list
import gleam/string

type MemoryAsCSVString =
  String

type Memory =
  dict.Dict(Int, Int)

pub fn make_memory(memory_as_csv_string_param: MemoryAsCSVString) -> Memory {
  let values =
    memory_as_csv_string_param
    |> string.split(",")
    |> list.map(string.trim)
    |> list.filter_map(int.parse)
  dict.from_list(
    list.index_map(values, fn(element, index) { #(index, element) }),
  )
}
// makeInstruction :: Int -> Instruction
// makeInstruction op =
//   Map.fromList instructionAsKVTupleList
//   where
//     keys = ['a', 'b', 'c', 'd', 'e']
//     opAsString = show op
//     paddedOp = replicate (5 - length opAsString) '0' ++ opAsString
//     values = map DC.digitToInt paddedOp
//     instructionAsKVTupleList = zip keys values
