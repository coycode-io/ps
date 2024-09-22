#!/bin/bash

# Get the current directory (where the script is called)
callingDir=$(pwd)

# Loop through each subdirectory directly under the calling directory
for dir in "$callingDir"/*; do
    if [ -d "$dir" ]; then  # Check if it's a directory
        portFile="$dir/portnr.def"  # Define the path to portnr.def in the current subdirectory

        if [ -f "$portFile" ]; then  # Check if the portnr.def file exists
            # Read the port number from portnr.def
            portNumber=$(cat "$portFile")
            portNumber=$(echo "$portNumber" | xargs)  # Trim any spaces or newlines

            echo "Serving directory '$dir' on port $portNumber"

            # Start the HTTP server in the background
            (cd "$dir" && http-server -p "$portNumber" --cors -c-1 > /dev/null 2>&1 &)
        else
            echo "No portnr.def found in '$dir', skipping..."
        fi
    fi
done
