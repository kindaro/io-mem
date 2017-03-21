#! /bin/sh -ex

proj="$(find *.cabal | rev | cut -d '.' -f 2- | rev)"

while [ "${1:0:2}" == "--" ]
do
    opt="${1:2}"
    [ "$opt" ] || break
    case "$opt" in
        ("clean") clean=yes ;;
        ("build") build=yes ;;
        ("time") time=yes;;
        ("centre") [ "$centres" ] && centres="$centres $2" || centres="$2" ; shift ;;
        ("review") review=yes ;;
    esac
    shift
done

if [ "$clean" ]
then
    rm *.hp *.prof *.ps *.aux && true
    stack clean
fi

if [ "$build" ]
then
    stack build                                     \
        --ghc-options "-rtsopts -auto-all -caf-all" \
        --executable-profiling                      \
        --library-profiling
fi


if [ "$time" ]
then
    ./.stack-work/dist/x86_64-linux/Cabal-*/build/"$proj"/"$proj"        \
        +RTS -p -hc -RTS
    mv "$proj"{,-time}.hp
fi

[ "$centres" ] && echo "$centres" | tr ' ' '\n' | while read centre
do
    ./.stack-work/dist/x86_64-linux/Cabal-*/build/"$proj"/"$proj" \
        +RTS -p -hd -hc"$centre" -RTS
    mv "$proj"{,-"$centre"}.hp
done

if [ "$review" ]
then
    for file in "$proj"-*.hp
    do
        hp2ps "$file"
    done

    zathura "$proj"-*.ps 
fi
