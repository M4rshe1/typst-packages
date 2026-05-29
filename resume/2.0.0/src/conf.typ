#let primary-color = rgb("#3d4655")
#let secondary-color = rgb("#e7e7e7")
#let text-gray = rgb("#4a4a4a")
#import "@preview/fontawesome:0.6.0": fa-icon
#import "comps.typ": exp-item, section-title, sidebar-section
#import "@local/util:2.0.0": email, string
#import "trl.typ"

#let calculate-age(birthday-str) = {
  let bday = datetime(year: int(birthday-str.split("-").at(0)), month: int(birthday-str.split("-").at(1)), day: int(
    birthday-str.split("-").at(2),
  ))
  let today = datetime.today()
  let age = today.year() - bday.year()
  if (today.month(), today.day()) < (bday.month(), bday.day()) {
    age -= 1
  }
  return str(age)
}

#let resume(
  data: yaml("../assets/data/example.yaml"),
  pic: image("../assets/imgs/profile.png"),
) = {
  set page(
    margin: (left: 0pt, right: 0pt, top: 0pt, bottom: 0pt),
    fill: white,
  )
  set text(size: 9pt, fill: text-gray)

  grid(
    columns: (1fr, 2.5fr),
    rows: (auto, 1fr),
    grid.cell(
      colspan: 2,
      fill: primary-color,
      inset: (top: 40pt, bottom: 40pt, left: 30%),
      {
        set text(fill: white)
        align(left)[
          #upper(text(size: 24pt, weight: "bold", tracking: 1.5pt)[#data.name]) \
          #v(-5pt)
          #upper(text(size: 12pt, tracking: 1pt)[#data.role])
        ]
      },
    ),
    rect(
      fill: secondary-color,
      width: 100%,
      height: 100%,
      inset: (top: -40pt, x: 20pt, bottom: 20pt),
      {
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

        sidebar-section(trl.get("contact"))
        grid(
          columns: (1fr, 8fr),
          row-gutter: 10pt,
          align: (left, left),
          fa-icon("phone"), [#link("tel:" + data.contact.number, data.contact.number)],
          fa-icon("envelope"), [#email(data.contact.email)],
          fa-icon("cake-candles"), [#calculate-age(data.birthday)  #trl.get("years-old")],
          fa-icon("map-pin"), [#data.contact.address],
          fa-icon("globe"), [#link(data.contact.website, data.contact.website)],
        )

        v(4pt, weak: true)
        for section in data.side.keys() {
          sidebar-section(section)
          for item in data.side.at(section) {
            text(size: 8.5pt)[#eval(item, mode: "markup") \ ]
          }
        }
      },
    ),
    pad(
      top: 30pt,
      left: 30pt,
      right: 30pt,
      bottom: 20pt,
      {
        section-title(trl.get("about"))
        text(data.about)
        for section in data.main {
          section-title(section.title)
          for item in section.items {
            exp-item(item.company, item.roles)
          }
        }
      },
    ),
  )
}
