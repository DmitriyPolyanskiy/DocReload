﻿
#Область ПрограммныйИнтерфейс

Функция ОбъектВСтроку(ОбъектСсылка) Экспорт
	
	ОбрабатываемыеТипы = Новый ОписаниеТипов;
	ОбрабатываемыеТипы = Новый ОписаниеТипов(ОбрабатываемыеТипы, Документы.ТипВсеСсылки().Типы());
	ОбрабатываемыеТипы = Новый ОписаниеТипов(ОбрабатываемыеТипы, Справочники.ТипВсеСсылки().Типы());
	ОбрабатываемыеТипы = Новый ОписаниеТипов(ОбрабатываемыеТипы, ПланыВидовХарактеристик.ТипВсеСсылки().Типы());
	//ОбрабатываемыеТипы = Новый ОписаниеТипов(ОбрабатываемыеТипы, ПланыВидовРасчета.ТипВсеСсылки().Типы());
	//ОбрабатываемыеТипы = Новый ОписаниеТипов(ОбрабатываемыеТипы, ПланыСчетов.ТипВсеСсылки().Типы());
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ОбъектВСтроку", "ОбъектСсылка", ОбъектСсылка, ОбрабатываемыеТипы);
	
	Если Не ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ВызватьИсключение нСтр("ru='Ссылка на объект выгрузки не указана. Сериализация не может быть выполнена'", "ru") 
	КонецЕсли; 
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектСсылка));
	
	//ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	
	ОбъектСериализация = СтрШаблон("%1<%2>", Разделитель("О"), МетаданныеОбъекта.ПолноеИмя());
	
	Для Каждого СтРеквизит Из МетаданныеОбъекта.СтандартныеРеквизиты Цикл
		Если НеУчитыватьРеквизиты.Найти(СтРеквизит.Имя) <> Неопределено Тогда Продолжить КонецЕсли;
		РеквизитОбъектаВСтроку(СтРеквизит.Имя, ОбъектСсылка);
	КонецЦикла;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		РеквизитОбъектаВСтроку(Реквизит.Имя, ОбъектСсылка);
	КонецЦикла; 
	
	Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл 
		Если ОбъектСсылка[ТабличнаяЧасть.Имя].Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		Отступ = Отступ + 1;
		ДополнитьРезультатСериализации(Разделитель("Т") + ТабличнаяЧасть.Имя + "[", Истина);
		Для Каждого СтрокаТЧ Из ОбъектСсылка[ТабличнаяЧасть.Имя] Цикл
			ДополнитьРезультатСериализации(Разделитель("С"), Истина);
			Для Каждого РеквизитТЧ Из ТабличнаяЧасть.Реквизиты Цикл
				РеквизитОбъектаВСтроку(РеквизитТЧ.Имя, СтрокаТЧ);
			КонецЦикла;
			ДополнитьРезультатСериализации(Разделитель("С", 1));
		КонецЦикла; 
		ДополнитьРезультатСериализации("]" + Разделитель("Т", 1));
		Отступ = Отступ - 1;
	КонецЦикла;
	
	ДополнитьРезультатСериализации(Разделитель("О", 1));
	
	Возврат ОбъектСериализация;
	
КонецФункции

