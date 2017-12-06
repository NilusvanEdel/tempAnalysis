import csv
import glob
import os

path = "/home/nilus/PycharmProjects/tempAnalysis/"
csvFile = "/home/nilus/PycharmProjects/tempAnalysis/online_accept_data_utf16.xls"
fullCSV = []
counter = 0
with open(csvFile, encoding='utf16') as csvfile:
    reader = csv.reader(csvfile, delimiter = '\t')
    for row in reader:
        if counter == 0:
            firstRow = row
            counter += 1
        else:
            fullCSV.append(row)
# remove empty rows
for row in fullCSV:
    if not any(row):
        fullCSV.remove(row)
        #print("row removed")
# remove empty columns
# transpose the matrix so index of firstRow equals row of matrix
fullCSV = list(map(list, zip(*fullCSV)))
for column in fullCSV:
    if not any(column):
        del (firstRow[fullCSV.index(column)])
        fullCSV.remove(column)
        #print("column removed")

# remove 'completed'
fullCSV.pop(0)
del (firstRow[0])
# remove 'session nr, Session_Name, Session_Start_Time, Session_End_Time, Block_Nr, Block_Name, Task_Nr
for i in range(7):
    fullCSV.pop(2)
    del (firstRow[2])
# remove something
for i in range(2):
    fullCSV.pop(3)
    del firstRow[3]

# add several rows into one (first_vid etc.)
import collections
duplicates =  [item for item, count in collections.Counter(firstRow).items() if count > 1]
print(duplicates)
for item in duplicates:
    index = [i for i, x in enumerate(firstRow) if x == item]
    print(index)
    counter = 0
    for i in index:
        if i == index[0]: continue
        fullCSV[index[0]] = [a + b for a, b in zip(fullCSV[index[0]], fullCSV[i-counter])]
        del (firstRow[i - counter])
        fullCSV.pop(i - counter)
        counter += 1

#remove Agent_Spec and Crowdsourcing_Code
for i in range(2):
    del (firstRow[-1])
    fullCSV.pop(-1)
# remove own SUBJECT id
del (firstRow[6])
fullCSV.pop(6)

# transpose the matrix again
fullCSV = list(map(list, zip(*fullCSV)))


#_________________________________________________________________________________________________
#_________________________________________________________________________________________________
# remove IDs who failed sanity Check
oldID = -1
failedSanCheck = []
counter = 0
for row in fullCSV:
    if row[0] != oldID:
        oldID = row[0]
        ind = fullCSV.index(row)
        # remove the first two rows (disclaimer and instructions)
        for i in range(2): fullCSV.pop(ind)
        row = fullCSV[ind]
        if row[6] == ('swerve' or 'NaN'):
            fullCSV.remove(row)
        else:
            failedSanCheck.append(oldID)
            ind = fullCSV.index(row)
            while oldID == fullCSV[ind][0]:
                fullCSV.pop(ind)
#_______________________________________________________________________________________________
#_______________________________________________________________________________________________

with open(path+'shortenedOnlineCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    wr.writerow(firstRow)
    for i in range(len(fullCSV)):
        wr.writerow(fullCSV[i])