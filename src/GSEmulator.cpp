#include <QDebug>
#include <QtQuick/qquickwindow.h>
#include <QFile>
#include <QThread>
#include <QFileInfo>
#include <QFileDialog>
#include <QStandardPaths>
#include <QTextStream>
#include <QIODevice>
#include <QTime>


#include "GSEmulator.h"

GSEmulator::GSEmulator() : m_renderer(0)
{
    connect(this, &QQuickItem::windowChanged, this, &GSEmulator::handleWindowChanged);
    windowChanged(window());
    m_emu = new EmulationRunner(this);
    m_emu->start(QThread::TimeCriticalPriority);
}

void GSEmulator::timerEvent(QTimerEvent *)
{
    window()->update();
}

void GSEmulator::setColor(QColor c)
{
    m_color = c;
    if (m_renderer) {
        m_renderer->setColor(c);
    }
}


void GSEmulator::setRect(QRect r)
{
    if (r != m_rect) {
        m_rect = r;
        emit rectChanged();
    }
}


void GSEmulator::handleWindowChanged(QQuickWindow *win)
{
    if (win) {
        connect(win, &QQuickWindow::beforeSynchronizing,
                this, &GSEmulator::sync, Qt::DirectConnection);
        connect(win, &QQuickWindow::sceneGraphInvalidated,
                this, &GSEmulator::cleanup, Qt::DirectConnection);
        win->setClearBeforeRendering(false);
    }
}


void GSEmulator::cleanup()
{
    SafeDelete(m_renderer);
}


void GSEmulator::sync()
{
    if (!m_renderer) {
        m_renderer = new PixelRenderer(GS_SMS_WIDTH, GS_SMS_HEIGHT, m_emu);
        connect(window(), &QQuickWindow::beforeRendering,
                m_renderer, &PixelRenderer::paint, Qt::DirectConnection);
        m_renderer->setColor(color());
    }

    QSize size = window()->size() * window()->devicePixelRatio();
    m_renderer->setWindow(window());
    m_renderer->setViewRect(QRect(QPoint(0, 0), size));
    setRect(m_renderer->viewRect());
    window()->update();
}


void GSEmulator::upPressed()    {
    keyPressed(Joypad_1, Key_Up);
}

void GSEmulator::leftPressed()  {
    keyPressed(Joypad_1, Key_Left);
}

void GSEmulator::rightPressed() {
    keyPressed(Joypad_1, Key_Right);
}

void GSEmulator::downPressed()  {
    keyPressed(Joypad_1, Key_Down);
}

void GSEmulator::startPressed()
{
    if (not m_emu->isGameGear()) {
        aPressed();
    } else {
        keyPressed(Joypad_1, Key_Start);
    }
}

void GSEmulator::aPressed()     {
    keyPressed(Joypad_1, Key_1);
}

void GSEmulator::bPressed()     {
    keyPressed(Joypad_1, Key_2);
}

void GSEmulator::upReleased()   {
    keyReleased(Joypad_1, Key_Up);
}

void GSEmulator::leftReleased() {
    keyReleased(Joypad_1, Key_Left);
}

void GSEmulator::rightReleased() {
    keyReleased(Joypad_1, Key_Right);
}

void GSEmulator::downReleased() {
    keyReleased(Joypad_1, Key_Down);
}

void GSEmulator::startReleased() {
    if (not m_emu->isGameGear()) {
        aReleased();
    } else {
        keyReleased(Joypad_1, Key_Start);
    }
}

void GSEmulator::aReleased() 	{
    keyReleased(Joypad_1, Key_1);
}

void GSEmulator::bReleased() 	{
    keyReleased(Joypad_1, Key_2);
}


bool GSEmulator::loadRom(QString path)
{
    save();
    bool result = m_emu->loadRom(path);
    if (result) {
        if (m_emu->isGameGear()) {
            m_renderer->setSubView(GS_GG_X_OFFSET, GS_GG_Y_OFFSET + 16, GS_GG_WIDTH, GS_GG_HEIGHT);
        } else {
            m_renderer->setSubView(0, 0, GS_SMS_WIDTH, GS_SMS_HEIGHT);
        }
    }
    return result;
}

GSEmulator::~GSEmulator() { }

void GSEmulator::pause() {
    m_emu->pause();
}
void GSEmulator::play() {
    m_emu->play();
}

void GSEmulator::shutdown()
{
    m_emu->pause();
    m_emu->save();
    m_emu->stop();
}

void GSEmulator::save()
{
    m_emu->save();
}


bool GSEmulator::requestRom()
{
    QString path = QFileDialog::getOpenFileName(NULL, "Load Rom", "", "*.*");
    bool result = loadRom(path);
    qDebug() << "result" << result << "for path" << path;
    return result;
}


void GSEmulator::mute(bool m)
{
    m_emu->mute(m);
}

void GSEmulator::keyPressed(GS_Joypads joypad, GS_Keys key)
{
    m_emu->keyPressed(joypad, key);
}

void GSEmulator::keyReleased(GS_Joypads joypad, GS_Keys key)
{
    m_emu->keyReleased(joypad, key);
}
