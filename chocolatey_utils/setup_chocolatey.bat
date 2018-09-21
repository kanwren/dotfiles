FOR /F "tokens=*" %%A IN ("choco_list.txt") DO (
 choco upgrade -y %%A
)
