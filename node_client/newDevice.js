


const buf = Buffer.from([0x00, 0xB5, 0xBA, 0xD8, 0x35, 0x7E, 0xBC, 0xC4]);

let ba =  buf.readBigUInt64BE(); // left to right

let la =  buf.readBigUInt64LE();

return Math.floor(Math.random() * (max - min)) + min;
Math.random();
//uid 00 B5 BA D8 35 7E BC C4 
//id 00 3B 16 7C 1B 1C 4B E5
//sk 00 AA 8E 42 58 3C 09 93 00 71 32 23 BE 62 D6 B1
console.log(ba);
console.log(la);
console.log(buf.toString('hex'));



