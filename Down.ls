require! <[
  path
]>
require! {
  \fs-extra : fs
}
mtd = require \zeltice-mt-downloader

class Down
  (@root)->
  get : (url, outpath)~>
    new Promise(
      (resolve, reject)~>
        downloader = new mtd(
          outpath
          url
          {
            timeout: 6
            onStart:(meta)!~>
            onEnd:(err,result)!~>
              if err
                reject(err)
                return
              resolve(result)
          }
        )
        downloader.start()

    )

  get_and_verify : (url, hasher, bin)!~>
    filename = path.basename(url)
    filename = filename.slice(0, filename.indexOf("#"))
    outpath = path.join @root,filename
    verify = ~>
      if not bin.compare(await hasher(outpath))
        return true
      await fs.unlink(outpath)

    if await fs.exists(outpath)
      if await verify()
        return filename

    count = 0
    while count < 3
      ++count
      await @get(url, outpath)
      if await verify()
        return filename
      console.log "下载出错，第#{count}次尝试重下 #{url}"
    throw new Error()

module.exports = Down
