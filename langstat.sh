#!/bin/bash

# langstat.sh
# TP OpenClassRoom: script to show stat about letter using in any language
# dictionary is necessary

# first we get dico file name from first parameter
dicofilename=""
if [[ "$1" != "" ]]; then
    dicofilename="$1"
fi

# if dico file name specified does not exists 
# we display error and exit
if [[ $dicofilename == "" ]]; then
    echo "ERROR: you must specify dico file name as first parameter"
    exit 1
# if dico file name specified does not exists 
# we display error and exit
elif [[ ! -e $dicofilename ]]; then
    echo "ERROR: $dicofilename does not exist"
    exit 1
fi

# results files
resultfile="result.txt"
finalresultfile="sortedresult.txt"

# we remove final result file if exists
if [[ -e $finalresultfile ]]; then
    rm $finalresultfile
fi

# we define string alphabet var
alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# for letter in ${alphabet}
# do 
#     echo "$letter"
# done
# letter="A"
# grep -i "$letter" dictionary/dico.txt | wc -l

# for each alphabet letter we search with 
# grep in how much line it appears (dico is one word by line)
# and we write line number - letter in result file
for (( i=0; i<${#alphabet}; i++ )); do
    letter="${alphabet:$i:1}"
    result="$(grep -i "$letter" "$dicofilename" | wc -l)"
    echo "$result - $letter" >> $resultfile
done

# then we read result file and sort it by number
# descending in final result file
cat $resultfile | sort -nr >> $finalresultfile

# message to specify process is done and where result file is available
echo "process done, result file available here: $resultfile"

# processing second parameter if specified
bonusword="$2"
if [[ "$bonusword" != "" ]]; then
    
    if [[ -e bonusfile.txt ]]; then
        rm bonusfile.txt
    fi
    
    sleep 1
    echo "Oh wait!"
    sleep 1
    echo "I can see you specified a bonus word!"
    
    wordsin="0"
    wordsin="$(grep -i "$bonusword" "$dicofilename" | wc -l)"
    
    if [[ "$wordsin" != "0" ]]; then
        grep -i "$bonusword" "$dicofilename" >> bonusfile.txt
        
        echo "Well, your bonus word, $bonusword, is part of $wordsin words"
        sleep 1
        echo "You can check these words list in bonusfile.txt"
        sleep 1
        echo "Can you find a bigger word existing in words?"
    else   
        sleep 1
        echo "Sorry, $bonusword is not part of any word existing in your dictionnary. Try again!"
    fi

fi

# finally we remove result file because it was only
# used to sort data to send to final result file
if [[ -e $resultfile ]]; then
    rm $resultfile
fi
