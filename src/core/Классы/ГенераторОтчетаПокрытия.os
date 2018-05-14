#Использовать json
#Использовать logos

Перем ПутьККаталогуПроекта;
Перем ПутьККаталогуИсходников;
Перем ПутьКФайлуСтатистики; // путь к файлу
Перем ПутьКРабочемуКаталогу; //
Перем ДанныеСтатистикиПокрытия; // Соответствие
Перем ГенерируемыеОтчеты; // Структура

Перем ПутиФайловВОтносительные;

Перем Лог;

Функция ФайлСтатистики(Знач ПутьКфайлу = "stat.json") Экспорт

	ПутьКФайлуСтатистики = ПутьКфайлу;

	Возврат ЭтотОбъект;

КонецФункции

Функция РабочийКаталог(Знач ПутьККаталогу) Экспорт

	ПутьКРабочемуКаталогу = ПутьККаталогу;

	Возврат ЭтотОбъект;

КонецФункции

Функция ОтносительныеПути() Экспорт

	ПутиФайловВОтносительные = Истина;

	Возврат ЭтотОбъект;

КонецФункции

Функция КаталогИсходников(Знач ПутьККаталогу) Экспорт

	ПутьККаталогуИсходников = ПутьККаталогу;

	Возврат ЭтотОбъект;

КонецФункции

Функция КаталогПроекта(Знач ПутьККаталогу) Экспорт

	ПутьККаталогуПроекта = ПутьККаталогу;

	Возврат ЭтотОбъект;

КонецФункции

Функция Clover(Знач ИмяПроекта, Знач ИмяФайлаОтчета= "clover.xml") Экспорт

	ГенерируемыеОтчеты.Вставить("ОтчетClover", Новый Структура("ИмяФайла, ИмяПроекта", ИмяФайлаОтчета, ИмяПроекта));

	Возврат ЭтотОбъект;

КонецФункции

Функция GenericCoverage(Знач ИмяФайлаОтчета = "genericCoverage.xml") Экспорт

	ГенерируемыеОтчеты.Вставить("ОтчетGenericCoverage", ИмяФайлаОтчета);

	Возврат ЭтотОбъект;

КонецФункции

Процедура Сформировать() Экспорт

	ПроверитьФайлСтатистики();

	ПрочитатьДанныеСтатистики();

	СформироватьОтчетClover();
	СформироватьОтчетGenericCoverage();

КонецПроцедуры

Процедура ПрочитатьДанныеСтатистики()

	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлуСтатистики, КодировкаТекста.UTF8);

	СтрокаJSON = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	Парсер = Новый ПарсерJSON();

	ДанныеФайлаСтатистики = Парсер.ПрочитатьJSON(СтрокаJSON);
	ДанныеСтатистикиПокрытия = Новый Соответствие;

	Для Каждого Файл Из ДанныеФайлаСтатистики Цикл

		ДанныеФайла = Файл.Значение;

		ПутьКФайлу = ДанныеФайла.Получить("#path");

		Если НЕ ЭтоФайлПроекта(ПутьКФайлу) Тогда
			Продолжить;
		КонецЕсли;

		ФайлПокрытия = Новый Файл(ПутьКФайлу);
		ПолноеИмя = ФайлПокрытия.ПолноеИмя;

		Если ПутиФайловВОтносительные Тогда
			ДанныеФайла.Вставить("#path", СтрЗаменить(ПолноеИмя, ПутьККаталогуПроекта + "/", ""));
		КонецЕсли;

		ДанныеСтатистикиПокрытия.Вставить(Файл.Ключ, ДанныеФайла);

	КонецЦикла;

КонецПроцедуры

Функция ЭтоФайлПроекта(Знач ПутьКФайлу)

	ФайлПодходит = СтрНачинаетсяС(ПутьКФайлу, ПутьККаталогуИсходников);

	Возврат ФайлПодходит;

КонецФункции

