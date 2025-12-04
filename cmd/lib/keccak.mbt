///| Keccak 状态结构和核心算法实现

// Keccak 状态：5x5 的 UInt64 数组，共 1600 位
priv struct State {
  a : Array[UInt64]  // 25 个 64 位字
}

// 创建新的空状态
fn State::new() -> State {
  { a: Array::make(25, 0UL) }
}

// 获取状态中的元素 (x, y 坐标)
fn State::get(self : State, x : Int, y : Int) -> UInt64 {
  self.a[x + 5 * y]
}

// 设置状态中的元素 (x, y 坐标)
fn State::set(self : State, x : Int, y : Int, value : UInt64) -> Unit {
  self.a[x + 5 * y] = value
}

///|
/// 常量定义

// Keccak256 参数
let rate_bytes : Int = 136 // r = 1088 bits = 136 bytes

///|
let capacity_bytes : Int = 64 // c = 512 bits = 64 bytes

///|
let output_bytes : Int = 32 // 256 bits = 32 bytes

// Keccak-f[1600] 的轮次数

///|
let rounds : Int = 24

// ι (iota) 步骤的轮常量

///|
let round_constants : Array[UInt64] = [
  0x0000000000000001UL, 0x0000000000008082UL, 0x800000000000808AUL, 0x8000000080008000UL,
  0x000000000000808BUL, 0x0000000080000001UL, 0x8000000080008081UL, 0x8000000000008009UL,
  0x000000000000008AUL, 0x0000000000000088UL, 0x0000000080008009UL, 0x000000008000000AUL,
  0x000000008000808BUL, 0x800000000000008BUL, 0x8000000000008089UL, 0x8000000000008003UL,
  0x8000000000008002UL, 0x8000000000000080UL, 0x000000000000800AUL, 0x800000008000000AUL,
  0x8000000080008081UL, 0x8000000000008080UL, 0x0000000080000001UL, 0x8000000080008008UL,
]

// ρ (rho) 步骤的旋转偏移量

///|
let rho_offsets : Array[Int] = [
  0, 1, 62, 28, 27, 36, 44, 6, 55, 20, 3, 10, 43, 25, 39, 41, 45, 15, 21, 8, 18,
  2, 61, 56, 14,
]

///|
/// Keccak-f[1600] 置换的五个步骤

// 辅助函数：64 位循环左移
fn rotl64(x : UInt64, n : Int) -> UInt64 {
  (x << n.reinterpret_as_uint()) | (x >> (64 - n).reinterpret_as_uint())
}

// θ (theta) 步骤

///|
fn theta(state : State) -> Unit {
  let c : Array[UInt64] = Array::make(5, 0UL)
  let d : Array[UInt64] = Array::make(5, 0UL)

  // 计算 C[x] = A[x,0] xor A[x,1] xor A[x,2] xor A[x,3] xor A[x,4]
  for x = 0; x < 5; x = x + 1 {
    c[x] = state.get(x, 0) ^
      state.get(x, 1) ^
      state.get(x, 2) ^
      state.get(x, 3) ^
      state.get(x, 4)
  }

  // 计算 D[x] = C[x-1] xor rot(C[x+1], 1)
  for x = 0; x < 5; x = x + 1 {
    d[x] = c[(x + 4) % 5] ^ rotl64(c[(x + 1) % 5], 1)
  }

  // A[x,y] = A[x,y] xor D[x]
  for x = 0; x < 5; x = x + 1 {
    for y = 0; y < 5; y = y + 1 {
      state.set(x, y, state.get(x, y) ^ d[x])
    }
  }
}

// ρ (rho) 步骤 - 旋转

///|
fn rho(state : State) -> Unit {
  for x = 0; x < 5; x = x + 1 {
    for y = 0; y < 5; y = y + 1 {
      let offset = rho_offsets[x + 5 * y]
      state.set(x, y, rotl64(state.get(x, y), offset))
    }
  }
}

// π (pi) 步骤 - 重新排列

///|
fn pi(state : State) -> Unit {
  let temp : Array[UInt64] = Array::make(25, 0UL)

  // 复制当前状态
  for i = 0; i < 25; i = i + 1 {
    temp[i] = state.a[i]
  }

  // A[x,y] = A'[x+3y, x] (其中 A' 是输入状态)
  for x = 0; x < 5; x = x + 1 {
    for y = 0; y < 5; y = y + 1 {
      let old_x = (x + 3 * y) % 5
      let old_y = x
      state.set(x, y, temp[old_x + 5 * old_y])
    }
  }
}

// χ (chi) 步骤 - 非线性混合

///|
fn chi(state : State) -> Unit {
  let temp : Array[UInt64] = Array::make(25, 0UL)

  // 复制当前状态
  for i = 0; i < 25; i = i + 1 {
    temp[i] = state.a[i]
  }

  // A[x,y] = A'[x,y] xor ((not A'[x+1,y]) and A'[x+2,y])
  for x = 0; x < 5; x = x + 1 {
    for y = 0; y < 5; y = y + 1 {
      let v1 = temp[x + 5 * y]
      let v2 = temp[(x + 1) % 5 + 5 * y]
      let v3 = temp[(x + 2) % 5 + 5 * y]
      state.set(x, y, v1 ^ (v2.lnot() & v3))
    }
  }
}

