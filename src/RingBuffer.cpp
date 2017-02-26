#include <algorithm>

#include <QDebug>
#include "RingBuffer.h"


RingBuffer::RingBuffer(QObject *parent)
    : QIODevice(parent)
    , read(0), write(0)
    , read_i(0) , write_i(0)
    , buf_len(BUFF_SIZE)
    , sample_count(BUFF_SIZE)
{
}

RingBuffer::~RingBuffer()
{
}

void RingBuffer::setSamplePeriod(long samples)
{
    buf_len = samples;
}

void RingBuffer::start()
{
    open(QIODevice::ReadOnly);
    write.release(BUFF_SIZE);
}


void RingBuffer::stop()
{
    close();
}


qint64 RingBuffer::readData(char *data, qint64 maxSize)
{
    qint64 buf_size = buf_len * sizeof(sample_t);
    long chunks_writeable = maxSize / buf_size;
    long chunks_readable = read.available() / buf_len;
    long read_count = buf_len * qMin(chunks_writeable, chunks_readable);

    if (read_count) {
        read.acquire(read_count);
        const char *buf = reinterpret_cast<char*>(&buffers[read_i]);
        qint64 sample_size = qMin(sample_count - read_i, read_count);
        qint64 bytes_size = sample_size * sizeof(sample_t);
        std::copy(buf, &buf[bytes_size], data);
        read_i += sample_size;
        if (read_i >= sample_count) {
            qint64 remain = read_count - sample_size;
            const char *buf = reinterpret_cast<char*>(buffers);
            std::copy(buf, &buf[remain * sizeof(sample_t)], data + bytes_size);
            read_i = remain;
        }
        write.release(read_count);
        return read_count * sizeof(sample_t);
    } else {
        qint64 size = qMin(buf_size, maxSize);
        memset(data, 0, size);
        return size;
    }
}


qint64 RingBuffer::writeData(const char *, qint64)
{
    return 0;
}

qint64 RingBuffer::bytesAvailable() const
{
    return read.available() * sizeof(sample_t) + QIODevice::bytesAvailable();
}

void RingBuffer::write_samples(const sample_t *in, long count)
{
    while (count) {
        long write_count = qMin(count, sample_count - write_i);
        if (not write.tryAcquire(write_count)) {
            write_count = qMin(buf_len, write_count);
            write.acquire(write_count);
        }
        std::copy(in, &in[write_count], &buffers[write_i]);
        read.release(write_count);
        count -= write_count;
        write_i += write_count;
        in += write_count;
        if (write_i >= sample_count) {
            write_i = 0;
        }
    }
}
