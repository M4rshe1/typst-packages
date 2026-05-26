#let mod(n, m) = {
  while n >= m {
    n -= m
  }

  return n
}

#let random(current-seed) = {
  let a = 1103515245
  let c = 12345
  let m = calc.pow(2, 31) - 1

  let seed = if (current-seed == none) {
    1
  } else {
    current-seed
  }

  let next-seed = mod((a * seed + c), m)
  return float(next-seed) / float(m)
}
