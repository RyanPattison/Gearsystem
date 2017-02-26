#ifndef GBEmulator_H
#define GBEmulator_H

#include <QtQuick/QQuickItem>
#include <QMutex>
#include <QTime>

#include "gearsystem.h"
#include "PixelRenderer.h"
#include "EmulationRunner.h"


class GSEmulator : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QRect rect READ rect WRITE setRect NOTIFY rectChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor)

public:
    GSEmulator();
    ~GSEmulator();

    QRect rect() {
        return m_rect;
    }
    void setRect(QRect);
    void setColor(QColor);
    QColor color() {
        return m_color;
    }

    QString defaultPath() const;
    QString defaultSavePath() const;

    bool importROM(const char *rom_path);

signals:
    void rectChanged();

public slots:
    void sync();
    void cleanup();

    bool loadRom(QString path);
    void save();
    void play();
    void pause();

    void upPressed();
    void leftPressed();
    void rightPressed();
    void downPressed();

    void startPressed();
    void startReleased();

    void aPressed();
    void bPressed();

    void upReleased();
    void leftReleased();
    void rightReleased();
    void downReleased();


    void aReleased();
    void bReleased();

    void shutdown();
    bool requestRom();
    void mute(bool m);

private slots:
    void handleWindowChanged(QQuickWindow *win);
protected:
    void timerEvent(QTimerEvent *event) Q_DECL_OVERRIDE;

private:
    void keyPressed(GS_Joypads joypad, GS_Keys key);
    void keyReleased(GS_Joypads joypad, GS_Keys key);
    EmulationRunner *m_emu;
    PixelRenderer *m_renderer;
    QRect m_rect;
    QColor m_color;
};

#endif	/* GSEMULATOR_H */

