<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="ru_RU">
<context>
    <name>Cmd</name>
    <message>
        <source>
Available commands:

status

	Get information about current state of aquarium.


date DD.MM.YY W

	Set date.

	DD - day of month (01-31)
	MM - month (01-12)
	YY - year (00-99)
	W  - day of week (1 - monday .. 7 - sunday)


time HH:MM:SS
time +CC
time -CC
time HH:MM:SS +CC
time HH:MM:SS -CC

	Set time and/or time correction.

	HH - hours (00-23)
	MM - minutes (00-59)
	SS - seconds (00-59)
	CC - time correction in seconds (00-59)


heat LL-HH
heat on
heat off
heat auto

	Heater setup.

	LL - minimal temperature (00-99)
	HH - maximal temperature (00-99)


light H1:M1:S1-H2:M2:S2
light level XXX
light H1:M1:S1-H2:M2:S2 XXX
light on
light off
light auto

	Setup light.

	H1:M1:S1 - time of turn on light (00:00:00-23:59:59)
	H2:M2:S2 - time of turn off light (00:00:00-23:59:59)
	XXX      - brightness level (000-100)


display time
display temp

	Setup display.


help

	Print this help message.


exit

	Exit application.</source>
        <translation type="vanished">
Доступны следующие команды:

status

	Получить информацию о текущем состоянии аквариума.


date DD.MM.YY W

	Установить дату.

	DD - число (01-31)
	MM - месяц (01-12)
	YY - год (00-99)
	W  - день недели (1 - понедельник .. 7 - воскресенье)


time HH:MM:SS
time +CC
time -CC
time HH:MM:SS +CC
time HH:MM:SS -CC

	Установить время и/или коррекцию времени.

	HH - часов (00-23)
	MM - минут (00-59)
	SS - секунд (00-59)
	CC - коррекция времени в секундах (00-59)


heat LL-HH
heat on
heat off
heat auto

	Настройка нагревателя.

	LL - минимальная температура (00-99)
	HH - максимальная температура (00-99)


light H1:M1:S1-H2:M2:S2
light level XXX
light H1:M1:S1-H2:M2:S2 XXX
light on
light off
light auto

	Настройка освещения.

	H1:M1:S1 - время включения света (00:00:00-23:59:59)
	H2:M2:S2 - время выключения света (00:00:00-23:59:59)
	XXX      - уровень яркости (000-100)


display time
display temp

	Настройка дисплея.


help

	Вывести это сообщение помощи.


exit

	Выйти из приложения.</translation>
    </message>
    <message>
        <location filename="../Cmd.qml" line="24"/>
        <source>
Available commands:

status

	Get information about current state of aquarium.


date DD.MM.YY W

	Set date.

	DD - day of month (01-31)
	MM - month (01-12)
	YY - year (00-99)
	W  - day of week (1 - monday .. 7 - sunday)


time HH:MM:SS
time +CC
time -CC
time HH:MM:SS +CC
time HH:MM:SS -CC

	Set time and/or time correction.

	HH - hours (00-23)
	MM - minutes (00-59)
	SS - seconds (00-59)
	CC - time correction in seconds (00-59)


heat LL-HH
heat on
heat off
heat auto

	Heater setup.

	LL - minimal temperature (00-99)
	HH - maximal temperature (00-99)


light H1:M1:S1-H2:M2:S2
light level XXX
light H1:M1:S1-H2:M2:S2 XXX
light on
light off
light auto

	Light setup.

	H1:M1:S1 - time of turn on light (00:00:00-23:59:59)
	H2:M2:S2 - time of turn off light (00:00:00-23:59:59)
	XXX      - brightness level (000-100)


display time
display temp

	Display setup.


help

	Print this help message.


exit

	Exit application.</source>
        <translation>
Доступны следующие команды:

status

	Получить информацию о текущем состоянии аквариума.