Функция ОбъектИзСтроки(ИсходнаяСтрока) Экспорт
	
	ОбъектСериализация = ИсходнаяСтрока;
	ОбщиеДанные = ДанныеПредставленийОбъектов.Добавить();
	ОбщиеДанные.КонецДанных = СтрДлина(ОбъектСериализация);
	ОбщиеДанные.КонецОбъекта = ОбщиеДанные.КонецДанных;
	
	Если Не СледующаяСтруктураСтрокОбъекта("О") Тогда
		ОбщегоНазначения.СообщитьПользователю(нСтр("ru='Не найдено описание документа'", "ru"));
	КонецЕсли; 
	
	ПолноеИмя = СтруктураСтрокОбъекта.ТипСтрокой;
	МетаданныеОбъекта = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПолноеИмя);
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		НовыйОбъект = МенеджерОбъекта.СоздатьДокумент();
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта)
		Или ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеОбъекта) Тогда
		НовыйОбъект = МенеджерОбъекта.СоздатьЭлемент();
	//ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта) Тогда
	//	НовыйОбъект = МенеджерОбъекта.СоздатьСчет();
	//ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъекта) Тогда
	//	НовыйОбъект = МенеджерОбъекта.СоздатьВидРасчета();
	Иначе
		ВызватьИсключение СтрШаблон(нСтр("ru='Не поддерживается загрузка объектов данного типа (%1)'", "ru"), ПолноеИмя);
	КонецЕсли;
	
	Пока СледующаяСтруктураСтрокОбъекта("Р") Цикл
		
		ИмяРеквизита = СтруктураСтрокОбъекта.Имя;
		Если НеУчитыватьРеквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда Продолжить КонецЕсли;
		
		// Распарсить реквизит
		ЗначениеРеквизита = ЗначениеРеквизитаОбъектаИзСтруктурыСтрок();
		Если ЗначениеРеквизита = Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Реквизит ""%1"" не будет загружен'", "ru"), ИмяРеквизита)); 
		КонецЕсли;
		НовыйОбъект[ИмяРеквизита] = ЗначениеРеквизита;
		
	КонецЦикла;
	
	Пока СледующаяСтруктураСтрокОбъекта("Т") Цикл
		
		ИмяТаблицы = СтруктураСтрокОбъекта.Имя;
		// Распарсить таблицу
		Пока СледующаяСтруктураСтрокОбъекта("С") Цикл
			СтрокаТаблицы = НовыйОбъект[ИмяТаблицы].Добавить();
			Пока СледующаяСтруктураСтрокОбъекта("Р") Цикл
				ИмяРеквизита = СтруктураСтрокОбъекта.Имя;
				ЗначениеРеквизита = ЗначениеРеквизитаОбъектаИзСтруктурыСтрок();
				Если ЗначениеРеквизита = Неопределено Тогда
					ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Реквизит ""%1"" строки %2 табличной части ""%3"" не будет загружен'", "ru"),
														  СтруктураСтрокОбъекта.Имя,
														  СтрокаТаблицы.НомерСтроки,
														  ИмяТаблицы));
				КонецЕсли;
				СтрокаТаблицы[ИмяРеквизита] = ЗначениеРеквизита;
			КонецЦикла; 
		КонецЦикла; 
		
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		Проводить = НовыйОбъект.Проведен;
		Попытка
			Попытка
				НовыйОбъект.Записать(?(Проводить, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			Исключение
				Если Проводить Тогда
					ОбщегоНазначения.СообщитьПользователю(нСтр("ru='Не удалось провести документ. Попытка записи'"));
					НовыйОбъект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			КонецПопытки;
		Исключение
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Не удалось записать документ по причине:
																	 | %1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки; 
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) 
		Или ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеОбъекта) Тогда
		Попытка
			НовыйОбъект.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Не удалось записать элемент по причине:
																	 | %1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки;
	//ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта) Тогда
	//	НовыйОбъект = МенеджерОбъекта.СоздатьСчет();
	//ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъекта) Тогда
	//	НовыйОбъект = МенеджеоОбъекта.СоздатьВидРасчета();
	КонецЕсли;
	
	Возврат НовыйОбъект.Ссылка;
	
КонецФункции

#КонецОбласти 

#Область Выгрузка

Процедура ДополнитьРезультатСериализации(ДобавляемаяСтрока, СНовойСтроки = Ложь)
	
	СтрокаОтступа = "";
	Если СНовойСтроки Тогда
		Табуляция = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(Символы.Таб, Отступ);
		СтрокаОтступа = Символы.ПС + Табуляция;
	КонецЕсли; 
	ОбъектСериализация = ОбъектСериализация + СтрокаОтступа + ДобавляемаяСтрока;
	
КонецПроцедуры 

