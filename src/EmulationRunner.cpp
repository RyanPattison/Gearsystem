#include <QDebug>
#include <QFile>
#include <QDir>
#include <QThread>
#include <QFileInfo>
#include <QStandardPaths>
#include <QTime>

#include "EmulationRunner.h"
#include "Cartridge.h"

QList<QThread *> EmulationRunner::threads;

EmulationRunner::EmulationRunner(QObject *parent) : QThread(parent)
{
    readFrame(m_pixels, 256);
    threads.append(this);
    m_core.Init();
    m_isPaused = true;
    m_isRunning = true;
}


bool EmulationRunner::isGameGear()
{
    if (m_core.GetCartridge()) {
        return m_core.GetCartridge()->IsGameGear();
    }
    return false;
}

void EmulationRunner::run()
{
    while (m_isRunning) {
        m_time.start();
        for (int i = 0; i < 3; ++i) { // run 3 frames, at 60 fps, 50ms for 3.
            if (!m_isPaused) {
                m_core.RunToVBlank(m_buffer);
                int elapsed = m_time.elapsed();
                int rest = ((i + 1) * 16 - elapsed);
                if (m_pixel_lock.tryLock(rest)) {
                    readFrame(m_pixels, 256);
                    m_pixel_lock.unlock();
                }
            }
        }
        int elapsed = m_time.elapsed();
        int rest = 50 - elapsed;
        if (rest > 0) msleep(rest);
    }
}

void EmulationRunner::mute(bool m)
{
    m_core.EnableSound(!m);
}

unsigned char *EmulationRunner::openPixels()
{
    return m_pixels;
}


void EmulationRunner::closePixels()
{
}


EmulationRunner::~EmulationRunner() { }


bool EmulationRunner::loadRom(QString path)
{
    std::string cppstr = path.toStdString();
    const char *local_path = cppstr.c_str();
    m_lock.lock();
    bool result = m_core.LoadROM(local_path);
    if (result) {
        qDebug() << "successful load ROM";
        QString save_path = defaultSavePath();
        if (QFileInfo::exists(save_path)) {
            qDebug() << "Loading ram save file";
            m_core.LoadRam(save_path.toStdString().c_str());
            qDebug() << "Loaded Save File";
        } else {
            qDebug() << "No Save File Found. checked: " << save_path;
        }
    } else {
        qDebug() << "Failed to Load ROM";
    }
    m_lock.unlock();
    return result;
}


void EmulationRunner::keyPressed(GS_Joypads joypad ,GS_Keys key)
{
    m_core.KeyPressed(joypad, key);
}


void EmulationRunner::keyReleased(GS_Joypads joypad ,GS_Keys key)
{
    m_core.KeyReleased(joypad, key);
}

QString EmulationRunner::defaultPath()
{
    std::string rom_name = m_core.GetCartridge()->GetFileName();
    if (rom_name.empty()) return QString();
    const size_t slash_loc = rom_name.find_last_of("\\/");
    if (std::string::npos != slash_loc) {
        rom_name.erase(0, slash_loc + 1);
    }
    const size_t ext_loc = rom_name.rfind('.');
    if (std::string::npos != ext_loc)
    {
        rom_name.erase(ext_loc);
    }
    rom_name.erase(remove_if(rom_name.begin(), rom_name.end(), ::isspace), rom_name.end());

    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir saveloc(path);
    if (!saveloc.exists()) {
        if (not saveloc.mkpath(".")) {
            qDebug() << "Failed to create save path: " << path;
        }
    }

    path.append(QString(("/" + rom_name).c_str()));
    return path;
}


QString EmulationRunner::defaultSavePath()
{
    QString path = defaultPath();
    if (path.isNull()) {
        return path;
    } else {
        path.append(".gearsystem");
        return path;
    }
}

void EmulationRunner::save()
{
    m_lock.lock();
    QString path = defaultSavePath();
    if (!path.isNull()) {
        qDebug() << "Saving Game to: " << path;
        if (not m_core.SaveRam(path.toStdString().c_str())) {
            qDebug() << "Failed to save ram to: " << path;
        }
    } else {
        qDebug() << "No Game Loaded to Save";
    }
    m_lock.unlock();
}

void EmulationRunner::pause()
{
    m_isPaused = true;
}


void EmulationRunner::play()
{
    m_isPaused = false;
}

void EmulationRunner::stop()
{
    m_isRunning = false;
}


void EmulationRunner::readFrame(unsigned char *pixels, int)
{
    GS_Color *buff = reinterpret_cast<GS_Color*>(pixels);
    GS_Color *src = reinterpret_cast<GS_Color*>(m_buffer);
    std::copy(src, &src[GS_SMS_HEIGHT * GS_SMS_WIDTH], buff);
}