date DD.MM.YY W

	Установить дату.

	DD - число (01-31)
	MM - месяц (01-12)
	YY - год (00-99)
	W  - день недели (1 - понедельник .. 7 - воскресенье)


time HH:MM:SS
time +CC
time -CC
time HH:MM:SS +CC
time HH:MM:SS -CC

	Установить время и/или коррекцию времени.

	HH - часов (00-23)
	MM - минут (00-59)
	SS - секунд (00-59)
	CC - коррекция времени в секундах (00-59)


heat LL-HH
heat on
heat off
heat auto

	Настройка нагревателя.

	LL - минимальная температура (00-99)
	HH - максимальная температура (00-99)


light H1:M1:S1-H2:M2:S2
light level XXX
light H1:M1:S1-H2:M2:S2 XXX
light on
light off
light auto

	Настройка освещения.

	H1:M1:S1 - время включения света (00:00:00-23:59:59)
	H2:M2:S2 - время выключения света (00:00:00-23:59:59)
	XXX      - уровень яркости (000-100)


display time
display temp

	Настройка дисплея.


help

	Вывести это сообщение помощи.


exit

	Выйти из приложения.</translation>
    </message>
    <message>
        <location filename="../Cmd.qml" line="180"/>
        <source>Enter command</source>
        <translation>Введите команду</translation>
    </message>
</context>
<context>
    <name>Gui</name>
    <message>
        <location filename="../Gui.qml" line="67"/>
        <source>Display shows the temperature now.</source>
        <translation>Сейчас на дисплее отображается температура.</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="71"/>
        <source>Display shows the time now.</source>
        <translation>Сейчас на дисплее отображается время.</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="149"/>
        <source>no data</source>
        <translation>нет данных</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="186"/>
        <source>Aquarium (not connected)</source>
        <translation>Аквариум (не подключен)</translation>
    </message>
    <message>
        <source>Aquarium</source>
        <translation type="vanished">Аквариум</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="268"/>
        <source>Exit</source>
        <translation>Выйти</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="244"/>
        <source>Update</source>
        <translation>Обновить</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="220"/>
        <source>Terminal</source>
        <translation>Терминал</translation>
    </message>
</context>
<context>
    <name>Message</name>
    <message>
        <location filename="../Message.qml" line="79"/>
        <source>Exit</source>
        <translation>Выйти</translation>
    </message>
    <message>
        <location filename="../Message.qml" line="79"/>
        <source>OK</source>
        <translation>ОК</translation>
    </message>
</context>
<context>
    <name>Search</name>
    <message>
        <source>Searching for aquarium...</source>
        <translation type="vanished">Поиск аквариума...</translation>
    </message>
</context>
<context>
    <name>SetupDate</name>
    <message>
        <location filename="../SetupDate.qml" line="19"/>
        <source>Monday</source>
        <translation>Понедельник</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="20"/>
        <source>Tuesday</source>
        <translation>Вторник</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="21"/>
        <source>Wednesday</source>
        <translation>Среда</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="22"/>
        <source>Thursday</source>
        <translation>Четверг</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="23"/>
        <source>Friday</source>
        <translation>Пятница</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="24"/>
        <source>Saturday</source>
        <translation>Суббота</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="25"/>
        <source>Sunday</source>
        <translation>Воскресенье</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="61"/>
        <source>Date %1 %2 was set successfull.</source>
        <translation>Дата %1 %2 буда успешно установлена.</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="77"/>
        <source>Date %1.%2.%3 %4 was set successfull.</source>
        <translation>Дата %1.%2.%3 %4 была успешно установлена.</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="112"/>
        <source>Day</source>
        <translation>Число</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="146"/>
        <source>Month</source>
        <translation>Месяц</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="180"/>
        <source>Year</source>
        <translation>Год</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="214"/>
        <source>Day of week</source>
        <translation>День недели</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="265"/>
        <source>Date setup</source>
        <translation>Настройка даты</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="340"/>
        <source>Cancel</source>
        <translation>Закрыть</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="292"/>
        <source>Set current date</source>
        <translation>Установить текущую дату</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="316"/>
        <source>Set</source>
        <translation>Установить</translation>
    </message>
