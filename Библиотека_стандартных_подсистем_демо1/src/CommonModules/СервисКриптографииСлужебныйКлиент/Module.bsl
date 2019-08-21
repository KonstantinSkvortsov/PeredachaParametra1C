////////////////////////////////////////////////////////////////////////////////
//
// Подсистема "Сервис криптографии".
//  
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

#Область ПолучитьМаркерБезопасности

Процедура ПолучитьМаркерБезопасности(ОповещениеОЗавершении, Идентификатор) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("Идентификатор", Идентификатор);
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьМаркерБезопасностиПослеПолучения", ЭтотОбъект, Контекст);
	ОткрытьФорму(
		"ОбщаяФорма.ВводВременногоПароля", 
		Новый Структура("Сертификат", Новый Структура("Идентификатор", Идентификатор)),
		,,,, 
		Оповещение);
		
КонецПроцедуры

Процедура ПолучитьМаркерБезопасностиПослеПолучения(Результат, ВходящийКонтекст) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено", Ложь);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Состояние = "ИзменениеНастроекПолученияВременныхПаролей" Тогда
			Оповещение = Новый ОписаниеОповещения("ПолучитьМаркерБезопасностиПослеИзмененияНастроекПолученияВременныхПаролей", ЭтотОбъект, ВходящийКонтекст);
			ЭлектроннаяПодписьВМоделиСервисаКлиент.ИзменитьНастройкиПолученияВременныхПаролей(Результат.Сертификат, Оповещение);
			Возврат;
		ИначеЕсли Результат.Состояние = "ПарольНеПринят" Тогда
			ТекстИсключения = Результат.ОписаниеОшибки;
		ИначеЕсли Результат.Состояние = "ПарольПринят" Тогда
			РезультатВыполнения.Вставить("Выполнено", Истина);	
		КонецЕсли;
	Иначе
		ТекстИсключения = НСтр("ru = 'Пользователь отказался от ввода пароля'");
	КонецЕсли;
	
	
	Если Не РезультатВыполнения.Выполнено Тогда
		Попытка
			ВызватьИсключение(ТекстИсключения);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура ПолучитьМаркерБезопасностиПослеИзмененияНастроекПолученияВременныхПаролей(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.ТелефонИзменен ИЛИ Результат.ЭлектроннаяПочтаИзменена Тогда
			ПолучитьМаркерБезопасности(ВходящийКонтекст.ОповещениеОЗавершении, ВходящийКонтекст.Идентификатор);	
		Иначе
			ПолучитьМаркерБезопасностиПослеПолучения(Неопределено, ВходящийКонтекст);	
		КонецЕсли;
	Иначе
		ПолучитьМаркерБезопасностиПослеПолучения(Неопределено, ВходящийКонтекст);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область Зашифровать

Процедура Зашифровать(ОповещениеОЗавершении, Данные, Получатели, ТипШифрования = "CMS", ПараметрыШифрования = Неопределено) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		ЗашифрованныеДанные = СервисКриптографииСлужебныйВызовСервера.Зашифровать(Данные, Получатели, ТипШифрования, ПараметрыШифрования);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("ЗашифрованныеДанные", ЗашифрованныеДанные);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Расшифровать

Процедура Расшифровать(ОповещениеОЗавершении, ЗашифрованныеДанные, ТипШифрования = "CMS", ПараметрыШифрования = Неопределено) Экспорт
	
	Попытка
		СвойстваСообщения = СервисКриптографииСлужебныйВызовСервера.ПолучитьСвойстваКриптосообщения(ЗашифрованныеДанные, Истина);
		
		Если СвойстваСообщения.Тип = "envelopedData" Тогда
			Идентификаторы = Новый Массив;
			Для Каждого Получатель Из СвойстваСообщения.Получатели Цикл
				Если Получатель.Свойство("Идентификатор") Тогда
					Идентификаторы.Добавить(Получатель.Идентификатор);
				КонецЕсли;
			КонецЦикла;			
		Иначе
			ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра ЗашифрованныеДанные - файл не является криптосообщением'"));
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Идентификаторы) Тогда
			ВызватьИсключение(НСтр("ru = 'В хранилище отсутствуют сертификаты для расшифровки сообщения.'"));
		КонецЕсли;
		
		Контекст = Новый Структура;
		Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		Контекст.Вставить("ЗашифрованныеДанные", ЗашифрованныеДанные);
		Контекст.Вставить("ТипШифрования", ТипШифрования);
		Контекст.Вставить("ПараметрыШифрования", ПараметрыШифрования);
		Контекст.Вставить("Идентификаторы", Идентификаторы);
		Контекст.Вставить("ТекущийИдентификатор", 0);
		Контекст.Вставить("Получатели", СвойстваСообщения.Получатели);
		Контекст.Вставить("ОписанияОшибок", Новый Массив);
		РасшифроватьПереборомСертификатов(Контекст);
	Исключение
		РезультатВыполнения = Новый Структура;
		РезультатВыполнения.Вставить("Выполнено", Ложь);
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
		Если ЗначениеЗаполнено(СвойстваСообщения) И СвойстваСообщения.Свойство("Получатели") Тогда
			РезультатВыполнения.Вставить("Получатели", СвойстваСообщения.Получатели);
		КонецЕсли;
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	КонецПопытки;
		
