
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ОбсужденияСлужебныйВызовСервера.Подключены() Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Подключение обсуждений не выполнено.'"));
		Возврат;
	КонецЕсли;
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Отключить");
	Кнопки.Добавить(КодВозвратаДиалога.Нет);
	
	Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбОтключении", ЭтотОбъект);
	
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Отключить обсуждения?'"),
		Кнопки,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОтветаНаВопросОбОтключении(КодВозврата, Контекст) Экспорт
	
	Если КодВозврата = "Отключить" Тогда 
		ПриОтключении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтключении()
	
	Оповещение = Новый ОписаниеОповещения("ПослеУспешногоОтключения", ЭтотОбъект,,
		"ПриОбработкеОшибкиОтключения", ЭтотОбъект);
	СистемаВзаимодействия.НачатьОтменуРегистрацииИнформационнойБазы(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУспешногоОтключения(Контекст) Экспорт
	
	Оповестить("ОбсужденияПодключены", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОбработкеОшибкиОтключения(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
КонецПроцедуры

#КонецОбласти