</context>
<context>
    <name>SetupHeat</name>
    <message>
        <location filename="../SetupHeat.qml" line="24"/>
        <source>Heater was turned on manually.</source>
        <translation>Нагреватель включен вручную.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="31"/>
        <source>Heater was turned off manually.</source>
        <translation>Нагреватель выключен вручную.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="38"/>
        <source>Heater was set to automatic mode.</source>
        <translation>Нагреватель был установлен в автоматический режим.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="49"/>
        <source>Water temperature will be maintained in range %1-%2 °C.</source>
        <translation>Температура воды будет поддерживаться в диапазоне %1-%2 °C.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="82"/>
        <source>Minimal temperature</source>
        <translation>Минимальная температура</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="104"/>
        <source>Minimal temperature cannot be bigger than maximal.</source>
        <translation>Минимальная температура не может быть больше максимальной.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="125"/>
        <source>Maximal temperature</source>
        <translation>Максимальная температура</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="147"/>
        <source>Maximal temperature cannot be less than minimal.</source>
        <translation>Максимальная температура не может быть меньше минимальной.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="172"/>
        <source>Heat setup</source>
        <translation>Настройка нагревателя</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="201"/>
        <source>Turn on</source>
        <translation>Включить</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="225"/>
        <source>Turn off</source>
        <translation>Выключить</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="249"/>
        <source>Auto</source>
        <translation>Авто</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="311"/>
        <source>Cancel</source>
        <translation>Закрыть</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="287"/>
        <source>Set</source>
        <translation>Установить</translation>
    </message>
</context>
<context>
    <name>SetupLight</name>
    <message>
        <location filename="../SetupLight.qml" line="34"/>
        <source>Light was turned on manually.</source>
        <translation>Свет включен вручную.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="41"/>
        <source>Light was turned off manually.</source>
        <translation>Свет выключен вручную.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="48"/>
        <source>Light was set to automatic mode.</source>
        <translation>Освещение было установлено в автоматический режим.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="60"/>
        <source>Light will turn on at %1 o&apos;clock with brightness %3% and turn off at %2 o&apos;clock.</source>
        <translation>Свет будет включаться в %1 с яркостью %3% и выиключаться в %2.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="94"/>
        <source>Turn on time</source>
        <translation>Время включения</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="137"/>
        <source>Turn off time</source>
        <translation>Время выключения</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="180"/>
        <source>Brightness</source>
        <translation>Яркость</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="218"/>
        <source>Light setup</source>
        <translation>Настройка освещения</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="247"/>
        <source>Turn on</source>
        <translation>Включить</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="271"/>
        <source>Turn off</source>
        <translation>Выключить</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="295"/>
        <source>Auto</source>
        <translation>Авто</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="357"/>
        <source>Cancel</source>
        <translation>Закрыть</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="333"/>
        <source>Set</source>
        <translation>Установить</translation>
    </message>
</context>
<context>
    <name>SetupLightTime</name>
    <message>
        <location filename="../SetupLightTime.qml" line="16"/>
        <source>Time of turn on the light</source>
        <translation>Время включения освещения</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="20"/>
        <source>Time of turn off the light</source>
        <translation>Время выключения освещения</translation>
    </message>
    <message>
        <source>Time of turn on cannot be bigger than time of turn off.</source>
        <translation type="vanished">Время включения не может быть больше времени выключения.</translation>
    </message>
    <message>
        <source>Time of turn off cannot be less than time of turn on.</source>
        <translation type="vanished">Время выключения не может быть меньше времени включения.</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="50"/>
        <source>Time of turn on must be less than time of turn off.</source>
        <translation>Время включения должно быть меньше времени выключения.</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="65"/>
        <source>Time of turn off must be bigger than time of turn on.</source>
        <translation>Время выключения должно быть больше времени включения.</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="102"/>
        <source>Hours</source>
        <translation>Часов</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="136"/>
        <source>Minutes</source>
        <translation>Минут</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="170"/>
        <source>Seconds</source>
        <translation>Секунд</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="258"/>
        <source>Cancel</source>
        <translation>Закрыть</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="234"/>
        <source>OK</source>
        <translation>ОК</translation>
    </message>
