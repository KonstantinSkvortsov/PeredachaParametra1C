
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.РазрешеноВыбиратьИНастраиватьВариантыБезСохранения = Истина;
	Настройки.СкрытьКомандыРассылки                              = Истина;
	Настройки.ФормироватьСразу                                   = Истина;
	
	Настройки.События.ПриСозданииНаСервере               = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере    = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - форма отчета.
//   Отказ - Булево - передается из параметров стандартного обработчика ПриСозданииНаСервере "как есть".
//   СтандартнаяОбработка - Булево - передается из параметров стандартного обработчика ПриСозданииНаСервере "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ПараметрыФормы = Форма.Параметры;
	Если ПараметрыФормы.Свойство("СсылкаНаОбъект") Тогда
		
		ИмяПроцедуры = "КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта";
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Форма", Форма, Тип("УправляемаяФорма"));
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ПроблемныйОбъект", ПараметрыФормы.СсылкаНаОбъект, ОбщегоНазначения.ОписаниеТипаВсеСсылки());
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "СтандартнаяОбработка", СтандартнаяОбработка, Тип("Булево"));
		
		СтруктураПараметровДанных = Новый Структура("Контекст", ПараметрыФормы.СсылкаНаОбъект);
		УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
		
	ИначеЕсли ПараметрыФормы.Свойство("ДанныеКонтекста") Тогда
		
		Если ТипЗнч(ПараметрыФормы.ДанныеКонтекста) = Тип("Структура") Тогда
			
			ДанныеКонтекста  = ПараметрыФормы.ДанныеКонтекста;
			ВыделенныеСтроки = ДанныеКонтекста.ВыделенныеСтроки;
			
			Если ВыделенныеСтроки.Количество() > 0 Тогда
				
				ПроблемныеОбъекты = КонтрольВеденияУчетаСлужебный.ПроблемныеОбъекты(ДанныеКонтекста.ВыделенныеСтроки);
				
				Если ПроблемныеОбъекты.Количество() = 0 Тогда
					Отказ = Истина;
				Иначе
					
					СписокПроблемныхОбъектов = Новый СписокЗначений;
					СписокПроблемныхОбъектов.ЗагрузитьЗначения(ПроблемныеОбъекты);
					
					СтруктураПараметровДанных = Новый Структура("Контекст", СписокПроблемныхОбъектов);
					УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("МассивСсылок") Тогда
		
		МассивСсылок = ПараметрыФормы.МассивСсылок;
		Если МассивСсылок.Количество() > 0 Тогда
			
			СписокПроблемныхОбъектов = Новый СписокЗначений;
			СписокПроблемныхОбъектов.ЗагрузитьЗначения(МассивСсылок);
			
			СтруктураПараметровДанных = Новый Структура("Контекст", СписокПроблемныхОбъектов);
			УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("ВидПроверки") Тогда
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемам", "ВидПроверки", 
			ПараметрыФормы.ВидПроверки, КонтрольВеденияУчетаСлужебный.ОписаниеТипаВидПроверки());
		
		ПодробнаяИнформацияПоВидамПроверок = КонтрольВеденияУчета.ПодробнаяИнформацияПоВидамПроверок(ПараметрыФормы.ВидПроверки);
		Если ПодробнаяИнформацияПоВидамПроверок.Количество() = 0 Тогда
			Отказ = Истина;
		Иначе
			КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СписокПроблем", ПодготовитьСписокПроверок(ОбщегоНазначенияКлиентСервер.СвернутьМассив(
				ПодробнаяИнформацияПоВидамПроверок.ВыгрузитьКолонку("ПравилоПроверки"))));
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("ПараметрКоманды") Тогда
		
		Если ТипЗнч(ПараметрыФормы.ПараметрКоманды) = Тип("Массив") И ПараметрыФормы.ПараметрКоманды.Количество() > 0 Тогда
			КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СписокПроблем", ПодготовитьСписокПроверок(ПараметрыФормы.ПараметрКоманды));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже.
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Варианты вызова:
//   Если КлючСхемы <> "1" Тогда
//   	КлючСхемы = "1";
//   	СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//   	ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//   КонецЕсли; - компоновщик отчета инициализируется на основании схемы из общих макетов.
//   Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//   	ПолноеИмяОбъектаМетаданных = "";
//   	Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//   		Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//   			ИмяПараметра = Строка(ЭлементКД.Параметр);
//   			Если ИмяПараметра = "ОбъектМетаданных" Тогда
//   				ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//   			КонецЕсли;
//   		КонецЕсли;
//   	КонецЦикла;
//   	Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//   		КлючСхемы = ПолноеИмяОбъектаМетаданных;
//   		СхемаКД = Новый СхемаКомпоновкиДанных;
//   		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//   	КонецЕсли;
//   КонецЕсли; - схема зависит от значения параметра, выведенного в пользовательские настройки отчета.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПараметрВыводитьОтветственного = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтветственного"));
	Если ПараметрВыводитьОтветственного <> Неопределено И НовыеПользовательскиеНастройкиКД <> Неопределено Тогда
		Настройка = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ПараметрВыводитьОтветственного.ИдентификаторПользовательскойНастройки);
		Если Настройка <> Неопределено Тогда
			СкрытьГруппировкуПоОтветственным(НовыеНастройкиКД, Настройка);
		КонецЕсли;
	КонецЕсли;
	
	Если КлючСхемы <> "1" Тогда
		КлючСхемы = "1";
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// Более подробное описание можно найти в синтакс-помощнике, а именно, в разделе расширений
// управляемой формы для отчета.
//
// Параметры:
//   Форма - УправляемаяФорма - форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ПараметрСКД         = Новый ПараметрКомпоновкиДанных("Контекст");
	КонтекстПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ПараметрСКД);
	
	Если КонтекстПараметрСКД <> Неопределено Тогда
		Контекст = КонтекстПараметрСКД.Значение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контекст) Тогда
		УстановитьПараметрыДанных(НовыеНастройкиКД, Новый Структура("Контекст", Контекст));
	КонецЕсли;
	
	УстановитьЛокализованныеПараметры(НовыеНастройкиКД);
	
	ДополнительныеСвойства = КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("СписокПроблем") Тогда
		УстановитьОтборПоСпискуПроблем(НовыеНастройкиКД.Отбор, ВидСравненияКомпоновкиДанных.ВСписке, ДополнительныеСвойства.СписокПроблем);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ВыводСКД

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПроверкиВеденияУчета = КонтрольВеденияУчетаСлужебныйПовтИсп.ПроверкиВеденияУчета();
	
	НастройкиКД       = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, Новый Структура("ВнешняяТаблица", ПроверкиВеденияУчета.Проверки), ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДоопределитьГотовыйМакет(ДокументРезультат, СтруктураОтчетаНеИзменена());
	
