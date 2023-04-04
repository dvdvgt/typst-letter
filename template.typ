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
    line(length: 100%, stroke: accent + 0.75pt)
}

#let default_address = [
    Name\
    Street, Street number\
    ZIP, City
]

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
    content
) = {
    set text(12pt)

    set page(
        paper: "a4",
        margin: (top: 4.5cm, bottom: 2.5cm, left: 2.5cm, right: 2cm),
        header: mk_header(sender_name, sender_address, sender_contact, accent),
        // set up fold line if it is a postal letter
        background: if postal {
            set block(below: 0em)
            align(top, line(start: (0mm, 105mm), length: 5mm))
            align(top, line(start: (0mm, 105mm), length: 5mm))
        }
    )

    let without_breaks = sender_address.children.filter(elem => elem != [ ] and elem != linebreak())

    // Address fields
    // change height if content is too large. Standard is 5.5cm
    block(height: if postal { 4.5cm } else { 2.5cm })[
        #set block(spacing: 0mm)
        #if postal { block(width: 100%, height: 17.7mm, text(size: 9pt, sender_name + " • " + without_breaks.join(" • "))) }
        #align(top + left, receiver)
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


#show: letter.with(
    sender_name: "Name",
    sender_address: [
        Street, Street number\
        ZIP, City\
    ],
    sender_contact: [
        0123456789 *|* #link("mailto:name@mail.com")
    ],
    date: "31.12.2099",
    subject: lorem(10),
    greeting: "Dear Mr./Ms. Name,",
    valediction: "Sincerely,",
    attachments: [
        #set list(tight: true)
        - Resume
        - Certificate
    ],
    postal: false
)

#lorem(50)

#lorem(70)

#lorem(30)