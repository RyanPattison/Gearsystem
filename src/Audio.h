/*
 * Gearboy - Nintendo Game Boy Emulator
 * Copyright (C) 2012  Ignacio Sanchez

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://www.gnu.org/licenses/
 *
 */

#ifndef AUDIO_H
#define	AUDIO_H

#include "definitions.h"
#include "audio/Multi_Buffer.h"
#include "audio/Sms_Apu.h"
#include "audio/Sound_Queue.h"

class Audio
{
public:
    Audio();
    ~Audio();
    void Init();
    void Reset(bool soft=false);
    void Enable(bool enabled);
    bool IsEnabled() const;
    void EndFrame();
    void Tick(unsigned int clockCycles);

    void WriteAudioRegister(u8 value);

    void WriteGGStereoRegister(u8 value);

private:
    bool m_bEnabled;
    Sms_Apu* m_pApu;
    Multi_Buffer* m_pBuffer;
    int m_Time;
    int m_AbsoluteTime;
    Sound_Queue* m_pSound;
    int m_iSampleRate;
    blip_sample_t* m_pSampleBuffer;
};

const int kSampleBufferSize = 2048;
const long kSoundFrameLength = 10000;
const u8 kSoundMask[] = {
    0x80, 0x3F, 0x00, 0xFF, 0xBF,                       // NR10-NR14 (0xFF10-0xFF14)
    0xFF, 0x3F, 0x00, 0xFF, 0xBF,                       // NR20-NR24 (0xFF15-0xFF19)
    0x7F, 0xFF, 0x9F, 0xFF, 0xBF,                       // NR30-NR34 (0xFF1A-0xFF1E)
    0xFF, 0xFF, 0x00, 0x00, 0xBF,                       // NR40-NR44 (0xFF1F-0xFF23)
    0x00, 0x00, 0x70, 0xFF, 0xFF,                       // NR50-NR54 (0xFF24-0xFF28)
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF,                       // --------- (0xFF29-0xFF2D)
    0xFF, 0xFF,                                         // --------- (0xFF2E-0xFF2F)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     // WaveRAM - (0xFF30-0xFF37)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     // WaveRAM - (0xFF38-0xFF3F)
};

inline void Audio::Tick(unsigned int clockCycles)
{
    m_Time += clockCycles;
    m_AbsoluteTime += clockCycles;

    if (m_Time >= kSoundFrameLength)
    {
        EndFrame();
        m_Time -= kSoundFrameLength;
        m_AbsoluteTime = 0;
    }
}


#endif	/* AUDIO_H */