Процедура СформироватьОтчетClover()

	Если НЕ ГенерируемыеОтчеты.Свойство("ОтчетClover") Тогда
		Возврат;
	КонецЕсли;

	ИмяПроекта = ГенерируемыеОтчеты.ОтчетClover.ИмяПроекта;
	ИмяФайла = ГенерируемыеОтчеты.ОтчетClover.ИмяФайла;

	ПутьКФайлуПокрытия = ОбъединитьПути(ПутьКРабочемуКаталогу, ИмяФайла);

	ГенераторОтчета = Новый ГенераторОтчетаClover(ПутьККаталогуИсходников, ИмяПроекта);

	ГенераторОтчета.Сформировать(ДанныеСтатистикиПокрытия, ПутьКФайлуПокрытия);

КонецПроцедуры

Процедура СформироватьОтчетGenericCoverage()

	Если НЕ ГенерируемыеОтчеты.Свойство("ОтчетGenericCoverage") Тогда
		Возврат;
	КонецЕсли;

	ИмяФайла = ГенерируемыеОтчеты.ОтчетGenericCoverage;

	ПутьКФайлуПокрытия = ОбъединитьПути(ПутьКРабочемуКаталогу, ИмяФайла);

	ГенераторОтчета = Новый ГенераторОтчетаGenericCoverage();

	ГенераторОтчета.Сформировать(ДанныеСтатистикиПокрытия, ПутьКФайлуПокрытия);

КонецПроцедуры

Процедура ПутьКФайлуСтатистикиПоУмолчанию()

	ПутьКФайлуСтатистикиВРабочемКаталоге = ОбъединитьПути(ПутьКРабочемуКаталогу, "stat.json");
	ПутьКФайлуСтатистики = ПутьКФайлуСтатистикиВРабочемКаталоге;

	Если ФайлСтатистикиУстановлен() Тогда
		Возврат;
	КонецЕсли;

	ПутьКФайлуСтатистикиВКаталогеПроекта = ОбъединитьПути(ПутьККаталогуПроекта, "stat.json");

	ПутьКФайлуСтатистики = ПутьКФайлуСтатистикиВКаталогеПроекта;

	Если ФайлСтатистикиУстановлен() Тогда
		Возврат;
	КонецЕсли;

	ПутьКФайлуСтатистики = "";

КонецПроцедуры

Процедура ПроверитьФайлСтатистики()

	Если НЕ ФайлСтатистикиУстановлен() Тогда
		ВызватьИсключение "Не найден или не установлен файл статистики OScript";
	КонецЕсли;

КонецПроцедуры

Функция ФайлСтатистикиУстановлен()

	Лог.Отладка("Путь к файлу статистики: <%1>", ПутьКФайлуСтатистики);
	Лог.Отладка("       файл статистики существует: <%1>", ФайлСуществует(ПутьКФайлуСтатистики));

	Возврат ЗначениеЗаполнено(ПутьКФайлуСтатистики)
			И ФайлСуществует(ПутьКФайлуСтатистики);

КонецФункции

Функция ФайлСуществует(Знач ПутьКФайлу)

	Возврат Новый Файл(ПутьКфайлу).Существует();

КонецФункции

Процедура ПриСозданииОбъекта()

	ТекущийКаталогПроекта = ТекущийКаталог();

	ПутьКРабочемуКаталогу = ОбъединитьПути(ТекущийКаталогПроекта, "coverage");

	КаталогПроекта(ТекущийКаталогПроекта);

	ФайлаКаталогаИсходников = Новый Файл(ОбъединитьПути(ТекущийКаталогПроекта, "src"));

	Если ФайлаКаталогаИсходников.Существует() Тогда
		КаталогИсходников(ФайлаКаталогаИсходников.ПолноеИмя);
	КонецЕсли;

	ПутиФайловВОтносительные = Ложь;

	ГенерируемыеОтчеты = Новый Структура;

	ПутьКФайлуСтатистикиПоУмолчанию();

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.coverage");