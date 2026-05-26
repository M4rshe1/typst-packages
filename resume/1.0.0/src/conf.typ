#let primary-color = rgb("#3d4655")
#let secondary-color = rgb("#e7e7e7")
#let text-gray = rgb("#4a4a4a")

#let resume(
  name: "",
  role: "",
  pic: none,
  body,
) = {
  set page(
    margin: (left: 0pt, right: 0pt, top: 0pt, bottom: 0pt),
    fill: white,
  )
  set text(font: "Arial", size: 9pt, fill: text-gray)

  grid(
    columns: (1fr, 2.5fr),
    rows: (auto, 1fr),
    grid.cell(colspan: 2, fill: primary-color, inset: (top: 40pt, bottom: 40pt, left: 30%), {
      set text(fill: white)
      align(left)[
        #upper(text(size: 24pt, weight: "bold", tracking: 1.5pt)[#name]) \
        #v(-5pt)
        #upper(text(size: 12pt, tracking: 1pt)[#role])
      ]
    }),

    rect(fill: secondary-color, width: 100%, height: 100%, inset: (top: -40pt, x: 20pt, bottom: 20pt), {
      if pic != none {
        set image(width: 120pt)
        align(center)[
          #block(
            stroke: 5pt + white,
            radius: 50%,
            clip: true,
            width: 120pt,
            height: 120pt,
            pic,
          )
        ]
      }

      v(20pt)
      body.at("sidebar")
    }),

    pad(top: 30pt, left: 30pt, right: 30pt, bottom: 20pt, {
      body.at("main")
    }),
  )
}
