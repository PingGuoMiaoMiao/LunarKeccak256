# LunarKeccak256

一个使用 MoonBit 语言实现的 Keccak256 哈希算法库。

## 简介

Keccak256 是 SHA-3 标准的一部分，广泛应用于区块链和密码学领域。本项目提供了一个纯 MoonBit 语言实现的 Keccak256 哈希函数。

## 特性

- ✅ 完整的 Keccak-f[1600] 置换实现
- ✅ 标准的海绵构造（Sponge Construction）
- ✅ 支持任意长度的输入
- ✅ 256 位（32 字节）输出
- ✅ 纯 MoonBit 实现，无外部依赖
- ✅ 包含完整的测试用例

## 使用方法

### 基本用法

```moonbit
// 计算字符串的哈希值（返回十六进制字符串）
let hash = @lib.keccak256_string_hex("Hello, World!")
println(hash)

// 计算字节数组的哈希值
let bytes : Array[Byte] = [b'\x01', b'\x02', b'\x03']
let hash_hex = @lib.keccak256_hex(bytes)
println(hash_hex)

// 获取字节数组形式的哈希值
let hash_bytes = @lib.keccak256_string("test")
// hash_bytes 是一个 32 字节的数组
```

### API 文档

#### 主要函数

- `keccak256(message : Array[Byte]) -> Array[Byte]`
  
  计算字节数组的 Keccak256 哈希值，返回 32 字节的哈希结果。

- `keccak256_hex(message : Array[Byte]) -> String`
  
  计算字节数组的 Keccak256 哈希值，返回 64 字符的十六进制字符串。

- `keccak256_string(message : String) -> Array[Byte]`
  
  计算字符串的 Keccak256 哈希值，返回 32 字节的哈希结果。

- `keccak256_string_hex(message : String) -> String`
  
  计算字符串的 Keccak256 哈希值，返回 64 字符的十六进制字符串。

## 运行示例

```bash
# 构建项目
moon build

# 运行示例程序
moon run cmd/main

# 运行测试
moon test

# 更新测试快照
moon test --update
```

## 测试向量

项目包含多个标准测试向量，验证实现的正确性：

- 空消息：`c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470`
- "abc"：`4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45`
- "The quick brown fox jumps over the lazy dog"：`4d741b6f1eb29cb2a9b9911c82f56fa8d73b04959d3d9d222895df6c0b28aa15`

## 项目结构

```
LunarKeccak256/
├── cmd/
│   ├── lib/                 # 核心库
│   │   ├── keccak.mbt       # Keccak256 主实现
│   │   ├── utils.mbt        # 工具函数
│   │   ├── keccak_test.mbt  # 测试用例
│   │   └── moon.pkg.json    # 包配置
│   └── main/                # 示例程序
│       ├── main.mbt         # 主程序
│       └── moon.pkg.json    # 包配置
├── moon.mod.json            # 模块配置
└── README.mbt.md            # 文档
```

## 技术细节

### 算法实现

本实现遵循 NIST FIPS 202 标准，包括：

1. **Keccak-f[1600] 置换函数**：24 轮迭代，每轮包含 5 个步骤
   - θ (theta)：列奇偶性扩散
   - ρ (rho)：位旋转
   - π (pi)：位置置换
   - χ (chi)：非线性混合
   - ι (iota)：轮常量异或

2. **海绵构造**：
   - 速率 r = 1088 位（136 字节）
   - 容量 c = 512 位（64 字节）
   - 吸收阶段：将填充后的消息逐块吸收
   - 挤出阶段：提取 256 位输出

3. **填充规则**：pad10*1 规则
   - 在消息末尾添加 0x01
   - 填充若干 0x00
   - 最后添加 0x80

## 参考文献

- [NIST FIPS 202 - SHA-3 Standard](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf)
- [Keccak Reference](https://keccak.team/files/Keccak-reference-3.0.pdf)
- [Keccak Submission](https://keccak.team/files/Keccak-submission-3.pdf)

## 许可证

Apache-2.0

## 贡献

欢迎提交 Issue 和 Pull Request！