#Область ОписаниеПеременных

&НаКлиенте
Перем ВнутренниеДанные, ОписаниеДанных, ФормаОбъекта, ОбработкаПослеПредупреждения, ТекущийСписокПредставлений;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаборСертификатов) Тогда
		УказанНеизменяемыйНаборСертификатов = Истина;
		ЗаполнитьСертификатыШифрованияИзНабора(Параметры.НаборСертификатов);
		Если НаборСертификатов.Количество() = 0 И Параметры.ИзменятьНабор Тогда
			// Если все сертификаты набора ссылочные и изменение набора разрешено,
			// то взаимодействие с пользователем обычное, как будто он сам их добавил.
			УказанНеизменяемыйНаборСертификатов = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.НастроитьФормуПодписанияШифрованияРасшифровки(ЭтотОбъект, Истина);
	
	Если УказанНеизменяемыйНаборСертификатов Тогда
		Элементы.Сертификат.Видимость = Ложь;
		Элементы.ГруппаСертификатыШифрования.Заголовок = Элементы.ГруппаУказанныйНаборСертификатов.Заголовок;
		Элементы.СертификатыШифрования.ТолькоПросмотр = Истина;
		Элементы.СертификатыШифрованияПодобрать.Доступность = Ложь;
		ЗаполнитьПрограммуШифрованияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОчиститьПеременныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ПрограммыЭлектроннойПодписиИШифрования")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux")
	 Или ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		
		Если УказанНеизменяемыйНаборСертификатов Тогда
			ПодключитьОбработчикОжидания("ПерезаполнитьПрограммуШифрования", 0.1, Истина);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		ПодключитьОбработчикОжидания("ПриИзмененииСпискаСертификатов", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, ТекущийСписокПредставлений);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("СертификатПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры СертификатПриИзменении.
&НаКлиенте
Процедура СертификатПриИзмененииЗавершение(ОтпечаткиСертификатовНаКлиенте, Контекст) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьКлиент.СертификатНачалоВыбораСПодтверждением(Элемент,
		Сертификат, СтандартнаяОбработка, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Сертификат) Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Сертификат = ВыбранноеЗначение;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("СертификатОбработкаВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры СертификатОбработкаВыбора.
&НаКлиенте
Процедура СертификатОбработкаВыбораЗавершение(ОтпечаткиСертификатовНаКлиенте, Контекст) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СертификатПодборИзСпискаВыбора(ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СертификатПодборИзСпискаВыбора(ЭтотОбъект, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыШифрования

&НаКлиенте
Процедура СертификатыШифрованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Значение Из ВыбранноеЗначение Цикл
		Отбор = Новый Структура("Сертификат", Значение);
		Строки = СертификатыШифрования.НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		СертификатыШифрования.Добавить().Сертификат = Значение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подобрать(Команда)
	
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.ПодборСертификатовДляШифрования",
		, Элементы.СертификатыШифрования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	Если Элементы.ВариантыШифрования.ТекущаяСтраница = Элементы.ПодборИзСправочника Тогда
		ТекущиеДанные = Элементы.СертификатыШифрования.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.НаборСертификатов.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Элементы.ВариантыШифрования.ТекущаяСтраница = Элементы.ПодборИзСправочника Тогда
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.Сертификат);
	Иначе
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(ТекущиеДанные.АдресДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если Не Элементы.ФормаЗашифровать.Доступность Тогда
		Возврат;
	КонецЕсли;
	
	Если Не УказанНеизменяемыйНаборСертификатов
	   И Не ПроверитьЗаполнение() Тогда
		
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаЗашифровать.Доступность = Ложь;
	
	ЗашифроватьДанные(Новый ОписаниеОповещения("ЗашифроватьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры Зашифровать.
&НаКлиенте
Процедура ЗашифроватьЗавершение(Результат, Контекст) Экспорт
	
	Элементы.ФормаЗашифровать.Доступность = Истина;
	
	Если Результат = Истина Тогда
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСертификатыШифрованияИзНабора(ОписаниеНабораСертификатов)
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОписаниеНабораСертификатов)) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ОписаниеНабораСертификатов);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СертификатыШифрования.Сертификат КАК Сертификат
		|ИЗ
		|	РегистрСведений.СертификатыШифрования КАК СертификатыШифрования
		|ГДЕ
		|	СертификатыШифрования.ЗашифрованныйОбъект = &Ссылка";
		МассивСертификатов = Новый Массив;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивСертификатов.Добавить(Выборка.Сертификат.Получить());
		КонецЦикла;
	Иначе
		Если ТипЗнч(ОписаниеНабораСертификатов) = Тип("Строка") Тогда
			МассивСертификатов = ПолучитьИзВременногоХранилища(ОписаниеНабораСертификатов);
		Иначе
			МассивСертификатов = ОписаниеНабораСертификатов;
		КонецЕсли;
		ДобавленныеСертификаты = Новый Соответствие;
		Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
			Если ТипЗнч(ТекущийСертификат) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
				Если ДобавленныеСертификаты.Получить(ТекущийСертификат) = Неопределено Тогда
					ДобавленныеСертификаты.Вставить(ТекущийСертификат, Истина);
					СертификатыШифрования.Добавить().Сертификат = ТекущийСертификат;
				КонецЕсли;
			Иначе
				СертификатыШифрования.Очистить();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если СертификатыШифрования.Количество() > 0
		 Или МассивСертификатов.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаСертификатов = Новый ТаблицаЗначений;
	ТаблицаСертификатов.Колонки.Добавить("Ссылка");
	ТаблицаСертификатов.Колонки.Добавить("Отпечаток");
	ТаблицаСертификатов.Колонки.Добавить("Представление");
	ТаблицаСертификатов.Колонки.Добавить("КомуВыдан");
	ТаблицаСертификатов.Колонки.Добавить("Данные");
	
	Ссылки = Новый Массив;
	Отпечатки = Новый Массив;
	Для Каждого ОписаниеСертификата Из МассивСертификатов Цикл
		НоваяСтрока = ТаблицаСертификатов.Добавить();
		Если ТипЗнч(ОписаниеСертификата) = Тип("ДвоичныеДанные") Тогда
			СертификатКриптографии = Новый СертификатКриптографии(ОписаниеСертификата);
			СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
			НоваяСтрока.Представление = СтруктураСертификата.Представление;
			НоваяСтрока.КомуВыдан     = СтруктураСертификата.КомуВыдан;
			НоваяСтрока.Отпечаток     = СтруктураСертификата.Отпечаток;
			НоваяСтрока.Данные        = ОписаниеСертификата;
			Отпечатки.Добавить(СтруктураСертификата.Отпечаток);
		Иначе
			НоваяСтрока.Ссылка = ОписаниеСертификата;
			Ссылки.Добавить(ОписаниеСертификата);
		КонецЕсли;
	КонецЦикла;
	ТаблицаСертификатов.Индексы.Добавить("Ссылка");
	ТаблицаСертификатов.Индексы.Добавить("Отпечаток");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	Запрос.УстановитьПараметр("Отпечатки", Отпечатки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка,
	|	Сертификаты.Отпечаток КАК Отпечаток,
	|	Сертификаты.Наименование КАК Представление,
	|	Сертификаты.ДанныеСертификата КАК ДанныеСертификата
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|ГДЕ
	|	(Сертификаты.Ссылка В (&Ссылки)
	|			ИЛИ Сертификаты.Отпечаток В (&Отпечатки))";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Строки = ТаблицаСертификатов.НайтиСтроки(Новый Структура("Ссылка", Выборка.Ссылка));
		Для Каждого Строка Из Строки Цикл
			ДанныеСертификата = Выборка.ДанныеСертификата.Получить();
			Если ТипЗнч(ДанныеСертификата) <> Тип("ДвоичныеДанные") Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Данные сертификата ""%1"" не найдены в справочнике'"), Выборка.Представление);
			КонецЕсли;
			Попытка
				СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Данные сертификата ""%1"" в справочнике не корректны по причине:
					           |%2'"),
					Выборка.Представление,
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			КонецПопытки;
			СтруктураСертификата= ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
			Строка.Отпечаток     = Выборка.Отпечаток;
			Строка.Представление = Выборка.Представление;
			Строка.КомуВыдан     = СтруктураСертификата.КомуВыдан;
			Строка.Данные        = ДанныеСертификата;
		КонецЦикла;
		Строки = ТаблицаСертификатов.НайтиСтроки(Новый Структура("Отпечаток", Выборка.Отпечаток));
		Для Каждого Строка Из Строки Цикл
			Строка.Ссылка        = Выборка.Ссылка;
			Строка.Представление = Выборка.Представление;
		КонецЦикла;
	КонецЦикла;
	
	// Удаление дублей.
	ВсеОтпечатки = Новый Соответствие;
	Индекс = ТаблицаСертификатов.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Строка = ТаблицаСертификатов[Индекс];
		Если ВсеОтпечатки.Получить(Строка.Отпечаток) = Неопределено Тогда
			ВсеОтпечатки.Вставить(Строка.Отпечаток, Истина);
		Иначе
			ТаблицаСертификатов.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Отбор = Новый Структура("Ссылка", Неопределено);
	ВсеСертификатыВСправочнике = ТаблицаСертификатов.НайтиСтроки(Отбор).Количество() = 0;
	
	Если ВсеСертификатыВСправочнике Тогда
		Для Каждого Строка Из ТаблицаСертификатов Цикл
			СертификатыШифрования.Добавить().Сертификат = Строка.Ссылка;
		КонецЦикла;
	Иначе
		СвойстваСертификатов = Новый Массив;
		Для Каждого Строка Из ТаблицаСертификатов Цикл
			НоваяСтрока = НаборСертификатов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.АдресДанных = ПоместитьВоВременноеХранилище(Строка.Данные, УникальныйИдентификатор);
			Свойства = Новый Структура;
			Свойства.Вставить("Отпечаток",     Строка.Отпечаток);
			Свойства.Вставить("Представление", Строка.КомуВыдан);
			Свойства.Вставить("Сертификат",    Строка.Данные);
			СвойстваСертификатов.Добавить(Свойства);
		КонецЦикла;
		
		АдресСвойствСертификатов = ПоместитьВоВременноеХранилище(СвойстваСертификатов, УникальныйИдентификатор);
		Элементы.ВариантыШифрования.ТекущаяСтраница = Элементы.УказанныйНаборСертификатов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПрограммуШифрования()
	
	ЗаполнитьПрограммуШифрованияНаСервере();
	ЗаполнитьПрограммуШифрования();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрограммуШифрованияНаСервере()
	
	СертификатПрограмма = Неопределено;
	ПерваяПрограммаНаСервере = Неопределено;
	
	Если НаборСертификатов.Количество() > 0 Тогда
		СертификатАдрес = НаборСертификатов[0].АдресДанных;
	Иначе
		Попытка
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				СертификатыШифрования[0].Сертификат, "Программа, ДанныеСертификата");
			
			Если ЗначениеЗаполнено(ЗначенияРеквизитов.Программа) Тогда
				СертификатПрограмма = ЗначенияРеквизитов.Программа;
				Возврат;
			КонецЕсли;
			
			ДвоичныеДанныеСертификата = ЗначенияРеквизитов.ДанныеСертификата.Получить();
			СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При получении данных сертификата ""%1""
				           |из информационной базы возникла ошибка:
				           |%2'"),
				СертификатыШифрования[0].Сертификат,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
		СертификатАдрес = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
	КонецЕсли;
	
	ОбщиеНастройки = ЭлектроннаяПодпись.ОбщиеНастройки();
	Если Не ОбщиеНастройки.СоздаватьЭлектронныеПодписиНаСервере Тогда
		Возврат;
	КонецЕсли;
	
	СертификатКриптографии = Новый СертификатКриптографии(ПолучитьИзВременногоХранилища(СертификатАдрес));
	ТестовыеДанные = ТестовыеДвоичныеДанные();
	
	Для Каждого ОписаниеПрограммы Из ОбщиеНастройки.ОписанияПрограмм Цикл
		МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("",
			Ложь, "", ОписаниеПрограммы.Ссылка);
		
		Если МенеджерКриптографии = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ПерваяПрограммаНаСервере) Тогда
			ПерваяПрограммаНаСервере = ОписаниеПрограммы.Ссылка;
		КонецЕсли;
		Попытка
			ЗашифрованныеТестовыеДанные = МенеджерКриптографии.Зашифровать(ТестовыеДанные, СертификатКриптографии);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		Если ИнформацияОбОшибке = Неопределено И ЗначениеЗаполнено(ЗашифрованныеТестовыеДанные) Тогда
			СертификатПрограмма = ОписаниеПрограммы.Ссылка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТестовыеДвоичныеДанные()
	
	Возврат БиблиотекаКартинок.СертификатКлюча.ПолучитьДвоичныеДанные();
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПрограммуШифрования(Оповещение = Неопределено)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("ПерваяПрограммаНаКлиенте", Неопределено);
	
	Если ЗначениеЗаполнено(СертификатПрограмма) Тогда
		ЗаполнитьПрограммуШифрованияПослеЦикла(Контекст);
		Возврат;
	КонецЕсли;
	
	ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
	
	Если ОписанияПрограмм = Неопределено Или ОписанияПрограмм.Количество() = 0 Тогда
		ЗаполнитьПрограммуШифрованияПослеЦикла(Контекст);
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ОписанияПрограмм",  ОписанияПрограмм);
	
	СертификатКриптографии = Новый СертификатКриптографии;
	СертификатКриптографии.НачатьИнициализацию(Новый ОписаниеОповещения(
			"ЗаполнитьПрограммуШифрованияПослеИнициализацииСертификата", ЭтотОбъект, Контекст),
		ПолучитьИзВременногоХранилища(СертификатАдрес));
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьПрограммуШифрования.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияПослеИнициализацииСертификата(СертификатКриптографии, Контекст) Экспорт
	
	Контекст.Вставить("СертификатШифрования", СертификатКриптографии);
	Контекст.Вставить("ТестовыеДанные", ТестовыеДвоичныеДанные());
	
	Контекст.Вставить("Индекс", -1);
	ЗаполнитьПрограммуШифрованияЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьПрограммуШифрования.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияЦиклНачало(Контекст)
	
	Если Контекст.ОписанияПрограмм.Количество() <= Контекст.Индекс + 1 Тогда
		ЗаполнитьПрограммуШифрованияПослеЦикла(Контекст);
		Возврат;
	КонецЕсли;
	Контекст.Индекс = Контекст.Индекс + 1;
	Контекст.Вставить("ОписаниеПрограммы", Контекст.ОписанияПрограмм[Контекст.Индекс]);
	
	ЭлектроннаяПодписьСлужебныйКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
			"ЗаполнитьПрограммуШифрованияПослеСозданияМенеджераКриптографии", ЭтотОбъект, Контекст),
		"Шифрование", Ложь, Контекст.ОписаниеПрограммы.Ссылка);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьПрограммуШифрования.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияПослеСозданияМенеджераКриптографии(МенеджерКриптографии, Контекст) Экспорт
	
	Если ТипЗнч(МенеджерКриптографии) <> Тип("МенеджерКриптографии") Тогда
		ЗаполнитьПрограммуШифрованияЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контекст.ПерваяПрограммаНаКлиенте) Тогда
		Контекст.ПерваяПрограммаНаКлиенте = Контекст.ОписаниеПрограммы.Ссылка;
	КонецЕсли;
	
	МенеджерКриптографии.НачатьШифрование(Новый ОписаниеОповещения(
			"ЗаполнитьПрограммуШифрованияПослеШифрования", ЭтотОбъект, Контекст,
			"ЗаполнитьПрограммуШифрованияПослеОшибкиШифрования", ЭтотОбъект),
		Контекст.ТестовыеДанные, Контекст.СертификатШифрования);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьПрограммуШифрования.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияПослеОшибкиШифрования(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ЗаполнитьПрограммуШифрованияЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ЗаполнитьПрограммуШифрования.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияПослеШифрования(ЗашифрованныеДанные, Контекст) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗашифрованныеДанные) Тогда
		ЗаполнитьПрограммуШифрованияЦиклНачало(Контекст);
		Возврат;
	КонецЕсли;
	
	СертификатПрограмма = Контекст.ОписаниеПрограммы.Ссылка;
	ЗаполнитьПрограммуШифрованияПослеЦикла(Контекст);
	
