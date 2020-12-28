import os
import pandas as pd

import geopandas as gpd
import shapely.geometry
from shapely.geometry import shape
# from shapely.geometry import Polygon, shape, point
import fiona


#(entity group)(number of map sheet)(object type).shp
#f_R4444L_s
import time
start_time = time.time()


 
def mergeShapes(selectedFolder): #kombinerar shapefiler (maastotietokanta enligt namn i folder)
    print("Clip was ok")
    selectedFolder=r'C:\Users\rahvo\Downloads\R4444R\clipped'
    outputFolder = r'C:\Users\rahvo\Downloads\R4444R\merged'
    endingList =[] #lista för suffix
    startingList=[] #lista för prefix
    # selectedFolder = r'C:\Users\rahvo\Downloads\R4444R' #vilken folder filerna är i
    slicePrefix = slice(2) #två första bokstäver
    file = os.listdir(selectedFolder) #lista på alla filer i foldern
    for i in file: 
        if "_clip.shp" in i and not "final" in i: #bara shapefilers namn granskas
            # print(i[slicePrefix])
            startingList.append(i[slicePrefix]) 
            # print(i[-6:])
            endingList.append(i[-10:]) #6 sista bokstäverna
    endingList = list(dict.fromkeys(endingList)) # tar bort duplicate
    startingList = list(dict.fromkeys(startingList))
    # print(endingList)
    # print(startingList):

    testlist = []
    namelist = []
    # append = testlist.append
    # append2 = namelist.append
    
    for prefix in startingList:
        for suffix in endingList:
    # for prefix, suffix in zip(startingList,endingList):
            print("Now appending: Prefix = "+prefix +" & Suffix = "+suffix)
            print("--- %s seconds ---" % (time.time() - start_time))
            path = [os.path.join(selectedFolder, i) for i in file if prefix and suffix in i]
            appendThis = [gpd.read_file(i) for i in path]
            # testlist.append(appendThis)
            # namelist.append(prefix +'final_'+suffix)
            gdf = gpd.GeoDataFrame(pd.concat(appendThis, ignore_index=True), crs=gpd.read_file(path[0]).crs)
            gdf.to_file(outputFolder +"\\"+prefix+"final"+ suffix) #filen sparas med namn o location
    print("testlist length is now: "+str(len(testlist)))

    # x=0
    # for files in testlist:
    #     print("Now merging file number: "+str(x+1))
    #     print("--- %s seconds ---" % (time.time() - start_time))
    #     gdf = gpd.GeoDataFrame(pd.concat(testlist[x], ignore_index=True), crs=gpd.read_file(path[0]).crs)
    #     gdf.to_file(outputFolder +"\\"+ namelist[x]) #filen sparas med namn o location
    #     x=x+1
    print("This is the end")
   
    
def clipShapes(): #klipper filer enligt polygon
    selectedFolder = r'C:\Users\rahvo\Downloads\R4444R'
    file = os.listdir(selectedFolder) #lista på alla filer i foldern
    loopcount = 1
    firstTime=True
    for i in file:
        print("Loop number: "+str(loopcount)+ "/" +str(len(file)))
        loopcount = loopcount+1
        print()
        if "Rantsila" not in i and "_clip" not in i and ".shp" in i:
            print("Now cropping file: "+str(i))
            print("--- %s seconds ---" % (time.time() - start_time))
            toBeClipped = gpd.read_file(selectedFolder+'\\'+i)
            if firstTime == True:
                clipPolygon = gpd.read_file(selectedFolder+'\\'+'Rantsila.shp')
                clipPolygon.set_crs(toBeClipped.crs, inplace=True, allow_override=True)
                firstTime = False
            clippedData = gpd.clip(toBeClipped, clipPolygon, True) #fil som ska klippas, enligt vilken polygon den klipps

            i=i[:-4]
            # print(clippedData.isna)    
            if clippedData.empty:
                print('DataFrame is empty!')
                clippedData = ""
            else:
                clippedData.to_file(selectedFolder+'\clipped\\' +i+"_clip.shp")
                clippedData = ""
                print("File clipped!")

 
            
    mergeShapes(selectedFolder)

clipShapes()

