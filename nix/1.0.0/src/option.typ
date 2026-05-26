#let option(
  prefix: "",
  name: "",
  typ: none,
  default: none,
  example: none,
  choices: (:),
  description: [],
) = box(block(
  width: 100%,
  stroke: 0.5pt + gray.lighten(50%),
  fill: gray.lighten(95%),
  inset: (x: 0.8em, y: 0.7em),
  radius: 3pt,
  breakable: true,
  {
    // Option Name
    text(font: "72 Monospace", weight: "bold", size: 1em, fill: rgb("#204a87"), prefix + name)

    // Helper to format values into Nix syntax
    let format-nix(val) = {
      let t_str = if typ != none { lower(typ) } else { "" }
      let is-str-type = t_str.contains("string") or t_str.contains("str") or t_str.contains("enum")

      // Recursive function to handle nested structures
      let rec(v) = {
        let vt = type(v)
        if vt == bool {
          if v { "true" } else { "false" }
        } else if vt == array {
          "[ " + v.map(it => rec(it)).join(" ") + " ]"
        } else if vt == dictionary {
          (
            "{ "
              + v
                .pairs()
                .map(it => {
                  it.at(0) + " = " + rec(it.at(1)) + ";"
                })
                .join(" ")
              + " }"
          )
        } else if vt == str {
          if is-str-type and not v.starts-with("\"") { "\"" + v + "\"" } else { v }
        } else {
          str(v)
        }
      }
      rec(val)
    }

    // Metadata Row
    if typ != none or default != none or example != none {
      v(0.2em)
      set text(size: 0.85em)
      grid(
        columns: (auto, 1fr),
        column-gutter: 0.8em,
        row-gutter: 0.2em,
        if typ != none { text(style: "italic", fill: gray.darken(40%), [Typ:]) },
        if typ != none { raw(typ, lang: "nix") },

        if default != none { text(style: "italic", fill: gray.darken(40%), [Standard:]) },
        if default != none { raw(format-nix(default), lang: "nix") },

        if example != none { text(style: "italic", fill: gray.darken(40%), [Beispiel:]) },
        if example != none { raw(format-nix(example), lang: "nix") },
      )
    }

    v(0.8em, weak: true)
    line(length: 100%, stroke: 0.3pt + gray.lighten(70%))
    v(0.8em, weak: true)

    // Main Description
    set par(justify: true)
    set text(size: 0.95em)
    description

    // Compact Choices Section
    if choices.len() > 0 {
      v(0.8em, weak: true)
      text(weight: "semibold", size: 0.85em, [Optionen:])
      v(0.6em, weak: true)
      pad(left: 0.5em)[
        #grid(
          columns: (auto, 1fr),
          column-gutter: 1em,
          row-gutter: 0.3em,
          ..choices
            .pairs()
            .map(it => (
              align(right)[#raw("\"" + it.at(0) + "\"", lang: "nix")],
              text(size: 0.9em, it.at(1)),
            ))
            .flatten()
        )
      ]
    }
  },
))
