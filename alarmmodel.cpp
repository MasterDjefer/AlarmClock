#include "alarmmodel.h"

AlarmModel::AlarmModel(QObject *parent) : QAbstractListModel(parent)
{
    mAlarmsData << AlarmData{1, 2, true, "a", currentDate()} << AlarmData{1, 3, false, "b", currentDate()};
    mAlarmsData << AlarmData{1, 4, true, "c", currentDate()} << AlarmData{1, 5, true, "d", currentDate()};
    mAlarmsData << AlarmData{1, 6, true, "e", currentDate()} << AlarmData{1, 7, false, "f", currentDate()};
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
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> AlarmModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TimeRole]        = "time";
    roles[IsEnabledRole]   = "isEnabled";
    roles[DescriptionRole] = "description";
    roles[CreateDateRole] = "createDate";

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

void AlarmModel::add(const QString& hour, const QString& minute)
{
    beginInsertRows(QModelIndex(), mAlarmsData.size(), mAlarmsData.size());
    mAlarmsData.append(AlarmData{hour.toInt(), minute.toInt(), true, "", currentDate()});
    endInsertRows();
}

void AlarmModel::updateTime(int index, const QString &hour, const QString &minute)
{
    assert(index >=0 && index < mAlarmsData.size());
    mAlarmsData[index].hour = hour.toInt();
    mAlarmsData[index].minute = minute.toInt();

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

void AlarmModel::updateEnabledState(int index, bool isEnabled)
{
    if (index >=0 && index < mAlarmsData.size())
    {
        mAlarmsData[index].isEnabled = isEnabled;

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

    beginRemoveRows(QModelIndex(), index, index);
    mAlarmsData.erase(mAlarmsData.begin() + index);
    endRemoveRows();
}

QString AlarmModel::getDescription(int index)
{
    if (index >= mAlarmsData.size())
    {
        qDebug() << "error";
        return "";
    }

    return mAlarmsData.at(index).description;
}
