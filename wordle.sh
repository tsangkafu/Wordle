#!/bin/bash

check_word(){
    # reset font style to default
    tput sgr0
    # to upper case
    ans=${1^^}
    guess=${2^^}
    # number of guess, namely
    chance=${3}
    
    # while the length of the guess is not 5
    while (( ${#2} != 5 )); do
	# return the same number of guess so that the loop will continue asking for guess
	echo -e "\e[3mError: Please enter exactly 5 characters.\e[0m"
	return $chance
    done
    
    # if the user guesses correctly
    if [[ "$ans" == "$guess" ]]; then
	echo -e "\e[42m$guess\e[0m"
	echo "You win!"
	exit 0
    else
	# decrement the number of guess
	((chance--))
    fi
    
    # loop though each character to see if the guess
    # matches any of the correct characters
    for ((i=0; i<5; i++)); do
	# put the character of the guess according to the corresponding index
	ansChar=${ans:$i:1}
	# same as above, string named "guess", start from index i, length is 1
	guessChar=${guess:$i:1}
	# make a "boolean"
	shownUp="false"
	# loop through each character of the answer
	for ((j=0; j<5; j++)); do
	    # if the guessChar show up, turn shownUp to true
	    if [[ "$guessChar" == "${ans:$j:1}" ]]; then
		shownUp="true"
	    fi
	done
	# if the guessChar is in the correct index
	if [[ "$ansChar" == "$guessChar" ]]; then
	    # green
	    echo -ne "\e[42m$guessChar\e[0m"
	# not in correct index but shown up at least once
	elif [[ "$shownUp" == "true" ]]; then
	    # yellow
	    echo -ne "\e[43m$guessChar\e[0m"
	    shownUp="false"
	else
	    echo -ne $guessChar
	fi
    done
    echo
    return $chance
}

# store user input
input=""
# change the number of guess here
numOfGuess=6
# change the answer here
answer="FUNKY"
while (( $numOfGuess >= 0 )); do
    if [[ $numOfGuess == 0 ]]; then
	echo "You ran out of guess! Gameover!"                                                                                                                            
        exit 0
    fi
    # prompt the user
    echo -e "Guesses available: \e[1m$numOfGuess\e[0m"
    read -p "Your guess: " input
    # call the function
    check_word $answer $input $numOfGuess
    # talk the return of the check_word function
    numOfGuess=$?
done
