///|
/// Keccak256 测试用例

// 测试空消息的哈希
test "keccak256 empty message" {
  let empty : Array[Byte] = []
  let hash = keccak256_hex(empty)
  // 空消息的 Keccak256 哈希值（标准测试向量）
  inspect(
    hash,
    content="c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
  )
}

// 测试简单字符串 "abc" 的哈希

///|
test "keccak256 abc" {
  let hash = keccak256_string_hex("abc")
  // "abc" 的 Keccak256 哈希值（标准测试向量）
  inspect(
    hash,
    content="4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45",
  )
}

// 测试更长的消息

///|
test "keccak256 longer message" {
  let hash = keccak256_string_hex("The quick brown fox jumps over the lazy dog")
  // 标准测试向量
  inspect(
    hash,
    content="4d741b6f1eb29cb2a9b9911c82f56fa8d73b04959d3d9d222895df6c0b28aa15",
  )
}

// 测试 "keccak" 字符串

///|
test "keccak256 keccak string" {
  let hash = keccak256_string_hex("keccak")
  inspect(
    hash,
    content="df35a135a69c769066bbb4d17b2fa3ec922c028d4e4bf9d0402e6f7c12b31813",
  )
}

// 测试单字节消息

///|
test "keccak256 single byte" {
  let msg : Array[Byte] = [b'\x00']
  let hash = keccak256_hex(msg)
  inspect(
    hash,
    content="bc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a",
  )
}

// 测试字节序列

///|
test "keccak256 byte sequence" {
  let msg : Array[Byte] = [b'\x01', b'\x02', b'\x03', b'\x04', b'\x05']
  let hash = keccak256_hex(msg)
  // 验证输出长度为 64 个十六进制字符（32 字节）
  inspect(hash.length(), content="64")
}

// 测试 256 位输出长度

///|
test "keccak256 output length" {
  let hash = keccak256_string("test")
  inspect(hash.length(), content="32")
}

// 测试确定性：相同输入应该产生相同输出

///|
test "keccak256 deterministic" {
  let msg = "hello world"
  let hash1 = keccak256_string_hex(msg)
  let hash2 = keccak256_string_hex(msg)
  inspect(hash1 == hash2, content="true")
}

// 测试不同输入产生不同输出

///|
test "keccak256 different inputs" {
  let hash1 = keccak256_string_hex("hello")
  let hash2 = keccak256_string_hex("world")
  inspect(hash1 == hash2, content="false")
}

// 测试较长的消息（超过一个块）

///|
test "keccak256 multi block" {
  let long_msg = "a".repeat(200)
  let hash = keccak256_string_hex(long_msg)
  // 验证输出长度正确
  inspect(hash.length(), content="64")
}
