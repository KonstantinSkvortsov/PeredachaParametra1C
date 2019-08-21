
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	РежимСинхронизацииОрганизаций =
		?(Объект.ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
	
	РежимСинхронизацииПодразделений =
		?(Объект.ИспользоватьОтборПоПодразделениям, "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям", "СинхронизироватьДанныеПоВсемПодразделениям");
	
	РежимСинхронизацииСкладов =
		?(Объект.ИспользоватьОтборПоСкладам, "СинхронизироватьДанныеТолькоПоВыбраннымСкладам", "СинхронизироватьДанныеПоВсемСкладам");
	
	Организации.Загрузить(ВсеОрганизацииПриложения());
	Подразделения.Загрузить(ВсеПодразделенияПриложения());
	Склады.Загрузить(ВсеСкладыПриложения());
	
	ОтметитьВыбранныеЭлементыТаблицы("Организации", "Организация");
	ОтметитьВыбранныеЭлементыТаблицы("Подразделения", "Подразделение");
	ОтметитьВыбранныеЭлементыТаблицы("Склады", "Склад");
	
	Элементы.ГруппаСтавкаНДСПоУмолчанию.Видимость = ПолучитьФункциональнуюОпцию("_ДемоУчитыватьНДС");
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьВариантСинхронизацииДокументов(ВариантСинхронизацииДокументов, ЭтотОбъект.Объект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьВариантСинхронизацииСправочников(ВариантСинхронизацииСправочников, ЭтотОбъект.Объект);
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Элементы.Наименование.Видимость = Ложь;
		Элементы.Служебные.Видимость = Ложь;
		
	КонецЕсли;
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
	РежимСинхронизацииСкладовПриИзмененииЗначения();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ИспользоватьОтборПоОрганизациям =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	ТекущийОбъект.ИспользоватьОтборПоПодразделениям =
		(РежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям");
	
	ТекущийОбъект.ИспользоватьОтборПоСкладам =
		(РежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам");
	
	Если ТекущийОбъект.ИспользоватьОтборПоОрганизациям Тогда
		
		ТекущийОбъект.Организации.Загрузить(Организации.Выгрузить(Новый Структура("Использовать", Истина), "Организация"));
		
	Иначе
		
		ТекущийОбъект.Организации.Очистить();
		
	КонецЕсли;
	
	Если ТекущийОбъект.ИспользоватьОтборПоПодразделениям Тогда
		
		ТекущийОбъект.Подразделения.Загрузить(Подразделения.Выгрузить(Новый Структура("Использовать", Истина), "Подразделение"));
		
	Иначе
		
		ТекущийОбъект.Подразделения.Очистить();
		
	КонецЕсли;
	
	Если ТекущийОбъект.ИспользоватьОтборПоСкладам Тогда
		
		ТекущийОбъект.Склады.Загрузить(Склады.Выгрузить(Новый Структура("Использовать", Истина), "Склад"));
		
	Иначе
		
		ТекущийОбъект.Склады.Очистить();
		
	КонецЕсли;
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьРежимыВыгрузкиДокументов(ВариантСинхронизацииДокументов, ТекущийОбъект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьРежимыВыгрузкиСправочников(ВариантСинхронизацииСправочников, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииПодразделенийПриИзменении(Элемент)
	
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииСкладовПриИзменении(Элемент)
	
	РежимСинхронизацииСкладовПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовОтправлятьПолучатьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовПолучатьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковТолькоИспользуемуюВДокументахПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Подразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Склады");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Подразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Склады");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	ДоступностьОрганизаций = (РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	Элементы.Организации.Доступность = ДоступностьОрганизаций;
	Элементы.КоманднаяПанельОрганизации.Доступность = ДоступностьОрганизаций;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииПодразделенийПриИзмененииЗначения()
	
	ДоступностьПодразделений = (РежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям");
	
	Элементы.Подразделения.Доступность = ДоступностьПодразделений;
	Элементы.КоманднаяПанельПодразделения.Доступность = ДоступностьПодразделений;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииСкладовПриИзмененииЗначения()
	
	ДоступностьСкладов = (РежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам");
	
	Элементы.Склады.Доступность = ДоступностьСкладов;
	Элементы.КоманднаяПанельСклады.Доступность = ДоступностьСкладов;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ВсеОрганизацииПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник._ДемоОрганизации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Функция ВсеПодразделенияПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	_ДемоПодразделения.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник._ДемоПодразделения КАК _ДемоПодразделения
	|ГДЕ
	|	НЕ _ДемоПодразделения.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	_ДемоПодразделения.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Функция ВсеСкладыПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	_ДемоМестаХранения.Ссылка КАК Склад
	|ИЗ
	|	Справочник._ДемоМестаХранения КАК _ДемоМестаХранения
	|ГДЕ
	|	НЕ _ДемоМестаХранения.ПометкаУдаления
	|	И НЕ _ДемоМестаХранения.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	_ДемоМестаХранения.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Процедура ОтметитьВыбранныеЭлементыТаблицы(ИмяТаблицы, ИмяРеквизита)
	
	Для Каждого СтрокаТаблицы Из Объект[ИмяТаблицы] Цикл
		
		Строки = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(Новый Структура(ИмяРеквизита, СтрокаТаблицы[ИмяРеквизита]));
		
		Если Строки.Количество() > 0 Тогда
			
			Строки[0].Использовать = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	Элементы.ДатаНачалаВыгрузкиДокументов.Доступность = 
			(ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьАвтоматически" 
			ИЛИ ВариантСинхронизацииДокументов = "ОтправлятьАвтоматически");
	Элементы.ВариантСинхронизацииДокументовПолучатьАвтоматически.Доступность = 
			(ВариантСинхронизацииСправочников <> "ОтправлятьИПолучатьПриНеобходимости");
	Элементы.ВариантСинхронизацииСправочниковТолькоИспользуемуюВДокументах.Доступность = 
			(ВариантСинхронизацииДокументов <> "ПолучатьАвтоматически");
КонецПроцедуры

#КонецОбласти
