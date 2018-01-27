import csv
import glob
import os

from fixVRPostQues import fixVRPostQues
from vr_check_numbers import doSecondSanCheck, checkVRNumbers

### where the dataFiles are stored
path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'vr_data/raw'))
### where the created Files will be stored
folder = os.path.abspath(os.path.join(os.path.dirname(__file__), 'vr_data/')) + '/'
### function to find the index in PostQuestionnaire
def findItem(theList, item):
   return [ind for ind in range(len(theList)) if item in theList[ind]][0]


fixVRPostQues()
os.chdir(path)
fileList = []
combinedCSV = []
counter = 0
numDatapoints = 0
### get each file in path with ending csv
for file in glob.glob("*.csv"):
    if file == 'Post Questionnaire.csv':
        continue
    numDatapoints += 1
    with open(path + '/' + file) as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        for row in reader:
            if counter == 0:
                counter += 1
                firstRow = row[0].split()
                combinedCSV.append(firstRow)
                continue
            row = row[0].split()
            if row == firstRow:
                continue
            row[0] = file.split(".")[0]
            combinedCSV.append(row)
print("Number of datapoints: ", numDatapoints)

### writeCombined CSV file
with open(folder+'combinedCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(combinedCSV)):
        wr.writerow(combinedCSV[i])

### read PostQues
postQues = []
with open(path + '/' + 'Post Questionnaire.csv') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
        postQues.append(row)

### write first line
childCSV, sidewalkCSV, selfSacCSV = [], [], []
firstLine = ['participant-ID', 'male','av/Car', 'perspective', 'passedSanCheck', 'perceivedCar', 
            'perceivedIden', 'age', 'drivExperience', 'education', 'recAccidents', 'heardBoutAV', 'opinAV',
            'prevVRExp', 'visImpairment', 'confidence', 'trial', 'decision']
childCSV.append(firstLine)
sidewalkCSV.append(firstLine)
selfSacCSV.append(firstLine)

counter = 0
with open(folder +'/'+ 'combinedCSV.csv') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    oldID = 0
    noSimIDFail = []
    for dataSplit in reader:
        ### ignore first line
        if counter == 0:
            counter += 1
            continue
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
        ### get the respective items out of PostQues
        try:
            if oldID == '1':
                ind = postQues[findItem(postQues, "FIX01")]
            else:
                ind = postQues[findItem(postQues, oldID)]
            # motorist
            newLine.append(ind[11])
            # perceived identity
            newLine.append(ind[12])
            # age
            newLine.append(ind[2])
            # driving experience
            newLine.append(ind[3])
            # education
            newLine.append(ind[4])
            # recent accidents
            newLine.append(ind[6])
            # heard about AVs before?
            newLine.append(ind[7])
            # opinion on AVs
            newLine.append(ind[8])
            # previous VR experience
            newLine.append(ind[9])
            # glasses?
            newLine.append(ind[10])
        except IndexError:
            noSimIDFail.append(oldID)
            for i in range(2): newLine.append("NoSimilarID")
        ### difficultyOfDecision
        newLine.append(dataSplit[10])
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

for i in range(2):
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
    noSimIDFail = list(dict.fromkeys(noSimIDFail))
    ### do second sanity Check and delete the failed ones out of the combined csv
    doSecondSanCheck()
print("Failures of combining online with VR data: ", len(list(dict.fromkeys(noSimIDFail))))
print(noSimIDFail)
checkVRNumbers(printIt = True)