Процедура РеквизитОбъектаВСтроку(ИмяРеквизита, Объект)
	
	Значение = Объект[ИмяРеквизита];
	Тип = ТипЗнч(Значение);
	ЭтоСсылка = ОбщегоНазначения.ЭтоСсылка(Тип);
	МетаданныеРеквизита = ?(ЭтоСсылка, Метаданные.НайтиПоТипу(Тип), Неопределено);
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеТипа = "";
	Если ЭтоСсылка Тогда
		ПредставлениеТипа = "ref|" + МетаданныеРеквизита.ПолноеИмя();
	Иначе
		ПрефиксПредставления = "val|";
		Если Тип = Тип("ХранилищеЗначения") Тогда
			ПредставлениеТипа = ПрефиксПредставления + "ХранилищеЗначения";
		ИНаче
			ПредставлениеТипа = ПрефиксПредставления + Тип;
		КонецЕсли;
	КонецЕсли; 

	Если ПустаяСтрока(ПредставлениеТипа) Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Не найдено представление для типа %1'"), Тип));
	КонецЕсли;
	
	Отступ = Отступ + 1;
	ДополнитьРезультатСериализации(Разделитель("Р") + СтрШаблон("%1<%2>", ИмяРеквизита, ПредставлениеТипа), Истина); 
	
	Если Не ЭтоСсылка Тогда
		Если Тип = Тип("ХранилищеЗначения") Тогда
			ПотокЗаписи = Новый ПотокВПамяти;
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.ОткрытьПоток(ПотокЗаписи, КодировкаТекста.UTF8);
			ЗаписатьXML(ЗаписьXML, Значение);
			ЗаписьXML.Закрыть();
			ДвоичныеДанные = ПотокЗаписи.ЗакрытьИПолучитьДвоичныеДанные();
			ПредставлениеЗначения = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные, КодировкаТекста.UTF8);
		ИначеЕсли Тип = Тип("Строка") Тогда 
			ПредставлениеЗначения = Значение;
		Иначе
			ПредставлениеЗначения = Формат(Значение);
		КонецЕсли;
		
		ДополнитьРезультатСериализации(ПредставлениеЗначения);
	Иначе
		
		Если ОбщегоНазначения.ЭтоДокумент(МетаданныеРеквизита) Тогда
			
			РеквизитОбъектаВСтроку("Номер", Значение);
			РеквизитОбъектаВСтроку("Дата", Значение);
			
		ИначеЕсли ОбщегоНазначения.ЭтоСправочник(МетаданныеРеквизита)
			Или ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеРеквизита) 
			Или ОбщегоНазначения.ЭтоПланСчетов(МетаданныеРеквизита)
			Или ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеРеквизита) Тогда
			
			РеквизитОбъектаВСтроку("Код", Значение);
			РеквизитОбъектаВСтроку("Наименование", Значение);
			
		ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(МетаданныеРеквизита) Тогда
			
			ПеречислениеМенеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеРеквизита.ПолноеИмя());
			ИндексЗначения = ПеречислениеМенеджер.Индекс(Значение);
			
			РеквизитОбъектаВСтроку("Имя", МетаданныеРеквизита.ЗначенияПеречисления[ИндексЗначения]);
			
		Иначе
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Непредусмотренный тип ""%1"". Значение: ""%2""'"), Тип, Значение));
		КонецЕсли;
		
	КонецЕсли;
	ДополнитьРезультатСериализации(Разделитель("Р", 1));
	
	Отступ = Отступ - 1;
	
КонецПроцедуры

#КонецОбласти 

#Область Загрузка

