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
    getCurrentTime(&currentTime);

    if (mHour == currentTime.tm_hour && mMinute == currentTime.tm_min)
    {
        emit alarmDone(mIndex);
    }
}

void AlarmWorker::updateTime(int hour, int minute)
{
    mMinute = minute;
    mHour = hour;
}
