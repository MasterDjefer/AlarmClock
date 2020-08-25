#include "alarmworker.h"

AlarmWorker::AlarmWorker(int index, int hour, int minute) : mIndex(index), mHour(hour), mMinute(minute), isRunning(true)
{
}

void AlarmWorker::getCurrentTime(struct tm *tmTime)
{
    time_t t = time(NULL);
    struct tm* tmT = localtime(&t);
    tmTime->tm_hour = tmT->tm_hour;
    tmTime->tm_min = tmT->tm_min;
}

void AlarmWorker::start()
{
    struct tm currentTime;

    while(getRunningState())
    {
        getCurrentTime(&currentTime);

        qDebug() << mHour << mMinute;
        qDebug() << currentTime.tm_hour << currentTime.tm_min;

        if (mHour == currentTime.tm_hour && mMinute == currentTime.tm_min)
        {
            emit finished(mIndex);
            return;
        }
        QThread::sleep(5);
    }
}

void AlarmWorker::stop()
{
    QMutexLocker locker(&mutex);
    isRunning = false;
}

void AlarmWorker::updateTime(int hour, int minute)
{
    QMutexLocker locker(&mutex);
    mMinute = minute;
    mHour = hour;
}

bool AlarmWorker::getRunningState()
{
    QMutexLocker locker(&mutex);
    return isRunning;
}
