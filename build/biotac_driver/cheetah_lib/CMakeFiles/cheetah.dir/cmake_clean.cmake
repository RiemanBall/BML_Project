FILE(REMOVE_RECURSE
  "/home/robot/rieman_ws/devel/lib/libcheetah.pdb"
  "/home/robot/rieman_ws/devel/lib/libcheetah.so"
)

# Per-language clean rules from dependency scanning.
FOREACH(lang)
  INCLUDE(CMakeFiles/cheetah.dir/cmake_clean_${lang}.cmake OPTIONAL)
ENDFOREACH(lang)