Функция СледующаяСтруктураСтрокОбъекта(КодОбъекта)
	
	СтруктураСтрокОбъекта = СтруктураСтрокОбъекта();
	
	ПредставлениеРодителя = ДанныеПредставленийОбъектов[ДанныеПредставленийОбъектов.Количество() - 1];
	Префикс = Лев(ОбъектСериализация, ПредставлениеРодителя.КонецДанных); 
	
	НачалоОбъекта = СтрНайти(Префикс, Разделитель(КодОбъекта), , Итератор);
	
	Если НачалоОбъекта < Итератор // Не нашёл начало объекта
		Или Не ПустаяСтрока(Сред(Префикс, Итератор, НачалоОбъекта - Итератор)) Тогда // нашёл начало объекта, но не СРАЗУ после предыдущего
		
		Если Не ПредставлениеРодителя.КодОбъекта = "О" Тогда // Документ удалять не нужно. Там дальше могут идти таблицы
			Итератор = ПредставлениеРодителя.КонецОбъекта;
			ДанныеПредставленийОбъектов.Удалить(ПредставлениеРодителя);
		КонецЕсли; 
		Возврат Ложь;
		
	КонецЕсли;
	
	НачалоДанных = НачалоОбъекта + СтрДлина(Разделитель(КодОбъекта));
	
	СтекОбъектов = 1;
	Позиция = НачалоДанных; 
	Пока СтекОбъектов > 0 И Позиция < СтрДлина(Префикс) Цикл
		СледОткрывающий = СтрНайти(Префикс, Разделитель(КодОбъекта), , Позиция);
		Если СледОткрывающий = 0 Тогда СледОткрывающий = СтрДлина(Префикс) КонецЕсли; 
		СледЗакрывающий = СтрНайти(Префикс, Разделитель(КодОбъекта, 1), , Позиция);
		Если СледЗакрывающий = 0 Тогда СледЗакрывающий = СтрДлина(Префикс) КонецЕсли; 
		
		Если СледОткрывающий < СледЗакрывающий Тогда
			СтекОбъектов = СтекОбъектов + 1;
		ИначеЕсли СледОткрывающий > СледЗакрывающий Тогда 
			СтекОбъектов = СтекОбъектов - 1;
		Иначе
			ВызватьИсключение СтрШаблон("Ожидается закрывающий разделитель (%1)", Разделитель(КодОбъекта, 1));
		КонецЕсли; 
		
		Позиция = Мин(СледОткрывающий, СледЗакрывающий) + 1;
	КонецЦикла;
	
	Если СтекОбъектов <> 0 Тогда
		ВызватьИсключение СтрШаблон("Ожидается закрывающий разделитель (%1)", Разделитель(КодОбъекта, 1));
	КонецЕсли;
	КонецДанных = СледЗакрывающий;
	
	ПредставлениеОбъекта = ДанныеПредставленийОбъектов.Добавить();
	ПредставлениеОбъекта.КодОбъекта = КодОбъекта;
	ПредставлениеОбъекта.КонецОбъекта = КонецДанных + СтрДлина(Разделитель(КодОбъекта, 1));
	ПредставлениеОбъекта.КонецДанных = КонецДанных;
	
	ДанныеОбъектаСтрокой = Сред(Префикс, НачалоДанных, КонецДанных - НачалоДанных);
	
	//Сообщить(ДанныеОбъектаСтрокой);
	
	Если КодОбъекта = "С" Тогда
		СтруктураСтрокОбъекта.ДанныеСтрокой = СокрЛП(ДанныеОбъектаСтрокой);
		Сдвиг = 0;
	ИначеЕсли КодОбъекта = "Т" Тогда
		НачалоМассива = СтрНайти(ДанныеОбъектаСтрокой, "[");
		КонецМассива = СтрНайти(ДанныеОбъектаСтрокой, "]", НаправлениеПоиска.СКонца);
		СтруктураСтрокОбъекта.Имя = СокрЛП(Лев(ДанныеОбъектаСтрокой, НачалоМассива - 1));
		СтруктураСтрокОбъекта.ДанныеСтрокой = СокрЛП(Сред(ДанныеОбъектаСтрокой, НачалоМассива + 1, КонецМассива - НачалоМассива - 1));
		Сдвиг = НачалоМассива + 1;
	ИначеЕсли КодОбъекта = "О" Тогда
		НачалоТипа = СтрНайти(ДанныеОбъектаСтрокой, "<");
		КонецТипа = СтрНайти(ДанныеОбъектаСтрокой, ">");
		СтруктураСтрокОбъекта.Имя = СокрЛП(Лев(ДанныеОбъектаСтрокой, НачалоТипа - 1));
		СтруктураСтрокОбъекта.ТипСтрокой = СокрЛП(Сред(ДанныеОбъектаСтрокой, НачалоТипа + 1, КонецТипа - НачалоТипа - 1));
		СтруктураСтрокОбъекта.ДанныеСтрокой = СокрЛП(Прав(ДанныеОбъектаСтрокой, СтрДлина(ДанныеОбъектаСтрокой) - КонецТипа));
		Сдвиг = КонецТипа + 1;
	ИначеЕсли КодОбъекта = "Р" Тогда
		НачалоТипа = СтрНайти(ДанныеОбъектаСтрокой, "<");
		РазделительВида = СтрНайти(ДанныеОбъектаСтрокой, "|");
		КонецТипа = СтрНайти(ДанныеОбъектаСтрокой, ">");
		СтруктураСтрокОбъекта.Имя = СокрЛП(Лев(ДанныеОбъектаСтрокой, НачалоТипа - 1));
		СтруктураСтрокОбъекта.Вид = СокрЛП(Сред(ДанныеОбъектаСтрокой, НачалоТипа + 1, РазделительВида - НачалоТипа - 1));
		СтруктураСтрокОбъекта.ТипСтрокой = СокрЛП(Сред(ДанныеОбъектаСтрокой, РазделительВида + 1, КонецТипа - РазделительВида - 1));
		СтруктураСтрокОбъекта.ДанныеСтрокой = СокрЛП(Прав(ДанныеОбъектаСтрокой, СтрДлина(ДанныеОбъектаСтрокой) - КонецТипа));
		Сдвиг = КонецТипа + 1;
	Иначе
		ВызватьИсключение СтрШаблон("Не распознан код объекта (%1)", КодОбъекта);
	КонецЕсли;
	
	Если СтруктураСтрокОбъекта.Вид = "val" Тогда
		Итератор = ПредставлениеОбъекта.КонецОбъекта;
		ДанныеПредставленийОбъектов.Удалить(ПредставлениеОбъекта);
		Возврат Истина;
	КонецЕсли; 
	
	Итератор = НачалоДанных + Сдвиг;
	Возврат Истина;
	
