import cv2
#import numpy as np
import struct
import os
from os import listdir
from os.path import isfile, join

bmp_path =  'C:/Users/Toni/Documents/02-UIB/17-18/2-Quatri II/Llenguatges de programacio/Practica/Imagenes/bmp/'
img_path= "C:/Users/Toni/Documents/02-UIB/17-18/2-Quatri II/Llenguatges de programacio/Practica/Imagenes/img/"

data =[]

data_bmp= [f for f in listdir(bmp_path) if isfile(join(bmp_path,f))]

for a in data_bmp:
    bmp_name = os.path.splitext(a)[0]
    print "la imagen a tratar es " + bmp_name
    f_bmp = join(bmp_path,(os.path.basename(a)))
    x = cv2.imread(f_bmp)
    _, _, r = cv2.split(x)
    f_img = join(img_path, bmp_name+'.img')
    with open(f_img, 'wb') as f:
        for c in r:
            for b in c:
                f.write(struct.pack("B",b))


