#include "alarmmodel.h"

AlarmModel::AlarmModel(QObject *parent) : QAbstractListModel(parent)
{
    mAlarmsData << AlarmData{10, 20, false, "a", currentDate(), false, {false, true, false, false, false, false, false}, "", getUniqueId()};
    mAlarmsData << AlarmData{10, 20, false, "b", currentDate(), false, {false, false, false, true, false, false, false}, "", getUniqueId()};
    mAlarmsData << AlarmData{10, 20, false, "c", currentDate(), false, {false, false, false, false, true, false, false}, "", getUniqueId()};
}

int AlarmModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
    {
        return 0;
    }

    return mAlarmsData.size();
}

QVariant AlarmModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }

    switch (role)
    {
    case TimeRole:
        return QVariant(formatTime(mAlarmsData.at(index.row()).hour, mAlarmsData.at(index.row()).minute));
    case IsEnabledRole:
        return QVariant(mAlarmsData.at(index.row()).isEnabled);
    case DescriptionRole:
        return QVariant(mAlarmsData.at(index.row()).description);
    case CreateDateRole:
        return QVariant(mAlarmsData.at(index.row()).createDate);
    case IsSelectedRole:
        return QVariant(mAlarmsData.at(index.row()).isSelected);
    case HourRole:
        return QVariant(mAlarmsData[index.row()].hour);
    case MinuteRole:
        return QVariant(mAlarmsData[index.row()].minute);
    case RepeatOnDaysRole:
        return QVariant::fromValue(QVector<bool>(mAlarmsData[index.row()].repeatOnDays, mAlarmsData[index.row()].repeatOnDays + DAYS_IN_WEEK));
    case FormatedRepeatOnDaysRole:
        return QVariant(formatDays(mAlarmsData[index.row()].repeatOnDays));
    case SongNameRole:
        return QVariant(songName(mAlarmsData[index.row()].songPath));
    default:
        return QVariant();
    }
}

bool AlarmModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid())
    {
        return false;
    }

    switch (role)
    {
    case IsEnabledRole:
        mAlarmsData[index.row()].isEnabled = value.toBool();
        if (mAlarmsData[index.row()].isEnabled)
        {
            mSession->addTimer(mAlarmsData[index.row()].id, mAlarmsData[index.row()].hour, mAlarmsData[index.row()].minute);
            mSession->updateSong(mAlarmsData[index.row()].id, mAlarmsData[index.row()].songPath);
        }
        else
        {
            mSession->removeTimer(mAlarmsData[index.row()].id);
        }
        break;
    case IsSelectedRole:
        mAlarmsData[index.row()].isSelected = value.toBool();
        break;
    default:
        return false;
    }

    emit dataChanged(index, index);

    return true;
}

Qt::ItemFlags AlarmModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::ItemIsEnabled;

    return QAbstractListModel::flags(index) | Qt::ItemIsEditable;
}

QHash<int, QByteArray> AlarmModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TimeRole]         = "time";
    roles[IsEnabledRole]    = "isEnabled";
    roles[DescriptionRole]  = "description";
    roles[CreateDateRole]   = "createDate";
    roles[IsSelectedRole]   = "isSelected";
    roles[HourRole]         = "hour";
    roles[MinuteRole]       = "minute";
    roles[RepeatOnDaysRole] = "repeatOnDays";
    roles[FormatedRepeatOnDaysRole] = "formatedRepeatOnDays";
    roles[SongNameRole]     = "songName";

    return roles;
}

QString AlarmModel::formatTime(int hour, int minute)
{
    return ((hour < 10 ? "0" : "") + QString::number(hour)) + ":" + ((minute < 10 ? "0" : "") + QString::number(minute));
}

QString AlarmModel::currentDate()
{
    return QDateTime::currentDateTime().toString("dd.MM.yyyy");
}

QString AlarmModel::songName(const QString &songPath)
{
    return songPath.mid(songPath.lastIndexOf('/') + 1);
}

int AlarmModel::getUniqueId()
{
    return mUniqueId++;
}

