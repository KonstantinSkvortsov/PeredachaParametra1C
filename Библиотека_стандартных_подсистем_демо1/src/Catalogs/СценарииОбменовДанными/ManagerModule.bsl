#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегламентноеЗаданиеGUID");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьСценарий(УзелИнформационнойБазы, Расписание = Неопределено) Экспорт
	
	Отказ = Ложь;
	
	Наименование = НСтр("ru = 'Автоматическая синхронизация данных с %1'");
	Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование,
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "Наименование"));
	
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	СценарийОбменаДанными = СоздатьЭлемент();
	
	// Заполняем реквизиты шапки
	СценарийОбменаДанными.Наименование = Наименование;
	СценарийОбменаДанными.ИспользоватьРегламентноеЗадание = Истина;
	
	// Создаем регламентное задание.
	ОбновитьДанныеРегламентногоЗадания(Отказ, Расписание, СценарийОбменаДанными);
	
	// Табличная часть
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	СценарийОбменаДанными.Записать();
	
КонецПроцедуры

Функция РасписаниеРегламентногоЗаданияПоУмолчанию() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	Расписание.Месяцы                   = Месяцы;
	
	Возврат Расписание;
КонецФункции

// Получает расписание регламентного задания.
// Если регламентное задание не задано, то возвращает пустое расписание (по умолчанию).
//
Функция ПолучитьРасписаниеВыполненияОбменаДанными(НастройкаВыполненияОбмена) Экспорт
	
	РегламентноеЗаданиеОбъект = ОбменДаннымиВызовСервера.НайтиРегламентноеЗаданиеПоПараметру(НастройкаВыполненияОбмена.РегламентноеЗаданиеGUID);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		
	Иначе
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Возврат РасписаниеРегламентногоЗадания;
	
КонецФункции

Процедура ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект) Экспорт
	
	// Получаем регламентное задание по идентификатору, если объект не находим, то создаем новый.
	РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// обновляем свойства РЗ
	УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект);
	
	// Записываем измененное задание.
	ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект);
	
	// Запоминаем GUID регламентное задания в реквизите объекта.
	ТекущийОбъект.РегламентноеЗаданиеGUID = Строка(РегламентноеЗаданиеОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

Функция СоздатьРегламентноеЗаданиеПриНеобходимости(Отказ, ТекущийОбъект)
	
	РегламентноеЗаданиеОбъект = ОбменДаннымиВызовСервера.НайтиРегламентноеЗаданиеПоПараметру(ТекущийОбъект.РегламентноеЗаданиеGUID);
	
	// При необходимости создаем регламентное задание.
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		ПараметрыЗадания = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияДанных);
		РегламентноеЗаданиеОбъект = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

Процедура УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, РасписаниеРегламентногоЗадания, ТекущийОбъект)
	
	Если ПустаяСтрока(ТекущийОбъект.Код) Тогда
		
		ТекущийОбъект.УстановитьНовыйКод();
		
	КонецЕсли;
	
	ПараметрыРегламентногоЗадания = Новый Массив;
	ПараметрыРегламентногоЗадания.Добавить(ТекущийОбъект.Код);
	
	НаименованиеРегламентногоЗадания = НСтр("ru = 'Выполнение обмена по сценарию: %1'");
	НаименованиеРегламентногоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеРегламентногоЗадания, СокрЛП(ТекущийОбъект.Наименование));
	
	РегламентноеЗаданиеОбъект.Наименование  = Лев(НаименованиеРегламентногоЗадания, 120);
	РегламентноеЗаданиеОбъект.Использование = ТекущийОбъект.ИспользоватьРегламентноеЗадание;
	РегламентноеЗаданиеОбъект.Параметры     = ПараметрыРегламентногоЗадания;
	
	// Обновляем расписание, если оно было изменено.
	Если РасписаниеРегламентногоЗадания <> Неопределено Тогда
		РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет запись регламентного задания.
//
// Параметры:
//  Отказ                     - Булево - флаг отказа. Если в процессе выполнения процедуры были обнаружены ошибки,
//                                       то флаг отказа устанавливается в значение Истина.
//  РегламентноеЗаданиеОбъект - объект регламентного задания, которое необходимо записать.
// 
Процедура ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		// записываем задание
		РегламентноеЗаданиеОбъект.Записать();
		
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Произошла ошибка при сохранении расписания выполнения обменов. Подробное описание ошибки: %1'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
		
	КонецПопытки;
	
КонецПроцедуры

//

// Удаляет узел из всех сценариев обменов данными.
// Если после этого сценарий оказывается пустым, то такой сценарий удаляется.
//
Процедура ОчиститьСсылкиНаУзелИнформационнойБазы(Знач УзелИнформационнойБазы) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК СценарийОбменаДанными
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СценарийОбменаДанными = Выборка.СценарийОбменаДанными.ПолучитьОбъект();
		
		УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
		УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
		
		СценарийОбменаДанными.Записать();
		
		Если СценарийОбменаДанными.НастройкиОбмена.Количество() = 0 Тогда
			СценарийОбменаДанными.Удалить();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//