КонецПроцедуры

Процедура ДоопределитьГотовыйМакет(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	ДоопределитьШапку(ДокументРезультат, СтруктураОтчетаНеИзменена);
	
	ДоопределитьВыводИтогов(ДокументРезультат, СтруктураОтчетаНеИзменена);
	
	ПроставитьГиперссылкиРешений(ДокументРезультат);
	
КонецПроцедуры

Процедура ДоопределитьШапку(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	Если СтруктураОтчетаНеИзменена Тогда
		
		ПерваяСтрока    = 0;
		ПоследняяСтрока = 0;
		
		ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
		
		Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
			
			ИмяОбласти = "R" + Формат(ИндексСтрок, "ЧГ=0");
			Область    = ДокументРезультат.Область(ИмяОбласти);
			
			Если СтрНайти(Область.Текст, "[ЗаголовокСкрыт]") <> 0 Тогда
				Если ПерваяСтрока = 0 Тогда
					ПерваяСтрока = ИндексСтрок;
				КонецЕсли;
				ПоследняяСтрока = ПоследняяСтрока + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		ДокументРезультат.УдалитьОбласть(ДокументРезультат.Область("R" + Формат(ПерваяСтрока, "ЧГ=0") + ":R" + Формат(ПерваяСтрока + ПоследняяСтрока - 1, "ЧГ=0")),
			ТипСмещенияТабличногоДокумента.ПоВертикали);
		
		ДокументРезультат.ФиксацияСверху = ПерваяСтрока - 1;
		
	Иначе
		
		ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
		ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
		
		Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
			Для ИндексКолонок = 1 По ШиринаТаблицы Цикл
			
				ИмяОбласти = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
				Область    = ДокументРезультат.Область(ИмяОбласти);
				
				Если СтрНайти(Область.Текст, "[ЗаголовокСкрыт]") <> 0 Тогда
					Область.Текст = СтрЗаменить(Область.Текст, "[ЗаголовокСкрыт]", "");
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли
	
КонецПроцедуры

Процедура ДоопределитьВыводИтогов(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	Если Не СтруктураОтчетаНеИзменена Тогда
		Возврат;
	КонецЕсли;
	
	ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
	ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
	
	Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
		Для ИндексКолонок = 1 По ШиринаТаблицы Цикл
			
			ИмяОбласти = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
			Область    = ДокументРезультат.Область(ИмяОбласти);
			
			Если СокрЛП(ВРег(Область.Текст)) = НСтр("ru = 'ИТОГО'") Тогда
				Область.ЦветФона = Новый Цвет(255, 250, 217);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ИмяОбласти   = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C1";
		Область      = ДокументРезультат.Область(ИмяОбласти);
		ТекстОбласти = СокрЛП(ВРег(Область.Текст));
		
		Если ТекстОбласти =    НСтр("ru = 'ОШИБКА'")
			Или ТекстОбласти = НСтр("ru = 'ВОЗМОЖНЫЕ ПРИЧИНЫ'")
			Или ТекстОбласти = НСтр("ru = 'РЕКОМЕНДАЦИИ'")
			Или ТекстОбласти = НСтр("ru = 'РЕШЕНИЕ'") Тогда
			
			Для ИндексКолонок = 3 По ШиринаТаблицы Цикл
				ИмяОбластиРесурсов    = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
				ОбластьРесурсов       = ДокументРезультат.Область(ИмяОбластиРесурсов);
				ОбластьРесурсов.Текст = "";
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроставитьГиперссылкиРешений(ДокументРезультат)
	
	ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
	ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
	
	Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
		Для ИндексКолонок = 1 По ШиринаТаблицы Цикл
			
			ИмяОбласти   = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
			Область      = ДокументРезультат.Область(ИмяОбласти);
			ТекстОбласти = Область.Текст;
			
			Если СтрНачинаетсяС(ТекстОбласти, "%") И СтрЗаканчиваетсяНа(ТекстОбласти, "%") Тогда
				
				ТекстОбласти      = СокрЛП(СтрЗаменить(ТекстОбласти, "%", ""));
				РазделеннаяСтрока = СтрРазделить(ТекстОбласти, ",");
				
				Если РазделеннаяСтрока.Количество() <> 3 Тогда
					Продолжить;
				КонецЕсли;
				
				ОбработчикПереходаКИсправлению = РазделеннаяСтрока.Получить(1);
				Если Не ЗначениеЗаполнено(ОбработчикПереходаКИсправлению) Тогда
					Область.Текст = "";
					Продолжить;
				КонецЕсли;
				
				ВидПроверки = Справочники.ВидыПроверок.ПолучитьСсылку(Новый УникальныйИдентификатор(РазделеннаяСтрока.Получить(2)));
				
				СтруктураРасшифровки = Новый Структура;
				
				СтруктураРасшифровки.Вставить("Назначение",                     "ИсправитьПроблемы");
				СтруктураРасшифровки.Вставить("ИдентификаторПроверки",          РазделеннаяСтрока.Получить(0));
				СтруктураРасшифровки.Вставить("ОбработчикПереходаКИсправлению", ОбработчикПереходаКИсправлению);
				СтруктураРасшифровки.Вставить("ВидПроверки",                    ВидПроверки);
				
				Область.Расшифровка = СтруктураРасшифровки;
				
				ОтчетыСервер.ВывестиГиперссылку(Область, СтруктураРасшифровки, НСтр("ru = 'Выполнить исправление'"));
				
			ИначеЕсли СтрНайти(ТекстОбласти, "<РасшифровкаСписка>") <> 0 Тогда
				
				СтруктураРасшифровки = Новый Структура;
				СтруктураРасшифровки.Вставить("Назначение", "ОткрытьФормуСписка");
				
				ОтборНабораЗаписей = Новый Структура;
				РазделенныйТекст   = СтрРазделить(ТекстОбласти, Символы.ПС);
				
				Для Каждого ЭлементТекста Из РазделенныйТекст Цикл
					
					Если РазделенныйТекст.Найти(ЭлементТекста) = 0 Тогда
						Продолжить;
					ИначеЕсли РазделенныйТекст.Найти(ЭлементТекста) = 1 Тогда
						СтруктураРасшифровки.Вставить("ПолноеИмяОбъекта", ЭлементТекста);
						Продолжить;
					КонецЕсли;
					
					РазделенныйЭлементТекста = СтрРазделить(ЭлементТекста, "~~~", Ложь);
					Если РазделенныйЭлементТекста.Количество() <> 3 Тогда
						Продолжить;
					КонецЕсли;
					
					ИмяОтбора             = РазделенныйЭлементТекста.Получить(0);
					ТипЗначенияОтбора     = РазделенныйЭлементТекста.Получить(1);
					ЗначениеОтбораСтрокой = РазделенныйЭлементТекста.Получить(2);
					
					Если ТипЗначенияОтбора = "Число" Или ТипЗначенияОтбора = "Строка" 
						Или ТипЗначенияОтбора = "Булево" Или ТипЗначенияОтбора = "Дата" Тогда
						
						ЗначениеОтбора = XMLЗначение(Тип(ТипЗначенияОтбора), ЗначениеОтбораСтрокой);
						
					ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(Метаданные.НайтиПоПолномуИмени(ТипЗначенияОтбора)) Тогда
						
						ЗначениеОтбора = XMLЗначение(Тип(СтрЗаменить(ТипЗначенияОтбора, "Перечисление", "ПеречислениеСсылка")), ЗначениеОтбораСтрокой);
						
					Иначе
						
						МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипЗначенияОтбора);
						Если МенеджерОбъекта = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						ЗначениеОтбора = МенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеОтбораСтрокой));
						
					КонецЕсли;
					
					ОтборНабораЗаписей.Вставить(ИмяОтбора, ЗначениеОтбора);
					
				КонецЦикла;
				СтруктураРасшифровки.Вставить("Отбор", ОтборНабораЗаписей);
				
				Область.Расшифровка = СтруктураРасшифровки;
				
				Если РазделенныйТекст.Количество() <> 0 Тогда
					Область.Текст = СтрЗаменить(РазделенныйТекст.Получить(0), "<РасшифровкаСписка>", "");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовитьСписокПроверок(МассивПроверок)
	
	СписокПроверок = Новый СписокЗначений;
	ПервыйЭлемент  = МассивПроверок.Получить(0);
	
	Если Не ОбщегоНазначения.ЗначениеСсылочногоТипа(ПервыйЭлемент) Тогда
		СписокПроверок.ЗагрузитьЗначения(МассивПроверок);
	Иначе
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка КАК Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(Таблица.Ссылка) КАК ПредставлениеСсылки
		|ИЗ
		|	&Таблица КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка В(&МассивСсылок)";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", ПервыйЭлемент.Метаданные().ПолноеИмя());
		Запрос       = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("МассивСсылок", МассивПроверок);
		
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		Для Каждого ЭлементРезультата Из РезультатЗапроса Цикл
			СписокПроверок.Добавить(ЭлементРезультата.Ссылка, ЭлементРезультата.ПредставлениеСсылки);
		КонецЦикла;
		
		Запрос = Неопределено;
	КонецЕсли;
	
	Возврат СписокПроверок;
	
