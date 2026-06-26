import gleam/list

fn gas(my_module: Int) -> Int {
  { my_module / 3 } - 2
}

pub fn sum_gas_a(gas_list: List(Int)) -> Int {
  gas_list |> list.map(gas) |> list.fold(0, fn(acc, x) { acc + x })
}

fn gas_plus(my_module: Int) -> Int {
  gas_plus_loop(my_module, 0)
}

fn gas_plus_loop(my_module: Int, acc: Int) -> Int {
  let new_gas = gas(my_module)
  case new_gas {
    ng if ng <= 0 -> acc
    _ -> gas_plus_loop(new_gas, acc + new_gas)
  }
}

pub fn sum_gas_b(gas_list: List(Int)) -> Int {
  gas_list |> list.map(gas_plus) |> list.fold(0, fn(acc, x) { acc + x })
}
