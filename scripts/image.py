import numpy, scipy

from scipy import misc
from glob  import glob
from math  import ceil, e, pi, atan
from series_analysis import *

def g2d(x, y, sigma):
    return math.pow(e, -(r*r+c*c)/(2*pi*pi))/(2*pi*sigma*sigma)

def gaussian(sigma=1.4, width=5):
    offset = int(width/2)
    gmatrix = zeros((width, width))
    for r, ri in zip(range(width), xrange(-offset, width-offset)):
        for c, ci in zip(range(width), xrange(-offset, width-offset)):
            gmatrix[r, c] = math.pow(e, -(ri*ri+ci*ci)/(2.0*sigma*sigma))
    total = sum([sum(gmatrix[r, :]) for r in xrange(len(gmatrix))])
    for r in xrange(width):
        for c in xrange(width):
            gmatrix[r, c] = gmatrix[r, c] / total
    return gmatrix

def matrixSum(a, b=None):
    row, col = (len(a), len(a[0]))
    if b is None:
        b = zeros((row, col))
    temp = [[a[r][c]*b[r][c] for c in range(col)] for r in range(row)]
    return sum([sum(temp[r]) for r in range(row)])

def matrixSum(a, b=None):
    row, col = (len(a), len(a[0]))
    if b is None:
        b = zeros((row, col))
    total = 0
    for r in xrange(row):
        for c in xrange(col):
            total += a[r][c]*b[r][c]
    return total

def horizontal_edge(dir, image):
    sigma  = 2.5
    offset = 2
    maxval = 0xffff
    gfilter = gaussian(sigma=sigma, width=5)
    image_list = sorted(glob(dir+"/*_*.dicm"))
    threshold, bg_data = findthreshold(image_list)

    plan = read_file(image)
    row, col = plan.pixel_array.shape
    new_array = numpy.zeros((row, col))
    
    print "Filtering using threshold ..."
    for r in xrange(row):
        for c in xrange(col):
            if plan.pixel_array[r, c] < threshold:
                plan.pixel_array[r, c] = 0
    print "done"

    print "Blurring image ..."
    for r in xrange(offset, row-offset):
        for c in xrange(offset, col-offset):
            new_array[r, c] = matrixSum(gfilter, plan.pixel_array[r-offset:r+offset+1, c-offset:c+offset+1])
    print "done"

    print "Filtering using Sobel ... "
    r22_5  = 22.5 / 180.0 * pi
    r67_5  = 67.5 / 180.0 * pi
    VERTICAL   = 1
    HORIZONTAL = 2
    UP         = 3
    DOWN       = 4
    sum_matrix   = numpy.zeros((row, col))
    angle_matrix = numpy.zeros((row, col)) 
    for r in xrange(1, row-1):
        for c in xrange(1, col-1):
            pixel00 = new_array[r-1, c-1]
            pixel01 = new_array[r-1, c]
            pixel02 = new_array[r-1, c+1]
            
            pixel10 = new_array[r, c-1]
            pixel12 = new_array[r, c+1]
            
            pixel20 = new_array[r+1, c-1]
            pixel21 = new_array[r+1, c]
            pixel22 = new_array[r+1, c+1]

            gy = pixel00 + pixel01*2 + pixel02 - pixel20 - pixel21*2 - pixel22
            gx = pixel00 + pixel10*2 + pixel20 - pixel02 - pixel12*2 - pixel22

            sum_matrix[r, c] = (abs(gx) + abs(gy))
            if (sum_matrix[r, c] > maxval):
                sum_matrix[r, c] = maxval

            if gy == 0 and gx == 0:
                continue
            elif gx == 0:
                if gy > 0:
                    raw_angle = pi/2
                else:
                    raw_angle = -pi/2
            else:
                raw_angle = atan(float(gy) / float(gx))

            if raw_angle <= -r67_5 or raw_angle > r67_5:
                angle_matrix[r, c] = HORIZONTAL
            elif raw_angle > -r67_5 and raw_angle <= -r22_5:
                angle_matrix[r, c] = DOWN
            elif raw_angle > -r22_5 and raw_angle <= r22_5:
                angle_matrix[r, c] = VERTICAL
            elif raw_angle > r22_5 and raw_angle <= r67_5:
                angle_matrix[r, c] = UP            
    print "done"

    # print "Nonmaxima suppression ..."
    # for 
    # print "done"

    misc.imshow(new_array)
    return new_array
