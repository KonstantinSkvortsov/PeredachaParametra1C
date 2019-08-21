#Область ПрограммныйИнтерфейс

// Возвращает новое сообщение.
//
// Параметры:
//  ТипТелаСообщения - ТипОбъектаXDTO - тип тела сообщения которое требуется создать.
//
// Возвращаемое значение:
//  ОбъектXDTO - объект требуемого типа.
Функция НовоеСообщение(Знач ТипТелаСообщения) Экспорт
	
	Сообщение = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипСообщение());
	
	Сообщение.Header = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипЗаголовокСообщения());
	Сообщение.Header.Id = Новый УникальныйИдентификатор;
	Сообщение.Header.Created = ТекущаяУниверсальнаяДата();
	
	Сообщение.Body = ФабрикаXDTO.Создать(ТипТелаСообщения);
	
	Возврат Сообщение;
	
КонецФункции

// Отправляет сообщение
//
// Параметры:
//  Сообщение - ОбъектXDTO - сообщение.
//  Получатель - ПланОбменаСсылка.ОбменСообщениями - получатель сообщения.
//  Сейчас - Булево - отправить сообщений через механизм быстрых сообщений.
//
Процедура ОтправитьСообщение(Знач Сообщение, Знач Получатель = Неопределено, Знач Сейчас = Ложь) Экспорт
	
	Сообщение.Header.Sender = ОписаниеУзлаОбменаСообщениями(ПланыОбмена.ОбменСообщениями.ЭтотУзел());
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		Сообщение.Header.Recipient = ОписаниеУзлаОбменаСообщениями(Получатель);
	КонецЕсли;
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаСообщениями.НастройкиТранспортаWS(Получатель);
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("URL",      СтруктураНастроек.WSURLВебСервиса);
	ПараметрыПодключения.Вставить("UserName", СтруктураНастроек.WSИмяПользователя);
	ПараметрыПодключения.Вставить("Password", СтруктураНастроек.WSПароль);

	ТранслироватьСообщениеВВерсиюКорреспондентаПриНеобходимости(
		Сообщение, 
		ПараметрыПодключения,
		Строка(Получатель));
	
	НетипизированноеТело = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
	
	КаналСообщений = ИмяКаналаПоТипуСообщения(Сообщение.Body.Тип());
	
	Если Сейчас Тогда
		ОбменСообщениями.ОтправитьСообщениеСейчас(КаналСообщений, НетипизированноеТело, Получатель);
	Иначе
		ОбменСообщениями.ОтправитьСообщение(КаналСообщений, НетипизированноеТело, Получатель);
	КонецЕсли;
	
КонецПроцедуры

// Получает список обработчиков сообщений по пространству имен.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * Канал - Строка - Канал сообщения.
//    * Обработчик - ОбщийМодуль - Обработчик сообщения.
//  ПространствоИмен - Строка - uri пространства имен в котором определены типы тел сообщений.
//  ОбщийМодуль - ОбщийМодуль - Общий модуль в котором содержатся обработчики сообщений.
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики, Знач ПространствоИмен, Знач ОбщийМодуль) Экспорт
	
	ИменаКаналов = СообщенияВМоделиСервисаПовтИсп.ПолучитьКаналыПакета(ПространствоИмен);
	
	Для каждого ИмяКанала Из ИменаКаналов Цикл
		Обработчик = Обработчики.Добавить();
		Обработчик.Канал = ИмяКанала;
		Обработчик.Обработчик = ОбщийМодуль;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает имя канала сообщений соответствующего типу сообщения.
//
// Параметры:
//  ТипСообщения - ТипОбъектаXDTO - тип сообщения удаленного администрирования.
//
// Возвращаемое значение:
//  Строка - имя канала сообщений соответствующее переданному типу сообщения.
//
Функция ИмяКаналаПоТипуСообщения(Знач ТипСообщения) Экспорт
	
	Возврат СериализаторXDTO.XMLСтрока(Новый РасширенноеИмяXML(ТипСообщения.URIПространстваИмен, ТипСообщения.Имя));
	
КонецФункции

// Возвращает тип сообщений удаленного администрирования по 
// имени канала сообщений.
//
// Параметры:
//  ИмяКанала - Строка - имя канала сообщений соответствующее переданному типу сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип сообщения удаленного администрирования.
//
Функция ТипСообщенияПоИмениКанала(Знач ИмяКанала) Экспорт
	
	Возврат ФабрикаXDTO.Тип(СериализаторXDTO.XMLЗначение(Тип("РасширенноеИмяXML"), ИмяКанала));
	
