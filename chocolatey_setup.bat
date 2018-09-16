for /F "tokens=*" %%A in ("choco_list.txt") do choco upgrade -y %%A
