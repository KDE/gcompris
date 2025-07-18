/* GCompris - ApplicationInfo.cpp
 *
 * SPDX-FileCopyrightText: 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This file was originally created from Digia example code under BSD license
 * and heavily modified since then.
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "ApplicationInfo.h"

#include <QtQml>
#include <QGuiApplication>
#include <QScreen>
#include <QLocale>
#include <QQuickWindow>
#include <QSensor>

#include <QDebug>

#include <QFontDatabase>
#include <QDir>

QQuickWindow *ApplicationInfo::m_window = nullptr;
ApplicationInfo *ApplicationInfo::m_instance = nullptr;

ApplicationInfo::ApplicationInfo(QObject *parent) :
    QObject(parent)
{

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY) || defined(UBUNTUTOUCH)
    m_isMobile = true;
#else
    m_isMobile = false;
#endif

#if defined(Q_OS_ANDROID)
    // Put android before checking linux/unix as it is also a linux
    m_platform = Android;
#elif defined(UBUNTUTOUCH)
    m_platform = UbuntuTouchOS;
#elif defined(Q_OS_MACOS)
    m_platform = MacOSX;
#elif (defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
    m_platform = Linux;
#elif defined(Q_OS_WIN)
    m_platform = Windows;
#elif defined(Q_OS_IOS)
    m_platform = Ios;
#elif defined(Q_OS_BLACKBERRY)
    m_platform = Blackberry;
#else // default is Linux
    m_platform = Linux;
#endif

    m_isBox2DInstalled = false;

    QRect rect = qApp->primaryScreen()->geometry();
    m_ratio = qMin(qMax(rect.width(), rect.height()) / 800., qMin(rect.width(), rect.height()) / 520.);
    // calculate a factor for font-scaling, cf.
    // https://doc.qt.io/qt-5/scalability.html#calculating-scaling-ratio
    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = qApp->primaryScreen()->logicalDotsPerInch();

#if defined(UBUNTUTOUCH)
    m_fontRatio = floor(m_ratio * 10) / 10;
#else
    m_fontRatio = qMax(qreal(1.0), qMin(height * refDpi / (dpi * refHeight), width * refDpi / (dpi * refWidth)));
#endif
    m_isPortraitMode = m_isMobile ? rect.height() > rect.width() : false;
    m_applicationWidth = m_isMobile ? rect.width() : 1120;

    m_useSoftwareRenderer = false;

    if (m_isMobile)
        connect(qApp->primaryScreen(), &QScreen::physicalSizeChanged, this, &ApplicationInfo::notifyPortraitMode);

// @FIXME this does not work on iOS: https://bugreports.qt.io/browse/QTBUG-50624
#if !defined(Q_OS_IOS)
    // Get all symbol fonts to remove them
    m_excludedFonts = QFontDatabase::families(QFontDatabase::Symbol);
#endif
    // Get fonts from rcc
    const QStringList fontFilters = { "*.otf", "*.ttf" };
    m_fontsFromRcc = QDir(":/gcompris/src/core/resource/fonts").entryList(fontFilters);
}

ApplicationInfo::~ApplicationInfo()
{
    m_instance = nullptr;
}

bool ApplicationInfo::sensorIsSupported(const QString &sensorType)
{
    return QSensor::sensorTypes().contains(sensorType.toUtf8());
}

Qt::ScreenOrientation ApplicationInfo::getNativeOrientation()
{
    return QGuiApplication::primaryScreen()->nativeOrientation();
}

void ApplicationInfo::setApplicationWidth(const int newWidth)
{
    if (newWidth != m_applicationWidth) {
        m_applicationWidth = newWidth;
        Q_EMIT applicationWidthChanged();
    }
}

QStringList ApplicationInfo::getResourceDataPaths()
{
    return { ApplicationSettings::getInstance()->userDataPath(), "qrc:/gcompris/data" };
}

QString ApplicationInfo::getFilePath(const QString &file)
{
#if defined(Q_OS_ANDROID)
    return QString("assets:/share/GCompris/rcc/%1").arg(file);
#elif defined(Q_OS_MACOS)
    return QString("%1/../Resources/rcc/%2").arg(QCoreApplication::applicationDirPath(), file);
#elif defined(Q_OS_IOS)
    return QString("%1/rcc/%2").arg(QCoreApplication::applicationDirPath(), file);
#else
    return QString("%1/%2/rcc/%3").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER, file);
#endif
}

QString ApplicationInfo::getAudioFilePath(const QString &file)
{
    QString localeName = getVoicesLocale(ApplicationSettings::getInstance()->locale());
    return getAudioFilePathForLocale(file, localeName);
}

QString ApplicationInfo::getAudioFilePathForLocale(const QString &file,
                                                   const QString &localeName)
{
    QString filename = file;
    filename.replace("$LOCALE", localeName);
    filename.replace("$CA", CompressedAudio());
    // Absolute paths are returned as is
    if (file.startsWith('/') || file.startsWith(QLatin1String("qrc:")) || file.startsWith(':'))
        return filename;

    // For relative paths, look into resource folders if found
    const QStringList dataPaths = getResourceDataPaths();
    for (const QString &dataPath: dataPaths) {
        if (QFile::exists(dataPath + '/' + filename)) {
            if (dataPath.startsWith('/'))
                return "file://" + dataPath + '/' + filename;
            else
                return dataPath + '/' + filename;
        }
    }
    // If not found, return the default qrc:/gcompris/data path
    return dataPaths.last() + '/' + filename;
}

QString ApplicationInfo::getLocaleFilePath(const QString &file)
{
    QString localeShortName = localeShort();

    QString filename = file;
    filename.replace("$LOCALE", localeShortName);
    return filename;
}

QStringList ApplicationInfo::getSystemExcludedFonts()
{
    return m_excludedFonts;
}

QStringList ApplicationInfo::getFontsFromRcc()
{
    return m_fontsFromRcc;
}

QStringList ApplicationInfo::getBackgroundMusicFromRcc()
{
    const QStringList backgroundMusicFilters = { QString("*.%1").arg(COMPRESSED_AUDIO) };
    m_backgroundMusicFromRcc = QDir(":/gcompris/data/backgroundMusic").entryList(backgroundMusicFilters);
    return m_backgroundMusicFromRcc;
}

void ApplicationInfo::notifyPortraitMode()
{
    int width = qApp->primaryScreen()->geometry().width();
    int height = qApp->primaryScreen()->geometry().height();
    setIsPortraitMode(height > width);
}

void ApplicationInfo::setIsPortraitMode(const bool newMode)
{
    if (m_isPortraitMode != newMode) {
        m_isPortraitMode = newMode;
        Q_EMIT portraitModeChanged();
    }
}

void ApplicationInfo::setWindow(QQuickWindow *window)
{
    m_window = window;
}

void ApplicationInfo::screenshot(const QString &file)
{
    QImage img = m_window->grabWindow();
    img.save(file);
}

void ApplicationInfo::notifyFullscreenChanged()
{
    if (ApplicationSettings::getInstance()->isFullscreen())
        m_window->showFullScreen();
    else
        m_window->showNormal();
}

// Would be better to create a component importing Box2D 2.0 using QQmlContext and test if it exists but it does not work.
void ApplicationInfo::setBox2DInstalled(QQmlEngine &engine)
{
    m_engine = &engine;
    /*
      QQmlContext *context = new QQmlContext(engine.rootContext());
      context->setContextObject(&myDataSet);

      QQmlComponent component(&engine);
      component.setData("import QtQuick\nimport Box2D 2.0\nItem { }", QUrl());
      component.create(context);
      box2dInstalled = (component != nullptr);
    */
    bool box2dInstalled = false;
    const QStringList importPathList = engine.importPathList();
    for (const QString &folder: importPathList) {
        if (QDir(folder).entryList().contains(QLatin1String("Box2D.2.0"))) {
            if (QDir(folder + "/Box2D.2.0").entryList().contains("qmldir")) {
                qDebug() << "Found box2d in " << folder;
                box2dInstalled = true;
                break;
            }
        }
    }
    m_isBox2DInstalled = box2dInstalled;
    Q_EMIT isBox2DInstalledChanged();
}

