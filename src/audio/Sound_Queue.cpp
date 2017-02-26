#include <algorithm>

#include <QDebug>

#include "Sound_Queue.h"


Sound_Queue::Sound_Queue() : buffer(0), audio(0) { }

Sound_Queue::~Sound_Queue()
{
    if (audio) {
        delete audio;
    }
}


const char* Sound_Queue::start(long sample_rate, int chan_count)
{
    QAudioFormat as;
    as.setSampleType(QAudioFormat::SignedInt);
    as.setSampleSize(16);
    as.setCodec("audio/pcm");
    as.setSampleRate((int)sample_rate);
    as.setChannelCount(chan_count);
    QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());

    if (audio == 0) {
        if (!info.isFormatSupported(as)) {
            qDebug() << "The requested format is not supported: " << as;
            qDebug() << "The nearest format is: " << info.nearestFormat(as);
            qDebug() << "And the prefferred format is: " << info.preferredFormat();
            return "format not supported";
        } else {
            audio = new QAudioOutput(as, this);
            buffer.start();
            audio->start(&buffer);
            buffer.setSamplePeriod(audio->periodSize() / sizeof (sample_t));
        }
    }

    qDebug() << "Preferred audio format: " << info.preferredFormat();
    qDebug() << "The requested format is: " << as;
    qDebug() << "Audio Buffer Size:" << audio->bufferSize();
    qDebug() << "Audio Period Size:" << audio->periodSize();
    return NULL;
}


void Sound_Queue::restart()
{
    if (audio) {
        audio->reset();
    }
}


void Sound_Queue::stop()
{
    if (audio) {
        audio->stop();
    }
}

void Sound_Queue::write(const sample_t *in, long count)
{
    buffer.write_samples(in, count);
}
