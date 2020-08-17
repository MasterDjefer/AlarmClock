#include "alarmmodel.h"

AlarmModel::AlarmModel(QObject *parent) : QAbstractListModel(parent)
{
    mAlarmsData << AlarmData{1, 2, true, "lol"} << AlarmData{1, 3, false, "asf"} << AlarmData{1, 4, true, "xvb"};
    mAlarmsData << AlarmData{1, 2, true, "lol"} << AlarmData{1, 3, false, "asf"} << AlarmData{1, 4, true, "xvb"};
    mAlarmsData << AlarmData{1, 2, true, "lol"} << AlarmData{1, 3, false, "asf"} << AlarmData{1, 4, true, "xvb"};
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

    return roles;
}

QString AlarmModel::formatTime(int hour, int minute)
{
    return ((hour < 10 ? "0" : "") + QString::number(hour)) + ":" + ((hour < 10 ? "0" : "") + QString::number(minute));
}

void AlarmModel::add()
{
    beginInsertRows(QModelIndex(), mAlarmsData.size(), mAlarmsData.size());
    mAlarmsData.append(AlarmData());
    endInsertRows();
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

    return QString(mAlarmsData.at(index).description);
}
