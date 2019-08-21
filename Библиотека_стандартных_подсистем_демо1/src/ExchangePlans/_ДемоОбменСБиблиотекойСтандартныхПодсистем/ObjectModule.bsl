#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередУдалением(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	// Для плана обмена используется безопасное хранилище,
	// поэтому при удалении узла обмена необходимо также удалять соответствующую запись из хранилища
	// (в соответствии с документацией по подсистеме базовой функциональности).
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДатаСеанса());
	
	ИспользоватьОтборПоОрганизациям   = Ложь;
	ИспользоватьОтборПоПодразделениям = Ложь;
	ИспользоватьОтборПоСкладам        = Ложь;
	
	Если ВариантНастройки = "ТолькоПолучение" Тогда
		
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
		
	ИначеЕсли ВариантНастройки = "ТолькоОтправка" Тогда
		
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	Иначе
		
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	КонецЕсли;
	
	РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли