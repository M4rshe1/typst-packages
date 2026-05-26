#import "@local/util:2.0.0": time as tm
#import "trl.typ": trl


#let section-title(title) = {
  v(15pt)
  upper(text(weight: "bold", size: 11pt, tracking: 1.2pt)[#title])
  v(-6pt)
  line(length: 100%, stroke: 0.5pt + gray)
  v(5pt)
}

#let sidebar-section(title) = {
  v(10pt)
  upper(text(weight: "bold", size: 11pt, tracking: 1.2pt, fill: black)[#title])
  v(-6pt)
  line(length: 100%, stroke: 0.5pt + gray)
}

#let exp-role(title, from, to, desc) = {
  let to-date = if (to == "present") {
    datetime.today()
  } else {
    datetime(year: int(to.split("-").at(0)), month: int(to.split("-").at(1)), day: int(to.split("-").at(2)))
  }
  let from-date = datetime(year: int(from.split("-").at(0)), month: int(from.split("-").at(1)), day: int(
    from.split("-").at(2),
  ))
  let time = to-date - from-date

  if (from-date > to-date) {
    panic("From date is after to date")
  }

  let dur = tm.dur-to-str(time, style: "long", precision: 2)

  grid(
    columns: (1fr, auto),
    text(size: 9pt, weight: "medium")[#title],
    text(
      style: "italic",
      size: 8.5pt,
    )[#from-date.display("[month repr:short] [year]") - #(if (to == "present") { context trl.at(text.lang).present } else { to-date.display("[month repr:short] [year]") }) (#dur)],
  )
  v(2pt)
  text(size: 8.5pt)[#eval(desc, mode: "markup")]
  v(6pt)
}

#let exp-item(company, ..roles) = {
  text(weight: "bold")[#company]
  for rolee in roles.pos() {
    let role = rolee.at(0)
    exp-role(role.title, role.from, role.to, role.desc)
  }
  v(4pt)
}
