<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="uk_UA">
<context>
    <name>Cmd</name>
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
        <translation>
Доступні наступні команди:

status

	Отримати інформацію про проточний стан акваріуму.


date DD.MM.YY W

	Встановити дату

	DD - число (01-31)
	MM - місяць (01-12)
	YY - рік (00-99)
	W  - день тижня (1 - понеділок .. 7 - неділя)


time HH:MM:SS
time +CC
time -CC
time HH:MM:SS +CC
time HH:MM:SS -CC

	Встановити час та/або корекцію часу.

	HH - годин (00-23)
	MM - хвилин (00-59)
	SS - секунд (00-59)
	CC - корекція часу в секундах (00-59)


heat LL-HH
heat on
heat off
heat auto

	Налаштування нагрівача.

	LL - мінімальна температура (00-99)
	HH - максимальна температура (00-99)


light H1:M1:S1-H2:M2:S2
light level XXX
light H1:M1:S1-H2:M2:S2 XXX
light on
light off
light auto

	Налаштування освітлення.

	H1:M1:S1 - час ввімкнення світла (00:00:00-23:59:59)
	H2:M2:S2 - час вимкнення світла (00:00:00-23:59:59)
	XXX      - рівень яскравості (000-100)


display time
display temp

	Налаштування дисплею.


help

	Вивести це повідомлення допомоги.


exit

	Вийти з програми.</translation>
    </message>
    <message>
        <location filename="../Cmd.qml" line="180"/>
        <source>Enter command</source>
        <translation>Введіть команду</translation>
    </message>
</context>
<context>
    <name>Gui</name>
    <message>
        <location filename="../Gui.qml" line="63"/>
        <source>Display shows the temperature now.</source>
        <translation>Зараз на дисплеї відображається температура.</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="67"/>
        <source>Display shows the time now.</source>
        <translation>На дисплеї відображється температура.</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="145"/>
        <source>no data</source>
        <translation>дані відсутні</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="180"/>
        <source>Aquarium</source>
        <translation>Акваріум</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="207"/>
        <source>Exit</source>
        <translation>Вийти</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="231"/>
        <source>Update</source>
        <translation>Оновити</translation>
    </message>
    <message>
        <location filename="../Gui.qml" line="255"/>
        <source>Terminal</source>
        <translation>Термінал</translation>
    </message>
</context>
<context>
    <name>Search</name>
    <message>
        <location filename="../Search.qml" line="50"/>
        <source>Searching for aquarium...</source>
        <translation>Пошук акваріуму...</translation>
    </message>
</context>
<context>
    <name>SetupDate</name>
    <message>
        <location filename="../SetupDate.qml" line="19"/>
        <source>Monday</source>
        <translation>Понеділок</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="20"/>
        <source>Tuesday</source>
        <translation>Вівторок</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="21"/>
        <source>Wednesday</source>
        <translation>Середа</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="22"/>
        <source>Thursday</source>
        <translation>Четвер</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="23"/>
        <source>Friday</source>
        <translation>П&apos;ятниця</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="24"/>
        <source>Saturday</source>
        <translation>Субота</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="25"/>
        <source>Sunday</source>
        <translation>Неділя</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="59"/>
        <source>Date %1 %2 was set successfull.</source>
        <translation>Дата %1 %2 була успішно встановлена.</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="73"/>
        <source>Date %1.%2.%3 %4 was set successfull.</source>
        <translation>Дата %1.%2.%3 %4 була успішно встановлена.</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="108"/>
        <source>Day</source>
        <translation>Число</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="142"/>
        <source>Month</source>
        <translation>Місяць</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="176"/>
        <source>Year</source>
        <translation>Рік</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="210"/>
        <source>Day of week</source>
        <translation>День тижня</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="261"/>
        <source>Date setup</source>
        <translation>Налаштування дати</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="288"/>
        <source>Cancel</source>
        <translation>Закрити</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="312"/>
        <source>Set current date</source>
        <translation>Встановити поточну дату</translation>
    </message>
    <message>
        <location filename="../SetupDate.qml" line="336"/>
        <source>Set</source>
        <translation>Встановити</translation>
    </message>
