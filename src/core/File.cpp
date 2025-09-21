/* GCompris - File.cpp
 *
 * SPDX-FileCopyrightText: 2014, 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "File.h"

#include <QFile>
#include <QDir>
#include <QString>
#include <QTextStream>

File::File(QObject *parent) :
    QObject(parent)
{
}

QString File::name() const
{
    return m_name;
}

QString File::sanitizeUrl(const QString &url)
{
    QString target(url);

    // make sure we strip off invalid URL schemes:
    // for windows, where path starts with C:/...
    if (target.startsWith(QLatin1String("file://")) && target.indexOf(":", 9) == 9) {
        target.remove(0, 8);
    }
    // for linux, where path starts with /...
    else if (target.startsWith(QLatin1String("file://"))) {
        target.remove(0, 7);
    }
    else if (target.startsWith(QLatin1String("qrc:/")))
        target.remove(0, 3);

    return target;
}

void File::setName(const QString &str)
{
    QString target = sanitizeUrl(str);

    if (target != m_name) {
        m_name = target;
        Q_EMIT nameChanged();
    }
}

QString File::read(const QString &name)
{
    if (!name.isEmpty())
        setName(name);

    if (m_name.isEmpty()) {
        Q_EMIT error("source is empty");
        return QString();
    }

    QFile file(m_name);
    QString fileContent;
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream t(&file);
        /* Force utf-8 : for some languages, it seems to be loaded in other
          encoding even if the file is in utf-8 */
        t.setEncoding(QStringConverter::Utf8);
        fileContent = t.readAll();
        file.close();
    }
    else {
        Q_EMIT error("Unable to open the file");
        return QString();
    }
    return fileContent;
}

bool File::write(const QString &data, const QString &name)
{
    if (!name.isEmpty())
        setName(name);

    if (m_name.isEmpty()) {
        Q_EMIT error("source is empty");
        return false;
    }

    QFile file(m_name);
    if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
        Q_EMIT error("could not open file " + m_name);
        return false;
    }

    QTextStream out(&file);
    /* Force utf-8 : needed at least for Windows */
    out.setEncoding(QStringConverter::Utf8);
    out << data;

    file.close();

    return true;
}

bool File::append(const QString &data, const QString &name)
{
    if (!name.isEmpty())
        setName(name);

    if (m_name.isEmpty()) {
        Q_EMIT error("source is empty");
        return false;
    }

    QFile file(m_name);
    if (!file.open(QFile::WriteOnly | QFile::Append)) {
        Q_EMIT error("could not open file " + m_name);
        return false;
    }

    QTextStream out(&file);
    /* Force utf-8 : needed at least for Windows */
    out.setEncoding(QStringConverter::Utf8);

    out << data;

    file.close();

    return true;
}

bool File::copy(const QString &sourceFile, const QString &name)
{
    if (!name.isEmpty())
        setName(name);

    if (m_name.isEmpty()) {
        Q_EMIT error("source is empty");
        return false;
    }

    if (QFile::exists(m_name)) {
        QFile::remove(m_name);
    }

    QString sanitizedSourceFile = sanitizeUrl(sourceFile);
    QFile::copy(sanitizedSourceFile, m_name);

    return true;
}

bool File::exists(const QString &path)
{
    return QFile::exists(sanitizeUrl(path));
}

bool File::mkpath(const QString &path)
{
    QDir dir;
    return dir.mkpath(dir.filePath(sanitizeUrl(path)));
}

bool File::rmpath(const QString &path)
{
    return QFile::remove(sanitizeUrl(path));
}

#include "moc_File.cpp"