QString AlarmModel::formatDays(const bool days[])
{
    QString formatedDays;

    if (days[Monday])    formatedDays += "Mon ";
    if (days[Tuesday])   formatedDays += "Tue ";
    if (days[Wednesday]) formatedDays += "Wed ";
    if (days[Thursday])  formatedDays += "Thu ";
    if (days[Friday])    formatedDays += "Fri ";
    if (days[Saturday])  formatedDays += "Sat ";
    if (days[Sunday])    formatedDays += "Sun ";

    if (!formatedDays.isEmpty()) formatedDays.remove(formatedDays.size() - 1, 1);

    return formatedDays;
}

void AlarmModel::add(int hour, int minute, const QString& songPath)
{
    beginInsertRows(QModelIndex(), mAlarmsData.size(), mAlarmsData.size());
    mAlarmsData.append(AlarmData{hour, minute, true, "", currentDate(), false, {false, false, false, false, false, false, false}, songPath, getUniqueId()});
    endInsertRows();
}

void AlarmModel::updateTime(int index, int hour, int minute)
{
    assert(index >= 0 && index < mAlarmsData.size());
    mAlarmsData[index].hour = hour;
    mAlarmsData[index].minute = minute;
    mSession->updateTime(mAlarmsData[index].id, hour, minute);

    QModelIndex modelIndex = createIndex(index, index, nullptr);
    emit dataChanged(modelIndex, modelIndex);
}

void AlarmModel::updateDescription(int index, const QString &description)
{
    if (index >=0 && index < mAlarmsData.size())
    {
        mAlarmsData[index].description = description;

        QModelIndex modelIndex = createIndex(index, index, nullptr);
        emit dataChanged(modelIndex, modelIndex);
    }
}

void AlarmModel::remove(int index)
{
    if (index >= mAlarmsData.size())
    {
        qDebug() << "error";
        return;
    }

    mSession->removeTimer(mAlarmsData[index].id);

    beginRemoveRows(QModelIndex(), index, index);
    mAlarmsData.erase(mAlarmsData.begin() + index);
    endRemoveRows();
}

void AlarmModel::unselectItems()
{
    for (int i = 0; i < mAlarmsData.size(); ++i)
    {
        mAlarmsData[i].isSelected = false;
        QModelIndex modelIndex = createIndex(i, i, nullptr);
        emit dataChanged(modelIndex, modelIndex);
    }
}

int AlarmModel::selectedItemIndex()
{
    for (int i = 0; i < mAlarmsData.size(); ++i)
    {
        if (mAlarmsData[i].isSelected)
            return i;
    }

    return -1;
}

void AlarmModel::setSession(AlarmSession *session)
{
    mSession = session;
}

QString AlarmModel::getTime(int index)
{
    assert(index >= 0 && index < mAlarmsData.size());
    return formatTime(mAlarmsData.at(index).hour, mAlarmsData.at(index).minute);
}

QString AlarmModel::getDescription(int index)
{
    assert(index >= 0 && index < mAlarmsData.size());
    return mAlarmsData.at(index).description;
}

void AlarmModel::updateRepeatOnDays(int index, int day, bool value)
{
    assert(index >= 0 && index < mAlarmsData.size());
    assert(day >= 0 && day < 8);

    mAlarmsData[index].repeatOnDays[day] = value;

    QModelIndex modelIndex = createIndex(index, index, nullptr);
    emit dataChanged(modelIndex, modelIndex);
}

void AlarmModel::updateSong(int index, const QString &songPath)
{
    assert(index >= 0 && index < mAlarmsData.size());
    mAlarmsData[index].songPath = songPath;
    mSession->updateSong(mAlarmsData[index].id, mAlarmsData[index].songPath);
}

QString AlarmModel::getSongName(int index)
{
    assert(index >= 0 && index < mAlarmsData.size());
    return songName(mAlarmsData.at(index).songPath);
}

int AlarmModel::getIndexById(int id)
{
    for (int i = 0; i < mAlarmsData.size(); ++i)
    {
        if (id == mAlarmsData.at(i).id)
        {
            return i;
        }
    }

    return -1;
}

int AlarmModel::mUniqueId = 0;