</context>
<context>
    <name>SetupHeat</name>
    <message>
        <location filename="../SetupHeat.qml" line="24"/>
        <source>Heater was turned on manually.</source>
        <translation>Нагрівач ввімкнено вручну.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="31"/>
        <source>Heater was turned off manually.</source>
        <translation>Нагрівач вимкнено вручну.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="38"/>
        <source>Heater was set to automatic mode.</source>
        <translation>Нагрівач було встановлено в автоматичний режим.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="47"/>
        <source>Water temperature will be maintained in range %1-%2 °C.</source>
        <translation>Температура води буде підтримуватись в діапазоні %1-%2 °C.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="80"/>
        <source>Minimal temperature</source>
        <translation>Мінімальна температура</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="102"/>
        <source>Minimal temperature cannot be bigger than maximal.</source>
        <translation>Мінімальна температура не може бути більше максимальної.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="123"/>
        <source>Maximal temperature</source>
        <translation>Максимальна температура</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="145"/>
        <source>Maximal temperature cannot be less than minimal.</source>
        <translation>Максимальна температура не може бути меньше мінімальної.</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="170"/>
        <source>Heat setup</source>
        <translation>Налаштування нагрівача</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="199"/>
        <source>Turn on</source>
        <translation>Увімкнути</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="223"/>
        <source>Turn off</source>
        <translation>Вимкнути</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="247"/>
        <source>Auto</source>
        <translation>Авто</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="285"/>
        <source>Cancel</source>
        <translation>Закрити</translation>
    </message>
    <message>
        <location filename="../SetupHeat.qml" line="309"/>
        <source>Set</source>
        <translation>Встановити</translation>
    </message>
</context>
<context>
    <name>SetupLight</name>
    <message>
        <location filename="../SetupLight.qml" line="34"/>
        <source>Light was turned on manually.</source>
        <translation>Світло ввімкнено вручну.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="41"/>
        <source>Light was turned off manually.</source>
        <translation>Світло вимкнено вручну.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="48"/>
        <source>Light was set to automatic mode.</source>
        <translation>Освітлення було встановлено в автоматичний режим.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="58"/>
        <source>Light will turn on at %1 o&apos;clock with brightness %3% and turn off at %2 o&apos;clock.</source>
        <translation>Світло буде вмикатись о %1 з яскравістю %3% та вимикатись о %2.</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="92"/>
        <source>Turn on time</source>
        <translation>Час ввімкнення</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="135"/>
        <source>Turn off time</source>
        <translation>Час вимкнення</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="178"/>
        <source>Brightness</source>
        <translation>Яскравість</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="216"/>
        <source>Light setup</source>
        <translation>Налаштування освітлення</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="245"/>
        <source>Turn on</source>
        <translation>Увімкнути</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="269"/>
        <source>Turn off</source>
        <translation>Вимкнути</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="293"/>
        <source>Auto</source>
        <translation>Авто</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="331"/>
        <source>Cancel</source>
        <translation>Закрити</translation>
    </message>
    <message>
        <location filename="../SetupLight.qml" line="355"/>
        <source>Set</source>
        <translation>Встановити</translation>
    </message>
</context>
<context>
    <name>SetupLightTime</name>
    <message>
        <location filename="../SetupLightTime.qml" line="16"/>
        <source>Time of turn on the light</source>
        <translation>Час ввімкнення освітлення</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="20"/>
        <source>Time of turn off the light</source>
        <translation>Час вимкнення освітлення</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="50"/>
        <source>Time of turn on cannot be bigger than time of turn off.</source>
        <translation>Час ввімкнення не може буди більшим за час вимкнення.</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="65"/>
        <source>Time of turn off cannot be less than time of turn on.</source>
        <translation>Час вимкненя не може бути меньше часу ввімкнення.</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="102"/>
        <source>Hours</source>
        <translation>Годин</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="136"/>
        <source>Minutes</source>
        <translation>Хвилин</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="170"/>
        <source>Seconds</source>
        <translation>Секунд</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="234"/>
        <source>Cancel</source>
        <translation>Закрити</translation>
    </message>
    <message>
        <location filename="../SetupLightTime.qml" line="258"/>
        <source>OK</source>
        <translation>ОК</translation>
    </message>
