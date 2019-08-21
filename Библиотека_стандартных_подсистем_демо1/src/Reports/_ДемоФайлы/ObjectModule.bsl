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
	Настройки.ФормироватьСразу = Истина;
	Настройки.Печать.ПолеСверху = 5;
	Настройки.Печать.ПолеСлева = 5;
	Настройки.Печать.ПолеСнизу = 5;
	Настройки.Печать.ПолеСправа = 5;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. также: УправляемаяФорма.ПриСозданииНаСервере в синтакс-помощнике 
// и ОтчетыПереопределяемый.ПриСозданииНаСервере.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	Форма.Элементы.ГруппаОтправить.Подсказка = НСтр("ru = '<Демо: Тест>'");
	Если Форма.Параметры.КлючВарианта = "ПоВерсиям" Тогда
		ОписаниеКоманды = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Форма.Параметры, "ОписаниеКоманды");
		Если ОписаниеКоманды <> Неопределено И ОписаниеКоманды.Идентификатор = "_ДемоОтчетПоВерсиям" Тогда
			Форма.ФормаПараметры.Отбор.Вставить("Папка", ВладельцыФайлов(Форма.ФормаПараметры.Отбор.Ссылка));
		КонецЕсли;
	КонецЕсли;
	
	Команда = Форма.Команды.Добавить("_ДемоКоманда");
	Команда.Действие  = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Изменить табличный документ'");
	Команда.Картинка  = БиблиотекаКартинок.Изменить;
	
	ОтчетыСервер.ВывестиКоманду(Форма, Команда, "РаботаСТабличнымДокументом");
	
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
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
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
// Пример:
//  // Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
//  // Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	Если КлючСхемы <> "1" Тогда
		КлючСхемы = "1";
		// Подмена списка доступных значений на уровне схемы, чтобы СКД знала о представлениях этих значений.
		ВсеИзвестныеТипыФайлов = ТипыФайлов();
		ПолеНабораДанныхСхемыКД = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Поля.Найти("Тип");
		Если ТипЗнч(ПолеНабораДанныхСхемыКД) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
			ПолеНабораДанныхСхемыКД.УстановитьДоступныеЗначения(ВсеИзвестныеТипыФайлов);
		КонецЕсли;
		// А также для вложенной схемы.
		ПолеНабораДанныхСхемыКД = СхемаКомпоновкиДанных.ВложенныеСхемыКомпоновкиДанных.Вложенный.Схема.НаборыДанных.НаборДанных1.Поля.Найти("Тип");
		Если ТипЗнч(ПолеНабораДанныхСхемыКД) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
			ПолеНабораДанныхСхемыКД.УстановитьДоступныеЗначения(ВсеИзвестныеТипыФайлов);
		КонецЕсли;
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	ИмяПоля = Строка(СвойстваНастройки.ПолеКД);
	Если ИмяПоля = "ПараметрыДанных.Размер" Тогда
		СвойстваНастройки.ЗначенияДляВыбора.Добавить(10000000, НСтр("ru = 'Больше 10 Мб'"));
	ИначеЕсли ИмяПоля = "Автор" И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Пользователи")) Тогда
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст =
		"ВЫБРАТЬ Ссылка ИЗ Справочник.Пользователи ГДЕ НЕ ПометкаУдаления И НЕ Недействителен И НЕ Служебный";
	ИначеЕсли ИмяПоля = "Тип" Тогда
		СвойстваНастройки.ЗначенияДляВыбора.Очистить();
		ВсеИзвестныеТипыФайлов = ТипыФайлов();
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ Расширение ИЗ Справочник.ВерсииФайлов";
		Таблица = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			Тип = НРег(СтрокаТаблицы.Расширение);
			Если СвойстваНастройки.ЗначенияДляВыбора.НайтиПоЗначению(Тип) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Элемент = ВсеИзвестныеТипыФайлов.НайтиПоЗначению(Тип);
			Если Элемент = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СвойстваНастройки.ЗначенияДляВыбора.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает список значений, в котором значение - расширение файлов в нижнем регистре.
//
Функция ТипыФайлов()
	Результат = Новый СписокЗначений;
	Результат.Добавить("txt",  НСтр("ru = 'Текстовый документ (.txt)'"));
	Результат.Добавить("xls",  НСтр("ru = 'Таблица Excel 97-2003 (.xls)'"));
	Результат.Добавить("xlsx", НСтр("ru = 'Таблица Excel 2007 (.xlsx)'"));
	Результат.Добавить("mxl",  НСтр("ru = 'Таблица 1С (.mxl)'"));
	Результат.Добавить("doc",  НСтр("ru = 'Документ Word 97-2003 (.doc)'"));
	Результат.Добавить("docx", НСтр("ru = 'Документ Word 2007 (.docx)'"));
	Результат.Добавить("pdf",  НСтр("ru = 'Документ Adobe (.pdf)'"));
	Результат.Добавить("htm",  НСтр("ru = 'Веб-страница (.htm)'"));
	Результат.Добавить("html", НСтр("ru = 'Веб-страница (.html)'"));
	Результат.Добавить("png",  НСтр("ru = 'Картинка (.png)'"));
	Возврат Результат;
КонецФункции

Функция ВладельцыФайлов(МассивФайлов)
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ВладелецФайла ИЗ Справочник.Файлы ГДЕ Ссылка В (&МассивФайлов)");
	Запрос.УстановитьПараметр("МассивФайлов", МассивФайлов);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВладелецФайла");
КонецФункции

#КонецОбласти

#КонецЕсли