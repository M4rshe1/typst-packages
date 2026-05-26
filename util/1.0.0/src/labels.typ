#let find-label(lbl) = context {
  let results = query(label(lbl))
  if (results.len() != 0) {
    let meta = results.at(0).value
    show link: set text(fill: black)
    show link: set underline(stroke: (thickness: 0.1em, dash: (0.1em, 0.1em)))
    let loc = locate(label(lbl))
    box[_#link(loc)[#meta (S#{ loc.page() - 1 })]_]
  } else {
    panic("Tried to find label: '" + lbl + "' but found nothing")
  }
}