</context>
<context>
    <name>SetupTime</name>
    <message>
        <location filename="../SetupTime.qml" line="29"/>
        <source>Time %1 with correction %2 was set successfull.</source>
        <translation>Час %1 з корекцією %2 було успішно встановлено.</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="43"/>
        <source>Time %1:%2:%3 with correction %4 was set successfull.</source>
        <translation>Час %1:%2:%3 з корекцією %4 було успішно встановлено.</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="78"/>
        <source>Hours</source>
        <translation>Годин</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="112"/>
        <source>Minutes</source>
        <translation>Хвилин</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="146"/>
        <source>Seconds</source>
        <translation>Секунд</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="180"/>
        <source>Time correction</source>
        <translation>Корекція часу</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="229"/>
        <source>Time setup</source>
        <translation>Налаштування часу</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="256"/>
        <source>Cancel</source>
        <translation>Закрити</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="280"/>
        <source>Set current time</source>
        <translation>Встановити поточний час</translation>
    </message>
    <message>
        <location filename="../SetupTime.qml" line="304"/>
        <source>Set</source>
        <translation>Встановити</translation>
    </message>
</context>
<context>
    <name>main</name>
    <message>
        <location filename="../main.qml" line="45"/>
        <source>
Aquarium not found. 

Please ensure that aquarium
is available and restart app.</source>
        <translation>
Акваріум не знайдено. 

Будь ласка, перевірте акваріум
та зпустіть програму заново.</translation>
    </message>
    <message>
        <location filename="../main.qml" line="52"/>
        <source>

Discovery failed.
Please ensure Bluetooth is available.</source>
        <translation>

Пошук не вдався.
Будь ласка, перевірте стан Bluetooth.</translation>
    </message>
    <message>
        <location filename="../main.qml" line="59"/>
        <source>
Found device %1.</source>
        <translation>
Знайдено пристрій %1.</translation>
    </message>
    <message>
        <location filename="../main.qml" line="60"/>
        <source>
Connecting to aquarium...</source>
        <translation>
Підключення до акваріуму...</translation>
    </message>
    <message>
        <location filename="../main.qml" line="75"/>
        <source>Aquarium (%1)</source>
        <translation>Акваріум (%1)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="90"/>
        <source>%1 %2</source>
        <translation>%1 %2</translation>
    </message>
    <message>
        <location filename="../main.qml" line="97"/>
        <source>%1 (time corrects on %2 sec. everyday at %3)</source>
        <translation>%1 (час коригується на %2 сек. кожного дня о %3)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="102"/>
        <source>%1 °C</source>
        <translation>%1 °C</translation>
    </message>
    <message>
        <location filename="../main.qml" line="109"/>
        <location filename="../main.qml" line="120"/>
        <source>on</source>
        <translation>ввімкнено</translation>
    </message>
    <message>
        <location filename="../main.qml" line="109"/>
        <location filename="../main.qml" line="121"/>
        <source>off</source>
        <translation>вимкнено</translation>
    </message>
    <message>
        <location filename="../main.qml" line="110"/>
        <location filename="../main.qml" line="125"/>
        <source>automatic</source>
        <translation>автоматичному</translation>
    </message>
    <message>
        <location filename="../main.qml" line="110"/>
        <location filename="../main.qml" line="126"/>
        <source>manual</source>
        <translation>ручному</translation>
    </message>
    <message>
        <location filename="../main.qml" line="111"/>
        <source>Heater is %1 in %2 mode (%3)</source>
        <translation>Нагрівач %1 в %2 режимі (%3)</translation>
    </message>
    <message>
        <location filename="../main.qml" line="122"/>
        <source>in unknown state</source>
        <translation>в невідомому стані</translation>
    </message>
    <message>
        <location filename="../main.qml" line="127"/>
        <source>unknown</source>
        <translation>невідомому</translation>
    </message>
    <message>
        <location filename="../main.qml" line="129"/>
        <source>Light is %1 in %2 mode (%3), brightness %4%</source>
        <translation>Світло %1 в %2 режимі (%3), яскравість %4%</translation>
    </message>
    <message>
        <location filename="../main.qml" line="134"/>
        <source>none</source>
        <translation>нічого</translation>
    </message>
    <message>
        <location filename="../main.qml" line="136"/>
        <source>time</source>
        <translation>час</translation>
    </message>
    <message>
        <location filename="../main.qml" line="137"/>
        <source>temperature</source>
        <translation>температура</translation>
    </message>
    <message>
        <location filename="../main.qml" line="139"/>
        <source>Display shows the %1</source>
        <translation>На дисплеї відображається %1</translation>
    </message>
    <message>
        <location filename="../main.qml" line="145"/>
        <source>Error occurred while send the command!</source>
        <translation>Під час передачі команди трапилась помилка!</translation>
    </message>
    <message>
        <location filename="../main.qml" line="215"/>
        <source>OK</source>
        <translation>ОК</translation>
    </message>
</context>
</TS>