КонецФункции 

Функция ЗначениеРеквизитаОбъектаИзСтруктурыСтрок()
	
	Если СтруктураСтрокОбъекта.Вид = "ref" Тогда
		ТипЗначения = ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураСтрокОбъекта.ТипСтрокой).ПустаяСсылка());
	ИначеЕсли СтруктураСтрокОбъекта.Вид = "val" Тогда 
		ТипЗначения = Тип(СтруктураСтрокОбъекта.ТипСтрокой);
	Иначе
		ВызватьИсключение СтрШаблон(нСтр("ru='Неизвестный вид (%1)'", "ru"), СтруктураСтрокОбъекта.Вид);
	КонецЕсли; 
	ЗначениеСтрокой = СтруктураСтрокОбъекта.ДанныеСтрокой;
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
		МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗначения);
		МенеджерЗначения = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеЗначения.ПолноеИмя());
		
		Если ОбщегоНазначения.ЭтоДокумент(МетаданныеЗначения) Тогда
			
			РеквизитыПоиска = Новый Структура("Номер, Дата");
			Пока СледующаяСтруктураСтрокОбъекта("Р") Цикл
				ОписаниеТипов = Новый ОписаниеТипов(СтруктураСтрокОбъекта.ТипСтрокой);
				РеквизитыПоиска.Вставить(СтруктураСтрокОбъекта.Имя, ОписаниеТипов.ПривестиЗначение(СтруктураСтрокОбъекта.ДанныеСтрокой));
			КонецЦикла;
			Если МетаданныеЗначения.ДлинаНомера > 0 Тогда
				Возврат МенеджерЗначения.НайтиПоНомеру(РеквизитыПоиска.Номер, РеквизитыПоиска.Дата);
			Иначе
				Возврат МенеджерЗначения.НайтиПоРеквизиту("Дата", РеквизитыПоиска.Дата);
			КонецЕсли; 
			
		ИначеЕсли ОбщегоНазначения.ЭтоСправочник(МетаданныеЗначения)
			Или ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеЗначения) 
			Или ОбщегоНазначения.ЭтоПланСчетов(МетаданныеЗначения)
			Или ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеЗначения) Тогда
			
			РеквизитыПоиска = Новый Структура("Код, Наименование");
			Пока СледующаяСтруктураСтрокОбъекта("Р") Цикл
				ОписаниеТипов = Новый ОписаниеТипов(СтруктураСтрокОбъекта.ТипСтрокой);
				РеквизитыПоиска.Вставить(СтруктураСтрокОбъекта.Имя, ОписаниеТипов.ПривестиЗначение(СтруктураСтрокОбъекта.ДанныеСтрокой));
			КонецЦикла;
			Если МетаданныеЗначения.ДлинаКода > 0 Тогда
				Возврат МенеджерЗначения.НайтиПоКоду(РеквизитыПоиска.Код);
			ИначеЕсли МетаданныеЗначения.ДлинаНаименования > 0 Тогда 
				Возврат МенеджерЗначения.НайтиПоНаименованию(РеквизитыПоиска.Наименование, Истина);
			Иначе
				ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Ссылка типа ""%1"" не может быть найдена по стандартным реквизитам'", "ru"), ТипЗначения));
				Возврат Неопределено;
			КонецЕсли; 
			
		ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(МетаданныеЗначения) Тогда
			
			ДанныеЗначения = Новый Структура("Имя, Индекс");
			Пока СледующаяСтруктураСтрокОбъекта("Р") Цикл
				ОписаниеТипов = Новый ОписаниеТипов(СтруктураСтрокОбъекта.ТипСтрокой);
				ДанныеЗначения.Вставить(СтруктураСтрокОбъекта.Имя, ОписаниеТипов.ПривестиЗначение(СтруктураСтрокОбъекта.ДанныеСтрокой));
			КонецЦикла;
			Возврат МенеджерЗначения[ДанныеЗначения.Имя];
			
		Иначе
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Ссылочный тип ""%1"" не поддерживается'", "ru"), ТипЗначения));
			Возврат Неопределено;
		КонецЕсли;
	ИначеЕсли ТипЗначения = Тип("Строка") Тогда 
		Возврат ЗначениеСтрокой;
	ИначеЕсли ТипЗначения = Тип("Число") Тогда
		Возврат Число(ЗначениеСтрокой);
	ИначеЕсли ТипЗначения = Тип("Булево") Тогда
		Возврат Булево(ЗначениеСтрокой);
	ИначеЕсли ТипЗначения = Тип("Дата") Тогда
		Возврат Дата(ЗначениеСтрокой);
	ИначеЕсли ТипЗначения = Тип("ХранилищеЗначения") Тогда
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки(ЗначениеСтрокой, КодировкаТекста.UTF8);
		ПотокЧтения = Новый ПотокВПамяти(ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные));
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьПоток(ПотокЧтения);
		Значение = ПрочитатьXML(ЧтениеXML, Тип("ХранилищеЗначения"));
		ЧтениеXML.Закрыть();
		ПотокЧтения.Закрыть();
		Возврат Значение;
	Иначе
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(нСтр("ru='Тип ""%1"" не найден'"), ТипЗначения));
		Возврат Неопределено;
	КонецЕсли; 
	