// return the shortest possible locale name for the given locale, describing
// a unique voices dataset
QString ApplicationInfo::getVoicesLocale(const QString &locale)
{
    QString _locale = locale;
    if (_locale == GC_DEFAULT_LOCALE) {
        _locale = QLocale::system().name();
        if (_locale == "C")
            _locale = "en_US";
    }
    // locales we have country-specific voices for:
    /* clang-format off */
    if (_locale.startsWith(QLatin1String("en_GB")) ||
        _locale.startsWith(QLatin1String("en_US")) ||
        _locale.startsWith(QLatin1String("pt_BR")) ||
        _locale.startsWith(QLatin1String("zh_CN")) ||
        _locale.startsWith(QLatin1String("zh_TW"))) {
        return QLocale(_locale).name();
    }
    /* clang-format on */

    // short locale for all the rest:
    return localeShort(_locale);
}

QVariantList ApplicationInfo::localeSort(QVariantList list,
                                         const QString &locale) const
{
    std::sort(list.begin(), list.end(),
              [&locale, this](const QVariant &a, const QVariant &b) {
                  return (localeCompare(a.toString(), b.toString(), locale) < 0);
              });
    return list;
}

bool ApplicationInfo::loadAndroidTranslation(const QString &locale)
{
    QFile file("assets:/share/GCompris/gcompris_" + locale + ".qm");

    if (!file.exists()) {
        qDebug() << "file assets:/share/GCompris/gcompris_" << locale << ".qm does not exist";
        return false;
    }

    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);

    qint64 fileSize = file.size();
    uchar *data = (uchar *)malloc(fileSize);

    in.readRawData((char *)data, fileSize);

    if (!m_translator.load(data, fileSize)) {
        qDebug() << "Unable to load translation for locale " << locale << ", use en_US by default";
        free(data);
        return false;
    }
    // Do not free data, it is still needed by translator
    return true;
}

