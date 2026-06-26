import gleeunit
import lib

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn stand_alone_test() {
  assert 1 + 1 == 2
}

// For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
// For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
// For a mass of 1969, the fuel required is 654.
// For a mass of 100756, the fuel required is 33583.

pub fn gas_test() {
  assert lib.sum_gas_a([12]) == 2
  assert lib.sum_gas_a([14]) == 2
  assert lib.sum_gas_a([1969]) == 654
  assert lib.sum_gas_a([100_756]) == 33_583
}
