from PIL import Image
import numpy as np
import argparse

parser = argparse.ArgumentParser(description = "herhangi bir gorseli 300x300 boyutunda gri tonlamali gosterimindeki veriye cevirir")

parser.add_argument('gorsel', help="cevrilecek dosya")

args = parser.parse_args()

im = Image.open(args.gorsel).convert('L')
im = im.resize((300, 300))
p = np.array(im)

output = ''

for row in p:
    for i in range(0,len(row),4):
        output += format(row[i+3], '02x') + format(row[i+2], '02x') \
                + format(row[i+1], '02x') + format(row[i], '02x') 
        output += '\n'

f = open('cevrilmis.txt', 'w')
f.write(output)