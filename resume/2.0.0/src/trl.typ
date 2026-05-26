#let trl = (
  en: (
    present: "present",
    contact: "Contact",
    about: "About me",
    years-old: "years old",
  ),
  de: (
    present: "jetzt",
    contact: "Kontakt",
    about: "Über mich",
    years-old: "Jahre alt",
  ),
)

#let get(key) = {
  context trl.at(text.lang).at(key)
}
