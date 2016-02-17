# XXTEA 加密算法的 Nim 实现

<a href="https://github.com/xxtea/">
    <img src="https://avatars1.githubusercontent.com/u/6683159?v=3&s=86" alt="XXTEA logo" title="XXTEA" align="right" />
</a>

[![Build Status](https://travis-ci.org/xxtea/xxtea-nim.svg?branch=master)](https://travis-ci.org/xxtea/xxtea-nim)

## 简介

XXTEA 是一个快速安全的加密算法。本项目是 XXTEA 加密算法的 Nim 实现。

它不同于原始的 XXTEA 加密算法。它是针对原始二进制数据类型进行加密的，而不是针对 32 位 int 数组。同样，密钥也是原始二进制数据类型。

## 安装

```sh
nimble install https://github.com/xxtea/xxtea-nim.git
```

## 使用

```nim
import xxtea

const text = "Hello World! 你好，中国！"
const key = "1234567890"
var encrypt_data = xxtea.encrypt(text, key)
var decrypt_data = xxtea.decrypt(encrypt_data, key)
if text == decrypt_data:
    echo "success!"
else:
    echo "fail!"
```
