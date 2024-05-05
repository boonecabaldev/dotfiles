let x = map(buffs.infoItems(), {index, item -> 'Buf name: ' . item.name})
"echo x

let anum = ab.number()
let y = filter(x, 'v:val != anum')
echo y
