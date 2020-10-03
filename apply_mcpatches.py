#!/usr/bin/evn python
from subprocess import run
import subprocess
import codecs
import argparse
import os
import sys
import json

def get_patches(path):
  result = []
  for patch in os.listdir(path):
    if patch.endswith(".patch"):
      result.append(os.path.join(path, patch))
  return result

def load_config(filepath):
  cfg = dict()
  with codecs.open(filepath, "r", "utf-8") as f:
    cfg = json.loads(f.read())
  return cfg


def patch(config, patches, paper_root):
  for patch in patches:
    _, fn = os.path.split(patch)
    fn, ext = fn.split(".")
    pcfg = None
    if fn in config:
      pcfg = config[fn]
    elif f"{fn}.{ext}" in config:
      pcfg = config[f"{fn}.{ext}"]
    else:
      print(f"{fn} not found")
      continue
    for topatch in pcfg['topatch']:
      # -N -> skip if already applied
      run(["patch", "-N", os.path.join(paper_root, topatch), f"{patch}"])
      print("")

if  __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("patches_dir")
  parser.add_argument("paper_root")
  args = parser.parse_args()

  pd = os.path.abspath(args.patches_dir)  
  patches = get_patches(pd)
  cfg = load_config(os.path.join(pd, "mcpatches.json"))
  patch(cfg, patches, os.path.abspath(args.paper_root))
