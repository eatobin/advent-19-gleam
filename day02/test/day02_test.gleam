import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn stand_alone_test() {
  assert 1 + 1 == 2
}
