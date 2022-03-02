#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 21 11:10:10 2019

@author: gunnvantsaini
"""

import os 
import glob
import shutil
import random

### Doing basic os tasks
# creating folders, checking if some path is a file/folder
# checking file extensions
# moving files

os.path.isdir("/Users/gunnvantsaini/Data/Work/ML Course/Module 5 Neural Networks/Data/waffle_pancakes/test/pancakes")
os.path.isfile("/Users/gunnvantsaini/Data/Work/ML Course/Module 5 Neural Networks/Data/waffle_pancakes/test/pancakes")

os.listdir("/Users/gunnvantsaini/Documents/Work/Jigsaw Academy/Corporate Trainings")

os.listdir("/Users/gunnvantsaini/Documents/Work/Jigsaw Academy/Lending Club")

## What if I wanted to get file names of a particular extension eg .csv
os.chdir("/Users/gunnvantsaini/Documents/Work/Jigsaw Academy/Lending Club")
glob.glob("*.csv")

## Write a function to populate a list of files that are images (having an extension .jpg, .jpeg, .png, ,tiff, .bmp)

## Sometimes we may need to sample from file names
random.sample(["abc.jpg","def.jpg","ghi.jpg"],2)
random.sample(["abc.jpg","def.jpg","ghi.jpg"],2.2)


## Write a function to generate 70% random image names from a list of image names

## We may also need to get the balance set of images

file_names=["abc.jpg","def.jpg","ijk.jpg","lmn.jpg","opq.jpg"]
train_names=["abc.jpg","def.jpg"]
[x for x in file_names if x not in train_names ]
for x in file_names:
    if x not in train_names:
        print(x)

## Now modify the function that you wrote above to return both train and test set
        
## We will also need the ability to create folers and move files        
        
os.mkdir("/Volumes/MAXTOR/Image_Datasets/new_folder")

# a better approch is to check if a folder exists, if not only the create it

if not os.path.isdir("/Volumes/MAXTOR/Image_Datasets/new_folder"):
    os.mkdir("/Volumes/MAXTOR/Image_Datasets/new_folder")
# to move a file we will need to know its source location and destination location

source="/Volumes/MAXTOR/Image_Datasets/flowers/daisy/5547758_eea9edfd54_n.jpg"
dest="/Volumes/MAXTOR/Image_Datasets/new_folder/5547758_eea9edfd54_n.jpg"    
shutil.copyfile(source,dest)    

### write a program that takes source path of a folder and destination path of a new folder as input, divides the image files in the source file in train_test split of 70% and copies these files in new train, test subfolders in the new destination folder.

## Improving path string creation
# we can improve the creation of path strings using os.path.join

source="/Volumes/MAXTOR/Image_Datasets/flowers/daisy"
file_name="5547758_eea9edfd54_n.jpg"
os.path.join(source,file_name)

## Now improove the function that you created above by removing the hardcoded logic for file path generation