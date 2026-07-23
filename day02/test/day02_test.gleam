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

pub fn lookup_a_valid_memory_index_pw_test() {
  let this_memory = iv.from_list([10, 11, 1])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.pw(int_code, 2) |> should.equal(1)
}

pub fn lookup_a_valid_memory_index_pr_test() {
  let this_memory = iv.from_list([10, 11, 1])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.pr(int_code, 2) |> should.equal(11)
}

pub fn lookup_a_valid_a_param_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  let this_memory = iv.from_list([0, 2, 1, 0])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.a_param(instruction_1, int_code) |> should.equal(0)
}

pub fn lookup_a_valid_b_param_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  let this_memory = iv.from_list([0, 2, 1, 0])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.b_param(instruction_1, int_code) |> should.equal(2)
}

pub fn lookup_a_valid_c_param_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  let this_memory = iv.from_list([0, 2, 1, 0])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.c_param(instruction_1, int_code) |> should.equal(1)
}

pub fn one_plus_2_should_be_set_at_0_and_pointer_should_be_4_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  let this_memory = iv.from_list([3, 2, 1, 0])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.add(instruction_1, int_code)
  |> should.equal(
    lib.IntCode(pointer: 4, memory: this_memory, actions: [lib.Add]),
  )
}

pub fn one_times_2_should_be_set_at_0_and_pointer_should_be_4_test() {
  let instruction_1 =
    dict.from_list([#("a", 0), #("b", 0), #("c", 0), #("d", 0), #("e", 6)])
  let this_memory = iv.from_list([2, 2, 1, 0])
  let int_code = lib.IntCode(pointer: 0, memory: this_memory, actions: [])
  lib.multiply(instruction_1, int_code)
  |> should.equal(
    lib.IntCode(pointer: 4, memory: this_memory, actions: [lib.Multiply]),
  )
}

pub fn exit_test() {
  let this_memory = iv.from_list([22, 22, 22, 22])
  let int_code = lib.IntCode(pointer: 22, memory: this_memory, actions: [])
  lib.exit(int_code)
  |> should.equal(
    lib.IntCode(pointer: 22, memory: this_memory, actions: [lib.Exit]),
  )
}

pub fn aoc_memory_1_test() {
  let this_aoc_memory = "1,0,0,3,99"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(pointer: 4, memory: iv.from_list([1, 0, 0, 2, 99]), actions: [
      lib.Exit,
      lib.Add,
    ]),
  )
}

pub fn aoc_memory_2_test() {
  let this_aoc_memory = "1,9,10,3,2,3,11,0,99,30,40,50"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(
      pointer: 8,
      memory: iv.from_list([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]),
      actions: [
        lib.Exit,
        lib.Multiply,
        lib.Add,
      ],
    ),
  )
}

pub fn aoc_memory_3_test() {
  let this_aoc_memory = "1,0,0,0,99"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(pointer: 4, memory: iv.from_list([2, 0, 0, 0, 99]), actions: [
      lib.Exit,
      lib.Add,
    ]),
  )
}

pub fn aoc_memory_4_test() {
  let this_aoc_memory = "2,3,0,3,99"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(pointer: 4, memory: iv.from_list([2, 3, 0, 6, 99]), actions: [
      lib.Exit,
      lib.Multiply,
    ]),
  )
}

pub fn aoc_memory_5_test() {
  let this_aoc_memory = "2,4,4,5,99,0"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(
      pointer: 4,
      memory: iv.from_list([2, 4, 4, 5, 99, 9801]),
      actions: [
        lib.Exit,
        lib.Multiply,
      ],
    ),
  )
}

pub fn aoc_memory_6_test() {
  let this_aoc_memory = "1,1,1,4,99,5,6,0,99"
  lib.run_op_code(
    lib.IntCode(
      pointer: 0,
      memory: lib.make_memory(this_aoc_memory),
      actions: [],
    ),
  )
  |> should.equal(
    lib.IntCode(
      pointer: 8,
      memory: iv.from_list([30, 1, 1, 4, 2, 5, 6, 0, 99]),
      actions: [lib.Exit, lib.Multiply, lib.Add],
    ),
  )
}