</context>
<context>
    <name>SetupTime</name>
    <message>
        <location filename="../SetupTime.qml" line="31"/>
        <source>Time %1 with correction %2 was set successfull.</source>
        <translation>Время %1 с коррекцией %2 было успешно установлено.</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="47"/>
        <source>Time %1:%2:%3 with correction %4 was set successfull.</source>
        <translation>Время %1:%2:%3 с коррекцией %4 было успешно установлено.</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="82"/>
        <source>Hours</source>
        <translation>Часов</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="116"/>
        <source>Minutes</source>
        <translation>Минут</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="150"/>
        <source>Seconds</source>
        <translation>Секунд</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="184"/>
        <source>Time correction</source>
        <translation>Коррекция времени</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="233"/>
        <source>Time setup</source>
        <translation>Настройка времени</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="308"/>
        <source>Cancel</source>
        <translation>Закрыть</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="260"/>
        <source>Set current time</source>
        <translation>Установить текущее время</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="284"/>
        <source>Set</source>
        <translation>Установить</translation>
    </message>
</context>
<context>
    <name>main</name>
    <message>
        <source>
Aquarium not found. 

Please ensure that aquarium
is available and restart app.</source>
        <translation type="vanished">
Аквариум не найден. 

Пожалуйста, проверьте аквариум
и запустите приложение заново.</translation>
    </message>
    <message>
        <source>

Discovery failed.
Please ensure Bluetooth is available.</source>
        <translation type="vanished">

Поиск не удался.
Пожалуйста, проверьте состояние Bluetooth.</translation>
    </message>
    <message>
        <source>Aquarium not found.
Please ensure that aquarium
is available.
</source>
        <translation type="vanished">Аквариум не найден.
Пожалуйста, проверьте состояние аквариума.
</translation>
    </message>
    <message>
        <source>Aquarium not found.
Please ensure Bluetooth is available.
</source>
        <translation type="vanished">Аквариум не найден.
Пожалуйста, проверьте состояние Bluetooth.
</translation>
    </message>
    <message>
        <source>
Found device %1.</source>
        <translation type="vanished">
Найдено устройство %1.</translation>
    </message>
    <message>
        <source>
Connecting to aquarium...</source>
        <translation type="vanished">
Подключение к аквариуму...</translation>
    </message>
    <message>
        <location filename="../main.qml" line="123"/>
        <source>Aquarium (%1)</source>
        <translation>Аквариум (%1)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="145"/>
        <source>%1 %2</source>
        <translation>%1 %2</translation>
    </message>
    <message>
        <location filename="../main.qml" line="152"/>
        <source>%1 (time corrects on %2 sec. everyday at %3)</source>
        <translation>%1 (время корректируется на %2 сек. каждый день в %3)</translation>
    </message>
    <message>
        <source>%1 °C</source>
        <translation type="vanished">%1 °C</translation>
    </message>
    <message>
        <location filename="../main.qml" line="19"/>
        <location filename="../main.qml" line="95"/>
        <source>Connecting to aquarium:
%1</source>
        <translation>Подключение к аквариуму:
