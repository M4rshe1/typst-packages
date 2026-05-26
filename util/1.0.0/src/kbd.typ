#let kbd-key(it, bg: rgb("#f6f8fa"), border: rgb("#d1d9e0b3"), radius: 3pt, color: rgb("#1f2328")) = context {
  // if target() == "html" {
  //   html.elem("kbd", it)
  // } else {
  set text(fill: color)
  show raw: it
  box(
    fill: bg,
    stroke: border,
    outset: (y: radius),
    inset: (x: radius),
    radius: radius,
    raw(it),
  )
  // }
}

#let kbd(combination) = {
  let parts = combination.split("+")
  let processed_parts = ()

  for part in parts {
    processed_parts.push(kbd-key(part.trim()))
  }

  let final_output = ()
  for i in range(processed_parts.len()) {
    final_output.push(processed_parts.at(i))
    if i < processed_parts.len() - 1 {
      final_output.push(" + ")
    }
  }

  final_output.join()
}
