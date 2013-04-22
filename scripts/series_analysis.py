#!/usr/bin/python
from glob  import glob
from pylab import plot, show, grid, normpdf
from numpy import arange, std, zeros
from scipy import ndimage, misc
from math  import ceil, e, pi
from dicom import read_file

import os, sys, shutil, pylab
import Image
import numpy as np

def smooth(data, mask):
    result = [0 for i in range(len(data))]
    for i in range(len(mask)/2, len(result)-len(mask)/2):
        a = [mask[j]   for j in range(len(mask))]
        b = [data[i+j] for j in range(-(len(mask)/2), -(len(mask)/2)+len(mask))]
        result[i] = sum([j*k for (j, k) in zip(a, b)])
    return result
    
def deriv1(data):
    result = [abs(data[i+1]-data[i]) for i in range(len(data)-1)]
    result.append(0)
    return result

def deriv2(data):
    result = [0 for i in range(len(data))]
    for i in range(1, len(result)-1):
        result[i] = abs(data[i-1] + data[i+1] - 2*data[i])
    return result

def analysis(series_dir):
    files = glob(series_dir + "/*.dicm")
    files.sort()
    series_intensity = [imageIntensity(name) for name in files]
    y = normpdf(series_intensity, min(series_intensity), max(series_intensity))
    plot([i for i in range(len(series_intensity))], series_intensity, 'b')
    plot([i for i in range(len(series_intensity))], deriv2(series_intensity), 'r')
    grid(True)
    show()
    return series_intensity
    
def imageIntensity(filename):
    print filename
    plan = read_file(filename)
    return sum([sum(row) for row in plan.pixel_array])

def findthreshold(image_list):
    if image_list == []:
        print "list is empty"
    sample = read_file(image_list[0], force=True)
    row, col = [sample.Rows, sample.Columns]
    bg_data = [max(read_file(image, force=True).pixel_array[30, col/2-20:col/2+20])
               for image in image_list[:-1]]
    mean = sum(bg_data)/float(len(bg_data))
    dev  = std(bg_data)
    print "background mean = {mean}, std = {std}".format(mean=mean, std=dev)
    return (ceil(max(bg_data)), bg_data)

def boundaries(dir, plotdata=True):
    x = 50
    image_list = glob(dir+"/*_*.dicm")
    image_list.sort()
    threshold, bg_data = findthreshold(image_list)
    print "threshold ",threshold
    data = []
    points = []
    status = True
    for image, i in zip(image_list, [i for i in range(len(image_list))]):
        print image
        plan = read_file(image, force=True)
        [row, col] = [plan.Rows, plan.Columns]
        value = sum(plan.pixel_array[row/2, (col/2-x):(col/2+x)])/float(x*2)
        if (value > threshold) == status:
            if status:
                points.append(i)
            else:
                points.append(i-1)
            status = not status
            
        data.append(value)
    print points
    if plotdata:
        x_axis = [i for i in range(len(data))]
        y = [threshold for i in range(len(data))]
        height = max(data)
        plot(x_axis, data)
        plot(x_axis[:-1], bg_data)
        plot(x_axis, y)
        # plot(x_axis, deriv1(data), 'r')
        # plot(x_axis, deriv2(data), 'g')
        for p in points:
            plot([p, p], [0, height])
        show()

def showImage(imagename):
    img = read_file(imagename, force=True)
    # row, col = [sample.Rows, sample.Columns]
    pylab.imshow(img.pixel_array, cmap=pylab.cm.bone)
    pylab.show()
    

def removeNoise(name):
    dicom_im = read_file(name, force=True)
    rescaled = (255.0 / dicom_im.pixel_array.max() * (dicom_im.pixel_array - dicom_im.pixel_array.min())).astype(np.uint8)
    png = Image.fromarray(rescaled)
    png.save("outputimg.png")
