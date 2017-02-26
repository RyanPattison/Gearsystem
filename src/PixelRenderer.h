#ifndef PIXEL_RENDER_H
#define PIXEL_RENDER_H

#include <QOpenGLFunctions>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLFunctions>
#include <QOpenGLTexture>
#include <QQuickWindow>
#include <QMutex>
#include <QDebug>

#include "EmulationRunner.h"
#include "definitions.h"

QT_FORWARD_DECLARE_CLASS(QOpenGLShaderProgram);
QT_FORWARD_DECLARE_CLASS(QOpenGLTexture);
QT_FORWARD_DECLARE_CLASS(QOpenGLBuffer);


class PixelRenderer : public QObject, protected QOpenGLFunctions
{
    Q_OBJECT
public:

    PixelRenderer(int width, int height, EmulationRunner *emu);
    ~PixelRenderer();

    void setWindow(QQuickWindow *window) {
        m_window = window;
    }
    void setColor(QColor c) {
        m_color = c;
    }
    void setViewRect(QRect rect) {
        resizeGL(rect.width(), rect.height());
    }
    QRect viewRect() {
        return m_viewRect;
    }
    QColor color() {
        return m_color;
    }

    void setSubView(int x, int y, int width, int height);

public slots:
    void paint();

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int width, int height);
    void setViewport();
    void setTextureView();
    void setBufferSize(int width, int height);
    bool initializeTexture(QOpenGLTexture::TextureFormat format, bool cleanup);
    void readFrame();
    void paintScreen();

private:
    EmulationRunner *emu;
    QOpenGLShaderProgram *m_program;
    QOpenGLTexture *m_texture;
    QOpenGLBuffer *m_vertices;

    QQuickWindow *m_window;
    QColor m_color;
    QRect m_viewRect;
    QRectF m_tex_rect;
    int m_image_width, m_image_height;
    int m_width, m_height;
    int m_tex_width, m_tex_height;
    GLint m_texCoordAttr, m_vertexAttr;
    unsigned char buffer[256 * 256 * sizeof(GS_Color)];
};

#endif
