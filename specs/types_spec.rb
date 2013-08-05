def dump_test(expected, given)
  assert_equal expected, MsgPack.dump(given)
end

def load_test(expected, given)
  assert_equal expected, MsgPack.load(given)
end



header 'Types encoding'

should("encode boolean (true) ")  { dump_test "\xC3",                  true }
should("encode boolean (false) ") { dump_test "\xC2",                  false }
should("encode nil")              { dump_test "\xC0",                  nil }

should("encode positive fixnum")  { dump_test "\x7F",                  127 }
should("encode uint8 (max)")      { dump_test "\xCC\xFF",              2**8 - 1 }
should("encode uint8")            { dump_test "\xCC\xC8",              200 }
should("encode uint16 (max)")     { dump_test "\xCD\xFF\xFF",          2**16 - 1 }
should("encode uint16")           { dump_test "\xCD\x7F\xFF",          2**15 - 1 }
should("encode uint32 (max)")     { dump_test "\xCE\xFF\xFF\xFF\xFF",  2**32 - 1 }

should("encode negative fixnum")  { dump_test "\xE0",                  -32 }
should("encode int8")             { dump_test "\xD0\x81",              -2**7  + 1 }
should("encode int16 (min)")      { dump_test "\xD1\x80\x00",          -2**15 }



header 'Type decoding'

should("decode boolean (true) ")  { load_test true,          "\xC3" }
should("decode boolean (false) ") { load_test false,         "\xC2" }
should("decode nil")              { load_test nil,           "\xC0" }

should("decode positive fixnum")  { load_test 127,           "\x7F" }
should("decode uint8")            { load_test 2**8 - 1,      "\xCC\xFF" }
should("decode uint16")           { load_test 2**15 - 1,     "\xCD\x7F\xFF" }
should("decode uint32")           { load_test 2**18,         "\xCE\x00\x04\x00\x00" }

should("decode negative fixnum")  { load_test(-32,           "\xE0") }
should("decode int8")             { load_test(-2**7  + 1,    "\xD0\x81") }
should("decode int16")            { load_test(-1,            "\xD1\xFF\xFF") }
should("decode int16")            { load_test(-2**15,        "\xD1\x80\x00") }
should("decode int32")            { load_test(-2**31,        "\xD2\x80\x00\x00\x00") }
# should("decode int64")            { load_test(-2**63,        "\xD3\x80\x00\x00\x00\x00\x00\x00\x00") }
