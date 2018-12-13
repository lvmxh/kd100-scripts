#!/usr/bin/python3

# REF: https://www.imooc.com/article/48845?block_id=tuijian_wz
import requests
import argparse
import os
import re

PATTERN="^v\d+\.\d+$"
VERSION_RE = re.compile(PATTERN)

# path = "getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking"
path = ""

parser = argparse.ArgumentParser(description='Description of Calico Github info')
parser.add_argument("-v", "--verbose", help="increase output verbosity",
                    action="store_true")
parser.add_argument('-u','--user', help='User for Github',
                    default="projectcalico")
                    # required=True, default="root")
parser.add_argument('-r','--repo', help='Repo of Github',
                    default="calico")
parser.add_argument('-cv','--calico_version', help='Version of Calico, can be master or V3.4',
                    default="master")
parser.add_argument('-p','--path', help='Path that files want to be search in',
                    default=path)

args = parser.parse_args()

headers = {"Content-Type": "application/json", "Accept": "application/vnd.github.v3.raw"}
github ="https://api.github.com/repos"
api = "contents"
# REF: https://www.jianshu.com/p/a0c7d0482415
url = os.path.join(github, args.user, args.repo, api, args.path)

res = requests.get(url, headers=headers)
if not res.ok:
    exit(1)

versions_obj = dict([(v["name"], i) for i, v in enumerate(res.json())
                if re.search(VERSION_RE, v["name"])])

versions = [v["name"] for v in res.json() if re.search(VERSION_RE, v["name"])]
versions.sort()
print(versions[-1])
exit(0)
