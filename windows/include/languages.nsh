;  SPDX-FileCopyrightText: © 2020 Alias developers
;  SPDX-FileCopyrightText: © 2020 Spectrecoin developers
;  SPDX-License-Identifier: MIT
;
;  @author Yves Schumann <yves@alias.cash>
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

LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Alias wallet software with all it's required components."
LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data. Download may take some time as it's a 1.2G archive."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor Settings"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_ENGLISH} "Please choose Tor configuration:"
LangString TOR_FLAVOUR_TITLE ${LANG_ENGLISH} "Tor flavour"
LangString TOR_FLAVOUR_DEFAULT ${LANG_ENGLISH} "Default settings"
LangString TOR_FLAVOUR_OBFS4 ${LANG_ENGLISH} "With activated OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_ENGLISH} "With activated Meek"
LangString PREVIOUS_VERSION_FOUND ${LANG_ENGLISH} "Found previous version, which needs to be uninstalled first."
LangString UNINSTALL_FAILED ${LANG_ENGLISH} "Failed to uninstall, continue anyway?"
LangString WALLET_RUNNING_SHUT_IT_DOWN ${LANG_ENGLISH} "Alias wallet is running. Closing it down"
LangString WAIT_FOR_WALLET_SHUT_DOWN ${LANG_ENGLISH} "Waiting for Alias wallet to close"
LangString NOT_RUNNING_AT_THE_MOMENT ${LANG_ENGLISH} "was not found to be running"

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

LangString DESC_SectionWalletBinary ${LANG_GERMAN} "Die Alias Wallet Software mit allen benötigten Abhängigkeiten."
LangString DESC_SectionBlockchain ${LANG_GERMAN} "Die Alias Wallet Bootstrap Blockchain. Der Download wird unter Umständen einige Zeit dauern, da es sich um ein 1.2G grosses Archiv handelt."
LangString PAGE_TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString PAGE_TOR_FLAVOUR_SUBTITLE ${LANG_GERMAN} "Bitte Tor-Konfiguration auswählen:"
LangString TOR_FLAVOUR_TITLE ${LANG_GERMAN} "Tor-Konfiguration"
LangString TOR_FLAVOUR_DEFAULT ${LANG_GERMAN} "Standard-Einstellungen"
LangString TOR_FLAVOUR_OBFS4 ${LANG_GERMAN} "Mit aktiviertem OBFS4"
LangString TOR_FLAVOUR_MEEK ${LANG_GERMAN} "Mit aktiviertem Meek"
LangString PREVIOUS_VERSION_FOUND ${LANG_ENGLISH} "Vorherige Version gefunden, welche zuerst deinstalliert werden muss."
LangString UNINSTALL_FAILED ${LANG_ENGLISH} "Deinstallation fehlgeschlagen. Dennoch fortfahren?"
LangString WALLET_RUNNING_SHUT_IT_DOWN ${LANG_ENGLISH} "Alias Wallet läuft noch und wird beendet"
LangString WAIT_FOR_WALLET_SHUT_DOWN ${LANG_ENGLISH} "Warte auf Beenden von Alias Wallet"
LangString NOT_RUNNING_AT_THE_MOMENT ${LANG_ENGLISH} "läuft momentan nicht"
