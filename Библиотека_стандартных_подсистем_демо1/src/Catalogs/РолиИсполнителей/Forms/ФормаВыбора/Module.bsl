#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПростыеРоли = Ложь;
	
	Если Параметры.Свойство("ТолькоПростыеРоли", ТолькоПростыеРоли) И ТолькоПростыеРоли = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ВнешняяРоль", Истина, , , Истина);
	КонецЕсли;
	
	ЭтоВнешнийПользователь = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	Если ЭтоВнешнийПользователь Тогда
		
		Если Элементы.КоманднаяПанель.ПодчиненныеЭлементы.Найти("ФормаИзменить") <> Неопределено Тогда
			Элементы.КоманднаяПанель.ПодчиненныеЭлементы.ФормаИзменить.Видимость = Ложь;
		КонецЕсли;
		СтрокаОтбораВТекстеЗапроса = ОпределитьОтборДляВнешнегоПользователя();
		
	Иначе
		СтрокаОтбораВТекстеЗапроса = " ГДЕ РолиИсполнителейНазначениеПереопределяемый.ТипПользователей = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	КонецЕсли;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = "Справочник.РолиИсполнителей";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса                 = Список.ТекстЗапроса + СтрокаОтбораВТекстеЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ЭтоВнешнийПользователь Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОпределитьОтборДляВнешнегоПользователя()
	
	ТекущийВнешнийПользователь =  ПользователиКлиентСервер.ТекущийВнешнийПользователь();
	
	СтрокаОтбораВТекстеЗапроса = СтрЗаменить(" ГДЕ РолиИсполнителейНазначениеПереопределяемый.ТипПользователей = ЗНАЧЕНИЕ(Справочник.%Имя%.ПустаяСсылка)",
		"%Имя%", ТекущийВнешнийПользователь.ОбъектАвторизации.Метаданные().Имя);
	
	Возврат СтрокаОтбораВТекстеЗапроса;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ГруппаЭлементовОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора .ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьИсполнители");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВнешняяРоль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.РольБезИсполнителей);
	
КонецПроцедуры

#КонецОбласти