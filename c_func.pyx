import numpy as np
from libc.stdlib cimport rand
cimport numpy as np
cimport cython

@cython.boundscheck(False) # turn off bounds-checking for entire function
@cython.wraparound(False)
def func1(int[:,:,:] frame, int N):
    cdef int height = frame.shape[0]
    cdef int width = frame.shape[1]
    cdef int channel = frame.shape[2]
    cdef int x_shift, y_shift, x, y
    cdef int [:,:,:,:] samples = np.zeros((height, width, N, channel), np.int32)
    cdef num
    num = 0
    cdef int i, j
    for i in range(height):
        for j in range(width):
            print(num)
            for k in range(N):
                x_shift = rand() % 3 - 1
                y_shift = rand() % 3 - 1
                y = i + y_shift
                x = j + x_shift
                #deal with bound
                if x < 0:
                    x = 0
                if x > width - 1:
                    x = width - 1
                if y < 0:
                    y = 0
                if y > height - 1:
                    y = height - 1
                samples[i][j][k][:] = frame[y, x, :]
            num += 1
    return samples

@cython.boundscheck(False) # turn off bounds-checking for entire function
@cython.wraparound(False)
def func2(int [:,:,:] frame, int [:,:,:,:] samples, int min_count, int N, int Radius, int Phi):
    cdef int height = frame.shape[0]
    cdef int width = frame.shape[1]
    cdef int[:,:] mask = np.zeros((height, width), np.int32)
    cdef int num
    cdef int count, index, rand_1, rand2, rand_index, rand_index2, x_shift, y_shift, x, y
    num = 0
    cdef int i, j
    for i in range(height):
        for j in range(width):
            
            count = 0
            index = 0
            while(count < min_count and index < N):
                disdance = color_space_disdance(frame[i][j], samples[i][j][index])
                if disdance < Radius:
                    count += 1
                index += 1
            if (count >= min_count):
                rand_1 = rand() % Phi
                if rand_1 == 0:
                    rand_index = rand() % N
                    samples[i][j][rand_index] = frame[i][j]
                rand2 = rand() % Phi
                if rand2 == 0:
                    rand_index2 = rand() % N
                    x_shift = rand() % 3 - 1
                    y_shift = rand() % 3 - 1
                    y = i + y_shift
                    x = j + x_shift
                    if x < 0:
                        x = 0
                    if x > width - 1:
                        x = width - 1
                    if y < 0:
                        y = 0
                    if y > height - 1:
                        y = height - 1
                    samples[y][x][rand_index2] = frame[i][j]
            else:
                mask[i][j] = 255
            num += 1
    return mask, samples 

cdef double color_space_disdance(int [:] i, int[:] j):
    if len(i) == 3:
        return ((i[0] - j[0]) ** 2 + (i[1] - j[1]) ** 2 + (i[2] - j[2]) ** 2) ** 0.5
    elif len(i) == 1:
        return abs(i[0] - j[0])
    else:
        raise ValueError("color space error")