Процедура УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	
КонецПроцедуры

Процедура УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	
КонецПроцедуры

Процедура ДобавитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	НадоЗаписатьОбъект = Ложь;
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		
		СценарийОбменаДанными = СценарийОбменаДанными.ПолучитьОбъект();
		
		НадоЗаписатьОбъект = Истина;
		
	КонецЕсли;
	
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	НастройкиОбмена = СценарийОбменаДанными.НастройкиОбмена;
	
	// Добавляем выгрузку данных в цикле.
	МаксимальныйИндекс = НастройкиОбмена.Количество() - 1;
	
	Для Индекс = 0 По МаксимальныйИндекс Цикл
		
		ОбратныйИндекс = МаксимальныйИндекс - Индекс;
		
		СтрокаТаблицы = НастройкиОбмена[ОбратныйИндекс];
		
		// последняя строка выгрузки
		Если СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных Тогда
			
			НоваяСтрока = НастройкиОбмена.Вставить(ОбратныйИндекс + 1);
			
			НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
			НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
			НоваяСтрока.ВыполняемоеДействие    = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
			
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	// Если в цикле строка выгрузки не была добавлена, то вставляем строку в конец таблицы.
	Отбор = Новый Структура("УзелИнформационнойБазы, ВыполняемоеДействие", УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	Если НастройкиОбмена.НайтиСтроки(Отбор).Количество() = 0 Тогда
		
		НоваяСтрока = НастройкиОбмена.Добавить();
		
		НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
		НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
		НоваяСтрока.ВыполняемоеДействие    = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
		
	КонецЕсли;
	
	Если НадоЗаписатьОбъект Тогда
		
		// Записываем изменения в объекте.
		СценарийОбменаДанными.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы) Экспорт
	
	НадоЗаписатьОбъект = Ложь;
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		
		СценарийОбменаДанными = СценарийОбменаДанными.ПолучитьОбъект();
		
		НадоЗаписатьОбъект = Истина;
		
	КонецЕсли;
	
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	НастройкиОбмена = СценарийОбменаДанными.НастройкиОбмена;
	
	// Добавляем загрузку данных в цикле.
	Для каждого СтрокаТаблицы Из НастройкиОбмена Цикл
		
		Если СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных Тогда // первая строка загрузки
			
			НоваяСтрока = НастройкиОбмена.Вставить(НастройкиОбмена.Индекс(СтрокаТаблицы));
			
			НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
			НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
			НоваяСтрока.ВыполняемоеДействие    = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
			
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	// Если в цикле строка загрузки не была добавлена, то вставляем строку в начало таблицы.
	Отбор = Новый Структура("УзелИнформационнойБазы, ВыполняемоеДействие", УзелИнформационнойБазы, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Если НастройкиОбмена.НайтиСтроки(Отбор).Количество() = 0 Тогда
		
		НоваяСтрока = НастройкиОбмена.Вставить(0);
		
		НоваяСтрока.УзелИнформационнойБазы = УзелИнформационнойБазы;
		НоваяСтрока.ВидТранспортаОбмена    = ВидТранспортаОбмена;
		НоваяСтрока.ВыполняемоеДействие    = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
		
	КонецЕсли;
	
	Если НадоЗаписатьОбъект Тогда
		
		// Записываем изменения в объекте.
		СценарийОбменаДанными.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСтрокуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы, ДействиеПриОбмене)
	
	НадоЗаписатьОбъект = Ложь;
	
	Если ТипЗнч(СценарийОбменаДанными) = Тип("СправочникСсылка.СценарииОбменовДанными") Тогда
		
		СценарийОбменаДанными = СценарийОбменаДанными.ПолучитьОбъект();
		
		НадоЗаписатьОбъект = Истина;
		
	КонецЕсли;
	
	НастройкиОбмена = СценарийОбменаДанными.НастройкиОбмена;
	
	МаксимальныйИндекс = НастройкиОбмена.Количество() - 1;
	
	Для Индекс = 0 По МаксимальныйИндекс Цикл
		
		ОбратныйИндекс = МаксимальныйИндекс - Индекс;
		
		СтрокаТаблицы = НастройкиОбмена[ОбратныйИндекс];
		
		Если  СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы
			И СтрокаТаблицы.ВыполняемоеДействие = ДействиеПриОбмене Тогда
			
			НастройкиОбмена.Удалить(ОбратныйИндекс);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НадоЗаписатьОбъект Тогда
		
		// Записываем изменения в объекте.
		СценарийОбменаДанными.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
