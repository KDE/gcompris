#=============================================================================
# SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
GCOMPRIS_ADD_RESOURCE(activities/wordsgame
  QML_FILES
  *.qml
  RESOURCES
  *.svg
  resource/*.svg
  resource/*.json
  DEPENDENCIES
  gletters
)
