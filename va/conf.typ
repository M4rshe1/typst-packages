#import "@local/lib:1.0.0": light-gray, transparent
#import "@preview/wordometer:0.1.4": total-characters, total-words, word-count
#import "@preview/glossy:0.8.0": glossary, init-glossary
#import "@local/glossar:1.0.0": glossar-theme-german-table, theme-show-term


#let conf(
  title: "Some Title",
  subtitle: "Vertiefungsarbeit xxxx",
  apprentice-year: 4,
  author: (
    first-name: "Colin",
    last-name: "Heggli",
    job: "Betriebsinformatiker EFZ",
    company: "Georg Fischer AG",
    class: "INF 22a",
  ),
  signature: (
    image: "assets/signature.png",
    location: "8200 Schaffhausen",
    date: datetime,
  ),
  semester: 7,
  class: "ABU",
  teacher: "Michael Meier",
  cover: image("assets/cover.jpg"),
  created: datetime,
  submission: datetime,
  document-name: "",
  sources: bibliography,
  gloss: yaml("gloss.yml"),
  show-term: theme-show-term,
  appendix: [],
  info: false,
  doc,
) = {
  set document(title: title, author: author.first-name + " " + author.last-name, date: created, description: subtitle)

  show: init-glossary.with(gloss, show-term: show-term)

  show figure: set block(breakable: true)

  show outline: set outline(indent: depth => (depth * 10pt))

  show: word-count

  set page(
    paper: "a4",
    numbering: "1",
    margin: (
      left: 25mm,
      right: 25mm,
      top: 25mm,
      bottom: 20mm,
    ),
    header: context {
      if (counter(page).get().at(0) != 1) {
        grid(
          columns: (1fr, auto),
          align: (top, right),
          align(top + left)[
            #text(9pt)[#title - #subtitle] \
            #text(9pt)[#author.first-name #author.last-name, #author.job #apprentice-year. Lehrjahr]
          ],
        )
      }
    },
    footer: context {
      if (counter(page).get().at(0) != 1) {
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (bottom, center, right),
          grid.cell(colspan: 3, line(length: 100%)),
          grid.cell(colspan: 3, v(10pt)),
          align(top + left)[#text(9pt)[#document-name]],
          text(9pt)[#created.display("[day]. [month repr:long] [year]")],
          text(9pt)[Seite #(counter(page).get().at(0) - 1) von #(counter(page).final().at(0) - 1)],
        )
      }
    },
  )


  show raw.where(block: false): it => box(
    fill: light-gray,
    radius: 2pt,
    inset: 2pt,
    [#text(weight: "bold", [#it])],
  )

  show heading.where(level: 1): it => [
    #colbreak()
    #text(weight: "bold", size: 19pt)[#it]
    #v(-12pt)
    #line(length: 100%)
  ]

  set heading(numbering: "1.")

  set text(
    font: "Arial",
    lang: "de",
    hyphenate: true,
    size: 12pt,
  )

  set par(
    leading: 0.7em,
    spacing: 1.5em,
    first-line-indent: 0pt,
    justify: true,
  )

  {
    show figure: set text(fill: transparent)
    set image(width: 100%)
    figure(
      cover,
      caption: "Cover",
    )
  }


  align(left)[
    #text(size: 2em, weight: "bold")[#title]\
    #text(size: 1.5em, weight: "bold")[#subtitle]
  ]
  v(100pt)

  align(left)[
    #show text: set text(9pt)
    #set table.cell(fill: light-gray)
    #table(
      columns: (auto, 1fr),
      rows: auto,
      stroke: none,
      align: left,
      [Name], [*#author.last-name*],
      [Vorname], [*#author.first-name*],
      [Beruf], [#author.job],
      [Firma], [#author.company],
      [Lehrjahr], [#apprentice-year. Lehrjahr],
      [Semester], [#semester. Semester],
      [Erstelldatum], [#created.display("[day]. [month repr:long] [year]")],
      [Fach], [#class],
      [Lehrperson], [#teacher],
      [Abgabedatum], [#submission.display("[day]. [month repr:long] [year]")],
      [Klasse], [#author.class],
    )
  ]


  {
    show outline.entry.where(level: 1): set text(weight: "bold")
    outline(
      title: "Inhaltsverzeichnis",
    )
  }

  if (info) {
    box(
      fill: red.lighten(80%),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      stroke: red + 4pt,
      [
        #text(16pt, fill: black, weight: "bold", hyphenate: false)[
          ACHTUNG: Bevor das Dokument abgegeben wird die "info" flag in der Template config entfernen damit diese Box verschwindet.
        ]
        #linebreak()
        #linebreak()
        #text(16pt, fill: black, hyphenate: false)[
          Wörter: *#total-words* \
          Zeichen: *#total-characters*
        ]
      ],
    )
  }

  show link: underline
  show link: set text(fill: blue)

  doc

  heading(level: 1)[Quellenverzeichnis]
  set bibliography(title: none, full: true)
  sources

  if (gloss != none and gloss.len() != 0) {
    glossary(
      title: "Glossar",
      sort: true,
      ignore-case: false,
      show-all: true,
    )
  }

  show link: set text(fill: black)
  show link: set underline(stroke: transparent)


  show outline.entry: it => link(
    it.element.location(),
    it.indented(it.prefix(), [#it.body() #it.inner().children.at(2) #(
        int(repr(it.inner().children.at(5)).slice(1, -1)) - 1
      )]),
  )

  context {
    if counter(figure.where(kind: image)).get().at(0) != 0 {
      heading(level: 1, [Abbildungsverzeichnis])
      outline(
        target: figure.where(kind: image),
        title: none,
      )
    }
  }
  context {
    if counter(figure.where(kind: table)).get().at(0) != 0 {
      heading(level: 1, [Tabellenverzeichnis])
      outline(
        target: figure.where(kind: table),
        title: none,
      )
    }
  }
  context {
    if counter(figure.where(kind: raw)).get().at(0) != 0 {
      heading(level: 1, [Codeverzeichnis])
      outline(
        target: figure.where(kind: raw),
        title: none,
      )
    }
  }

  heading(level: 1)[Eigenständigkeitserklärung]
  [„Ich habe die vorliegende Arbeit mit vollständiger Angabe der Quellen selbständig verfasst.“ ]
  linebreak()
  [#author.first-name #author.last-name]
  signature.image
  [#signature.location, #signature.date.display("[day]. [month repr:long] [year]") ]

  if (appendix.children.len() != 0) {
    heading(level: 1)[Anhang]
    appendix
  }
}
