#include "alarmworker.h"

AlarmWorker::AlarmWorker(int index, int hour, int minute) : mIndex(index)
{
    updateTime(hour, minute);
}

CTime AlarmWorker::getCurrentTime()
{
    time_t t = time(NULL);
    struct tm* tmT = localtime(&t);
    tmT->tm_sec = 0;
    tmT->tm_wday = 0;

    return *tmT;
}

int AlarmWorker::getCurrentWeekDay()
{
    time_t t = time(NULL);
    struct tm* tmT = localtime(&t);

    return tmT->tm_wday ? tmT->tm_wday - 1 : DAYS_IN_WEEK - 1;
}

time_t AlarmWorker::tomorrowTime()
{
    return time(NULL) + 86400;
}

void AlarmWorker::start()
{
    CTime currentTime = getCurrentTime();

    if (isRepeatable())
    {
        if (!memcmp(&mTime, &currentTime, sizeof(CTime)) && isProperDay(getCurrentWeekDay()))
        {
            emit alarmDone(mIndex, isRepeatable());
            updateTime(mTime.tm_hour, mTime.tm_mday);
        }
    }
    else
    {
        if (!memcmp(&mTime, &currentTime, sizeof(CTime)))
        {
            emit alarmDone(mIndex, isRepeatable());
        }
    }
}

void AlarmWorker::updateTime(int hour, int minute)
{
    struct tm currentTime = getCurrentTime();

    time_t tTime;
    if (hour == currentTime.tm_hour && minute == currentTime.tm_min)
    {
        tTime = tomorrowTime();
    }
    else
    {
        tTime = time(NULL);
    }

    CTime* tempT = localtime(&tTime);

    tempT->tm_hour = hour;
    tempT->tm_min = minute;
    memcpy(&mTime, tempT, sizeof(CTime));
    mTime.tm_sec = 0;
    mTime.tm_wday = 0;
}

void AlarmWorker::updateDays(bool days[])
{
    memcpy(mDays, days, sizeof(bool) * DAYS_IN_WEEK);
}

bool AlarmWorker::isProperDay(int currentWeekDay)
{
    for (int i = 0; i < DAYS_IN_WEEK; ++i)
    {
        if (currentWeekDay == i && mDays[i])
            return true;
    }

    return false;
}

bool AlarmWorker::isRepeatable()
{
    for (int i = 0; i < DAYS_IN_WEEK; ++i)
    {
        if (mDays[i])
            return true;
    }

    return false;
}
