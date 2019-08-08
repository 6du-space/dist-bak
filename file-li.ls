require! <[
  path
  zlib
]>

require! {
  \sodium-6du : sodium
  \config-6du/6du : config
  \fs-extra : fs
}

{promisify} = require \util


module.exports = {
  pack:(sk, file-hash-li)~>
    file-hash-li.sort (a,b)!~>
      if a > b
        return -1
      else
        return 1
    n = Buffer.allocUnsafe(6)
    n.writeUIntLE(file-hash-li.length,0,6)

    hash-li = []
    file-li = []

    for [f,h] in file-hash-li
      file-li.push f
      hash-li.push h

    b = Buffer.concat([
      n
      Buffer.from(file-li.join("\n"))
      Buffer.concat(hash-li)
    ])
    b = Buffer.concat([
      sodium.sign(sk, sodium.hash(b))
      b
    ])
    compress = promisify(
      zlib.brotliCompress
      {
        params:{
          "#{zlib.constants.BROTLI_PARAM_QUALITY}":zlib.constants.BROTLI_MAX_QUALITY
          "#{zlib.constants.BROTLI_PARAM_SIZE_HINT}":b.length
        }
      }
    )
    return compress(b)
}