// ι (iota) 步骤 - 添加轮常量

///|
fn iota(state : State, round : Int) -> Unit {
  state.set(0, 0, state.get(0, 0) ^ round_constants[round])
}

///|
/// Keccak-f[1600] 置换函数

// 完整的 Keccak-f[1600] 置换（24 轮）
fn keccak_f(state : State) -> Unit {
  for round = 0; round < rounds; round = round + 1 {
    theta(state)
    rho(state)
    pi(state)
    chi(state)
    iota(state, round)
  }
}

///|
/// 填充函数

// pad10*1 填充规则
// 在消息末尾添加 0x01，然后添加必要数量的 0x00，最后添加 0x80
fn pad(message : Array[Byte], rate : Int) -> Array[Byte] {
  let msg_len = message.length()
  let block_size = rate

  // 计算需要填充的字节数
  let pad_len = block_size - msg_len % block_size
  let padded : Array[Byte] = Array::make(msg_len + pad_len, b'\x00')

  // 复制原始消息
  for i = 0; i < msg_len; i = i + 1 {
    padded[i] = message[i]
  }

  // 添加填充
  if pad_len == 1 {
    // 只有一个字节的填充：0x81 = 0x01 | 0x80
    padded[msg_len] = b'\x81'
  } else {
    // 多个字节的填充
    padded[msg_len] = b'\x01' // 第一个填充字节
    // 中间的字节已经是 0x00（Array::make 默认值）
    padded[msg_len + pad_len - 1] = b'\x80' // 最后一个填充字节
  }
  padded
}

///|
/// 海绵构造

// 吸收阶段：将输入数据吸收到状态中
fn absorb(state : State, data : Array[Byte], rate : Int) -> Unit {
  let rate_bytes = rate
  let blocks = data.length() / rate_bytes
  for block = 0; block < blocks; block = block + 1 {
    // 将当前块的数据与状态异或
    let offset = block * rate_bytes
    let data_view = data[offset:offset + rate_bytes]
    for i = 0; i < rate_bytes / 8; i = i + 1 {
      let word = bytes_to_uint64_le(data_view, i * 8)
      state.a[i] = state.a[i] ^ word
    }

    // 应用置换
    keccak_f(state)
  }
}

// 挤出阶段：从状态中提取输出

///|
fn squeeze(state : State, output_len : Int, rate : Int) -> Array[Byte] {
  let output : Array[Byte] = Array::make(output_len, b'\x00')
  let rate_bytes = rate
  let mut output_offset = 0
  while output_offset < output_len {
    // 从状态中提取数据
    let copy_len = if output_len - output_offset < rate_bytes {
      output_len - output_offset
    } else {
      rate_bytes
    }
    let words_to_copy = (copy_len + 7) / 8 // 向上取整
    for i = 0; i < words_to_copy; i = i + 1 {
      let word = state.a[i]
      let bytes_in_word = if i == words_to_copy - 1 && copy_len % 8 != 0 {
        copy_len % 8
      } else {
        8
      }
      for j = 0; j < bytes_in_word; j = j + 1 {
        output[output_offset + i * 8 + j] = (word >> (j * 8).reinterpret_as_uint())
          .land(0xFFUL)
          .to_byte()
      }
    }
    output_offset = output_offset + copy_len

    // 如果还需要更多输出，继续应用置换
    if output_offset < output_len {
      keccak_f(state)
    }
  }
  output
}

///|
/// Keccak256 主函数

// Keccak256 哈希函数
pub fn keccak256(message : Array[Byte]) -> Array[Byte] {
  // 初始化状态
  let state = State::new()

  // 填充消息
  let padded = pad(message, rate_bytes)

  // 吸收阶段
  absorb(state, padded, rate_bytes)

  // 挤出阶段
  squeeze(state, output_bytes, rate_bytes)
}

// Keccak256 哈希函数（返回十六进制字符串）

///|
pub fn keccak256_hex(message : Array[Byte]) -> String {
  let hash = keccak256(message)
  bytes_to_hex(hash)
}

// Keccak256 哈希函数（输入为字符串）

///|
pub fn keccak256_string(message : String) -> Array[Byte] {
  let bytes : Array[Byte] = Array::make(message.length(), b'\x00')
  for i = 0; i < message.length(); i = i + 1 {
    bytes[i] = message.get(i).to_int().to_byte()
  }
  keccak256(bytes)
}

// Keccak256 哈希函数（输入为字符串，返回十六进制）

///|
pub fn keccak256_string_hex(message : String) -> String {
  let hash = keccak256_string(message)
  bytes_to_hex(hash)
}
