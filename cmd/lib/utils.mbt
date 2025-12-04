///|
/// 工具函数

// 将字节数组转换为 UInt64（小端序）
fn bytes_to_uint64_le(bytes : ArrayView[Byte], offset : Int) -> UInt64 {
  let mut result : UInt64 = 0UL
  for i = 0; i < 8; i = i + 1 {
    let byte_val = bytes[offset + i].to_uint64()
    result = result.lor(byte_val << (i * 8).reinterpret_as_uint())
  }
  result
}

// 将 UInt64 转换为字节数组（小端序）

///|
fn uint64_to_bytes_le(
  value : UInt64,
  bytes : Array[Byte],
  offset : Int,
) -> Unit {
  for i = 0; i < 8; i = i + 1 {
    bytes[offset + i] = (value >> (i * 8).reinterpret_as_uint()).land(0xFFUL).to_byte()
  }
}

// 将字节切片转换为十六进制字符串

///|
fn bytes_to_hex(bytes : Array[Byte]) -> String {
  let hex_chars = "0123456789abcdef"
  let mut result = ""
  for i = 0; i < bytes.length(); i = i + 1 {
    let b = bytes[i].to_int()
    let high = (b >> 4) & 0xF
    let low = b & 0xF
    result = result + hex_chars.get(high).to_string() + hex_chars.get(low).to_string()
  }
  result
}

// 将十六进制字符串转换为字节数组

///|
fn hex_to_bytes(hex : String) -> Array[Byte] {
  let len = hex.length()
  let bytes : Array[Byte] = Array::make(len / 2, b'\x00')
  fn hex_char_to_int(c : Char) -> Int {
    match c {
      '0' => 0
      '1' => 1
      '2' => 2
      '3' => 3
      '4' => 4
      '5' => 5
      '6' => 6
      '7' => 7
      '8' => 8
      '9' => 9
      'a' | 'A' => 10
      'b' | 'B' => 11
      'c' | 'C' => 12
      'd' | 'D' => 13
      'e' | 'E' => 14
      'f' | 'F' => 15
      _ => 0
    }
  }

  for i = 0; i < len / 2; i = i + 1 {
    let high = hex_char_to_int(hex[i * 2])
    let low = hex_char_to_int(hex[i * 2 + 1])
    bytes[i] = ((high << 4) | low).to_byte()
  }
  bytes
}
