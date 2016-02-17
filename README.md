# XXTEA for Nim

<a href="https://github.com/xxtea/">
    <img src="https://avatars1.githubusercontent.com/u/6683159?v=3&s=86" alt="XXTEA logo" title="XXTEA" align="right" />
</a>

[![Build Status](https://travis-ci.org/xxtea/xxtea-nim.svg?branch=master)](https://travis-ci.org/xxtea/xxtea-nim)

## Introduction

XXTEA is a fast and secure encryption algorithm. This is a XXTEA library for Nim.

It is different from the original XXTEA encryption algorithm. It encrypts and decrypts raw binary data instead of 32bit integer array, and the key is also the raw binary data.

## Installation

```sh
nimble install https://github.com/xxtea/xxtea-nim.git
```

## Usage

```nim
import xxtea

const text = "Hello World! 你好，中国！"
const key = "1234567890"
const encrypt_data = xxtea.encrypt(text, key)
const decrypt_data = xxtea.decrypt(encrypt_data, key)
if text == decrypt_data:
    echo "success!"
else:
    echo "fail!"
```