КонецФункции

#КонецОбласти

#Область СлужебныепроцедурыИФункции

Функция СтруктураСтрокОбъекта()
	
	Возврат Новый Структура("Имя, ТипСтрокой, Вид, ДанныеСтрокой");
	
КонецФункции 

Функция ИмяЕстьВКоллекцииОбъектовМетаданных(Знач Имя, КоллекцияОбъектовМетаданных)
	
	Для Каждого ОбъектМетаданных Из КоллекцияОбъектовМетаданных Цикл
		Если ОбъектМетаданных.Имя = Имя Тогда
			Возврат Истина;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Ложь;
	
КонецФункции 

Функция Разделитель(КодОбъекта, Закрывающий = 0)
	
	Если КодОбъекта = "О" Тогда //Документ
		ПредставлениеНазначения = "obj";
	ИначеЕсли КодОбъекта = "Р" Тогда //Реквизит
		ПредставлениеНазначения = "attr";
	ИначеЕсли КодОбъекта = "Т" Тогда //Табличная часть
		ПредставлениеНазначения = "table";
	ИначеЕсли КодОбъекта = "С" Тогда //Строка табличной части
		ПредставлениеНазначения = "tuple";
	//ИначеЕсли ПустаяСтрока(КодОбъекта) Тогда
	//	Возврат КодОбъекта;
	Иначе
		ВызватьИсключение СтрШаблон("Непредвиденный код разделителя (%1)", КодОбъекта);
	КонецЕсли; 
		
	Возврат СтрШаблон("<%1%2>", ?(Закрывающий, "/", ""), ПредставлениеНазначения);
	
КонецФункции 

#КонецОбласти 

#Область Инициализация

Итератор = 1;
Отступ = 0;
НеУчитыватьРеквизиты = СтрРазделить("Ссылка,Предопределенный", ",", Ложь);

#КонецОбласти 