КонецПроцедуры

Процедура РасшифроватьПереборомСертификатов(ВходящийКонтекст, ИнформацияОбОшибке = Неопределено)

	Если ВходящийКонтекст.ТекущийИдентификатор < ВходящийКонтекст.Идентификаторы.Количество() Тогда
		Попытка
			Результат = СервисКриптографииСлужебныйВызовСервера.Расшифровать(
				ВходящийКонтекст.ЗашифрованныеДанные, 
				Новый Структура("Идентификатор", ВходящийКонтекст.Идентификаторы[ВходящийКонтекст.ТекущийИдентификатор]),
				ВходящийКонтекст.ТипШифрования, 
				ВходящийКонтекст.ПараметрыШифрования);
				
			Если ТипЗнч(Результат) = Тип("Структура") Тогда
				Если Результат.КодВозврата = "ТребуетсяАутентификация" Тогда		
					Оповещение = Новый ОписаниеОповещения("РасшифроватьПослеПолученияМаркераБезопасности", ЭтотОбъект, ВходящийКонтекст);
					ПолучитьМаркерБезопасности(Оповещение, Результат.Идентификатор);
				Иначе
					ВызватьИсключение(НСтр("ru = 'Неизвестный код возврата'"));
				КонецЕсли;
			Иначе
				РезультатВыполнения = Новый Структура;
				РезультатВыполнения.Вставить("Выполнено", Истина);
				РезультатВыполнения.Вставить("РасшифрованныеДанные", Результат);
				ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
			КонецЕсли;
			Возврат;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ВходящийКонтекст.ТекущийИдентификатор = ВходящийКонтекст.ТекущийИдентификатор + 1;
			РасшифроватьПереборомСертификатов(ВходящийКонтекст, ИнформацияОбОшибке);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если ИнформацияОбОшибке = Неопределено Тогда
		ТекстИсключения = СтрСоединить(ВходящийКонтекст.ОписанияОшибок, Символы.ПС);
		Если Не ЗначениеЗаполнено(ТекстИсключения) Тогда
			ТекстИсключения = НСтр("ru = 'Не удалось выполнить расшифровку сообщения'");
		КонецЕсли;
		Попытка			
			ВызватьИсключение(ТекстИсключения);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("Выполнено", Ложь);
	Если ВходящийКонтекст.Свойство("Получатели") Тогда
		РезультатВыполнения.Вставить("Получатели", ВходящийКонтекст.Получатели);
	КонецЕсли;
	РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке);
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура РасшифроватьПослеПолученияМаркераБезопасности(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		РасшифроватьПереборомСертификатов(ВходящийКонтекст);
	Иначе
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
		Если ВходящийКонтекст.ОписанияОшибок.Найти(ПредставлениеОшибки) = Неопределено Тогда
			ВходящийКонтекст.ОписанияОшибок.Добавить(ПредставлениеОшибки);
		КонецЕсли;
		ВходящийКонтекст.ТекущийИдентификатор = ВходящийКонтекст.ТекущийИдентификатор + 1;
		РасшифроватьПереборомСертификатов(ВходящийКонтекст);
	КонецЕсли;
	
КонецПроцедуры
		
#КонецОбласти

#Область Подписать

Процедура Подписать(ОповещениеОЗавершении, Данные, Подписант, ТипПодписи = "CMS", ПараметрыПодписания = Неопределено) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		Результат = СервисКриптографииСлужебныйВызовСервера.Подписать(Данные, Подписант, ТипПодписи, ПараметрыПодписания);
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Если Результат.КодВозврата = "ТребуетсяАутентификация" Тогда		
				Контекст = Новый Структура;
				Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
				Контекст.Вставить("Данные", Данные);
				Контекст.Вставить("Подписант", Подписант);
				Контекст.Вставить("ТипПодписи", ТипПодписи);
				Контекст.Вставить("ПараметрыПодписания", ПараметрыПодписания);
				
				Оповещение = Новый ОписаниеОповещения("ПодписатьПослеПолученияМаркераБезопасности", ЭтотОбъект, Контекст);
				ПолучитьМаркерБезопасности(Оповещение, Результат.Идентификатор);
			Иначе
				ВызватьИсключение(НСтр("ru = 'Неизвестный код возврата'"));
			КонецЕсли;
			Возврат;
		Иначе
			РезультатВыполнения.Выполнено = Истина;
			РезультатВыполнения.Вставить("Подпись", Результат);
		КонецЕсли;
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

Процедура ПодписатьПослеПолученияМаркераБезопасности(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		Подписать(
			ВходящийКонтекст.ОповещениеОЗавершении,
			ВходящийКонтекст.Данные,
			ВходящийКонтекст.Подписант,
			ВходящийКонтекст.ТипПодписи,
			ВходящийКонтекст.ПараметрыПодписания
		);
	Иначе
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверитьПодпись

Процедура ПроверитьПодпись(ОповещениеОЗавершении, Подпись, Данные = Неопределено, ТипПодписи = "CMS", ПараметрыПодписания = Неопределено) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		РезультатПроверки = СервисКриптографииСлужебныйВызовСервера.ПроверитьПодпись(Подпись, Данные, ТипПодписи, ПараметрыПодписания);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("ПодписьДействительна", РезультатПроверки);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверитьСертификат

Процедура ПроверитьСертификат(ОповещениеОЗавершении, Сертификат) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		РезультатПроверки = СервисКриптографииСлужебныйВызовСервера.ПроверитьСертификат(Сертификат);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Действителен", РезультатПроверки);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучитьСвойстваСертификата

Процедура ПолучитьСвойстваСертификата(ОповещениеОЗавершении, Сертификат) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		СвойстваСертификата = СервисКриптографииСлужебныйВызовСервера.ПолучитьСвойстваСертификата(Сертификат);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Сертификат", СвойстваСертификата);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучитьСертификатыИзПодписи

Процедура ПолучитьСертификатыИзПодписи(ОповещениеОЗавершении, Подпись) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		Сертификаты = СервисКриптографииСлужебныйВызовСервера.ПолучитьСертификатыИзПодписи(Подпись);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Сертификаты", Сертификаты);
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры
		
#КонецОбласти

#Область ХешированиеДанных

Процедура ХешированиеДанных(ОповещениеОЗавершении, Данные, АлгоритмХеширования, ПараметрыХеширования) Экспорт
	
	РезультатВыполнения = Новый Структура("Выполнено");
	Попытка
		Результат = СервисКриптографииСлужебныйВызовСервера.ХешированиеДанных(Данные, АлгоритмХеширования, ПараметрыХеширования);
		
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("Хеш", Результат);
		
	Исключение
		РезультатВыполнения.Выполнено = Ложь;
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
	КонецПопытки;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти