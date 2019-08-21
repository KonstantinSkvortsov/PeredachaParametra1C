
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователейСлужебныйКлиентПовтИсп.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьURLДоступен(URL, Метод, ИмяОшибки, СообщениеОбОшибке, ИнформацияОбОшибке) Экспорт
	
	ИнтернетПоддержкаПользователейКлиентСервер.СлужебнаяПроверитьURLДоступен(
		URL,
		Метод,
		ИмяОшибки,
		СообщениеОбОшибке,
		ИнформацияОбОшибке);
	
	Если Не ПустаяСтрока(ИмяОшибки) Тогда
		ВызватьИсключение ИмяОшибки;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти