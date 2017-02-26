/*
 * Gearsystem - Sega Master System / Game Gear Emulator
 * Copyright (C) 2013  Ignacio Sanchez

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

#ifndef MEMORYRULE_H
#define	MEMORYRULE_H

#include "definitions.h"

class Memory;
class Cartridge;

class MemoryRule
{
public:
    MemoryRule(Memory* pMemory, Cartridge* pCartridge);
    virtual ~MemoryRule();
    virtual u8 PerformRead(u16 address) = 0;
    virtual void PerformWrite(u16 address, u8 value) = 0;
    virtual void Reset() = 0;
    virtual void SaveRam(std::ofstream &file);
    virtual bool LoadRam(std::ifstream &file, s32 fileSize);
    virtual bool PersistedRAM();

protected:
    Memory* m_pMemory;
    Cartridge* m_pCartridge;
};

#endif	/* MEMORYRULE_H */

