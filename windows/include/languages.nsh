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


;Add 2nd language
!insertmacro MUI_LANGUAGE "German"

;set up install lang strings for second lang
${ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Spectrecoin-Installer." \
      "Über den Installer:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."

;set up uninstall lang strings for second lang
${Un.ReadmeLanguage} "${LANG_GERMAN}" \
      "Read Me" \
      "Kurzinformation zum Spectrecoin-Uninstaller." \
      "Über den Uninstaller:" \
      "$\n  Click on scrollbar arrows or press Page Down to review the entire text."