КонецФункции

// Вызывает исключение при получении сообщения в неизвестный канал.
//
// Параметры:
//  КаналСообщений - Строка - имя неизвестного канала сообщений.
//
Процедура ОшибкаНеизвестноеИмяКанала(Знач КаналСообщений) Экспорт
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестное имя канала сообщений %1'"), КаналСообщений);
	
КонецПроцедуры

// Читает сообщение из нетипизированного тела сообщения.
//
// Параметры:
//  НетипизированноеТело - Строка - нетипизированное тело сообщения.
//
// Возвращаемое значение:
//  {http://www.1c.ru/SaaS/Messages}Message - сообщение.
//
Функция ПрочитатьСообщениеИзНетипизированногоТела(Знач НетипизированноеТело) Экспорт
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(НетипизированноеТело);
	
	Сообщение = ФабрикаXDTO.ПрочитатьXML(Чтение, СообщенияВМоделиСервисаПовтИсп.ТипСообщение());
	
	Чтение.Закрыть();
	
	Возврат Сообщение;
	
КонецФункции

// Записывает сообщение в нетипизированное тело сообщения.
//
// Параметры:
//  Сообщение - Сообщение - Сообщение с типом {http://www.1c.ru/SaaS/Messages}Message.
//
// Возвращаемое значение:
//  Строка - нетипизированное тело сообщения.
//
Функция ЗаписатьСообщениеВНетипизированноеТело(Знач Сообщение) Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, Сообщение, , , , НазначениеТипаXML.Явное);
	
	Возврат Запись.Закрыть();
	
КонецФункции

// Записывает в журнал регистрации событие начала обработки сообщения.
//
// Параметры:
//  Сообщение - Сообщение - Сообщение с типом {http://www.1c.ru/SaaS/Messages}Message.
//
Процедура ЗаписатьСобытиеНачалоОбработки(Знач Сообщение) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса.Начало обработки'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ПредставлениеСообщенияДляЖурнала(Сообщение));
	
КонецПроцедуры

// Записывает в журнал регистрации событие окончания обработки сообщения.
//
// Параметры:
//  Сообщение - Сообщение - Сообщение с типом {http://www.1c.ru/SaaS/Messages}Message.
//
Процедура ЗаписатьСобытиеОкончаниеОбработки(Знач Сообщение) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса.Окончание обработки'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ПредставлениеСообщенияДляЖурнала(Сообщение));
	
КонецПроцедуры

