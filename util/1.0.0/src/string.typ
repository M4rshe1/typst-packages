#let slugify(text) = {
  let s = lower(str(text))

  let filtered_chars = ""
  for char in s {
    let cc = char.to-unicode()
    if (
      char.len() == 1
        and (
          (cc >= 97 and cc <= 122) or (cc >= 48 and cc <= 57) or char == " " or char == "-"
        )
    ) {
      filtered_chars += char
    }
  }
  s = filtered_chars.replace(" ", "-")

  while s.contains("--") {
    s = s.replace("--", "-")
  }

  while s.starts-with("-") {
    s = s.slice(1)
  }

  while s.ends-with("-") {
    s = s.slice(0, s.len() - 1)
  }

  return s
}

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