КонецФункции

#КонецОбласти

#Область ПрограммныеНастройкиСКД

Процедура УстановитьПараметрыДанных(НастройкиКД, СтруктураПараметров)
	
	ПараметрыДанных = НастройкиКД.ПараметрыДанных.Элементы;
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
	
		ТекущийПараметр   = Новый ПараметрКомпоновкиДанных(Параметр.Ключ);
		ТекущийПараметрКД = ПараметрыДанных.Найти(ТекущийПараметр);
	
		Если ТекущийПараметрКД <> Неопределено Тогда
	
			ТекущийПараметрКД.Использование = Истина;
			ТекущийПараметрКД.Значение      = Параметр.Значение;
	
		Иначе
	
			ПараметрДанных               = НастройкиКД.ПараметрыДанных.Элементы.Добавить();
			ПараметрДанных.Использование = Истина;
			ПараметрДанных.Значение      = Параметр.Значение;
			ПараметрДанных.Параметр      = Новый ПараметрКомпоновкиДанных(Параметр.Ключ);
	
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЛокализованныеПараметры(НастройкиКД)
	
	ПараметрыДанных = НастройкиКД.ПараметрыДанных.Элементы;
	
	СтруктураЛокализованныхПараметров = Новый Структура;
	СтруктураЛокализованныхПараметров.Вставить("НадписьОшибка",            НСтр("ru = 'Ошибка'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьВозможныеПричины",  НСтр("ru = 'Возможные причины'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьРекомендации",      НСтр("ru = 'Рекомендации'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьРешение",           НСтр("ru = 'Решение'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьПроблемныеОбъекты", НСтр("ru = 'Проблемные объекты'"));
	
	Для Каждого ЭлементСтруктуры Из СтруктураЛокализованныхПараметров Цикл
		
		ТекущийПараметрКД = ПараметрыДанных.Найти(Новый ПараметрКомпоновкиДанных(ЭлементСтруктуры.Ключ));
		Если ТекущийПараметрКД <> Неопределено Тогда
			
			ТекущийПараметрКД.Использование = Истина;
			ТекущийПараметрКД.Значение      = ЭлементСтруктуры.Значение;
			
		Иначе
			
			ПараметрДанных               = НастройкиКД.ПараметрыДанных.Элементы.Добавить();
			ПараметрДанных.Использование = Истина;
			ПараметрДанных.Значение      = ЭлементСтруктуры.Значение;
			ПараметрДанных.Параметр      = Новый ПараметрКомпоновкиДанных(ЭлементСтруктуры.Ключ);
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьОтборПоСпискуПроблем(ОтборНастроекКД, ВидСравнения, ЗначениеОтбора)
	
	ПредставлениеОтбора = "";
	Для Каждого ЭлементСпискаОтбора Из ЗначениеОтбора Цикл
		ПредставлениеОтбора = ПредставлениеОтбора + ?(ЗначениеЗаполнено(ПредставлениеОтбора), "; ", "") + Лев(ЭлементСпискаОтбора.Представление, 25) + "...";
	КонецЦикла;
	
	ЭлементыОтбора = ОтборНастроекКД.Элементы;
	
	ЭлементОтбора                  = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ПравилоПроверки");
	ЭлементОтбора.ВидСравнения     = ВидСравнения;
	ЭлементОтбора.ПравоеЗначение   = ЗначениеОтбора;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Представление    = НСтр("ru = 'Правило проверки В списке'") + " """ + ПредставлениеОтбора + """";
	ЭлементОтбора.Использование    = Истина;
	
КонецПроцедуры

Процедура СкрытьГруппировкуПоОтветственным(НовыеНастройкиКД, Настройка)
	
	Если НовыеНастройкиКД <> Неопределено Тогда
		ГруппировкаПоОтветственномуКолонки = НайтиГруппировку(НовыеНастройкиКД.Структура[0].Колонки, "ОтветственныйГруппировка");
		ПолеОтветственного                 = НайтиПолеГруппировки(НовыеНастройкиКД.Структура[0].Строки, "Ответственный");
		Если ПолеОтветственного <> Неопределено Тогда
			ПолеОтветственного.Использование = Настройка.Значение;
		КонецЕсли;
		Если ГруппировкаПоОтветственномуКолонки <> Неопределено Тогда
			ГруппировкаПоОтветственномуКолонки.Состояние = ?(Настройка.Значение, СостояниеЭлементаНастройкиКомпоновкиДанных.Включен,
				СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиГруппировку(Структура, ИмяПоля)
	
	Для каждого Элемент Из Структура Цикл
		
		ПоляГруппировки = Элемент.ПоляГруппировки.Элементы;
		Для Каждого Поле Из ПоляГруппировки Цикл
			
			Если ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			Если Поле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
				Возврат Элемент;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Элемент.Структура.Количество() = 0 Тогда
			Продолжить;
		Иначе
			Группировка = НайтиГруппировку(Элемент.Структура, ИмяПоля);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

Функция НайтиПолеГруппировки(Структура, ИмяПоля)
	
	Группировка = НайтиГруппировку(Структура, ИмяПоля);
	
	Если Группировка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПоляГруппировки = Группировка.ПоляГруппировки.Элементы;
	НайденноеПоле   = Неопределено;
	
	Для Каждого ПолеГруппировки Из ПоляГруппировки Цикл
		ЦелевоеПоле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		Если ПолеГруппировки.Поле = ЦелевоеПоле Тогда
			НайденноеПоле = ПолеГруппировки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НайденноеПоле;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураОтчетаНеИзменена(ИсходнаяСтруктура = Неопределено, КонечнаяСтруктура = Неопределено)
	
	ИсходнаяСтруктура = СтруктураОтчетаДеревом(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонечнаяСтруктура = СтруктураОтчетаДеревом(КомпоновщикНастроек.Настройки);
	Возврат ДеревьяИдентичны(ИсходнаяСтруктура, КонечнаяСтруктура);
	
КонецФункции

Функция ДеревьяИдентичны(ПервоеДерево, ВтороеДерево, ДеревьяИдентичны = Истина, СвойстваДляСравнения = Неопределено)
	
	Если СвойстваДляСравнения = Неопределено Тогда
		СвойстваДляСравнения = Новый Массив;
		СвойстваДляСравнения.Добавить("Тип");
		СвойстваДляСравнения.Добавить("Подтип");
		СвойстваДляСравнения.Добавить("ЕстьСтруктура");
	КонецЕсли;
	
	СтрокиПервогоДерева = ПервоеДерево.Строки;
	СтрокиВторогоДерева = ВтороеДерево.Строки;
	
	КоличествоСтрокПервогоДерева  = СтрокиПервогоДерева.Количество();
	КоличествоСтрокиВторогоДерева = СтрокиВторогоДерева.Количество();
	
	Если КоличествоСтрокПервогоДерева <> КоличествоСтрокиВторогоДерева Тогда
		ДеревьяИдентичны = Ложь;
	КонецЕсли;
	
	Для ИндексСтроки = 0 По КоличествоСтрокПервогоДерева - 1 Цикл
		
		ТекущаяСтрокаПервогоДерева = СтрокиПервогоДерева.Получить(ИндексСтроки);
		ТекущаяСтрокаВторогоДерева = СтрокиВторогоДерева.Получить(ИндексСтроки);
		
		Для Каждого СвойствоДляСравнения Из СвойстваДляСравнения Цикл
			
			Если ТекущаяСтрокаПервогоДерева[СвойствоДляСравнения] <> ТекущаяСтрокаВторогоДерева[СвойствоДляСравнения] Тогда
				ДеревьяИдентичны = Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не НастройкиУзловКДИдентичны(ТекущаяСтрокаПервогоДерева.УзелКД, ТекущаяСтрокаВторогоДерева.УзелКД) Тогда
			ДеревьяИдентичны = Ложь;
		КонецЕсли;
		
		ДеревьяИдентичны(ТекущаяСтрокаПервогоДерева, ТекущаяСтрокаВторогоДерева, ДеревьяИдентичны, СвойстваДляСравнения);
		
	КонецЦикла;
	
	Возврат ДеревьяИдентичны;
	
КонецФункции

Функция НастройкиУзловКДИдентичны(ПервыйУзелКД, ВторойУзелКД)
	
	Если ТипЗнч(ПервыйУзелКД) <> ТипЗнч(ВторойУзелКД) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ПервыйУзелКД) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ПользовательскиеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Если Не СвойстваТаблицКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		
		Если Не СвойстваКоллекцийЭлементовСтруктурыТаблицыКомпоновкиДанныхИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Или ТипЗнч(ПервыйУзелКД) = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		Если Не СвойстваГруппировокКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ПоляГруппировокКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД)
	
	ВыбранныеПоляПервогоУзла = ПервыйУзелКД.Выбор.Элементы;
	ВыбранныеПоляВторогоУзла = ВторойУзелКД.Выбор.Элементы;
	
	КоличествоВыбранныхПолейПервогоУзла = ВыбранныеПоляПервогоУзла.Количество();
	КоличествоВыбранныхПолейВторогоУзла = ВыбранныеПоляВторогоУзла.Количество();
	
	Если КоличествоВыбранныхПолейПервогоУзла <> КоличествоВыбранныхПолейВторогоУзла Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СвойстваВыбранныхПолей = Новый Массив;
	
	Для Индекс = 0 По КоличествоВыбранныхПолейПервогоУзла - 1 Цикл
		
		ТекущаяСтрокаПервойКоллекции = ВыбранныеПоляПервогоУзла.Получить(Индекс);
		ТекущаяСтрокаВторойКоллекции = ВыбранныеПоляВторогоУзла.Получить(Индекс);
		
		Если ТипЗнч(ТекущаяСтрокаПервойКоллекции) <> ТипЗнч(ТекущаяСтрокаВторойКоллекции) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			
			СвойстваВыбранныхПолей.Добавить("Использование");
			СвойстваВыбранныхПолей.Добавить("Родитель");
			
		ИначеЕсли ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			
			СвойстваВыбранныхПолей.Добавить("Заголовок");
			СвойстваВыбранныхПолей.Добавить("Использование");
			СвойстваВыбранныхПолей.Добавить("Поле");
			СвойстваВыбранныхПолей.Добавить("РежимОтображения");
			СвойстваВыбранныхПолей.Добавить("Родитель");
			
		ИначеЕсли ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
		Если Не СравнитьСущностиПоСвойствам(ТекущаяСтрокаПервойКоллекции, ТекущаяСтрокаВторойКоллекции, СвойстваВыбранныхПолей) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваТаблицКомпоновкиИдентичны(ПерваяТаблица, ВтораяТаблица)
	
	СвойстваТаблицыКомпоновки = Новый Массив;
	СвойстваТаблицыКомпоновки.Добавить("Идентификатор");
	СвойстваТаблицыКомпоновки.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("Имя");
	СвойстваТаблицыКомпоновки.Добавить("Использование");
	СвойстваТаблицыКомпоновки.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("РежимОтображения");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяТаблица, ВтораяТаблица, СвойстваТаблицыКомпоновки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваГруппировокКомпоновкиИдентичны(ПерваяТаблица, ВтораяТаблица)
	
	СвойстваТаблицыКомпоновки = Новый Массив;
	СвойстваТаблицыКомпоновки.Добавить("Идентификатор");
	СвойстваТаблицыКомпоновки.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("Имя");
	СвойстваТаблицыКомпоновки.Добавить("Использование");
	СвойстваТаблицыКомпоновки.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("РежимОтображения");
	СвойстваТаблицыКомпоновки.Добавить("Состояние");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяТаблица, ВтораяТаблица, СвойстваТаблицыКомпоновки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваКоллекцийЭлементовСтруктурыТаблицыКомпоновкиДанныхИдентичны(ПерваяКоллекция, ВтораяКоллекция)
	
	СвойстваКоллекции = Новый Массив;
	СвойстваКоллекции.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваКоллекции.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваКоллекции.Добавить("РежимОтображения");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяКоллекция, ВтораяКоллекция, СвойстваКоллекции) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПоляГруппировокКомпоновкиИдентичны(ПерваяГруппировка, ВтораяГруппировка)
	
	ПерваяКоллекцияПолей = ПерваяГруппировка.ПоляГруппировки.Элементы;
	ВтораяКоллекцияПолей = ВтораяГруппировка.ПоляГруппировки.Элементы;
	
	КоличествоПолейВПервойКоллекции  = ПерваяКоллекцияПолей.Количество();
	КоличествоПолейВоВторойКоллекции = ВтораяКоллекцияПолей.Количество();
	
	СвойстваПолей = Новый Массив;
	СвойстваПолей.Добавить("Использование");
	СвойстваПолей.Добавить("КонецПериода");
	СвойстваПолей.Добавить("НачалоПериода");
	СвойстваПолей.Добавить("Поле");
	СвойстваПолей.Добавить("ТипГруппировки");
	СвойстваПолей.Добавить("ТипДополнения");
	
	Если КоличествоПолейВПервойКоллекции <> КоличествоПолейВоВторойКоллекции Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Индекс = 0 По КоличествоПолейВПервойКоллекции - 1 Цикл
		
		ТекущаяСтрокаПервогоПоля = ПерваяКоллекцияПолей.Получить(Индекс);
		ТекущаяСтрокаВторогоПоля = ВтораяКоллекцияПолей.Получить(Индекс);
		
		Если Не СравнитьСущностиПоСвойствам(ТекущаяСтрокаПервогоПоля, ТекущаяСтрокаВторогоПоля, СвойстваПолей) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПользовательскиеПоляИдентичны(ПервыеНастройкиКД, ВторыеНастройкиКД)
	
	Если ПервыеНастройкиКД.ПользовательскиеПоля.Элементы.Количество() <> ВторыеНастройкиКД.ПользовательскиеПоля.Элементы.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СравнитьСущностиПоСвойствам(ПерваяСущность, ВтораяСущность, Свойства)
	
	Для Каждого Свойство Из Свойства Цикл
		
		Если ЭтоИсключение(ПерваяСущность, Свойство) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПерваяСущность[Свойство] <> ВтораяСущность[Свойство] Тогда
			Возврат Ложь
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ЭтоИсключение(ПерваяСущность, Свойство)
	
	Если ТипЗнч(ПерваяСущность) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		
		Если ПерваяСущность.Имя = "Ответственный" И Свойство = "Состояние" Тогда
			Возврат Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПерваяСущность) = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
		
		Если ПерваяСущность.Поле = Новый ПолеКомпоновкиДанных("Ответственный") И Свойство = "Использование" Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция СтруктураОтчетаДеревом(НастройкиКД)
	
	ДеревоСтруктуры       = ДеревоСтруктуры();
	СтрокаДереваСтруктуры = ЗарегистрироватьУзелДереваВарианта(НастройкиКД, НастройкиКД, ДеревоСтруктуры.Строки);
	Возврат ДеревоСтруктуры;
	
КонецФункции

Функция ДеревоСтруктуры()
	
	ДеревоСтруктуры = Новый ДеревоЗначений;
	
	КолонкиДереваСтруктуры = ДеревоСтруктуры.Колонки;
	КолонкиДереваСтруктуры.Добавить("УзелКД");
	КолонкиДереваСтруктуры.Добавить("ДоступнаяНастройкаКД");
	КолонкиДереваСтруктуры.Добавить("Тип",                 Новый ОписаниеТипов("Строка"));
	КолонкиДереваСтруктуры.Добавить("Подтип",              Новый ОписаниеТипов("Строка"));
	КолонкиДереваСтруктуры.Добавить("ЕстьСтруктура",       Новый ОписаниеТипов("Булево"));
	
	Возврат ДеревоСтруктуры;
	
КонецФункции

Функция ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД, НаборСтрокДерева, ПодТип = "")
	
	СтрокаДерева = НаборСтрокДерева.Добавить();
	СтрокаДерева.УзелКД = УзелКД;
	СтрокаДерева.Тип    = ТипНастройкиСтрокой(ТипЗнч(УзелКД));
	СтрокаДерева.Подтип = ПодТип;
	
	Если СтрНайти("Настройки, Группировка, ГруппировкаДиаграммы, ГруппировкаТаблицы", СтрокаДерева.Тип) <> 0 Тогда
		СтрокаДерева.ЕстьСтруктура = Истина;
	ИначеЕсли СтрНайти("Таблица, Диаграмма, НастройкиВложенногоОбъекта,
		|КоллекцияЭлементовСтруктурыТаблицы, КоллекцияЭлементовСтруктурыДиаграммы", СтрокаДерева.Тип) = 0 Тогда
		Возврат СтрокаДерева;
	КонецЕсли;
	
	Если СтрокаДерева.ЕстьСтруктура Тогда
		Для Каждого ВложенныйЭлемент Из УзелКД.Структура Цикл
			ЗарегистрироватьУзелДереваВарианта(НастройкиКД, ВложенныйЭлемент, СтрокаДерева.Строки);
		КонецЦикла;
	КонецЕсли;
	
	Если СтрокаДерева.Тип = "Таблица" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Строки, СтрокаДерева.Строки, "ТаблицаСтроки");
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Колонки, СтрокаДерева.Строки, "ТаблицаКолонки");
	ИначеЕсли СтрокаДерева.Тип = "Диаграмма" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Точки, СтрокаДерева.Строки, "ДиаграммаТочки");
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Серии, СтрокаДерева.Строки, "ДиаграммаСерии");
	ИначеЕсли СтрокаДерева.Тип = "КоллекцияЭлементовСтруктурыТаблицы"
		Или СтрокаДерева.Тип = "КоллекцияЭлементовСтруктурыДиаграммы" Тогда
		Для Каждого ВложенныйЭлемент Из УзелКД Цикл
			ЗарегистрироватьУзелДереваВарианта(НастройкиКД, ВложенныйЭлемент, СтрокаДерева.Строки);
		КонецЦикла;
	ИначеЕсли СтрокаДерева.Тип = "НастройкиВложенногоОбъекта" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Настройки, СтрокаДерева.Строки);
	КонецЕсли;
	
	Возврат СтрокаДерева;
	
КонецФункции

Функция ТипНастройкиСтрокой(Тип) Экспорт
	Если Тип = Тип("НастройкиКомпоновкиДанных") Тогда
		Возврат "Настройки";
	ИначеЕсли Тип = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		Возврат "НастройкиВложенногоОбъекта";
	
	ИначеЕсли Тип = Тип("ОтборКомпоновкиДанных") Тогда
		Возврат "Отбор";
	ИначеЕсли Тип = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Возврат "ЭлементОтбора";
	ИначеЕсли Тип = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		Возврат "ГруппаЭлементовОтбора";
	
	ИначеЕсли Тип = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		Возврат "ЗначениеПараметраНастроек";
	
	ИначеЕсли Тип = Тип("ГруппировкаКомпоновкиДанных") Тогда
		Возврат "Группировка";
	ИначеЕсли Тип = Тип("ПоляГруппировкиКомпоновкиДанных") Тогда
		Возврат "ПоляГруппировки";
	ИначеЕсли Тип = Тип("КоллекцияПолейГруппировкиКомпоновкиДанных") Тогда
		Возврат "КоллекцияПолейГруппировки";
	ИначеЕсли Тип = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
		Возврат "ПолеГруппировки";
	ИначеЕсли Тип = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
		Возврат "АвтоПолеГруппировки";
	
	ИначеЕсли Тип = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
		Возврат "ВыбранныеПоля";
	ИначеЕсли Тип = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
		Возврат "ВыбранноеПоле";
	ИначеЕсли Тип = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
		Возврат "ГруппаВыбранныхПолей";
	ИначеЕсли Тип = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
		Возврат "АвтоВыбранноеПоле";
	
	ИначеЕсли Тип = Тип("ПорядокКомпоновкиДанных") Тогда
		Возврат "Порядок";
	ИначеЕсли Тип = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		Возврат "ЭлементПорядка";
	ИначеЕсли Тип = Тип("АвтоЭлементПорядкаКомпоновкиДанных") Тогда
		Возврат "АвтоЭлементПорядка";
	
	ИначеЕсли Тип = Тип("УсловноеОформлениеКомпоновкиДанных") Тогда
		Возврат "УсловноеОформление";
	ИначеЕсли Тип = Тип("ЭлементУсловногоОформленияКомпоновкиДанных") Тогда
		Возврат "ЭлементУсловногоОформления";
	
	ИначеЕсли Тип = Тип("СтруктураНастроекКомпоновкиДанных") Тогда
		Возврат "СтруктураНастроек";
	ИначеЕсли Тип = Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") Тогда
		Возврат "КоллекцияЭлементовСтруктурыНастроек";
	
	ИначеЕсли Тип = Тип("ТаблицаКомпоновкиДанных") Тогда
		Возврат "Таблица";
	ИначеЕсли Тип = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		Возврат "ГруппировкаТаблицы";
	ИначеЕсли Тип = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		Возврат "КоллекцияЭлементовСтруктурыТаблицы";
	
	ИначеЕсли Тип = Тип("ДиаграммаКомпоновкиДанных") Тогда
		Возврат "Диаграмма";
	ИначеЕсли Тип = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		Возврат "ГруппировкаДиаграммы";
	ИначеЕсли Тип = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") Тогда
		Возврат "КоллекцияЭлементовСтруктурыДиаграммы";
	
	ИначеЕсли Тип = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		Возврат "ЗначенияПараметровДанных";
	
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецЕсли