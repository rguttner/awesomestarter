#!/bin/bash

<<Comment
Tento script instaluje a povoluje moduly:

  - admin_toolbar
  - gin_toolbar
  - gin
  - gin_login
  - paragraphs
  - pathauto
  - structure_sync
  - twig_tweak
  - metatag
  - redirect
  - webform

Nastavi gin jako tema administrace
Nainstaluje a nastavy jako vychozi awesome theme.

Povoluje:
  - media
  - media_libary

Na konci pousti script npm install, run build a drush cr.

Comment

set -e  # Skript zastaví pokračování po chybě

prompt_continue() {
    while true; do
        read -p "Došlo k chybě. Chcete pokračovat? (Yes/No): " choice
        case "$choice" in
            [yY]|[yY][eE][sS] ) echo "Pokračujeme..."; return 0; ;;
            [nN]|[nN][oO] ) echo "Skript ukončen uživatelem."; exit 1; ;;
            * ) echo "Prosím zadejte Yes nebo No.";;
        esac
    done
}

# Instalace a povolení modulu admin_toolbar
ddev composer require 'drupal/admin_toolbar:^3.4' || {
    echo "Chyba: Instalace admin_toolbar selhala."
    prompt_continue
}
ddev drush en admin_toolbar

# Instalace a povolení modulu gin_toolbar
ddev composer require 'drupal/gin_toolbar:^1.0@RC' || {
    echo "Chyba: Instalace gin_toolbar selhala."
    prompt_continue
}

# Instalace a nastavení modulu gin
ddev composer require 'drupal/gin:^3.0@RC' || {
    echo "Chyba: Instalace gin selhala."
    prompt_continue
}

ddev drush theme:enable gin
ddev drush config-set system.theme admin gin -y

ddev drush en gin_toolbar

# Instalace a povoleni modulu gin_login
ddev composer require 'drupal/gin_login:^2.1' || {
  echo "Chyba: Instalace gin selhala."
      prompt_continue
}

ddev drush en gin_login

# Instalace modulu paragraphs
ddev composer require 'drupal/paragraphs:^1.17' -n || {
    echo "Chyba: Instalace paragraphs selhala."
    prompt_continue
}
ddev drush en paragraphs

# Instalace modulu pathauto
ddev composer require 'drupal/pathauto:^1.12' -n || {
    echo "Chyba: Instalace pathauto selhala."
    prompt_continue
}
ddev drush en pathauto

# Instalace modulu structure_sync
ddev composer require 'drupal/structure_sync:^2.0' || {
    echo "Chyba: Instalace structure_sync selhala."
    prompt_continue
}
ddev drush en structure_sync

# Instalace modulu twig_tweak
ddev composer require 'drupal/twig_tweak:^3.3' || {
    echo "Chyba: Instalace twig_tweak selhala."
    prompt_continue
}
ddev drush en twig_tweak

# Instalace modulu metatag
ddev composer require 'drupal/metatag:^2.0' || {
    echo "Chyba: Instalace metatag selhala."
    prompt_continue
}
ddev drush en metatag

# Instalace modulu redirect
ddev composer require 'drupal/redirect:^1.9' || {
    echo "Chyba: Instalace redirect selhala."
    prompt_continue
}
ddev drush en redirect

# Instalace a povoleni modulu webform
ddev composer require 'drupal/webform:^6.2' || {
  echo "Chyba: Instalace redirect selhala."
      prompt_continue
}
ddev drush en webform



# Povolení modulů media, media_library, toolbar_tools
ddev drush en media
ddev drush en media_library
ddev drush en admin_toolbar_tools


# Instalace NPM závislostí a build (pouze pokud je cílový adresář definován a existuje)
target_directory="web/themes/custom/awesome"
if [ -d "$target_directory" ]; then
    cd "$target_directory"
    ddev npm install || {
        echo "Chyba: Instalace npm závislostí selhala."
        prompt_continue
    }
    ddev npm audit fix || {
        echo "Chyba: Oprava bezpečnostních chyb v npm závislostech selhala."
        prompt_continue
    }
    ddev npm run build || {
        echo "Chyba: Build skončil s chybou."
        prompt_continue
    }

    ddev drush theme:enable awesome
    if [ $? -ne 0 ]; then
        echo "Chyba při povolování tématu 'Awesome'"
        prompt_continue
    fi

    ddev drush config:set system.theme default awesome -n
    if [ $? -ne 0 ]; then
        echo "Chyba při nastavování tématu 'Awesome' jako výchozího"
        prompt_continue
    fi
    echo "Téma 'Awesome' bylo úspěšně nainstalováno a nastaveno jako výchozí."
    ddev drush cr
else
    echo "Cílový adresář $target_directory neexistuje."
    prompt_continue
fi

exit 0

