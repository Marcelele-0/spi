#!/bin/zsh

if [ "$#" -ne 2 ]; then
    echo "Usage: spi \"<command>\" <output_file>"
    exit 1
fi

command="$1"
output_file="$2"

# Sprawdzenie, czy plik wyjściowy już istnieje
if [ -e "$output_file" ]; then
    read -p "$output_file already exists. Overwrite? (y/n) " choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        > "$output_file"  # Wyczyść plik, jeśli nadpisujemy
    else
        echo "Appending to $output_file"
    fi
fi

command_output=$(eval "$command" 2>&1)
exit_status=$?

{
    echo "## Command"
    echo "\`\`\`zsh"
    echo "$command"
    echo "\`\`\`"
    echo ""
    echo "## Output"
    echo "\`\`\`"
    echo "$command_output"
    echo "\`\`\`"
} >> "$output_file"

if [ $exit_status -ne 0 ]; then
    echo "Error: Command failed with exit status $exit_status. See output in $output_file"
fi
