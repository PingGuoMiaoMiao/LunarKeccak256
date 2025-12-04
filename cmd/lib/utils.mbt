///|
/// 工具函数

// 将字节数组转换为 UInt64（小端序）
fn bytes_to_uint64_le(bytes : ArrayView[Byte], offset : Int) -> UInt64 {
  let mut result : UInt64 = 0UL
  for i = 0; i < 8; i = i + 1 {
    let byte_val = bytes[offset + i].to_uint64()
    let shift = (i * 8).reinterpret_as_uint().reinterpret_as_int()
    result = result | (byte_val << shift)
  }
  result
}

// 将 UInt64 转换为字节数组（小端序）


// 将字节切片转换为十六进制字符串

///|
fn bytes_to_hex(bytes : Array[Byte]) -> String {
  let mut result = ""
  for i = 0; i < bytes.length(); i = i + 1 {
    let b = bytes[i].to_int()
    let high = (b >> 4) & 0xF
    let low = b & 0xF
    result = result + high.to_hex_digit() + low.to_hex_digit()
  }
  result
}

// 将 0-15 的整数转换为十六进制字符

///|
fn Int::to_hex_digit(self : Int) -> String {
  match self {
    0 => "0"
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "a"
    11 => "b"
    12 => "c"
    13 => "d"
    14 => "e"
    15 => "f"
    _ => "0"
  }
}