%1</translation>
    </message>
    <message>
        <location filename="../main.qml" line="31"/>
        <source>Searching for aquarium...</source>
        <translation>Поиск аквариума...</translation>
    </message>
    <message>
        <location filename="../main.qml" line="71"/>
        <location filename="../main.qml" line="82"/>
        <source>Aquarium not found</source>
        <translation>Аквариум не найден</translation>
    </message>
    <message>
        <location filename="../main.qml" line="72"/>
        <location filename="../main.qml" line="110"/>
        <source>Please ensure aquarium is available.</source>
        <translation>Пожалуйста, проверьте состояние аквариума.
</translation>
    </message>
    <message>
        <location filename="../main.qml" line="83"/>
        <source>Please ensure Bluetooth is available.</source>
        <translation>Пожалуйста, проверьте состояние Bluetooth.
</translation>
    </message>
    <message>
        <location filename="../main.qml" line="96"/>
        <source>Aquarium found</source>
        <translation>Аквариум найден</translation>
    </message>
    <message>
        <location filename="../main.qml" line="97"/>
        <source>Adress: %1</source>
        <translation>Адрес: %1</translation>
    </message>
    <message>
        <location filename="../main.qml" line="109"/>
        <source>Can&apos;t connect to aquarium</source>
        <translation>Не удалось подключиться к аквариуму</translation>
    </message>
    <message>
        <location filename="../main.qml" line="112"/>
        <location filename="../main.qml" line="129"/>
        <source>Aquarium (not connected)</source>
        <translation>Аквариум (не подключен)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="128"/>
        <source>
aquarium not connected!
</source>
        <translation>
аквариум не подключен!
</translation>
    </message>
    <message>
        <location filename="../main.qml" line="157"/>
        <source>Water temperature %1 °C</source>
        <translation>Температура воды %1 °C</translation>
    </message>
    <message>
        <location filename="../main.qml" line="164"/>
        <location filename="../main.qml" line="175"/>
        <source>on</source>
        <translation>включен</translation>
    </message>
    <message>
        <location filename="../main.qml" line="164"/>
        <location filename="../main.qml" line="176"/>
        <source>off</source>
        <translation>выключен</translation>
    </message>
    <message>
        <location filename="../main.qml" line="165"/>
        <location filename="../main.qml" line="180"/>
        <source>automatic</source>
        <translation>автоматическом</translation>
    </message>
    <message>
        <location filename="../main.qml" line="165"/>
        <location filename="../main.qml" line="181"/>
        <source>manual</source>
        <translation>ручном</translation>
    </message>
    <message>
        <location filename="../main.qml" line="166"/>
        <source>Heater is %1 in %2 mode (%3)</source>
        <translation>Нагреватель %1 в %2 режиме (%3)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="177"/>
        <source>in unknown state</source>
        <translation>в неизвестном состоянии</translation>
    </message>
    <message>
        <location filename="../main.qml" line="182"/>
        <source>unknown</source>
        <translation>неизвестном</translation>
    </message>
    <message>
        <location filename="../main.qml" line="184"/>
        <source>Light is %1 in %2 mode (%3), brightness %4%</source>
        <translation>Свет %1 в %2 режиме (%3), яркость %4%</translation>
    </message>
    <message>
        <location filename="../main.qml" line="189"/>
        <source>none</source>
        <translation>ничего</translation>
    </message>
    <message>
        <location filename="../main.qml" line="191"/>
        <source>time</source>
        <translation>время</translation>
    </message>
    <message>
        <location filename="../main.qml" line="192"/>
        <source>temperature</source>
        <translation>температура</translation>
    </message>
    <message>
        <location filename="../main.qml" line="194"/>
        <source>Display shows the %1</source>
        <translation>На дисплее отображается %1</translation>
    </message>
    <message>
        <location filename="../main.qml" line="200"/>
        <source>Error occurred while send the command!</source>
        <translation>Во время передачи комманды случилась ошибка!</translation>
    </message>
    <message>
        <source>OK</source>
        <translation type="vanished">ОК</translation>
    </message>
    <message>
        <source>Exit</source>
        <translation type="vanished">Выйти</translation>
    </message>
</context>
</TS>
