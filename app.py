import cv2
import numpy as np
from get_image import get_image
from Vibe import Vibe
from time import time
from PIL import Image
path = "../data_anno/Mini61/img"
cap = get_image(path)

vibe = Vibe()
frame = next(cap)
begin = time()
frame = frame.astype(np.int32)
vibe.init(frame)
end = time()
print(end - begin)

for frame in cap:
    frame = frame.astype(np.int32)
    mask = vibe.test_and_update(frame)
    print(mask)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(3, 3))
    closed = cv2.morphologyEx(mask.astype(np.uint8), cv2.MORPH_CLOSE, kernel) 
    cv2.imshow('mask', mask.astype(np.uint8))
    cv2.imshow("closed", closed)
    # Image.fromarray(mask.astype(np.uint8)).show()
    cv2.waitKey(100)



