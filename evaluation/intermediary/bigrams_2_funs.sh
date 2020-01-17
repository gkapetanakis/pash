#!/bin/bash

bigrams_aux()
{
    ( mkfifo s2 > /dev/null ) ;
    ## I am not sure if this reads the stdin of the function
    tee s2 |
        tail +2 |
        paste s2 -
    rm s2
}

bigram_aux_map()
{
    IN=$1
    OUT=$2
    AUX_HEAD=$3
    AUX_TAIL=$4

    s2=$(mktemp -u)
    aux1=$(mktemp -u)
    aux2=$(mktemp -u)

    mkfifo $s2
    mkfifo $aux1
    mkfifo $aux2
    cat $IN |
        tee $s2 $aux1 $aux2 |
        tail +2 |
        paste $s2 - > $OUT &

    ## The goal of this is to write the first line of $IN in the $AUX_HEAD
    ## stream and the last line of $IN in $AUX_TAIL

    ## TODO: I am not sure if using head/tail like this works or breaks
    ## the pipes
    cat $aux1 | ( head -n 1 > $AUX_HEAD; dd of=/dev/null > /dev/null 2>&1 ) &
    tail -n 1 $aux2 > $AUX_TAIL &

    wait

    rm $s2
    rm $aux1
    rm $aux2
}

bigram_aux_reduce()
{
    IN1=$1
    AUX_HEAD1=$2
    AUX_TAIL1=$3
    IN2=$4
    AUX_HEAD2=$5
    AUX_TAIL2=$6
    OUT=$7
    AUX_HEAD_OUT=$8
    AUX_TAIL_OUT=$9

    temp=$(mktemp -u)
    
    mkfifo $temp

    cat $AUX_HEAD1 > $AUX_HEAD_OUT &
    cat $AUX_TAIL2 > $AUX_TAIL_OUT &
    paste $AUX_TAIL1 $AUX_HEAD2 > $temp &
    cat $IN1 $temp $IN2 > $OUT &

    wait

    rm $temp
}

export -f bigrams_aux
export -f bigram_aux_map
export -f bigram_aux_reduce
