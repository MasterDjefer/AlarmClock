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

    while(isRunning)
    {
        getCurrentTime(&currentTime);

        qDebug() << mHour << mMinute;
        qDebug() << currentTime.tm_hour << currentTime.tm_min;

        if (mHour == currentTime.tm_hour && mMinute == currentTime.tm_min)
        {
            emit alarmDone(mIndex);
            return;
        }
        QThread::msleep(2000);
    }
    emit alarmStoped(mIndex);
}

void AlarmWorker::stop()
{
    isRunning = false;
}

void AlarmWorker::updateTime(int hour, int minute)
{
    mMinute = minute;
    mHour = hour;
}

bool AlarmWorker::getRunningState()
{
    return isRunning;
}
