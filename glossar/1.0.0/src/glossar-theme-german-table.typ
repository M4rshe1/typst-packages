#let glossar-theme-german-table = (
  section: (title, body) => {
    heading(level: 1, title)
    body
  },
  group: (name, index, total, body) => {
    if name != "" and total > 1 {
      heading(level: 2, name)
    }

    let entries = (
      for i in range(body.len(), step: 4) {
        (body.at(i), body.at(i + 1), body.at(i + 2), {
          body.at(i + 3).join(", ")
        })
      }
    )

    table(
      columns: 4,
      stroke: (x, y) => if y > 0 { (top: 0.5pt) } else { none },
      inset: (x, y) => {
        if (x == 0) {
          (left: 0pt, rest: 5pt)
        } else if (x == 3) {
          (right: 0pt, rest: 5pt)
        } else {
          5pt
        }
      },
      table.header([*Kürzel*], [*Bezeichnung*], [*Beschreibung*], [*Seiten*]),
      ..entries,
    )
  },
  entry: (entry, index, total) => {
    (entry.short + entry.label, entry.long, entry.description, entry.pages)
  },
)

#let theme-show-term = term => {
  show link: set text(fill: black)
  show link: set underline(stroke: stroke(
    thickness: 0.1em,
    dash: (0.1em, 0.1em),
  ))
  emph[#term]
}
