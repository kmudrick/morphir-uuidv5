function stringToBytes(str) {
  str = unescape(encodeURIComponent(str)); // UTF8 escape

  const bytes = [];

  for (let i = 0; i < str.length; ++i) {
    bytes.push(str.charCodeAt(i));
  }

  return bytes;
}

function f(s, x, y, z) {
  switch (s) {
    case 0:
      return (x & y) ^ (~x & z);
    case 1:
      return x ^ y ^ z;
    case 2:
      return (x & y) ^ (x & z) ^ (y & z);
    case 3:
      return x ^ y ^ z;
  }
}

function ROTL(x, n) {
  return (x << n) | (x >>> (32 - n));
}

function sha1(bytes) {
  const K = [0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6];
  const H = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0];

  if (typeof bytes === "string") {
    const msg = unescape(encodeURIComponent(bytes)); // UTF8 escape

    bytes = [];

    for (let i = 0; i < msg.length; ++i) {
      bytes.push(msg.charCodeAt(i));
    }
  } else if (!Array.isArray(bytes)) {
    // Convert Array-like to Array
    bytes = Array.prototype.slice.call(bytes);
  }

  bytes.push(0x80);

  const l = bytes.length / 4 + 2;
  const N = Math.ceil(l / 16);
  const M = new Array(N);

  for (let i = 0; i < N; ++i) {
    const arr = new Uint32Array(16);

    for (let j = 0; j < 16; ++j) {
      arr[j] =
        (bytes[i * 64 + j * 4] << 24) |
        (bytes[i * 64 + j * 4 + 1] << 16) |
        (bytes[i * 64 + j * 4 + 2] << 8) |
        bytes[i * 64 + j * 4 + 3];
    }

    M[i] = arr;
  }

  M[N - 1][14] = ((bytes.length - 1) * 8) / Math.pow(2, 32);
  M[N - 1][14] = Math.floor(M[N - 1][14]);
  M[N - 1][15] = ((bytes.length - 1) * 8) & 0xffffffff;

  for (let i = 0; i < N; ++i) {
    const W = new Uint32Array(80);

    for (let t = 0; t < 16; ++t) {
      W[t] = M[i][t];
    }

    for (let t = 16; t < 80; ++t) {
      W[t] = ROTL(W[t - 3] ^ W[t - 8] ^ W[t - 14] ^ W[t - 16], 1);
    }

    let a = H[0];
    let b = H[1];
    let c = H[2];
    let d = H[3];
    let e = H[4];

    for (let t = 0; t < 80; ++t) {
      const s = Math.floor(t / 20);
      const T = (ROTL(a, 5) + f(s, b, c, d) + e + K[s] + W[t]) >>> 0;
      e = d;
      d = c;
      c = ROTL(b, 30) >>> 0;
      b = a;
      a = T;
    }

    H[0] = (H[0] + a) >>> 0;
    H[1] = (H[1] + b) >>> 0;
    H[2] = (H[2] + c) >>> 0;
    H[3] = (H[3] + d) >>> 0;
    H[4] = (H[4] + e) >>> 0;
  }

  return [
    (H[0] >> 24) & 0xff,
    (H[0] >> 16) & 0xff,
    (H[0] >> 8) & 0xff,
    H[0] & 0xff,
    (H[1] >> 24) & 0xff,
    (H[1] >> 16) & 0xff,
    (H[1] >> 8) & 0xff,
    H[1] & 0xff,
    (H[2] >> 24) & 0xff,
    (H[2] >> 16) & 0xff,
    (H[2] >> 8) & 0xff,
    H[2] & 0xff,
    (H[3] >> 24) & 0xff,
    (H[3] >> 16) & 0xff,
    (H[3] >> 8) & 0xff,
    H[3] & 0xff,
    (H[4] >> 24) & 0xff,
    (H[4] >> 16) & 0xff,
    (H[4] >> 8) & 0xff,
    H[4] & 0xff,
  ];
}

const byteToHex = [];

for (let i = 0; i < 256; ++i) {
  byteToHex.push((i + 0x100).toString(16).slice(1));
}

function unsafeStringify(arr, offset = 0) {
  // Note: Be careful editing this code!  It's been tuned for performance
  // and works in ways you may not expect. See https://github.com/uuidjs/uuid/pull/434
  //
  // Note to future-self: No, you can't remove the `toLowerCase()` call.
  // REF: https://github.com/uuidjs/uuid/pull/677#issuecomment-1757351351
  return (
    byteToHex[arr[offset + 0]] +
    byteToHex[arr[offset + 1]] +
    byteToHex[arr[offset + 2]] +
    byteToHex[arr[offset + 3]] +
    "-" +
    byteToHex[arr[offset + 4]] +
    byteToHex[arr[offset + 5]] +
    "-" +
    byteToHex[arr[offset + 6]] +
    byteToHex[arr[offset + 7]] +
    "-" +
    byteToHex[arr[offset + 8]] +
    byteToHex[arr[offset + 9]] +
    "-" +
    byteToHex[arr[offset + 10]] +
    byteToHex[arr[offset + 11]] +
    byteToHex[arr[offset + 12]] +
    byteToHex[arr[offset + 13]] +
    byteToHex[arr[offset + 14]] +
    byteToHex[arr[offset + 15]]
  ).toLowerCase();
}

let input = "foo";
let inputBytes = stringToBytes(input);
let bytes = new Uint8Array(input.length);
bytes.set(inputBytes);
let hashedBytes = sha1(bytes);
console.dir(hashedBytes);
console.dir(unsafeStringify(hashedBytes));
