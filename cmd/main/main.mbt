///|
/// Keccak256 示例程序
fn main {
  println("=== Keccak256 哈希算法示例 ===\n")

  // 示例 1: 空消息
  let empty : Array[Byte] = []
  let hash1 = @lib.keccak256_hex(empty)
  println("空消息:")
  println("  哈希值: \{hash1}\n")

  // 示例 2: 简单字符串 "abc"
  let hash2 = @lib.keccak256_string_hex("abc")
  println("消息 'abc':")
  println("  哈希值: \{hash2}\n")

  // 示例 3: 经典测试向量
  let hash3 = @lib.keccak256_string_hex(
    "The quick brown fox jumps over the lazy dog",
  )
  println("消息 'The quick brown fox jumps over the lazy dog':")
  println("  哈希值: \{hash3}\n")

  // 示例 4: 自定义消息
  let hash4 = @lib.keccak256_string_hex("Hello, MoonBit!")
  println("消息 'Hello, MoonBit!':")
  println("  哈希值: \{hash4}\n")

  // 示例 5: 展示字节数组输出
  let hash_bytes = @lib.keccak256_string("test")
  println("消息 'test' (字节数组输出):")
  let mut output = "  字节: ["
  for i = 0; i < hash_bytes.length(); i = i + 1 {
    if i > 0 {
      output = output + ", "
    }
    output = output + hash_bytes[i].to_int().to_string()
    if i == 15 {
      output = output + "\n         "
    }
  }
  output = output + "]\n"
  println(output)
  println("=== 所有示例运行完成 ===")
}
