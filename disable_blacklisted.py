#!/usr/bin/evn python
from subprocess import run
import subprocess
import codecs
import argparse
import os
import sys


def disable(file):
  blacklist = None
  with open(file,"r") as f:
    blacklist = f.read().split("\n")

  patches = []
  for bl in blacklist:
    if not bl or len(bl)==0:
      continue
    print(f"Finding patch {bl}...")
    tmp = run(["find","-iname",f"*{bl}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = tmp.stdout
    if len(out) != 0:
      patches.append(codecs.decode(out,"utf-8").strip())
      continue
    tmp = run(["find","-iname",f"*{bl}.disabled"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out = tmp.stdout
    if len(out) != 0:
      # patch already disabled, continue
      print(f"{bl} already disabled")
      continue
    print(f"Blacklisted patch {bl} not found")
    sys.exit(1)


  # eliminate duplicates
  patches = set(patches)
  for patch in patches:
    print(f"Disabling {patch}")
    patch = os.path.abspath(patch)
    disabled = f"{patch}.disabled"
    run(["mv",patch,disabled])


if  __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("blacklist")
  args = parser.parse_args()
  disable(args.blacklist)
