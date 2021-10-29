#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 21 14:24:06 2019

@author: gunnvantsaini
"""

'''Creating classes'''
## pytorch relies on some oops concepts such as creating custom classes, overloading methods in the classes, inheriting from a super class etc

## Classes: custom data-type
class Reliance():
    def __init__(self,businesses,profits):
        self.businesses=businesses
        self.profits=profits
    def display(self):
        print("The busineeses are {}".format(self.businesses))
        print("The profits are {}".format(self.profits))
c=Reliance(businesses=["Telecom","Infrastructure","Refinery","Defence"],
           profits=[100,200,12,1])        
c.display()
print(dir(c))
d=Reliance(businesses=["Telecom","Infrastructure","Refinery","Defence"],
           profits=[100,200,12,1])  
len(c)

## We can extend claases to have custom functionality by over-riding/defining some default methods
class Reliance():
    def __init__(self,businesses,profits):
        self.businesses=businesses
        self.profits=profits
    def __len__(self):
        return len(self.businesses)
    def display(self):
        print("The busineeses are {}".format(self.businesses))
        print("The profits are {}".format(self.profits))
c=Reliance(businesses=["Telecom","Infrastructure","Refinery","Defence"],
           profits=[100,200,12,1])
len(c)
c.businesses[0]
c['businesses']

## We can impliment indexation by overiding/implimention __getitem__ 
class Reliance():
    def __init__(self,businesses,profits):
        self.businesses=businesses
        self.profits=profits
    def __len__(self):
        return len(self.businesses)
    def __getitem__(self,key):
        return self.__getattribute__(key)
    def display(self):
        print("The busineeses are {}".format(self.businesses))
        print("The profits are {}".format(self.profits))
c=Reliance(businesses=["Telecom","Infrastructure","Refinery","Defence"],
           profits=[100,200,12,1])
c['businesses']   

## Create numeric indexation
class Reliance():
    def __init__(self,businesses,profits):
        self.businesses=businesses
        self.profits=profits
    def __len__(self):
        return len(self.businesses)
    def __getitem__(self,idx):
        key_names=list(self.__dict__.keys())
        return self.__getattribute__(key_names[idx])
    def display(self):
        print("The busineeses are {}".format(self.businesses))
        print("The profits are {}".format(self.profits))
c=Reliance(businesses=["Telecom","Infrastructure","Refinery","Defence"],
           profits=[100,200,12,1]) 
c[0]
c[1] 

## Try to overide the __eq__ method so that same python objects can be compared. Hint, try to use this template:
'''
def __eq__(self,other):
    other.attr1==self.attr1 and other.attr2==self.attr2 ....
'''
## Inheriting classes

class Company():
    def __init__(self):
        self.parent="Reliance"
        self.listed="BSE"
        self.headquarters="Mumbai"


class jio():
    def __init__(self):
        self.industry="Telecom"
    def __getitem__(self,idx):
        key_names=list(self.__dict__.keys())
        return self.__getattribute__(key_names[idx])
d=jio()
d[0]

class jio(Company):
    def __init__(self):
        self.industry="Telecom"
    def __getitem__(self,idx):
        key_names=list(self.__dict__.keys())
        return self.__getattribute__(key_names[idx])
    
a=jio()      

## Change Company class and include a method, 

class Company():
    def __init__(self):
        self.parent="Reliance"
        self.listed="BSE"
        self.headquarters="Mumbai"
    def display(self):
        print("The parent group is {}, located in {} headquatered at {}".format(self.parent,self.listed,self.headquarters))
        
## Now again lets inherit the class Company and see what we get
class jio(Company):
    def __init__(self):
        self.industry="Telecom"
    def __getitem__(self,idx):
        key_names=list(self.__dict__.keys())
        return self.__getattribute__(key_names[idx])        
j=jio()  
j.display()

## How do we also get access to the init method of parent class?
class jio(Company):
    def __init__(self):
        super(jio,self).__init__()
        self.industry="Telecom"
    def __getitem__(self,idx):
        key_names=list(self.__dict__.keys())
        return self.__getattribute__(key_names[idx]) 
j=jio()    

## Create a class that impliments methods to
# reads a csv file
# print out the number of rows and columns of the csv file
# print out column names
# number of missing values

# Hint: Use pandas module to do any parsing of csv filex