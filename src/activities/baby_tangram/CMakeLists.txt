#=============================================================================
# SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/baby_tangram
  QML_FILES
  *.qml
  dataset.js
  RESOURCES
  *.svg
  resource/*/*.svg
  DEPENDENCIES
  tangram
)
