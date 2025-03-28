//remplate pour prise de notes CM à plusieurs
//ici on utilise les définitions

#let definition = ("testt","testd")

#let ajouter(definition,term, defi) ={
  definition = definition + (term,defi)
}


#let defcount=counter("def")
#let propcount=counter("prop")
#let theocount=counter("theo")


#let def(term) = {
  box(
    stroke: none,
    fill: rgb("#dff2e4"),
    width: 160mm,
    inset: 1em,
    radius: 25%
  )[#defcount.step()
    *Définition #context defcount.display(): * 
    #term]
}

#let prop(term) = {
  box(
    stroke: none,
    fill: rgb("#f2dfe2"),
    width: 160mm,
    inset: 1em,
    radius: 25%
  )[#propcount.step()
    *Proposition #context propcount.display() :* #term]
}

#let theo(term) = {
  box(
    stroke: none,
    fill: rgb("#dfe1f2"),
    width: 160mm,
    inset: 1em,
    radius: 25%
  )[#theocount.step()
    *Théorème #context theocount.display() :* #term]
}

#let citation(term, name, date)={
  box(
    stroke: none,
    fill: rgb("#fcdefc"),
    width: 160mm,
    inset: 1em,
    radius: 20pt
  )[*#emoji.sparkles #emoji.ribbon Citation inspirante #emoji.ribbon #emoji.sparkles:  #linebreak() *#emph[#term] #align(right, [#emph[#emoji.flower.tulip #emoji.flower #name #emoji.butterfly #date #emoji.flower #emoji.flower.tulip]])]
}
  

#let project(
  title : "", generalites : (), body) = {
  //définition des basiques du template
  set page(numbering: "1", number-align: right)
  set document(title: title)
  set heading(numbering: "1.1.")
  set text(font: "New Computer Modern", lang: "fr")
  
  
  //titre ici
  align(center)[
    #block(text(weight: 700, 1.75em, "Prise de notes : " + title))
  ]

  //ici on va mettre les généralités
  //titre ici
  align(left)[
    #block(text(weight: 600, 1.15em, "Généralités sur le cours "))
  ]
  //on vérifie que generalites n'est pas vide pour écrire quelque chose
  if generalites.len() > 0 {
    //le cadre est fait là
    box(
      stroke: luma(10),
      fill: luma(200),
      inset: 1em,
      width: 160mm
    )[#list(..generalites)]
  }

  //table des matières 
  outline(depth: 2)
  
  linebreak()
  
  
  //définitions à écrire
  text(weight: 700, 1.25em, "Définitions")
  //ici je fais le tableau avec les defs et terme
  table(
    columns: 2,
    row-gutter: (2.2pt, auto),
    align: center,
    table.header[*_Mot_*][*_Définition_*],
    ..definition
  )
  
  box()[#list(..definition)]

  pagebreak()
  // main body.
  set par(justify: true)
  body
  
}


