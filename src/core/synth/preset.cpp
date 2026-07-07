/* miniSynth - A Simple Software Synthesizer
   SPDX-FileCopyrightText: 2015 Ville Räisänen <vsr at vsr.name>

   SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "preset.h"

Preset::Preset() : timbreAmplitudes(4, 0), timbrePhases(4, 0) {
//hardcode custom church pad preset
    waveformMode = Waveform::MODE_SIN;
    env.attackTime = 50;
    env.decayTime = 50;
    env.releaseTime = 10;

    env.initialAmpl = 0;
    env.peakAmpl = 0.9;
    env.sustainAmpl = 0.8;

    timbreAmplitudes[0] = 40;
    timbreAmplitudes[1] = 20;
    timbreAmplitudes[3] = 10;
    timbrePhases[0] = 0;
    timbrePhases[1] = 10;
    timbrePhases[3] = 20;
}
