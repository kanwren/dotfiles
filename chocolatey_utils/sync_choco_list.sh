#!/bin/bash
choco list --local-only --id-only --limit-output > choco_list.txt
cat choco_list.txt
