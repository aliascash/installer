;Set up install lang strings for 1st lang
${ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Spectrecoin installer." \
      "About the installer:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

;Set up uninstall lang strings for 1st lang
${Un.ReadmeLanguage} "${LANG_ENGLISH}" \
      "Read Me" \
      "Short information about the Spectrecoin uninstaller." \
      "About Uninstall:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

LangString DESC_SectionWalletBinary ${LANG_ENGLISH} "The Spectrecoin wallet software with all it's required components."
LangString DESC_SectionBlockchain ${LANG_ENGLISH} "The bootstrap blockchain data. Download may take some time as it's a 1.2G archive."

;Add 2nd language
!insertmacro MUI_LANGUAGE "German"

;set up install lang strings for second lang
${ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Spectrecoin-Installer." \
      "Über den Installer:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

;set up uninstall lang strings for second lang
${Un.ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Spectrecoin-Uninstaller." \
      "Über den Uninstaller:" \
      "$\n  Drücken Sie die Bild-Runter-Taste, um den restlichen Text zu sehen."

LangString DESC_SectionWalletBinary ${LANG_GERMAN} "Die Spectrecoin Wallet-Software mit allen benötigten Abhängigkeiten."
LangString DESC_SectionBlockchain ${LANG_GERMAN} "Die Spectrecoin Bootstrap-Blockchain. Der Download wird unter Umständen einige Zeit dauern, da es sich um ein 1.2G grosses Archiv handelt."