/**
 * Checks if the locale is supported. Locale may have been removed because
 * translation progress was not enough or invalid language put in configuration.
 */
bool ApplicationInfo::isSupportedLocale(const QString &locale)
{
    bool isSupported = false;
    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl("qrc:/gcompris/src/core/LanguageList.qml"));
    QObject *object = component.create();
    if (!object) {
        qWarning() << "isSupportedLocale:" << component.errors();
        return false;
    }
    QVariant variant = object->property("languages");
    QJSValue languagesList = variant.value<QJSValue>();
    const int length = languagesList.property("length").toInt();
    for (int i = 0; i < length; ++i) {
        if (languagesList.property(i).property("locale").toString() == locale) {
            isSupported = true;
        }
    }
    delete object;
    return isSupported;
}

// Return the locale
QString ApplicationInfo::loadTranslation(const QString &requestedLocale)
{
    QString locale = requestedLocale;
    if (!isSupportedLocale(locale)) {
        qDebug() << "locale" << locale << "not supported, defaulting to" << GC_DEFAULT_LOCALE;
        locale = GC_DEFAULT_LOCALE;
        ApplicationSettings::getInstance()->setLocale(locale);
    }

    if (locale == GC_DEFAULT_LOCALE)
        locale = QString(QLocale::system().name() + ".UTF-8");

    if (locale == "C.UTF-8")
        locale = "en_US.UTF-8";

    // Load translation
    // Remove .UTF8
    locale.remove(".UTF-8");

#if defined(Q_OS_ANDROID)
    if (!loadAndroidTranslation(locale))
        loadAndroidTranslation(ApplicationInfo::localeShort(locale));
#else

#if (defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
    // only useful for translators: load from $application_dir/../share/... if exists as it is where kde scripts install translations
    if (m_translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale))) {
        qDebug() << "load translation for locale " << locale << " in " << QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale);
    }
    else if (m_translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]))) {
        qDebug() << "load translation for locale " << locale << " in " << QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]);
    }
    else
#endif
        if (!m_translator.load("gcompris_" + locale, QString("%1/%2/translations").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER))) {
        qDebug() << "Unable to load translation for locale " << locale << ", use en_US by default";
    }
#endif
    return locale;
}

void ApplicationInfo::switchLocale()
{
    switchLocale(ApplicationSettings::getInstance()->locale());
}

void ApplicationInfo::switchLocale(const QString &locale)
{
    qDebug() << "switch locale to" << locale;

    // Remove previous translation
    QCoreApplication::removeTranslator(&m_translator);
    loadTranslation(locale);
    // Apply translation
    QCoreApplication::installTranslator(&m_translator);

    if (m_engine) {
        m_engine->retranslate();
    }
}

ApplicationInfo *ApplicationInfo::create(QQmlEngine *engine,
                                         QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    /*
     * Connect the fullscreen change signal to applicationInfo in order to change
     * the QQuickWindow value
     */
    ApplicationInfo *appInfo = getInstance();
    connect(ApplicationSettings::getInstance(), &ApplicationSettings::fullscreenChanged, appInfo,
            &ApplicationInfo::notifyFullscreenChanged);

    return appInfo;
}

#include "moc_ApplicationInfo.cpp"
