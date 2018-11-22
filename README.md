# oscript-coverage

[![Stars](https://img.shields.io/github/stars/khorevaa/oscript-coverage.svg?label=Github%20%E2%98%85&a)](https://github.com/khorevaa/oscript-coverage/stargazers)
[![Release](https://img.shields.io/github/tag/khorevaa/oscript-coverage.svg?label=Last%20release&a)](https://github.com/khorevaa/oscript-coverage/releases)
[![Открытый чат проекта https://gitter.im/EvilBeaver/oscript-library](https://badges.gitter.im/khorevaa/oscript-coverage.png)](https://gitter.im/EvilBeaver/oscript-library)

[![Build Status](https://travis-ci.org/khorevaa/oscript-coverage.svg?branch=master)](https://travis-ci.org/khorevaa/oscript-coverage)
[![Coverage Status](https://coveralls.io/repos/github/khorevaa/oscript-coverage/badge.svg?branch=master)](https://coveralls.io/github/khorevaa/oscript-coverage?branch=master)

# Библиотека для конвертации результата расчета покрытия тестами в различные форматы

## Возможности

 * Конвертация в формат `GenericCoverage`, используемый SonarQube
 * Конвертация в формат `Clover`, используемый на серверe сборок `Bamboo`
 * Конвертация в формат `Cobertura` - популярный формат `python` и `java`

## Установка

Для установки необходимо:
* Скачать файл coverage.ospx из раздела [releases](https://github.com/khorevaa/oscript-coverage/releases)
* Воспользоваться командой:

```
opm install -f <ПутьКФайлу>
```
или установить с хаба пакетов

```
opm install coverage
```

## Пример работы

- Файл `coverage.os`

```bsl
#Использовать 1commands
#Использовать coverage
#Использовать fs

ФС.ОбеспечитьПустойКаталог("coverage");
ПутьКСтат = "coverage/stat.json";

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Команда.ДобавитьПараметр("-encoding=utf-8");
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКСтат));
Команда.ДобавитьПараметр("tasks/test.os"); // Файла запуска тестов
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

Файл_Стат = Новый Файл(ПутьКСтат);

ИмяПакета = "oscript-package";

ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

ПроцессорГенерации.ОтносительныеПути()
				.ФайлСтатистики(Файл_Стат.ПолноеИмя)
				.GenericCoverage() // // Формирование отчета в формате GenericCoverage
				.Cobertura() // Формирование отчета в формате Cobertura
				.Clover(ИмяПакета) // Формирование отчета в формате Clover
				.Сформировать();

ЗавершитьРаботу(КодВозврата);
```

## Использование совместно с `vscode`

* Установить расширение `coverage-gutters` для `vscode`
* Установить путь к файлу покрытия (настройка `coverage-gutters.xmlname`): `coverage/coverage.xml`
* Установить библиотеке `coverage` по инструкции
* Создать файла `coverage.os` с содержанием 
```bsl
#Использовать 1commands
#Использовать coverage
#Использовать fs

ФС.ОбеспечитьПустойКаталог("coverage");
ПутьКСтат = "coverage/stat.json";

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Команда.ДобавитьПараметр("-encoding=utf-8");
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКСтат));    
Команда.ДобавитьПараметр("tasks/test.os"); // ВАЖНО ФАЙЛ ДЛЯ ТЕСТОВ
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

Файл_Стат = Новый Файл(ПутьКСтат);

ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

ПроцессорГенерации.ОтносительныеПути()
				.ФайлСтатистики(Файл_Стат.ПолноеИмя)
				.Cobertura()
				.Сформировать();
```
* Запустить файл `coverage.os` для выполнения тестов и создания отчетов
* Включить просмотр покрытия (`Display Coverage`) в контекстном меню открытого файла

## Публичный интерфейс

[Документация публичного интерфейса (в разработке)](docs/README.md)

## Доработка

Доработка проводится по git-flow. Жду ваших PR.

## Лицензия

Смотри файл `LICENSE`.
