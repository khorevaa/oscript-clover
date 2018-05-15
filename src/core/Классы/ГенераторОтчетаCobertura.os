#Использовать asserts
#Использовать fs
#Использовать json

Перем ТекущаяЗаписьXML;
Перем ДатаГенерации;
Перем ИмяПроекта;
Перем ПутьКИсходникам;

// Выполняет формирование отчета
//
// Параметры:
//   ДанныеСтатистикиПокрытия - Соответствие - Прочитанные данные статистики OScript
//   ПутьКОтчету - Строка - Путь к файлу отчета
//
Процедура Сформировать(Знач ДанныеСтатистикиПокрытия, Знач ПутьКОтчету) Экспорт
	
	ДанныеПокрытия = ДанныеСтатистикиПокрытия;

	ТекущаяЗаписьXML = Новый ЗаписьXML;
	ТекущаяЗаписьXML.ОткрытьФайл(ПутьКОтчету);
	ТекущаяЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ДатаГенерации = ДатуВTimestamp(ТекущаяДата());

	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("coverage");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("version", "1.0");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("timestamp", ДатаГенерации);
	ТекущаяЗаписьXML.ЗаписатьАтрибут("complexity", "");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("branches-covered", "");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("branches-valid", "");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("branch-rate", "");
	
	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("sources");
	
	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("source");
	ТекущаяЗаписьXML.ЗаписатьТекст(ПутьКИсходникам);

	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // source

	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // sources

	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("packages");

	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("package");

	ТекущаяЗаписьXML.ЗаписатьАтрибут("name", ".");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("complexity", "");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("branch-rate", "");
	ТекущаяЗаписьXML.ЗаписатьАтрибут("line-rate", "");// Строка(ВсегоПокрытоЭлементов / ВсегоЭлементов));

	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("classes");

	ВсегоФайловВПакете = 0;
	МетрикаПакета = Новый Структура;

	Для Каждого Файл Из ДанныеПокрытия Цикл

		ДанныеФайла = Файл.Значение;

		ПутьКФайлу = ДанныеФайла.Получить("#path");

		ВсегоФайловВПакете = ВсегоФайловВПакете + 1;

		ФайлПокрытия = Новый Файл(ПутьКФайлу);
		ИмяФайла = ФайлПокрытия.Имя;
		КаталогФайла = ФайлПокрытия.Путь;
		ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("class");
		ТекущаяЗаписьXML.ЗаписатьАтрибут("name", ИмяФайла);
		ТекущаяЗаписьXML.ЗаписатьАтрибут("filename", ПутьКФайлу);
		ТекущаяЗаписьXML.ЗаписатьАтрибут("complexity", "");
		ТекущаяЗаписьXML.ЗаписатьАтрибут("branch-rate", "");
		ТекущаяЗаписьXML.ЗаписатьАтрибут("line-rate", ""); //Строка(ВсегоПокрытоЭлементов / ВсегоЭлементов));
		ТекущаяЗаписьXML.ЗаписатьАтрибут("condition-coverage", "100%");
	
		КоличествоМетодов = 0;
		КоличествоПокрытыхМетодов = 0;
		ОбщееВремяВыполнения = 0;
		ВсегоСтрокВФайле = 0;
		ВсегоЭлементов = 0;
		ВсегоПокрытоЭлементов = 0;
		
		ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("methods");
		ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // sources

		ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("lines");
	

		Для Каждого КлючИЗначение Из ДанныеФайла Цикл
			
			ИмяМетода = КлючИЗначение.Ключ;
			
			Если ИмяМетода = "#path" Тогда
				Продолжить;
			КонецЕсли;
			
			ДанныеПроцедуры = КлючИЗначение.Значение;
			ВсегоЭлементовМетода = 0;

			ПокрытыхСтрокВМетоде = 0;

			Для Каждого ДанныеСтроки Из ДанныеПроцедуры Цикл
							
				ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("line");
				
				ТекущаяЗаписьXML.ЗаписатьАтрибут("number", ДанныеСтроки.Ключ);
				ТекущаяЗаписьXML.ЗаписатьАтрибут("branch", "false");
				ТекущаяЗаписьXML.ЗаписатьАтрибут("condition-coverage", "100%");
				
				Покрыто = Число(ДанныеСтроки.Значение.Получить("count")) > 0;
				ТекущаяЗаписьXML.ЗаписатьАтрибут("hits", ДанныеСтроки.Значение.Получить("count"));
				
				ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // lineToCover
			
				Если Покрыто Тогда
					ПокрытыхСтрокВМетоде = ПокрытыхСтрокВМетоде + 1;
				КонецЕсли;

				ВсегоЭлементовМетода = ВсегоЭлементовМетода + 1;
			
			КонецЦикла;

			МетодПокрытПолностью = ДанныеПроцедуры.Количество() = ПокрытыхСтрокВМетоде;

			Если МетодПокрытПолностью Тогда
				КоличествоПокрытыхМетодов = КоличествоПокрытыхМетодов + 1;
			КонецЕсли;

			ВсегоЭлементов = ВсегоЭлементов + ВсегоЭлементовМетода;
		
			ВсегоПокрытоЭлементов = ВсегоПокрытоЭлементов + ПокрытыхСтрокВМетоде;

		КонецЦикла;
	
		ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // lines
		// ТекущаяЗаписьXML.ЗаписатьАтрибут("line-rate", Строка(ВсегоПокрытоЭлементов/ВсегоЭлементов));
		ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // class

	
	КонецЦикла;

	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // classes

	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // package

	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // packages
	
	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // coverage
	
	ТекущаяЗаписьXML.Закрыть();

КонецПроцедуры

Процедура ПриСозданииОбъекта(Знач КаталогИсходников)
	ПутьКИсходникам = Новый Файл(КаталогИсходников).ПолноеИмя;
КонецПроцедуры

Функция ДатуВTimestamp(ВходящаяДата = Неопределено)
	Возврат Формат(Число( ?(ТипЗнч(ВходящаяДата) = Тип("Дата"), ВходящаяДата, ТекущаяДата()) 
					- Дата("19700101")), "ЧН=0; ЧГ=0");
 КонецФункции