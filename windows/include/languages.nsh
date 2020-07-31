;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2020 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author Yves Schumann <yves@alias.cash>
;
;Set up install lang strings for 1st lang
${ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Aliaswallet installer." \
      "About the installer:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

;Set up uninstall lang strings for 1st lang
${Un.ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Aliaswallet uninstaller." \
      "About Uninstall:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Aliaswallet software with all it's required components."
LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data. Download may take some time as it's a 1.2G archive."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor Settings"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_ENGLISH} "Please choose Tor configuration:"
LangString TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor flavour"
LangString TOR_FLAVOUR_DEFAULT ${LANG_ENGLISH} "Default settings"
LangString TOR_FLAVOUR_OBFS4 ${LANG_ENGLISH} "With activated OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_ENGLISH} "With activated Meek"

;Add 2nd language
!insertmacro MUI_LANGUAGE "German"

;set up install lang strings for second lang
${ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Aliaswallet-Installer." \
      "Über den Installer:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

;set up uninstall lang strings for second lang
${Un.ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Aliaswallet-Uninstaller." \
      "Über den Uninstaller:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

LangString DESC_SectionWalletBinary ${LANG_GERMAN} "Die Aliaswallet-Software mit allen benötigten Abhängigkeiten."
LangString DESC_SectionBlockchain ${LANG_GERMAN} "Die Aliaswallet Bootstrap-Blockchain. Der Download wird unter Umständen einige Zeit dauern, da es sich um ein 1.2G grosses Archiv handelt."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_GERMAN} "Bitte Tor-Konfiguration auswählen:"
LangString TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString TOR_FLAVOUR_DEFAULT ${LANG_GERMAN} "Standard-Einstellungen"
LangString TOR_FLAVOUR_OBFS4 ${LANG_GERMAN} "Mit aktiviertem OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_GERMAN} "Mit aktiviertem Meek"
