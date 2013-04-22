#!/usr/bin/python

import os, sys, shutil
import dicom, argparse
from collections import defaultdict
from glob import glob

series_count = defaultdict(lambda : 1)
links = defaultdict(lambda : None)

def storeimage(imagename, dest):
    plan = dicom.read_file(imagename, force=True)
    parent_dir = os.path.join(dest,
                              str(plan.StudyDescription),
                              str(plan.StudyDate),
                              str(plan.SeriesDescription),
                              str(plan.SeriesNumber))
    if not os.path.exists(parent_dir):
        os.makedirs(parent_dir)
    try:
        if not links[parent_dir]:
            shortcut = os.path.join(dest, str(plan.SeriesNumber))
            os.symlink(parent_dir, shortcut)
            links[parent_dir] = shortcut
    except OSError as error:
        while True:
            series_count[shortcut] += 1
            new_shortcut = shortcut + "_" + str(series_count[shortcut])
            if not os.path.exists(new_shortcut):
                break
        os.symlink(parent_dir, new_shortcut)
        links[parent_dir] = new_shortcut
                
    newname = os.path.join(parent_dir,
                           str(plan.SeriesDate) + '_'
                           + str(plan.InstanceNumber).zfill(3) + '.dicm')
    print newname
    plan.save_as(newname)
    
def fetchdir(source, dest):
    for (parent, dirs, files) in os.walk(source):
        for fname in files:
            if fname[0] == '.':
                continue
            imagename = parent + '/' + fname
            storeimage(imagename, dest)
    return links.values()
def fetchfiles(files, dest):
    imagelist = glob(files)
    for imagename in imagelist:
        storeimage(imagename, dest)
    return links.values()        

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fetch raw dicom files")
    parser.add_argument("--source", help="Source dir of raw dicom files")
    parser.add_argument("--files",  help="File name pattern of dicom files")
    parser.add_argument("--dest",   default="./", help="Desired directory to store dicom files. NOTE: Raw dicom files should not be in any sub directories.")
    args = parser.parse_args()
    if not os.path.exists(args.dest):
        os.mkdir(args.dest)
    print "dest   : ", args.dest
    print "source : ", args.source
    print "files  : ", args.files
    dir_links = None
    if args.source:
        dir_links = fetchdir(args.source, args.dest)
    elif args.files:
        dir_links = fetchfiles(args.files, args.dest)
    print dir_links

