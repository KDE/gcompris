#=============================================================================
# SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/memory-sound
  QML_FILES
  *.qml
  *.js
  RESOURCES
  *.svg
  resource/*.${COMPRESSED_AUDIO}
  resource/*.svg
  DEPENDENCIES
  memory
)
