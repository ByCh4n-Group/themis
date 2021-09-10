#!/bin/bash

while :; do
    read -p "x tool v1.0.0:> " x
    case "${x}" in
        *=*)
            export "${x}"
        ;;
        list)
            echo "test=$test"
        ;;
        exit)
            exit 0
        ;;
    esac
done