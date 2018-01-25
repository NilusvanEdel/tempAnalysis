import csv
import glob
import os

file = "/home/nilus/PycharmProjects/tempAnalysis/vr_data/combinedCSV.csv"


def findItem(theList, item):
    return [ind for ind in range(len(theList)) if item in theList[ind]][0]


# get each file in path with ending csv
counter = 0
oldID = ""
with open(file) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    counterMale = 0
    counterFemale = 0
    for row in reader:
        if oldID != row[0]:
            oldID = row[0]
            counter += 1
            if row[1] == 'True':
                counterMale += 1
            else:
                counterFemale += 1
print(counter)
print(counterMale)
print(counterFemale)
            