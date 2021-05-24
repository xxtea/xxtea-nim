import base64

const DELTA = 0x9e3779b9'u32

proc mx(sum: uint32, y: uint32, z: uint32, p: int, e: int, k: openArray[uint32]): uint32 =
    result = (z shr 5 xor y shl 2) + (y shr 3 xor z shl 4) xor (sum xor y) + (k[p and 3 xor e] xor z)

proc encrypt(v: var seq[uint32], k: seq[uint32]): seq[uint32] =
    if v.len < 2: return v
    var n = v.len - 1
    var z = v[n]
    var sum = 0'u32
    var y: uint32
    var q = 6 + 52 div v.len
    var e: int
    while 0 < q:
        dec(q)
        sum = sum + DELTA
        e = (sum shr 2 and 3).int
        for p in countup(0, n - 1):
            y = v[p + 1]
            v[p] = v[p] + mx(sum, y, z, p, e, k)
            z = v[p]
        y = v[0]
        v[n] = v[n] + mx(sum, y, z, n, e, k)
        z = v[n]
    return v

proc decrypt(v: var seq[uint32], k: seq[uint32]): seq[uint32] =
    if v.len < 2: return v
    var n = v.len - 1
    var z: uint32
    var y = v[0]
    var sum = uint32(6 + 52 div v.len) * DELTA;
    var e: int
    while sum != 0:
        e = (sum shr 2 and 3).int
        for p in countdown(n, 1):
            z = v[p - 1]
            v[p] = v[p] - mx(sum, y, z, p, e, k)
            y = v[p]
        z = v[n]
        v[0] = v[0] - mx(sum, y, z, 0, e, k)
        y = v[0]
        sum = sum - DELTA
    return v

proc fixkey(key: string): string =
    if key.len == 16: return key
    if key.len > 16: return key[0..15]
    result = newString(16)
    result[0 .. key.len - 1] = key

proc toUint32Seq(data: string, includeLength: bool): seq[uint32] =
    var len = data.len
    var n = len shr 2
    if (len and 3) != 0: inc(n)
    if includeLength:
        newSeq(result, n + 1)
        result[n] = uint32(len)
    else:
        newSeq(result, n)
    for i, value in data:
        result[i shr 2] = result[i shr 2] or uint32(ord(value) shl ((i and 3) shl 3))

proc toString(data: seq[uint32], includeLength: bool): string =
    var n = data.len shl 2
    if includeLength:
        var m = int(data[^1])
        n -= 4
        if (m < n - 3) or (m > n): return ""
        n = m
    result = newString(n)
    for i in countup(0, n - 1):
        result[i] = chr(int((data[i shr 2] shr uint32((i and 3) shl 3)) and 0xff))

proc encrypt*(data, key: string): string =
    ## encrypt data with key.
    ## return binary string encrypted data or empty string on failure.
    if data.len == 0: return ""
    var v = toUint32Seq(data, true)
    var k = toUint32Seq(fixkey(key), false)
    return toString(encrypt(v, k), false)

proc decrypt*(data, key: string): string =
    ## decrypt binary string encrypted data with key.
    ## return decrypted string or empty string on failure
    if data.len == 0: return ""
    var v = toUint32Seq(data, false)
    var k = toUint32Seq(fixkey(key), false)
    return toString(decrypt(v, k), true)

proc encryptToBase64*(data, key: string): string =
    ## encrypt data with key.
    ## return base64 string encrypted data or nil on failure.
    return base64.encode(encrypt(data, key))

proc decryptFromBase64*(data, key: string): string =
    ## decrypt base64 string encrypted data with key.
    ## return decrypted string or nil on failure
    return decrypt(base64.decode(data), key)

when defined(test):
    import unittest
    suite "xxtea":
        echo "xxtea:"
        test "encrypt":
            const text = "Hello World! 你好，中国🇨🇳！"
            const key = "1234567890"
            const encrypt_data = encryptToBase64(text, key)
            check encrypt_data == "D4t0rVXUDl3bnWdERhqJmFIanfn/6zAxAY9jD6n9MSMQNoD8TOS4rHHcGuE="
        test "decrypt":
            const text = "D4t0rVXUDl3bnWdERhqJmFIanfn/6zAxAY9jD6n9MSMQNoD8TOS4rHHcGuE="
            const key = "1234567890"
            const decrypt_data = decryptFromBase64(text, key)
            check decrypt_data == "Hello World! 你好，中国🇨🇳！"
