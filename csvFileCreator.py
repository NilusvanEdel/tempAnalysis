import csv
import glob
import os

### where the dataFiles are stored
path = '/home/nilus/PycharmProjects/tempAnalysis/Data'
### where the created Files will be stored
folder = '/home/nilus/PycharmProjects/tempAnalysis/'

os.chdir(path)
fileList = []
combinedCSV = []
counter = 0
### get each file in path with ending csv
for file in glob.glob("*.csv"):
    with open(path +'/'+ file) as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        for row in reader:
            if counter == 0:
                counter += 1
                firstRow = row
                combinedCSV.append(firstRow)
                continue
            if row[0] == firstRow[0]:
                continue
            combinedCSV.append(row)

### writeCombined CSV file
with open(folder+'combinedCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(combinedCSV)):
        wr.writerow(combinedCSV[i])

### get children Scenarios
childCSV = []
childCSV.append(['participant-ID', 'male','av/Car', 'perspective', 'passedSanCheck', 'Trial', 'Decision'])
counter = 0
with open(folder +'/'+ 'combinedCSV.csv') as csvfile:
    reader = csv.reader(csvfile, delimiter=' ')
    oldID = 0
    for row in reader:
        if counter == 0:
            counter += 1
            continue
        dataSplit = row[0].split()
        newLine = dataSplit[0:3]
        if oldID != dataSplit[0]:
            oldID = dataSplit[0]
            ### next participant skip practiceTrial
            continue
        ### check if Sanity check was passed
        if dataSplit[5] == '0' and dataSplit[6] == '0' and dataSplit[7] == '1':
            if (dataSplit[8]=='TRUE' and dataSplit[9]=='Ersteres') or \
                    (dataSplit[8=='FALSE' and dataSplit[9] == 'Zweiteres']):
                sanityCheckPassed = True
            else:
                sanityCheckPassed = False
            continue
        ### if not the childrenScenario skip
        elif dataSplit[5] == '0':
            continue

        if dataSplit[3] == '0':
            newLine.append('Passenger')
        elif dataSplit[3] == '1':
            newLine.append('Observer')
        elif dataSplit[3] == '2':
            newLine.append('PedSmall')
        else:
            newLine.append('PedLarge')
        newLine.append(sanityCheckPassed)
        if dataSplit[5] == '1':
            newLine.append('smallGroups')
        else:
            newLine.append('largeGroups')
        if (dataSplit[8] == 'True' and dataSplit[9] == 'Ersteres') or \
                (dataSplit[8] == 'False' and dataSplit[9] == 'Zweiteres'):
            newLine.append('hitChildren')
        else:
            newLine.append('hitAdults')
        childCSV.append(newLine)

### writeChildren CSV file
with open(folder+'childrenCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(childCSV)):
        wr.writerow(childCSV[i])
