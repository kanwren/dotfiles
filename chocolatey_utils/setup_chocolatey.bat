@echo off
for /F "usebackq tokens=*" %%A in ("choco_list.txt") do (
    choco install -y %%A
)
