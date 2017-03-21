#! /bin/sh

stack clean                                                            &&
    stack build                                     \
        --ghc-options "-rtsopts -auto-all -caf-all" \
        --executable-profiling                      \
        --library-profiling                                            &&

    ./.stack-work/dist/x86_64-linux/Cabal-1.24.2.0/build/io-mem/io-mem \
        +RTS -p -hc -RTS                                               &&

    hp2ps io-mem.hp                                                    &&
    zathura io-mem.ps
