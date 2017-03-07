import bpy
import os
import math
import sys
import csv

base_path = "/Users/philippegirard/git/FloatingTrain/matlab/SB-1/"
aller_path = base_path + "aller.csv"
retour_path = base_path + "retour.csv"

FPS = 24

            
def delete_mesh():
    for item in bpy.data.objects:
        if item.type == "MESH":
            item.select = True
            bpy.ops.object.delete() 
             
# get the train object 
#if "train" in bpy.data.objects:
#   train = bpy.data.objects["train"]
#else:
    # creation de la balle
delete_mesh()
bpy.ops.mesh.primitive_uv_sphere_add()
train = bpy.data.objects["Sphere"]
train.name = "train"
    
def parse_data(path):
    data = []
    with open(path, 'r') as csvfile:
        ofile = csv.reader(csvfile, delimiter=',')
        for row in ofile:
            data.append(row)
    return data

def animate(obj, data, vitesse, f):
    i = f
    for r in data:
        obj.location.x = float(r[0]) 
        obj.location.y = float(r[1])
        # print(r[0] + " " + r[1])
        obj.keyframe_insert(data_path = 'location', frame = vitesse * i * FPS)
        i +=1
    return i
        
    
aller_data = parse_data(aller_path)
retour_data = parse_data(retour_path)
f = animate(train, aller_data, 0.007, 0)
animate(train, retour_data, 0.007, f)