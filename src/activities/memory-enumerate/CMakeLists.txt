#=============================================================================
# SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/memory-enumerate
  QML_FILES
  *.qml
  resource/*/Data.qml
  RESOURCES
  *.svg
  resource/*.svg
  DEPENDENCIES
  memory
)
