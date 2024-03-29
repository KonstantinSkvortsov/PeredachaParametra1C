#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьДействие(Параметры, АдресРезультата) Экспорт
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 Выполняется действие %2'"), ТекущаяДатаСеанса(), Параметры.НомерОперации));
	
	Если Не Параметры.ВыполнитьСразу Тогда
		Начало = ТекущаяДатаСеанса();
		Длительность = 20; // 20 секунд
		СрокЗавершения = Начало + Длительность; 
		ПредыдущийИндекс = 0;
		Пока ТекущаяДатаСеанса() < СрокЗавершения Цикл
			Индекс = ТекущаяДатаСеанса() - Начало; 
			Если Индекс <> ПредыдущийИндекс Тогда
				ПредыдущийИндекс = Индекс;
				Процент = Макс(Цел(Индекс * 100 / Длительность), 1);
				Этап = Цел(Процент / Длительность) + 1;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 операция %2 выполнена на %3 % (этап %4)'"),
					ТекущаяДатаСеанса(), Параметры.НомерОперации, Процент, Этап));
				Если Параметры.ВыводитьПрогрессВыполнения Тогда
					ДлительныеОперации.СообщитьПрогресс(Процент, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Этап %1'"), Этап));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.ОжидаемыйРезультат = "Успешно" Тогда
		ПоместитьВоВременноеХранилище(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Действие %1 успешно выполнено.'"), Параметры.НомерОперации), АдресРезультата);
	ИначеЕсли Параметры.ОжидаемыйРезультат = "Ошибка" Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка: действие %1 не выполнено'"), Параметры.НомерОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
