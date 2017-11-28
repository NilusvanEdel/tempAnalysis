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

### write first line
childCSV, sidewalkCSV, selfSacCSV = [], [], []
firstLine = ['participant-ID', 'male','av/Car', 'perspective', 'passedSanCheck', 'Trial', 'Decision']
childCSV.append(firstLine)
sidewalkCSV.append(firstLine)
selfSacCSV.append(firstLine)

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
        ### check if sanity check was passed
        if dataSplit[5] == '0' and dataSplit[6] == '0' and dataSplit[7] == '1':
            if (dataSplit[8] == 'True' and dataSplit[9]=='Ersteres') or \
                    (dataSplit[8] == 'False' and dataSplit[9] == 'Zweiteres'):
                sanityCheckPassed = True
            else:
                sanityCheckPassed = False
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
        newLineChild = newLine
        newLineSidewalk = newLine
        newLineSelfSac = newLine
        ### if childrenScenario
        if dataSplit[5] != '0':
            if dataSplit[5] == '1':
                newLineChild.append('smallGroups')
            else:
                newLineChild.append('largeGroups')
            if (dataSplit[8] == 'True' and dataSplit[9] == 'Ersteres') or \
                    (dataSplit[8] == 'False' and dataSplit[9] == 'Zweiteres'):
                newLineChild.append('hitChildren')
            else:
                newLineChild.append('hitAdults')
            childCSV.append(newLineChild)
        ### if sidewalkScenario
        if (dataSplit[6] == '1' and dataSplit[7] == '2') or \
                (dataSplit[6] == '2' and dataSplit[7] == '4'):
            if dataSplit[6]== '1':
                newLineSidewalk.append('smallGroups')
            else:
                newLineSidewalk.append('largeGroups')
            if (dataSplit[8] == 'True' and dataSplit[9] == 'Ersteres') or \
                    (dataSplit[8] == 'False' and dataSplit[9] == 'Zweiteres'):
                newLineSidewalk.append('hitSidewalk')
            else:
                newLineChild.append('hitStreet')
            sidewalkCSV.append(newLineChild)
        ### if selfSacrificeScenario
        if dataSplit[6] == '2' and dataSplit[7] == '0':
            if dataSplit[4] == '2':
                newLineSelfSac.append('mountain')
            else:
                newLineSelfSac.append('cityR')
            if (dataSplit[8] == 'True' and dataSplit[9] == 'Ersteres') or \
                    (dataSplit[8] == 'False' and dataSplit[9] == 'Zweiteres'):
                newLineSelfSac.append('hitPedestrians')
            else:
                newLineSelfSac.append('selfSacrifice')
            selfSacCSV.append(newLineSelfSac)

### writeChildren CSV file
with open(folder+'childrenCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(childCSV)):
        wr.writerow(childCSV[i])
### write sidewalkCSV
with open(folder+'sidewalkCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(sidewalkCSV)):
        wr.writerow(sidewalkCSV[i])
### write selfSacCSV
with open(folder+'selfSacCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(selfSacCSV)):
        wr.writerow(selfSacCSV[i])
