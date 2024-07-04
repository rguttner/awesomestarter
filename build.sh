#!/bin/bash

target_directory="web/themes/custom/awesome"

cd target_directory

# Ověření existence cílové složky
if [ -d "$target_directory" ]; then
    echo "Cílová složka \"$target_directory\" existuje."
    echo "Naviguji do slozky..."
    cd "$target_directory"
    echo "Spouštím build scss a mazu cache"
    ddev npm run build; ddev drush cr
else
    echo "Cílová složka \"$target_directory\" neexistuje nebo není adresářem."
fi
