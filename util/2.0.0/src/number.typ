#let format(number, precision) = {
  assert(precision > 0)
  let s = str(calc.round(number, digits: precision))
  let after_dot = s.find(regex("\..*"))
  if after_dot == none {
    s = s + "."
    after_dot = "."
  }
  for i in range(precision - after_dot.len() + 1) {
    s = s + "0"
  }
  s
}

// leading zero
#let lz(number, length) = {
  let s = if type(number) == str { number } else { str(number) }
  while s.len() < length {
    s = "0" + s
  }
  s
}

