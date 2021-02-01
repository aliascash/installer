;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2020 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author HLXEasy <hlxeasy@gmail.com>>
;
;Set up install lang strings for 1st lang
${ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Alias wallet installer." \
      "About the installer:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

;Set up uninstall lang strings for 1st lang
${Un.ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Alias wallet uninstaller." \
      "About Uninstall:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

LangString DESC_SectionWalletBinaryFromBeforeRebranding ${LANG_ENGLISH} "Handle leftovers from before project rebranding"
LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Alias wallet software with all it's required components."
LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data. Download may take some time as it's a 1.9G archive."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor Settings"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_ENGLISH} "Please choose Tor configuration:"
LangString TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor flavour"
LangString TOR_FLAVOUR_DEFAULT ${LANG_ENGLISH} "Default settings"
LangString TOR_FLAVOUR_OBFS4 ${LANG_ENGLISH} "With activated OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_ENGLISH} "With activated Meek"
LangString PREVIOUS_VERSION_FOUND ${LANG_ENGLISH} "Found previous version, which needs to be uninstalled first."
LangString VERSION_FROM_BEFORE_REBRANDING_FOUND ${LANG_ENGLISH} "Found version from before the project rebranding, which needs to be uninstalled first."
LangString UNINSTALL_FAILED ${LANG_ENGLISH} "Failed to uninstall, continue anyway?"
LangString FIND_WALLET_PROCESS ${LANG_ENGLISH} "Check if wallet is running."
LangString WALLET_RUNNING_SHUT_IT_DOWN ${LANG_ENGLISH} "Wallet is running. Closing it down."
LangString WAIT_FOR_WALLET_SHUT_DOWN ${LANG_ENGLISH} "Waiting for wallet to close."
LangString NOT_RUNNING_AT_THE_MOMENT ${LANG_ENGLISH} "Wallet not running."

;Add 2nd language
!insertmacro MUI_LANGUAGE "German"

;set up install lang strings for second lang
${ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Alias Wallet Installer." \
      "Über den Installer:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

;set up uninstall lang strings for second lang
${Un.ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Alias Wallet Uninstaller." \
      "Über den Uninstaller:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

LangString DESC_SectionWalletBinaryFromBeforeRebranding ${LANG_GERMAN} "Verarbeite Dateien von vor dem Projekt-Rebranding."
LangString DESC_SectionWalletBinary ${LANG_GERMAN} "Die Alias Wallet Software mit allen benötigten Abhängigkeiten."
LangString DESC_SectionBlockchain ${LANG_GERMAN} "Die Alias Wallet Bootstrap Blockchain. Der Download wird unter Umständen einige Zeit dauern, da es sich um ein 1.9G grosses Archiv handelt."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_GERMAN} "Bitte Tor-Konfiguration auswählen:"
LangString TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString TOR_FLAVOUR_DEFAULT ${LANG_GERMAN} "Standard-Einstellungen"
LangString TOR_FLAVOUR_OBFS4 ${LANG_GERMAN} "Mit aktiviertem OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_GERMAN} "Mit aktiviertem Meek"
LangString PREVIOUS_VERSION_FOUND ${LANG_GERMAN} "Vorherige Version gefunden, welche zuerst deinstalliert werden muss."
LangString VERSION_FROM_BEFORE_REBRANDING_FOUND ${LANG_GERMAN} "Version von vor dem Projekt-Rebranding gefunden, welche zuerst deinstalliert werden muss."
LangString UNINSTALL_FAILED ${LANG_GERMAN} "Deinstallation fehlgeschlagen. Dennoch fortfahren?"
LangString FIND_WALLET_PROCESS ${LANG_GERMAN} "Prüfen ob Wallet läuft."
LangString WALLET_RUNNING_SHUT_IT_DOWN ${LANG_GERMAN} "Wallet läuft noch und wird beendet."
LangString WAIT_FOR_WALLET_SHUT_DOWN ${LANG_GERMAN} "Warte auf Beenden des Wallet."
LangString NOT_RUNNING_AT_THE_MOMENT ${LANG_GERMAN} "Wallet läuft momentan nicht."

;Add 3rd language
!insertmacro MUI_LANGUAGE "French"

${ReadmeLanguage} "${LANG_FRENCH}" \
      "Lisez-moi" \
      "Quelques informations à propos de l'installeur Portefeuille Alias." \
      "A propos de l'installeur:" \
      "$\n  Cliquer sur les fleches dans la barre de défilement ou appuyez sur PageSuiv pour lire le texte en entier."

${Un.ReadmeLanguage} "${LANG_FRENCH}" \
      "Lisez-moi" \
      "Quelques informations à propos de du désinstalleur Portefeuille Alias." \
      "A propos de la désinstallation:" \
      "$\n  Cliquer sur les fleches dans la barre de défilement ou appuyez sur PageSuiv pour lire le texte en entier."

LangString DESC_SectionWalletBinaryFromBeforeRebranding ${LANG_FRENCH} "Gérer les orphelins d'avant le renommage du projet"
LangString DESC_SectionWalletBinary ${LANG_FRENCH} "Le logiciel Portefeuille Alias avec tous ses composants requis."
LangString DESC_SectionBlockchain ${LANG_FRENCH} "Les données de bootstrap de la blockchain. Télécharger prendra du temps car il s'agit d'une archive de 1,96Go."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_FRENCH} "Réglages Tor"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_FRENCH} "Choisissez la configuration Tor:"
LangString TOR_FLAVOUR_TITLE ${LANG_FRENCH} "Tor flavour"
LangString TOR_FLAVOUR_DEFAULT ${LANG_FRENCH} "Réglages par défaut"
LangString TOR_FLAVOUR_OBFS4 ${LANG_FRENCH} "Avec OBFS4 activé"
LangString TOR_FLAVOUR_MEEK ${LANG_FRENCH} "Avec Meek activé"
LangString PREVIOUS_VERSION_FOUND ${LANG_FRENCH} "Une version précédente a été trouvée, elle doit d'abord être désinstallée."
LangString VERSION_FROM_BEFORE_REBRANDING_FOUND ${LANG_FRENCH} "Une version d'avant le rebranding a été trouvée, elle doit d'abord êre désinstallée."
LangString UNINSTALL_FAILED ${LANG_FRENCH} "Echec de la désinstallation, poursuivre quand même?"
LangString FIND_WALLET_PROCESS ${LANG_FRENCH} "Vérifie si le portefeuille est en cours d'éxecution."
LangString WALLET_RUNNING_SHUT_IT_DOWN ${LANG_FRENCH} "Le portefeuille est en cours d'éxecution. Fermeture en cours."
LangString WAIT_FOR_WALLET_SHUT_DOWN ${LANG_FRENCH} "Attente de la fermeture du portefeuille."
LangString NOT_RUNNING_AT_THE_MOMENT ${LANG_FRENCH} "Le portefeuille n'est pas en cours d'éxecution."
