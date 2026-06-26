import gleam/list

fn gas(my_module: Int) -> Int {
  { my_module / 3 } - 2
}

pub fn sum_gas_a(gas_list: List(Int)) -> Int {
  gas_list |> list.map(gas) |> list.fold(0, fn(acc, x) { acc + x })
}