// Выполняет доставку быстрых сообщений.
//
Процедура ДоставитьБыстрыеСообщения() Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение(НСтр("ru = 'Доставка быстрых сообщений невозможна в транзакции'"));
	КонецЕсли;
	
	ИмяМетодаЗадания = "ОбменСообщениями.ДоставитьСообщения";
	КлючЗадания = 1;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОтборЗаданий = Новый Структура;
	ОтборЗаданий.Вставить("ИмяМетода", ИмяМетодаЗадания);
	ОтборЗаданий.Вставить("Ключ", КлючЗадания);
	ОтборЗаданий.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ОтборЗаданий);
	Если Задания.Количество() > 0 Тогда
		Попытка
			Задания[0].ОжидатьЗавершения(3);
		Исключение
			
			Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Задания[0].УникальныйИдентификатор);
			Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно
				И Задание.ИнформацияОбОшибке <> Неопределено Тогда
				
				ВызватьИсключение(ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
			КонецЕсли;
			
			Возврат;
		КонецПопытки;
	КонецЕсли;
		
	Попытка
		ФоновыеЗадания.Выполнить(ИмяМетодаЗадания, , КлючЗадания, НСтр("ru = 'Доставка быстрых сообщений'"))
	Исключение
		// Дополнительная обработка исключения не требуется
		// ожидаемое исключение - дублирование задания с таким же ключом.
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Доставка быстрых сообщений'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Возвращает XDTO тип - сообщение.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип сообщения.
//
Функция ТипСообщение() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипСообщение();
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений
// в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений в модели сервиса.
//
Функция ТипТело() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений, 
// относящихся к областям данных в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений областей данных в модели сервиса.
//
Функция ТипТелоОбласти() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТелоОбласти();
	
КонецФункции

// Возвращает тип, являющийся базовым для всех типов тел сообщений, 
// отправляемых из областей данных с аутентификацией области в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений областей данных с аутентификацией 
//   в модели сервиса.
//
Функция ТипАутентифицированноеТелоОбласти() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипАутентифицированноеТелоОбласти();
	
КонецФункции

// Возвращает тип - заголовок сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип заголовок сообщения в модели сервиса.
//
Функция ТипЗаголовокСообщения() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипЗаголовокСообщения();
	
КонецФункции

// Возвращает тип - узел обмена сообщениями в модели сервиса.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - тип узел обмена сообщениями в модели сервиса.
//
Функция ТипУзелОбменаСообщениями() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипУзелОбменаСообщениями();
	
КонецФункции

// Возвращает типы объектов XDTO содержащихся в заданном
// пакете, являющиеся типа сообщений удаленного администрирования.
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить.
//
// Возвращаемое значение:
//  ФиксированныйМассив(ТипОбъектаXDTO) - типы сообщений найденные в пакете.
//
Функция ПолучитьТипыСообщенийПакета(Знач URIПакета) Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ПолучитьТипыСообщенийПакета(URIПакета);
	
КонецФункции

// Возвращает имена каналов сообщений из заданного пакета.
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого
//   требуется получить.
//
// Возвращаемое значение:
//  ФиксированныйМассив(Строка) - имена каналов найденные в пакете.
//
Функция ПолучитьКаналыПакета(Знач URIПакета) Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ПолучитьКаналыПакета(URIПакета);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик события перед отправкой сообщения.
// Обработчик данного события вызывается перед запись сообщения для последующей отправки.
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения - Произвольный - тело записываемого сообщения.
//
Процедура ПередОтправкойСообщения(Знач КаналСообщений, Знач ТелоСообщения) Экспорт
	
	Если Не РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса() Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		Если СообщенияВМоделиСервисаПовтИсп.ТипТелоОбласти().ЭтоПотомок(Сообщение.Body.Тип()) Тогда
			Если РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() <> Сообщение.Body.Zone Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса.Отправка сообщения'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ПредставлениеСообщенияДляЖурнала(Сообщение));
					
				ШаблонОшибки = НСтр("ru = 'Ошибка при отправке сообщения. Область данных %1 не совпадает с текущей (%2).'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
					Сообщение.Body.Zone, РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
					
				ВызватьИсключение(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события при отправке сообщения.
// Обработчик данного события вызывается перед помещением сообщения в XML-поток.
// Обработчик вызывается для каждого отправляемого сообщения.
//
//  Параметры:
// КаналСообщений - Строка - идентификатор канала сообщений, в который отправляется сообщение.
// ТелоСообщения - Произвольный - тело отправляемого сообщения. В обработчике события тело сообщения
//    может быть изменено, например, дополнено информацией.
//
Процедура ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		
		Сообщение.Header.Sent = ТекущаяУниверсальнаяДата();
		ТелоСообщения = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса.Отправка'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ПредставлениеСообщенияДляЖурнала(Сообщение));
		
	КонецЕсли;
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		МодульСообщенияВМоделиСервисаРазделениеДанных.ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
		
	КонецЕсли;
	
	СообщенияВМоделиСервисаПереопределяемый.ПриОтправкеСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
	
КонецПроцедуры

// Обработчик события при получении сообщения.
// Обработчик данного события вызывается при получении сообщения из XML-потока.
// Обработчик вызывается для каждого получаемого сообщения.
//
//  Параметры:
// КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
// ТелоСообщения - Произвольный - тело полученного сообщения. В обработчике события тело сообщения
//    может быть изменено, например, дополнено информацией.
//
Процедура ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения) Экспорт
	
	Сообщение = Неопределено;
	Если ТелоСодержитТипизированноеСообщение(ТелоСообщения, Сообщение) Тогда
		
		Сообщение.Header.Delivered = ТекущаяУниверсальнаяДата();
		
		ТелоСообщения = ЗаписатьСообщениеВНетипизированноеТело(Сообщение);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Сообщения в модели сервиса.Получение'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ПредставлениеСообщенияДляЖурнала(Сообщение));
		
	КонецЕсли;
	
	Если РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация() Тогда
		
		МодульСообщенияВМоделиСервисаРазделениеДанных = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервисаРазделениеДанных");
		МодульСообщенияВМоделиСервисаРазделениеДанных.ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
		
	КонецЕсли;
	
	СообщенияВМоделиСервисаПереопределяемый.ПриПолученииСообщения(КаналСообщений, ТелоСообщения, ОбъектСообщения);
	
КонецПроцедуры

Функция ОписаниеУзлаОбменаСообщениями(Знач Узел)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Узел,
		Новый Структура("Код, Наименование"));
	
	Описание = ФабрикаXDTO.Создать(СообщенияВМоделиСервисаПовтИсп.ТипУзелОбменаСообщениями());
	Описание.Code = Реквизиты.Код;
	Описание.Presentation = Реквизиты.Наименование;
	
	Возврат Описание;
	
КонецФункции

// Для внутреннего использования.
//
Функция ТелоСодержитТипизированноеСообщение(Знач НетипизированноеТело, Сообщение) Экспорт
	
	Если ТипЗнч(НетипизированноеТело) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтрНачинаетсяС(НетипизированноеТело, "<") ИЛИ Не СтрЗаканчиваетсяНа(НетипизированноеТело, ">") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Чтение = Новый ЧтениеXML;
		Чтение.УстановитьСтроку(НетипизированноеТело);
		
		Сообщение = ФабрикаXDTO.ПрочитатьXML(Чтение);
		
		Чтение.Закрыть();
		
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Сообщение.Тип() = СообщенияВМоделиСервисаПовтИсп.ТипСообщение();
	
КонецФункции

Функция ПредставлениеСообщенияДляЖурнала(Знач Сообщение)
	
	Шаблон = НСтр("ru = 'Канал: %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ИмяКаналаПоТипуСообщения(Сообщение.Body.Тип()));
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, Сообщение.Header, , , , НазначениеТипаXML.Явное);
	
	Шаблон = НСтр("ru = 'Заголовок:
		|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Представление = Представление + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Запись.Закрыть());
		
	Если СообщенияВМоделиСервисаПовтИсп.ТипТелоОбласти().ЭтоПотомок(Сообщение.Body.Тип()) Тогда
		Шаблон = НСтр("ru = 'Область данных: %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Представление = Представление + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Формат(Сообщение.Body.Zone, "ЧН=0; ЧГ="));
	КонецЕсли;
		
	Возврат Представление;
	
КонецФункции

// Выполняет трансляцию отправляемого сообщения в версию, поддерживаемую ИБ-корреспондентом.
//
// Параметры:
//  Сообщение: ОбъектXDTO, отправляемое сообщение.
//  ИнформацияПодключения - структура, параметры подключения к ИБ-получателю.
//  ПредставлениеПолучателя - строка, представление ИБ-получателя.
//
// Возвращаемое значение:
//  ОбъектXDTO, сообщение, транслированное в версию ИБ-получателя.
//
Процедура ТранслироватьСообщениеВВерсиюКорреспондентаПриНеобходимости(Сообщение, Знач ИнформацияПодключения, Знач ПредставлениеПолучателя)
	
	ИнтерфейсСообщения = ТрансляцияXDTOСлужебный.ПолучитьИнтерфейсСообщения(Сообщение);
	Если ИнтерфейсСообщения = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не удалось определить интерфейс отправляемого сообщения: ни для одного из типов, используемых в сообщении, не зарегистрирован обработчик интерфейса.'");
	КонецЕсли;
	
	Если Не ИнформацияПодключения.Свойство("URL") 
			Или Не ЗначениеЗаполнено(ИнформацияПодключения.URL) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не задан URL сервиса обмена сообщениями с информационной базой %1'"), ПредставлениеПолучателя);
	КонецЕсли;
	
	ВерсияКорреспондента = ИнтерфейсыСообщенийВМоделиСервиса.ВерсияИнтерфейсаКорреспондента(
			ИнтерфейсСообщения.ПрограммныйИнтерфейс, ИнформацияПодключения, ПредставлениеПолучателя);
	
	Если ВерсияКорреспондента = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Корреспондент %1 не поддерживает получение версий сообщений интерфейса %2, поддерживаемых текущей информационной базой.'"),
			ПредставлениеПолучателя, ИнтерфейсСообщения.ПрограммныйИнтерфейс);
	КонецЕсли;
	
	ОтправляемаяВерсия = ИнтерфейсыСообщенийВМоделиСервиса.ПолучитьВерсииОтправляемыхСообщений().Получить(ИнтерфейсСообщения.ПрограммныйИнтерфейс);
	Если ОтправляемаяВерсия = ВерсияКорреспондента Тогда
		Возврат;
	КонецЕсли;
	
	Сообщение = ТрансляцияXDTO.ТранслироватьВВерсию(Сообщение, ВерсияКорреспондента, ИнтерфейсСообщения.ПространствоИмен);
	
КонецПроцедуры

#КонецОбласти
