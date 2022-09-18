#!/bin/bash


# Get UNIPROT DATA (UNIPROT IDs from .txt file)

VAR=$(cat uniprot_ids.txt) # Define VAR to read ids from txt file
URL="https://www.uniprot.org/uniprot/" # Define base URL from uniprot


# LOOP FOR DOWNLOADING DATA

for i in ${VAR}
	do
		echo "Downloading Uniprot entry: ${i}" # Echo IDs
		# DOWNLOAD UNIPROT ENTRY
		wget ${URL}${i}.fasta  # Download using wget
		echo "Download complete" # echo completed download
	done
