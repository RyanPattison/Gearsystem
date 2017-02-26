#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#include <QIODevice>
#include <QObject>
#include <QSemaphore>

class RingBuffer : public QIODevice
{
    Q_OBJECT
public:
    RingBuffer(QObject *parent);
    ~RingBuffer();
    typedef short sample_t;

    void start();
    void stop();

    qint64 readData(char *data, qint64 maxSize);
    qint64 writeData(const char *, qint64);
    qint64 bytesAvailable() const;

    void write_samples(const sample_t *in, long count);
    void setSamplePeriod(long samples);
private:
    enum { BUFF_SIZE=44100/2 };
    QSemaphore read, write;
    long read_i, write_i;
    long buf_len;
    sample_t buffers[BUFF_SIZE];
    long sample_count;
};

#endif

