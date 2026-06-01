#import "../colors.typ"
#import "../string.typ"

#let basic(body, columns) = {
  [
    #show table.cell.where(y: 0): set text(weight: "bold")
    #table(
      columns: columns,
      rows: auto,
      fill: (_, y) => if (y == 0) { colors.light-gray } else { white },
      stroke: black,
      align: left,
      table.header(..body.slice(0, if type(columns) == int { columns } else { columns.len() })),
      ..body.slice(if type(columns) == int { columns } else { columns.len() }),
    )
  ]
}

#let caption(body, columns, caption, fill: function, ..args) = {
  show table.cell.where(y: 0): set text(weight: "bold")
  show figure: set block(breakable: true)
  show text: set text(hyphenate: false)

  let fig-content = figure(
    kind: table,
    caption: caption,
    table(
      columns: columns,
      rows: auto,
      fill: (x, y) => {
        let fill-color = if (y == 0) { colors.light-gray } else { white }
        let custom-fill = none
        if (type(fill) == function) { custom-fill = fill(x, y, body.at(y).at(x)) }
        if (type(custom-fill) == color) { custom-fill } else { fill-color }
      },
      stroke: black,
      align: left,
      table.header(
        ..body
          .flatten()
          .slice(
            0,
            if type(columns) == int {
              columns
            } else {
              columns.len()
            },
          ),
      ),
      ..body
        .flatten()
        .slice(if type(columns) == int {
          columns
        } else {
          columns.len()
        }),
    ),
    ..args,
  )

  if ref != none {
    [#fig-content #label("table-" + string.slugify(caption))]
  } else {
    fig-content
  }
}

