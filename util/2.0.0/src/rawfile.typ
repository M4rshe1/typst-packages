#import "@preview/zebraw:0.6.1": *
#import "code.typ": default-colormap


#let rawfile(reader: function, path, lang, declarations, offset: 0, colormap: default-colormap) = {
  let file-name = path.split("/").at(-1)
  let lang = if (lang == none) { path.split(".").at(-1) } else { lang }
  let raw-content = "```" + lang + "\n" + reader(path) + "\n```"

  let lines = ()
  let colors = ()
  for (typ, col) in colormap {
    if typ in declarations {
      for dec in declarations.at(typ) {
        lines.push(dec)
        colors.push(col)
      }
    }
  }
  let opts = if declarations.len() != 0 {
    (
      highlight-lines: lines.zip(colors),
    )
  } else {
    ()
  }

  zebraw(
    ..opts,
    numbering-offset: offset,
    eval(raw-content),
  )
}
