#!/usr/bin/evn python
from subprocess import run
import subprocess
import codecs
import argparse


def revert(file):
  blacklist = None
  with open(file,"r") as f:
    blacklist = f.read().split("\n")

  patches = []
  for bl in blacklist:
    if not bl or len(bl)==0:
      continue
    tmp = run(["find","-iname",f"*{bl}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = tmp.stdout
    if len(out) != 0:
      patches.append(codecs.decode(out,"utf-8").strip())

  # eliminate duplicates
  patches = set(patches)

  for patch in patches:
    print(f"Reverting {patch}")
    run(["git","apply","-R",patch])


if  __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("blacklist")
  args = parser.parse_args()
  revert(args.blacklist)
