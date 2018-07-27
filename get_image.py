import os
import cv2
def get_image(path):
    for root, dirs, files in os.walk(path):
            for filename in files:
                frame_copy = cv2.imread(os.path.join(root, filename))
                yield frame_copy
    return
                
