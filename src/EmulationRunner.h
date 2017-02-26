#ifndef Emulation_Runner_H
#define Emulation_Runner_H

#include <QMutex>
#include <QObject>
#include <QString>
#include <QThread>
#include <QTime>
#include <QThread>

#include "GearsystemCore.h"


class EmulationRunner : public QThread
{
    Q_OBJECT
public:
    EmulationRunner(QObject *parent);
    ~EmulationRunner();

    static void waitAll() {
        foreach (QThread *t, threads) {
            t->wait();
        }
    }

    unsigned char *openPixels();
    void closePixels();

    bool loadRom(QString path);

    void play();
    void pause();
    void stop();
    void save();
    void mute(bool m);

    void keyPressed(GS_Joypads joypad,  GS_Keys key);
    void keyReleased(GS_Joypads joypad, GS_Keys key);
    bool isGameGear();

protected:
    virtual void run();
    QString defaultPath();
    QString defaultSavePath();
    void readFrame(unsigned char *pixels, int width);

private:
    unsigned char m_pixels[256 * 256 * sizeof(GS_Color)];
    GS_Color m_buffer[GS_SMS_WIDTH * GS_SMS_HEIGHT];
    GearsystemCore m_core;
    QMutex m_lock;
    QMutex m_pixel_lock;
    bool m_isPaused;
    bool m_isRunning;
    QTime m_time;

    static QList<QThread *> threads;
};

#endif
