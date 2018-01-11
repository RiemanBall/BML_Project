FILE(REMOVE_RECURSE
  "CMakeFiles/cheetah_"
  "CMakeFiles/cheetah_-complete"
  "src/cheetah_-stamp/cheetah_-install"
  "src/cheetah_-stamp/cheetah_-mkdir"
  "src/cheetah_-stamp/cheetah_-download"
  "src/cheetah_-stamp/cheetah_-update"
  "src/cheetah_-stamp/cheetah_-patch"
  "src/cheetah_-stamp/cheetah_-configure"
  "src/cheetah_-stamp/cheetah_-build"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/cheetah_.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
