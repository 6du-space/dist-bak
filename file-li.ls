require! <[
  path
  zlib
]>

require! {
  \sodium-6du : sodium
  \fs-extra : fs
}

{promisify} = require \util

compress = promisify(
  zlib.brotliCompress
  {
    params:{
      "#{zlib.constants.BROTLI_PARAM_QUALITY}":zlib.constants.BROTLI_MAX_QUALITY
    }
  }
)

strcmp = (a,b)!~>
  if a > b
    return -1
  else
    return 1

_pack = (file-hash-li)!~>
  file-hash-li.sort strcmp

  n = Buffer.allocUnsafe(6)
  n.writeUIntLE(file-hash-li.length,0,6)

  hash-li = []
  file-li = []

  for [f,h] in file-hash-li
    file-li.push f
    hash-li.push h

  return await compress Buffer.concat([
    n
    Buffer.from(file-li.join("\n"))
    Buffer.concat(hash-li)
  ])

module.exports = {
  pack:(sk, file-hash-li-li)~>
    t = []
    hash-li = []
    for i in file-hash-li-li
      b = await _pack(i)
      hash = sodium.hash(b)
      hash-li.push hash
      t.push [hash, b]
    hash-li.sort strcmp
    hash-li = Buffer.concat hash-li
    return [
      await compress Buffer.concat([
        sodium.hash-sign(sk, hash-li)
        hash-li
      ])
      t
    ]
}
