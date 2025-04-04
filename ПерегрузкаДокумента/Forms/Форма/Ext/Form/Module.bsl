﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастроитьОтображениеКомандыПоказать(Элементы.Показать, ЗначениеЗаполнено(ПутьКДанным));
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаСервере
Функция ВыгрузитьНаСервере(ДокументСсылка)
	
	Возврат ОбработкаОбъект().ДокументВСтроку(ДокументСсылка);
	
КонецФункции

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ОчиститьСообщения();
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Не заполнен ""Документ""'"), , "Документ", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПутьКДанным) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Не выбран файл'"), , "ПутьКДанным", , Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ДокументСериализация = ВыгрузитьНаСервере(Документ);
		
		ПотокЗаписи = Новый ФайловыйПоток(ПутьКДанным, РежимОткрытияФайла.Создать, ДоступКФайлу.Запись);
		ЗаписьТекста = Новый ЗаписьТекста(ПотокЗаписи, КодировкаТекста.UTF8);
		ЗаписьТекста.Записать(ДокументСериализация);
		ЗаписьТекста.Закрыть();
		ПотокЗаписи.Закрыть();
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Выгрузка завершена'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаСервере(ДокументСериализация)
	
	Возврат ОбработкаОбъект().ДокументИзСтроки(ДокументСериализация);
	
КонецФункции

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОчиститьСообщения();
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(ПутьКДанным) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Не выбран файл'"), , "ПутьКДанным", , Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ПотокЧтения = Новый ФайловыйПоток(ПутьКДанным, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);
		ЧтениеТекста = Новый ЧтениеТекста(ПотокЧтения, КодировкаТекста.UTF8);
		ДокументСериализация = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ПотокЧтения.Закрыть();
		
		МаксЧисло = СтрДлина(ДокументСериализация) + 1;
		
		НовыйДокумент = ЗагрузитьНаСервере(ДокументСериализация);
		Если НовыйДокумент.Пустая() Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(нСтр("ru='Загрузка завершена с ошибками'")));
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(нСтр("ru='Загрузка завершена. Создан документ ""%1""'"), НовыйДокумент), НовыйДокумент);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Показать(Команда)
	
	Если Не ЗначениеЗаполнено(ПутьКДанным) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКДанным, КодировкаТекста.UTF8);
	
	ТекстовыйДокумент.Показать(нСтр("ru='Выгрузка документа'", "ru"), ПутьКДанным);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПутьКДаннымПриИзменении(Элемент)
	НастроитьОтображениеКомандыПоказать(Элементы.Показать, ЗначениеЗаполнено(ПутьКДанным));
КонецПроцедуры

&НаКлиенте
Процедура ПутьКДаннымНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораФайлаЗавершение", ЭтотОбъект);
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораФайлаЗавершение(МассивПутей, ДопПараметры) Экспорт
	
	Если ЗначениеЗаполнено(МассивПутей) Тогда
		ПутьКДанным = МассивПутей[0];
	КонецЕсли;
	
	НастроитьОтображениеКомандыПоказать(Элементы.Показать, ЗначениеЗаполнено(ПутьКДанным));
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбработкаОбъект()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеКомандыПоказать(КнопкаКоманды, ЗаполненПуть)
	
	КнопкаКоманды.Видимость = ЗаполненПуть;
	
КонецПроцедуры 

#КонецОбласти