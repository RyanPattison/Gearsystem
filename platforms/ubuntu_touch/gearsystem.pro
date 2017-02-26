UBUNTU_MANIFEST_FILE=manifest.json.in

UBUNTU_TRANSLATION_DOMAIN="gearsystem.rpattison"

UBUNTU_TRANSLATION_SOURCES+= \
    $$files(*.qml,true) \
    $$files(*.js,true)  \
    $$files(*.cpp,true) \
    $$files(*.h,true) \
    $$files(*.desktop,true)


UBUNTU_PO_FILES+=$$files(po/*.po)

TEMPLATE = app
TARGET = gearsystem

load(ubuntu-click)

QT += core gui widgets multimedia qml quick
CONFIG += c++11

RESOURCES += gearsystem.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  gearsystem.apparmor \
	       gearsystem-content.json \
               gearsystem.png 

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               gearsystem.rpattison.desktop 

#specify where the qml/js files are installed to
qml_files.path = /gearsystem
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /
config_files.files += $${CONF_FILES}

desktop_file.path = /
desktop_file.files = $$OUT_PWD/gearsystem.rpattison.desktop 
desktop_file.CONFIG += no_check_exist 



SOURCES += \
    ../../src/audio/Blip_Buffer.cpp \
    ../../src/audio/Effects_Buffer.cpp \
    ../../src/audio/Multi_Buffer.cpp \
    ../../src/audio/Sms_Apu.cpp \
    ../../src/audio/Sound_Queue.cpp \
    ../../src/Audio.cpp \
    ../../src/Cartridge.cpp \
    ../../src/CodemastersMemoryRule.cpp \
    ../../src/GameGearIOPorts.cpp \
    ../../src/GearsystemCore.cpp \
    ../../src/Input.cpp \
    ../../src/Memory.cpp \
    ../../src/MemoryRule.cpp \
    ../../src/opcodes.cpp \
    ../../src/opcodes_cb.cpp \
    ../../src/opcodes_ed.cpp \
    ../../src/Processor.cpp \
    ../../src/RomOnlyMemoryRule.cpp \
    ../../src/SegaMemoryRule.cpp \
    ../../src/SmsIOPorts.cpp \
    ../../src/Video.cpp \
    ../../src/miniz/miniz.c \
    ../../src/PixelRenderer.cpp \
    ../../src/GSEmulator.cpp \
    ../../src/EmulationRunner.cpp \
    ../../src/RingBuffer.cpp \
    ../../src/main.cpp 

HEADERS  += \
    ../../src/audio/blargg_common.h \
    ../../src/audio/blargg_config.h \
    ../../src/audio/blargg_source.h \
    ../../src/audio/Blip_Buffer.h \
    ../../src/audio/Blip_Synth.h \
    ../../src/audio/Effects_Buffer.h \
    ../../src/audio/Multi_Buffer.h \
    ../../src/audio/Sms_Apu.h \
    ../../src/audio/Sms_Oscs.h \
    ../../src/audio/Sound_Queue.h \
    ../../src/Audio.h \
    ../../src/Cartridge.h \
    ../../src/CodemastersMemoryRule.h \
    ../../src/definitions.h \
    ../../src/EightBitRegister.h \
    ../../src/game_db.h \
    ../../src/GSEmulator.h \
    ../../src/EmulationRunner.h \
    ../../src/RingBuffer.h \
    ../../src/PixelRenderer.h 

target.path = $${UBUNTU_CLICK_BINARY_PATH}

INSTALLS += target config_files qml_files desktop_file 
