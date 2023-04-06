
#let default_address = [
    Name\
    Street, Street number\
    ZIP, City
]

#let default_stroke = 0.75pt

#let mk_header(
    name,
    address,
    contact,
    accent
) = {
    set block(spacing: 0.64em)
    grid(
        columns: (1fr, 1fr),
        rows: 2,
        align(top + left)[
            #text(16pt, fill: accent, strong(name))\
            #address
        ],
        align(bottom + right, contact)
    )
    line(length: 100%, stroke: accent + default_stroke)
}

#let letter(
    sender_address: [],
    sender_contact: none,
    sender_name: none,
    receiver: none,
    date: none,
    subject: none,
    greeting: none,
    valediction: none,
    attachments: none,
    postal: false,
    accent: black,
    duplex: true,
    content
) = {
    set text(12pt)

    set page(
        paper: "a4",
        margin: (top: 4.5cm, bottom: 2.5cm, left: 2.5cm, right: 2cm),
        header: locate(loc => {
            if loc.page() == 1 {
                mk_header(sender_name, sender_address, sender_contact, accent)
            } else {
                set text(size: 9pt)
                set block(spacing: 0.64em)
                [#sender_name #h(1fr) #date]
                line(length: 100%, stroke: default_stroke)
            }}),
        numbering: "1/1", 
        // set up fold line if it is a postal letter
        background: locate(loc =>
            if postal and (duplex or calc.mod(loc.page(), 2) != 0) {
                place(top + left, line(start: (0mm, 105mm), length: 5mm))
                place(top + left, line(start: (0mm, 210mm), length: 5mm))
        })
    )

    let without_breaks = sender_address.children.filter(elem => elem != [ ] and elem != linebreak())

    // Address fields
    // change height if content is too large. Standard is 5.5cm
    block(height: if postal { 4.5cm } else { 2.5cm })[
        #set block(spacing: 0mm)
        #if postal {
            block(
                width: 100%,
                height: 17.7mm,
                underline(text(size: 9pt, sender_name + " • " + without_breaks.join(" • ")))
            )
        }
        #move(dx: 5mm, align(top + left, receiver))
    ]

    // date
    align(right)[#date]

    // subject
    linebreak()
    strong(text(fill: accent, subject))

    // greeting
    linebreak()
    linebreak()
    greeting

    // content
    {
        set par(justify: true)
        content
    }

    // end
    {
        valediction
        v(1.5em)
        sender_name
    }

    // attachement
    if attachments != none {
        v(1fr)
        set text(9pt)
        [
            *Attachments*:
            #attachments
        ]
    }
}
