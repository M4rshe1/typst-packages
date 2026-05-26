#import "@local/lib:1.0.0": mod

#let section-title(title) = {
  v(15pt)
  upper(text(weight: "bold", size: 11pt, tracking: 1.2pt)[#title])
  v(-6pt)
  line(length: 100%, stroke: 0.5pt + gray)
  v(5pt)
}

#let sidebar-section(title) = {
  v(20pt)
  upper(text(weight: "bold", size: 11pt, tracking: 1.2pt, fill: black)[#title])
  v(-6pt)
  line(length: 100%, stroke: 0.5pt + gray)
  v(5pt)
}

#let exp-role(title, from, to, desc) = {
  let time = to - from
  let dur = ""

  if (from > to) {
    panic("From date is after to date")
  }
  if time.days() > 365 {
    let years = calc.floor(time.days() / 365)
    dur = str(years) + " Jahre"
  }
  if (mod(time.days(), 365) > 30) {
    dur += " " + str(calc.floor(mod(time.days(), 365) / 30)) + " Monate"
  }
  grid(
    columns: (1fr, auto),
    text(size: 9pt, weight: "medium")[#title],
    text(
      style: "italic",
      size: 8.5pt,
    )[#from.display("[month repr:short] [year]") - #to.display("[month repr:short] [year]") (#dur.trim())],
  )
  v(2pt)
  text(size: 8.5pt)[#desc]
  v(6pt)
}

#let exp-item(company, ..roles) = {
  text(weight: "bold")[#company]
  v(4pt)
  for role in roles.pos() {
    exp-role(role.title, role.from, role.to, role.desc)
  }
  v(4pt)
}