КонецПроцедуры

// Продолжение процедуры СоздатьМенеджерКриптографии.
&НаКлиенте
Процедура ЗаполнитьПрограммуШифрованияПослеЦикла(Контекст)
	
	Если Не ЗначениеЗаполнено(СертификатПрограмма) Тогда
		
		Если ЗначениеЗаполнено(Контекст.ПерваяПрограммаНаКлиенте) Тогда
			СертификатПрограмма = Контекст.ПерваяПрограммаНаКлиенте;
			
		ИначеЕсли ЗначениеЗаполнено(ПерваяПрограммаНаСервере) Тогда
			СертификатПрограмма = ПерваяПрограммаНаСервере;
		КонецЕсли;
	КонецЕсли;
	
	Если Контекст.Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные, КлиентскиеПараметры) Экспорт
	
	ОписаниеДанных             = КлиентскиеПараметры.ОписаниеДанных;
	ФормаОбъекта               = КлиентскиеПараметры.Форма;
	ТекущийСписокПредставлений = КлиентскиеПараметры.ТекущийСписокПредставлений;
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	Контекст = Новый Структура("Оповещение", Оповещение);
	Оповещение = Новый ОписаниеОповещения("ПродолжитьОткрытие", ЭтотОбъект);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПродолжитьОткрытиеНачало(Новый ОписаниеОповещения(
		"ПродолжитьОткрытиеПослеНачала", ЭтотОбъект, Контекст), ЭтотОбъект, КлиентскиеПараметры, Истина);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеНачала(Результат, Контекст) Экспорт
	
	Если Результат <> Истина Тогда
		ПродолжитьОткрытиеЗавершение(Контекст);
		Возврат;
	КонецЕсли;
	
	Если УказанНеизменяемыйНаборСертификатов Тогда
		ЗаполнитьПрограммуШифрования(Новый ОписаниеОповещения(
			"ПродолжитьОткрытиеПослеЗаполненияПрограммы", ЭтотОбъект, Контекст));
	Иначе
		ПродолжитьОткрытиеПослеЗаполненияПрограммы(Неопределено, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеЗаполненияПрограммы(Результат, Контекст) Экспорт
	
	Если БезПодтверждения Тогда
		ОбработкаПослеПредупреждения = Неопределено;
		ЗашифроватьДанные(Новый ОписаниеОповещения("ПродолжитьОткрытиеПослеШифрованияДанных", ЭтотОбъект, Контекст));
		Возврат;
	КонецЕсли;
	
	Открыть();
	
	ПродолжитьОткрытиеЗавершение(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеШифрованияДанных(Результат, Контекст) Экспорт
	
	ПродолжитьОткрытиеЗавершение(Контекст, Результат = Истина);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеЗавершение(Контекст, Результат = Неопределено)
	
	Если Не Открыта() Тогда
		ОчиститьПеременныеФормы();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПеременныеФормы()
	
	ОписаниеДанных             = Неопределено;
	ФормаОбъекта               = Неопределено;
	ТекущийСписокПредставлений = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьШифрование(КлиентскиеПараметры, ОбработкаЗавершения) Экспорт
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбновитьФормуПередПовторнымИспользованием(ЭтотОбъект, КлиентскиеПараметры);
	
	ОписаниеДанных             = КлиентскиеПараметры.ОписаниеДанных;
	ФормаОбъекта               = КлиентскиеПараметры.Форма;
	ТекущийСписокПредставлений = КлиентскиеПараметры.ТекущийСписокПредставлений;
	
	ОбработкаПослеПредупреждения = ОбработкаЗавершения;
	ОбработкаПродолжения = Новый ОписаниеОповещения("ВыполнитьШифрование", ЭтотОбъект);
	
	Контекст = Новый Структура("ОбработкаЗавершения", ОбработкаЗавершения);
	ЗашифроватьДанные(Новый ОписаниеОповещения("ВыполнитьШифрованиеЗавершение", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ВыполнитьШифрование.
&НаКлиенте
Процедура ВыполнитьШифрованиеЗавершение(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаЗавершения, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСпискаСертификатов()
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьОтпечаткиСертификатовНаКлиенте(
		Новый ОписаниеОповещения("ПриИзмененииСпискаСертификатовЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры ПриИзмененииСпискаСертификатов.
&НаКлиенте
Процедура ПриИзмененииСпискаСертификатовЗавершение(ОтпечаткиСертификатовНаКлиенте, Контекст) Экспорт
	
	СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте, Истина);
	
КонецПроцедуры

&НаСервере
Процедура СертификатПриИзмененииНаСервере(ОтпечаткиСертификатовНаКлиенте, ПроверитьСсылку = Ложь)
	
	Если ПроверитьСсылку
	   И ЗначениеЗаполнено(Сертификат)
	   И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "Ссылка") <> Сертификат Тогда
		
		Сертификат = Неопределено;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.СертификатПриИзмененииНаСервере(ЭтотОбъект, ОтпечаткиСертификатовНаКлиенте, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьДанные(Оповещение)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("ОшибкаНаКлиенте", Новый Структура);
	Контекст.Вставить("ОшибкаНаСервере", Новый Структура);
	
	Если ЗначениеЗаполнено(Сертификат) Тогда
		Если СертификатДействителенДо < ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			Контекст.ОшибкаНаКлиенте.Вставить("ОписаниеОшибки",
				НСтр("ru = 'У выбранного личного сертификата истек срок действия.
				           |Выберите другой сертификат.'"));
			ПоказатьОшибку(Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
			ВыполнитьОбработкуОповещения(Контекст.Оповещение, Ложь);
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СертификатПрограмма) Тогда
			Контекст.ОшибкаНаКлиенте.Вставить("ОписаниеОшибки",
				НСтр("ru = 'У выбранного личного сертификата не указана программа для закрытого ключа.
				           |Выберите другой сертификат.'"));
			ПоказатьОшибку(Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
			ВыполнитьОбработкуОповещения(Контекст.Оповещение, Ложь);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Контекст.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	Если ТипЗнч(ФормаОбъекта) = Тип("УправляемаяФорма") Тогда
		Контекст.ИдентификаторФормы = ФормаОбъекта.УникальныйИдентификатор;
	ИначеЕсли ТипЗнч(ФормаОбъекта) = Тип("УникальныйИдентификатор") Тогда
		Контекст.ИдентификаторФормы = ФормаОбъекта;
	КонецЕсли;
	
	Если НаборСертификатов.Количество() = 0 Тогда
		Ссылки = Новый Массив;
		ИсключитьЛичныйСертификат = Ложь;
		Если Элементы.Сертификат.Видимость И ЗначениеЗаполнено(Сертификат) Тогда
			Ссылки.Добавить(Сертификат);
			ИсключитьЛичныйСертификат = Истина;
		КонецЕсли;
		Для каждого Строка Из СертификатыШифрования Цикл
			Если Не ИсключитьЛичныйСертификат Или Строка.Сертификат <> Сертификат Тогда
				Ссылки.Добавить(Строка.Сертификат);
			КонецЕсли;
		КонецЦикла;
		ОписаниеДанных.Вставить("СертификатыШифрования",
			СвойстваСертификатов(Ссылки, Контекст.ИдентификаторФормы));
	Иначе
		ОписаниеДанных.Вставить("СертификатыШифрования", АдресСвойствСертификатов);
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ОписаниеДанных",     ОписаниеДанных);
	ПараметрыВыполнения.Вставить("Форма",              ЭтотОбъект);
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", Контекст.ИдентификаторФормы);
	Контекст.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
	
	Если ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().СоздаватьЭлектронныеПодписиНаСервере Тогда
		Если ЗначениеЗаполнено(СертификатНаСервереОписаниеОшибки) Тогда
			Результат = Новый Структура("Ошибка", СертификатНаСервереОписаниеОшибки);
			СертификатНаСервереОписаниеОшибки = Новый Структура;
			ЗашифроватьДанныеПослеВыполненияНаСторонеСервера(Результат, Контекст);
		Иначе
			// Попытка шифрования на сервере.
			ЭлектроннаяПодписьСлужебныйКлиент.ВыполнитьНаСтороне(Новый ОписаниеОповещения(
					"ЗашифроватьДанныеПослеВыполненияНаСторонеСервера", ЭтотОбъект, Контекст),
				"Шифрование", "НаСторонеСервера", Контекст.ПараметрыВыполнения);
		КонецЕсли;
	Иначе
		ЗашифроватьДанныеПослеВыполненияНаСторонеСервера(Неопределено, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЗашифроватьДанные.
&НаКлиенте
Процедура ЗашифроватьДанныеПослеВыполненияНаСторонеСервера(Результат, Контекст) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗашифроватьДанныеПослеВыполнения(Результат);
	КонецЕсли;
	
	Если Результат <> Неопределено И Не Результат.Свойство("Ошибка") Тогда
		ЗашифроватьДанныеПослеВыполненияНаСторонеКлиента(Новый Структура, Контекст);
	Иначе
		Если Результат <> Неопределено Тогда
			Контекст.ОшибкаНаСервере = Результат.Ошибка;
		КонецЕсли;
		
		// Попытка подписания на клиенте.
		ЭлектроннаяПодписьСлужебныйКлиент.ВыполнитьНаСтороне(Новый ОписаниеОповещения(
				"ЗашифроватьДанныеПослеВыполненияНаСторонеКлиента", ЭтотОбъект, Контекст),
			"Шифрование", "НаСторонеКлиента", Контекст.ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЗашифроватьДанные.
&НаКлиенте
Процедура ЗашифроватьДанныеПослеВыполненияНаСторонеКлиента(Результат, Контекст) Экспорт
	
	ЗашифроватьДанныеПослеВыполнения(Результат);
	
	Если Результат.Свойство("Ошибка") Тогда
		Контекст.ОшибкаНаКлиенте = Результат.Ошибка;
		ПоказатьОшибку(Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	Если Не ЗаписатьСертификатыШифрования(Контекст.ИдентификаторФормы, Контекст.ОшибкаНаКлиенте) Тогда
		ПоказатьОшибку(Контекст.ОшибкаНаКлиенте, Контекст.ОшибкаНаСервере);
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеДанных)
	   И (Не ОписаниеДанных.Свойство("СообщитьОЗавершении")
	      Или ОписаниеДанных.СообщитьОЗавершении <> Ложь) Тогда
		
		ЭлектроннаяПодписьКлиент.ИнформироватьОШифрованииОбъекта(
			ЭлектроннаяПодписьСлужебныйКлиент.ПолноеПредставлениеДанных(ЭтотОбъект),
			ТекущийСписокПредставлений.Количество() > 1);
	КонецЕсли;
	
	Если ОписаниеДанных.Свойство("КонтекстОперации") Тогда
		ОписаниеДанных.КонтекстОперации = ЭтотОбъект;
	КонецЕсли;
	
	Если ОповеститьОбОкончанииСрокаДействия Тогда
		ПараметрыФормы = Новый Структура("Сертификат", Сертификат);
		ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.ОповещениеОбОкончанииСрокаДействия",
			ПараметрыФормы);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
	
КонецПроцедуры

// Продолжение процедуры ЗашифроватьДанные.
&НаКлиенте
Процедура ЗашифроватьДанныеПослеВыполнения(Результат)
	
	Если Результат.Свойство("ЕстьОбработанныеЭлементыДанных") Тогда
		// После начала шифрования изменять сертификаты более недопустимо,
		// иначе набор данных будет обработан по-разному.
		Элементы.Сертификат.ТолькоПросмотр = Истина;
		Элементы.СертификатыШифрования.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СвойстваСертификатов(Знач Ссылки, Знач ИдентификаторФормы)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка,
	|	Сертификаты.Наименование КАК Наименование,
	|	Сертификаты.Программа,
	|	Сертификаты.ДанныеСертификата
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Ссылка В(&Ссылки)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	СвойстваСертификатов = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСертификата = Выборка.ДанныеСертификата.Получить();
		Если ТипЗнч(ДанныеСертификата) <> Тип("ДвоичныеДанные") Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Данные сертификата ""%1"" не найдены в справочнике'"),
				Выборка.Наименование);
		КонецЕсли;
		
		Попытка
			СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные сертификата ""%1"" в справочнике не корректны по причине:
				           |%2'"),
				Выборка.Наименование,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
		СвойстваСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
		
		Свойства = Новый Структура;
		Свойства.Вставить("Отпечаток",     СвойстваСертификата.Отпечаток);
		Свойства.Вставить("Представление", СвойстваСертификата.КомуВыдан);
		Свойства.Вставить("Сертификат",    ДанныеСертификата);
		
		СвойстваСертификатов.Добавить(Свойства);
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(СвойстваСертификатов, ИдентификаторФормы);
	
КонецФункции


&НаКлиенте
Функция ЗаписатьСертификатыШифрования(ИдентификаторФормы, Ошибка)
	
	ОписаниеОбъектов = Новый Массив;
	Если ОписаниеДанных.Свойство("Данные") Тогда
		ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ОписаниеДанных);
	Иначе
		Для каждого ЭлементДанных Из ОписаниеДанных.НаборДанных Цикл
			ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ОписаниеДанных);
		КонецЦикла;
	КонецЕсли;
	
	АдресСертификатов = ОписаниеДанных.СертификатыШифрования;
	
	Ошибка = Новый Структура;
	ЗаписатьСертификатыШифрованияНаСервере(ОписаниеОбъектов, АдресСертификатов, ИдентификаторФормы, Ошибка);
	
	Возврат Не ЗначениеЗаполнено(Ошибка);
	
КонецФункции

&НаКлиенте
Процедура ДобавитьОписаниеОбъекта(ОписаниеОбъектов, ЭлементДанных)
	
	Если Не ЭлементДанных.Свойство("Объект") Тогда
		Возврат;
	КонецЕсли;
	
	ВерсияОбъекта = Неопределено;
	ЭлементДанных.Свойство("ВерсияОбъекта", ВерсияОбъекта);
	
	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка", ЭлементДанных.Объект);
	ОписаниеОбъекта.Вставить("Версия", ВерсияОбъекта);
	
	ОписаниеОбъектов.Добавить(ОписаниеОбъекта);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьСертификатыШифрованияНаСервере(ОписаниеОбъектов, АдресСертификатов, ИдентификаторФормы, Ошибка)
	
	СвойстваСертификатов = ПолучитьИзВременногоХранилища(АдресСертификатов);
	
	НачатьТранзакцию();
	Попытка
		Для каждого ОписаниеОбъекта Из ОписаниеОбъектов Цикл
			ЭлектроннаяПодпись.ЗаписатьСертификатыШифрования(ОписаниеОбъекта.Ссылка,
				СвойстваСертификатов, ИдентификаторФормы, ОписаниеОбъекта.Версия);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Ошибка.Вставить("ОписаниеОшибки", НСтр("ru = 'При записи сертификатов шифрования возникла ошибка:'")
			+ Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьОшибку(ОшибкаНаКлиенте, ОшибкаНаСервере)
	
	Если Не Открыта() И ОбработкаПослеПредупреждения = Неопределено Тогда
		Открыть();
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПоказатьОшибкуОбращенияКПрограмме(
		НСтр("ru = 'Не удалось зашифровать данные'"), "",
		ОшибкаНаКлиенте, ОшибкаНаСервере, , ОбработкаПослеПредупреждения);
	
КонецПроцедуры

#КонецОбласти
