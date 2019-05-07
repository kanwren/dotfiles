#!/bin/bash
choco list --local-only --id-only --limit-output > choco_list.txt
git diff choco_list.txt
