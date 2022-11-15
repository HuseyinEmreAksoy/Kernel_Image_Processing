from PIL import Image
import numpy as np
import argparse

parser = argparse.ArgumentParser(description = "on altilik tabanda veri ile gosterilen 8-bit gri tonlamali gorseli jpg formatina cevirir")

parser.add_argument('dosya', help="jpg formatina cevrilecek on altilik tabanda sayilari iceren dosya")

args = parser.parse_args()

f = open(args.dosya, 'r')
lines = f.readlines()

colCtr = 0

rows = []
col = []

for line in lines:
    line = line[0:8]

    b4 = int(line[0:2],base = 16)
    b3 = int(line[2:4],base = 16)
    b2 = int(line[4:6],base = 16)
    b1 = int(line[6:8],base = 16)

    colCtr += 4

    col.append(b1)
    col.append(b2)
    col.append(b3)
    col.append(b4)

    if colCtr == 300:
        colCtr = 0
        rows.append(col)
        col = []

arr = np.array(rows, dtype=np.uint8)

im = Image.fromarray(arr)

im.save("geri-cevrilmis.jpeg")