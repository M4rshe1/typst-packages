#let trl = (
  en: (
    option: "Option",
    options: "Options",
    type: "Type",
    default: "Default",
    example: "Example",
  ),
  de: (
    option: "Option",
    options: "Optionen",
    type: "Typ",
    default: "Standard",
    example: "Beispiel",
  ),
)

#let get(key) = {
  context trl.at(text.lang).at(key)
}
