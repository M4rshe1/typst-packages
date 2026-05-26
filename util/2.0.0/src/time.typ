#import "number.typ"

#let trl = (
  en: (
    y: ("year", "years", "y"),
    m: ("month", "months", "M"),
    d: ("day", "days", "d"),
    h: ("hour", "hours", "h"),
    M: ("minute", "minutes", "m"),
    s: ("second", "seconds", "s"),
  ),
  de: (
    y: ("Jahr", "Jahre", "J"),
    m: ("Monat", "Monate", "M"),
    d: ("Tag", "Tage", "T"),
    h: ("Stunde", "Stunden", "h"),
    M: ("Minute", "Minuten", "m"),
    s: ("Sekunde", "Sekunden", "s"),
  ),
)

#let dur-to-str(
  dur,
  style: "long", // "long" or "short"
  lang: "auto",
  leading-zero: false,
  precision: 5,
) = context {
  let auto-lang = "en"
  if lang == "auto" {
    auto-lang = text.lang
  } else {
    auto-lang = lang
  }

  let dict = trl.at(auto-lang, default: trl.en)

  let total-days = calc.floor(dur.days())
  let years = calc.floor(total-days / 365)
  let months = calc.floor(calc.rem(total-days, 365) / 30)
  let days = calc.floor(calc.rem(calc.rem(total-days, 365), 30))
  let hours = calc.floor(calc.floor(dur.hours()) - (total-days * 24))
  let minutes = calc.floor(calc.floor(dur.minutes()) - (calc.floor(dur.hours()) * 60))
  let seconds = calc.floor(dur.seconds() - (calc.floor(dur.minutes()) * 60))

  let units = (
    ("y", years),
    ("m", months),
    ("d", days),
    ("h", hours),
    ("M", minutes),
    ("s", seconds),
  )

  let result = ""
  let sp = if style == "short" { "" } else { " " }
  for (key, value) in units.slice(0, precision) {
    if value > 0 {
      let labels = dict.at(key)
      let label = if style == "short" {
        labels.at(2)
      } else if value == 1 {
        labels.at(0)
      } else {
        labels.at(1)
      }

      if (leading-zero) {
        value = number.lz(str(value), 2)
      } else {
        value = str(value)
      }

      result = (
        result + "[#value][#sp][#label] ".replace("[#value]", value).replace("[#sp]", sp).replace("[#label]", label)
      )
    }
  }
  return result.trim()
}
