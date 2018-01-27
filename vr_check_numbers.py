import csv
import os
import glob

path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), 'vr_data'))
file = path + "/childrenCSV.csv"


def findItem(theList, item):
    return [ind for ind in range(len(theList)) if item in theList[ind]][0]


def checkVRNumbers():
    # get each file in path with ending csv
    counter = 0
    counterMale = 0
    counterFemale = 0
    # 8 femPers
    counterFemObs = 0
    counterFemPas = 0
    counterFemLar = 0
    counterFemSma = 0
    counterMalObs = 0
    counterMalPas = 0
    counterMalLar = 0
    counterMalSma = 0
    # 8 malPers
    counterFemObsAV = 0
    counterFemPasAV = 0
    counterFemLarAV = 0
    counterFemSmaAV = 0
    counterMalObsAV = 0
    counterMalPasAV = 0
    counterMalLarAV = 0
    counterMalSmaAV = 0
    oldID = ""
    failedSecondSanCheck = []

    with open(file) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            if oldID != row[0]:
                oldID = row[0]
                counter += 1
                # right perceived Motorist?
                if row[2] == "True" and row[5] == "Mensch":
                    failedSecondSanCheck.append(row[0])
                    continue

                pers = row[3]
                if row[1] == 'True':
                    counterMale += 1
                    if row[2] == 'False':
                        if pers == "Observer":
                            counterMalObs += 1
                        elif pers == "PedSmall":
                            counterMalSma += 1
                        elif pers == "PedLarge":
                            counterMalLar += 1
                        else:
                            counterMalPas += 1
                    else:
                        if pers == "Observer":
                            counterMalObsAV += 1
                        elif pers == "PedSmall":
                            counterMalSmaAV += 1
                        elif pers == "PedLarge":
                            counterMalLarAV += 1
                        else:
                            counterMalPasAV += 1
                else:
                    counterFemale += 1
                    if row[2] == 'False':
                        if pers == "Observer":
                            counterFemObs += 1
                        elif pers == "PedSmall":
                            counterFemSma += 1
                        elif pers == "PedLarge":
                            counterFemLar += 1
                        else:
                            counterFemPas += 1
                    else:
                        if pers == "Observer":
                            counterFemObsAV += 1
                        elif pers == "PedSmall":
                            counterFemSmaAV += 1
                        elif pers == "PedLarge":
                            counterFemLarAV += 1
                        else:
                            counterFemPasAV += 1

    print("Overall: ", counter)
    print("PassedSan: ", counterMale + counterFemale)
    print("Male: ", counterMale)
    print("Female: ", counterFemale)
    print("--------------------Male--------------------")
    print('{:.7} {:.7} {:.7} {:.7} {:.7}'.format('     ', 'PedLarge', 'PedSmall', 'Observer', 'Passenger'))
    print('{:.7} {:<7} {:<7} {:<7} {:<7}'.format('Human', counterMalLar, counterMalSma, counterMalObs, counterMalPas))
    print('{:.7} {:<7} {:<7} {:<7} {:<7}'.format('AV   ', counterMalLarAV, counterMalSmaAV, counterMalObsAV, counterMalPasAV))

    print("-------------------Female-------------------")
    print('{:.7} {:.7} {:.7} {:.7} {:.7}'.format('     ', 'PedLarge', 'PedSmall', 'Observer', 'Passenger'))
    print('{:.7} {:<7} {:<7} {:<7} {:<7}'.format('Human', counterFemLar, counterFemSma, counterFemObs, counterFemPas))        
    print('{:.7} {:<7} {:<7} {:<7} {:<7}'.format('AV   ',counterFemLarAV, counterFemSmaAV, counterFemObsAV, counterFemPasAV))
    return failedSecondSanCheck


def doSecondSanCheck():
    file = path + "/combinedCSV.csv"
    sanList = checkVRNumbers()
    csvList = []
    with open(file) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            csvList.append(row)
    print(len(csvList))
    for entry in sanList:
        error = False
        while not error:
            try:
                ind = findItem(csvList, entry)
                csvList.pop(ind)
            except IndexError:
                error = True
    print(len(csvList))
    with open(file, 'w+') as myfile:
        wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
        for i in range(len(csvList)):
            wr.writerow(csvList[i])

if __name__ == '__main__':
    checkVRNumbers()
    # doSecondSanCheck()