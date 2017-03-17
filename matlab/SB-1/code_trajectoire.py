import bpy
import os
import math
import sys
import csv

base_path = "G:\\Programming\\Repositories\\University\\FloatingTrain\\matlab\\SB-1\\"
aller_path = base_path + "aller.csv"
retour_path = base_path + "retour.csv"

initial_x = -23
initial_y = -10
initial_z = -1.0
             
# get the train object 
train = bpy.data.objects["train"]

    
def parse_data(path):
    data = []
    with open(path, 'r') as csvfile:
        ofile = csv.reader(csvfile, delimiter=',')
        for row in ofile:
            data.append(row)
    return data

def animate(obj, data, f, r_i):
    i = f
    for r in data:
        obj.location.x = float(r[0])*2 + initial_x 
        obj.location.y = float(r[1])*2 + initial_y
        obj.location.z = float(initial_z)
        obj.rotation_euler.z = r_i*-1
        
        # print(r[0] + " " + r[1])
        obj.keyframe_insert(data_path = 'location', frame = i)
        obj.keyframe_insert(data_path = 'rotation_euler', frame = i) 
        i +=1
    return i
        
    
aller_data = parse_data(aller_path)
retour_data = parse_data(retour_path)
f = animate(train, aller_data, 0, 0)
animate(train, retour_data, f, math.pi)