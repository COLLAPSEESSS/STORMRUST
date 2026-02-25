@echo off
chcp 65001 >nul
echo ========================================
echo Отправка workshop на GitHub
echo ========================================
echo.

REM Настройки
set GIT_PATH=D:\Git\cmd\git.exe
set REPO_URL=https://github.com/COLLAPSEESSS/STORMRUST.git
set CLONE_DIR=D:\STORMRUST_TEMP
set WORKSHOP_SOURCE=D:\devblogs\STORM280\workshop
set TARGET_PATH=280\workshop

REM Проверка наличия Git
if not exist "%GIT_PATH%" (
    echo ОШИБКА: Git не найден по пути %GIT_PATH%
    pause
    exit /b 1
)

REM Удаляем старую временную папку если есть
if exist "%CLONE_DIR%" (
    echo Удаление старой временной папки...
    rmdir /s /q "%CLONE_DIR%"
)

REM Клонируем репозиторий
echo Клонирование репозитория...
"%GIT_PATH%" clone %REPO_URL% "%CLONE_DIR%"
if errorlevel 1 (
    echo ОШИБКА: Не удалось склонировать репозиторий
    pause
    exit /b 1
)

REM Создаем папку 280 если её нет
if not exist "%CLONE_DIR%\280" (
    echo Создание папки 280...
    mkdir "%CLONE_DIR%\280"
)

REM Удаляем старую папку workshop если есть
if exist "%CLONE_DIR%\%TARGET_PATH%" (
    echo Удаление старой папки workshop...
    rmdir /s /q "%CLONE_DIR%\%TARGET_PATH%"
)

REM Копируем папку workshop
echo Копирование файлов workshop...
xcopy "%WORKSHOP_SOURCE%" "%CLONE_DIR%\%TARGET_PATH%\" /E /I /Y
if errorlevel 1 (
    echo ОШИБКА: Не удалось скопировать файлы
    pause
    exit /b 1
)

REM Переходим в папку репозитория
cd /d "%CLONE_DIR%"

REM Добавляем все файлы
echo Добавление файлов в git...
"%GIT_PATH%" add .

REM Создаем коммит
echo Создание коммита...
"%GIT_PATH%" commit -m "Add workshop skins and updated BloodSkins plugin"
if errorlevel 1 (
    echo Нет изменений для коммита или ошибка
)

REM Пушим на GitHub
echo Отправка на GitHub...
"%GIT_PATH%" push origin main
if errorlevel 1 (
    echo ОШИБКА: Не удалось отправить на GitHub
    echo Возможно нужна авторизация
    pause
    exit /b 1
)

echo.
echo ========================================
echo УСПЕШНО! Файлы отправлены на GitHub
echo ========================================
echo Ссылка: https://github.com/COLLAPSEESSS/STORMRUST/tree/main/280/workshop
echo.

REM Очистка
echo Удаление временной папки...
cd /d D:\
rmdir /s /q "%CLONE_DIR%"

echo Готово!
pause
