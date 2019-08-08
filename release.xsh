#!/usr/bin/env xonsh
$XONSH_SHOW_TRACEBACK = True

from os.path import abspath,dirname,join, exists
from json import loads,dumps
PWD = dirname(abspath(__file__))
ROOT = dirname(PWD)

# def update_version():
#   package_json = join(ROOT, "sh/package.json")
#   with open(package_json) as package:
#     package = loads(package.read()) 
#     version = package['version'].split('.')
#     version[-1] = str(int(version[-1])+1)
#     package['version'] = version = '.'.join(version)
#     with open(package_json, "w") as out:
#       out.write(dumps(package,indent=2))
#     return version


# version = update_version()
cd @(ROOT)/v
git pull

cd @(ROOT)/sh
yarn

cd @(PWD)
./yarn-lock.ls

cd @(ROOT)/v
git add .
git commit -m-
git push origin master
# version = "v%s"%version
# git add -u
# git commit -m @(version)
# git tag @(version)
# git push origin @(version)
# tmp = $(mktemp -d).strip("\n")
# git archive master | tar -x -C @(tmp)

# print(f"导出到 {tmp}")
# cd @(tmp)
# yarn

#cd @(PWD)
# if not exists(join(PWD, 'node_modules')):
#   yarn
# ./cloudflare-6du.ls

