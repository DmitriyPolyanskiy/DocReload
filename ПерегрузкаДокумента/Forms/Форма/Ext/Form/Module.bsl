﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастроитьОтображениеКомандыПоказать(ЭтаФорма);
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаСервере
Функция ВыгрузитьНаСервере(ОбъектСсылка)
	
	Возврат ОбработкаОбъект().ОбъектВСтроку(ОбъектСсылка);
	
КонецФункции

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ОчиститьСообщения();
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Не заполнен ""Объект""'"), , "Объект", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПутьКДанным) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Не выбран файл'"), , "ПутьКДанным", , Отказ);
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ОбъектСериализация = ВыгрузитьНаСервере(Объект);
		
		ПотокЗаписи = Новый ФайловыйПоток(ПутьКДанным, РежимОткрытияФайла.Создать, ДоступКФайлу.Запись);
		ЗаписьТекста = Новый ЗаписьТекста(ПотокЗаписи, КодировкаТекста.UTF8);
		ЗаписьТекста.Записать(ОбъектСериализация);
		ЗаписьТекста.Закрыть();
		ПотокЗаписи.Закрыть();
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Выгрузка завершена'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаСервере(ОбъектСериализация)
	
	Возврат ОбработкаОбъект().ОбъектИзСтроки(ОбъектСериализация);
	
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
		ОбъектСериализация = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ПотокЧтения.Закрыть();
		
		МаксЧисло = СтрДлина(ОбъектСериализация) + 1;
		
		НовыйОбъект = ЗагрузитьНаСервере(ОбъектСериализация);
		Если НовыйОбъект.Пустая() Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(нСтр("ru='Загрузка завершена с ошибками'")));
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(нСтр("ru='Загрузка завершена. Создан объект ""%1""(%2)'"), НовыйОбъект, ТипЗнч(НовыйОбъект)), НовыйОбъект);
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
	НастроитьОтображениеКомандыПоказать(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УДАЛИТЬПутьКДаннымНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораФайлаЗавершение", ЭтотОбъект);
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКДаннымНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
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
	
	НастроитьОтображениеКомандыПоказать(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбработкаОбъект()
	
	Возврат РеквизитФормыВЗначение("Обработка");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеКомандыПоказать(ЭтаФорма)
	
	ЭтаФорма.Элементы.Показать.Видимость = ЗначениеЗаполнено(ЭтаФорма.ПутьКДанным);
	
КонецПроцедуры 

#КонецОбласти