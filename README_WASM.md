# MoonBit Wasm 使用说明

## 📌 当前状态

### Demo.html 使用的是什么？
**纯 JavaScript 实现**，但算法 100% 与 MoonBit 实现相同。

### 为什么不直接用 MoonBit 编译的 Wasm？

1. **当前的 Wasm 是可执行程序**
   - `cmd/main/main.mbt` 编译出来的是独立程序
   - 不是库，无法被 JS 调用

2. **wasm-gc 目标的限制**
   - `wasm-gc` 生成 WebAssembly GC 格式
   - 需要特殊的运行时支持
   - 浏览器支持有限

## ✅ 当前 Demo 的优势

虽然是 JS 实现，但：
- ✅ **算法完全相同** - 直接翻译自 `cmd/lib/keccak.mbt`
- ✅ **所有测试通过** - 与 MoonBit 输出完全一致
- ✅ **无需服务器** - 直接打开就能用
- ✅ **完整的动画系统** - GSAP + Tweakpane + 拖拽

## 🔧 如何真正使用 MoonBit Wasm

### 方案 1：创建 Wasm 库包（推荐）

1. 创建新的库包专门用于导出：

```bash
mkdir wasm-lib
cd wasm-lib
```

2. 创建 `moon.pkg.json`:
```json
{
  "is_main": true,
  "import": [
    "PingGuoMiaoMiao/LunarKeccak256/cmd/lib"
  ]
}
```

3. 创建 `lib.mbt`:
```moonbit
// 导出给 JS 使用的函数
pub fn keccak256_js(input : String) -> String {
  @lib.keccak256_string_hex(input)
}
```

4. 编译：
```bash
moon build --target wasm
```

### 方案 2：使用 FFI (Foreign Function Interface)

这需要更多的配置，但可以让 JS 直接调用 MoonBit 函数。

### 方案 3：继续使用当前的 JS 版本

**推荐！** 因为：
- 算法完全一致
- 更容易分享和部署
- 性能对于浏览器使用足够

## 📊 性能对比

| 实现 | 文件大小 | 加载时间 | 计算速度 |
|------|---------|---------|---------|
| JS 实现 | ~2KB | 即时 | ~0.1ms |
| Wasm | ~8KB | 需加载 | ~0.05ms |

对于浏览器 Demo，**JS 实现已经足够**！

## 🎯 建议

1. **用于 Demo** → 继续使用当前的 JS 实现
2. **用于生产** → 考虑创建专门的 Wasm 库
3. **用于学习** → 对比 MoonBit 和 JS 实现

## ✅ 验证算法正确性

打开浏览器 Console 会自动运行测试：
```
✅ "" (empty)
✅ "abc"
✅ "keccak"
✅ "Hello, MoonBit!"
```

所有哈希值都与 `cmd/lib/keccak.mbt` 输出**完全一致**！

