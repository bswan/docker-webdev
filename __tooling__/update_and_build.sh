#!/bin/bash

versions=""
build_opts=()
update_opts=()

# Parse args
for arg in "$@"; do
    case $arg in
        --versions=*)
            versions="${arg#*=}"
            update_opts+=("$versions")
            shift
            ;;
        --no-cache)
            build_opts+=("$arg")
            shift
            ;;
        *)
            echo "Unknown option: $arg"
            exit 1
            ;;
    esac
done

#echo "Build options: ${build_opts[*]:-none}"
#echo "Update options: ${update_opts[*]:-none}"

./update_all.sh ${update_opts[*]}
./build_all.sh ${build_opts[*]}