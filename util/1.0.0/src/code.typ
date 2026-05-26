#import "@preview/zebraw:0.6.1": *

#let default-colormap = (
  h: blue.lighten(80%),
  a: green.lighten(80%),
  r: red.lighten(80%),
  c: yellow.lighten(80%),
)

#let code = (code, caption, high: (), colormap: default-colormap, ..args) => {
  let lines = ()

  if (type(high) == dictionary) {
    for (key, value) in high {
      let color = colormap.at(key)
      for line in value {
        lines.push((line, color))
      }
    }
  } else if (type(high) == array) {
    for line in high {
      lines.push((line, colormap.at("h")))
    }
  }

  [

    #figure(
      kind: raw,
      zebraw(
        highlight-lines: lines,
        code,
        ..args,
      ),
      caption: caption,
    )
  ]
}
