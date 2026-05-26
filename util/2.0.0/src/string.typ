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


#let stringify(item) = {
  if type(item) == str {
    item
  } else if type(item) != content {
    str(item)
  } else if item.has("text") {
    item.text
  } else if item.has("children") {
    item.children.map(stringify).join()
  } else if item.has("body") {
    stringify(item.body)
  } else if item == [ ] {
    " "
  }
}
