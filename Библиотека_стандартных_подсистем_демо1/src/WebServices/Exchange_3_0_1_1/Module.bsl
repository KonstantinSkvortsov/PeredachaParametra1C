
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции Upload.
Функция ВыполнитьВыгрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеОбмена = "";
	
	ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезСтроку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, СообщениеОбмена);
	
	ХранилищеСообщенияОбмена = Новый ХранилищеЗначения(СообщениеОбмена, Новый СжатиеДанных(9));
	
КонецФункции

// Соответствует операции Download.
Функция ВыполнитьЗагрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезСтроку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена.Получить());
	
КонецФункции

// Соответствует операции UploadData.
Функция ВыполнитьВыгрузкуДанных(ИмяПланаОбмена,
								КодУзлаИнформационнойБазы,
								ИдентификаторФайлаСтрокой,
								ДлительнаяОперация,
								ИдентификаторОперации,
								ДлительнаяОперацияРазрешена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	ИдентификаторФайлаСтрокой = Строка(ИдентификаторФайла);
	ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
	
КонецФункции

// Соответствует операции DownloadData.
Функция ВыполнитьЗагрузкуДанных(ИмяПланаОбмена,
								КодУзлаИнформационнойБазы,
								ИдентификаторФайлаСтрокой,
								ДлительнаяОперация,
								ИдентификаторОперации,
								ДлительнаяОперацияРазрешена)
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор(ИдентификаторФайлаСтрокой);
	ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
	
КонецФункции

// Соответствует операции GetIBParameters.
Функция ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке)
	
	Результат = ОбменДаннымиСервер.ПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке);
	Возврат СериализаторXDTO.ЗаписатьXDTO(Результат);
	
КонецФункции

// Соответствует операции CreateExchangeNode.
Функция СоздатьУзелОбменаДанными(ПараметрыXDTO)
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными(Истина);
	
	Параметры = СериализаторXDTO.ПрочитатьXDTO(ПараметрыXDTO);
	
	НастройкиПодключения = Параметры.НастройкиПодключения;
	СтрокаПараметровXML  = Параметры.СтрокаПараметровXML;
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	Попытка
		МодульПомощникНастройки.ЗаполнитьНастройкиПодключенияИзXML(
			НастройкиПодключения, Параметры.СтрокаПараметровXML, , Истина);
			
		МодульПомощникНастройки.ВыполнитьДействияПоНастройкеОбменаДанными(
			НастройкиПодключения);
	Исключение
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
КонецФункции

// Соответствует операции RemoveExchangeNode.
Функция УдалитьУзелОбменаДанными(ИмяПланаОбмена, ИдентификаторУзла)
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, ИдентификаторУзла);
		
	Если УзелОбмена = Неопределено Тогда
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найден узел плана обмена ""%2"" с идентификатором ""%3"".'"),
			ПредставлениеПрограммы, ИмяПланаОбмена, ИдентификаторУзла);
	КонецЕсли;
	
	ОбменДаннымиСервер.УдалитьНастройкуСинхронизации(УзелОбмена);
	
КонецФункции

// Соответствует операции GetContinuousOperationStatus.
Функция ПолучитьСостояниеДлительнойОперации(ИдентификаторОперации, СтрокаСообщенияОбОшибке)
	
	СостоянияФоновогоЗадания = Новый Соответствие;
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Активно,           "Active");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Завершено,         "Completed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.ЗавершеноАварийно, "Failed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Отменено,          "Canceled");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторОперации));
	
	Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
		
		СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		
	КонецЕсли;
	
	Возврат СостоянияФоновогоЗадания.Получить(ФоновоеЗадание.Состояние);
КонецФункции

// Соответствует операции PrepareGetFile.
Функция PrepareGetFile(FileId, BlockSize, TransferId, PartQuantity)
	
	УстановитьПривилегированныйРежим(Истина);
	
	TransferId = Новый УникальныйИдентификатор;
	
	ИмяИсходногоФайла = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(FileId);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	Файл = Новый Файл(ИмяИсходногоФайла);
	
	ИмяИсходногоФайлаВоВременномКаталоге = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	СоздатьКаталог(ВременныйКаталог);
	
	ПереместитьФайл(ИмяИсходногоФайла, ИмяИсходногоФайлаВоВременномКаталоге);
	
	Если BlockSize <> 0 Тогда
		// Разделение файла на части
		ИменаФайлов = РазделитьФайл(ИмяИсходногоФайлаВоВременномКаталоге, BlockSize * 1024);
		PartQuantity = ИменаФайлов.Количество();
		
		УдалитьФайлы(ИмяИсходногоФайлаВоВременномКаталоге);
	Иначе
		PartQuantity = 1;
		ПереместитьФайл(ИмяИсходногоФайлаВоВременномКаталоге, ИмяИсходногоФайлаВоВременномКаталоге + ".1");
	КонецЕсли;
	
КонецФункции

// Соответствует операции GetFilePart.
Функция GetFilePart(TransferId, PartNumber, PartData)
	
	ИменаФайлов = НайтиФайлЧасти(ВременныйКаталогВыгрузки(TransferId), PartNumber);
	
	Если ИменаФайлов.Количество() = 0 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(PartNumber), Строка(TransferId));
		ВызватьИсключение(ТекстСообщения);
		
	ИначеЕсли ИменаФайлов.Количество() > 1 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Найдено несколько фрагментов %1 сессии передачи с идентификатором %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(PartNumber), Строка(TransferId));
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ИмяФайлаЧасти = ИменаФайлов[0].ПолноеИмя;
	PartData = Новый ДвоичныеДанные(ИмяФайлаЧасти);
	
КонецФункции

// Соответствует операции ReleaseFile.
Функция ReleaseFile(TransferId)
	
	Попытка
		УдалитьФайлы(ВременныйКаталогВыгрузки(TransferId));
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецФункции

// Соответствует операции PutFilePart.
Функция PutFilePart(TransferId, PartNumber, PartData)
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	Если PartNumber = 1 Тогда
		
		СоздатьКаталог(ВременныйКаталог);
		
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(PartNumber));
	
	PartData.Записать(ИмяФайла);
	
КонецФункции

// Соответствует операции SaveFileFromParts.
Функция SaveFileFromParts(TransferId, PartQuantity, FileId)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(TransferId);
	
	ФайлыЧастейДляОбъединения = Новый Массив;
	
	Для НомерЧасти = 1 По PartQuantity Цикл
		
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(НомерЧасти));
		
		Если НайтиФайлы(ИмяФайла).Количество() = 0 Тогда
			ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2.
					|Необходимо убедиться, что в настройках программы заданы параметры
					|""Каталог временных файлов для Linux"" и ""Каталог временных файлов для Windows"".'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(НомерЧасти), Строка(TransferId));
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		ФайлыЧастейДляОбъединения.Добавить(ИмяФайла);
		
	КонецЦикла;
	
	ИмяАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	ОбъединитьФайлы(ФайлыЧастейДляОбъединения, ИмяАрхива);
	
	Разархиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Если Разархиватор.Элементы.Количество() = 0 Тогда
		Попытка
			УдалитьФайлы(ВременныйКаталог);
		Исключение
			ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		ВызватьИсключение(НСтр("ru = 'Файл архива не содержит данных.'"));
	КонецЕсли;
	
	КаталогВыгрузки = ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов();
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВыгрузки, Разархиватор.Элементы[0].Имя);
	
	Разархиватор.Извлечь(Разархиватор.Элементы[0], КаталогВыгрузки);
	Разархиватор.Закрыть();
	
	FileId = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ВременныйКаталог);
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецФункции

// Соответствует операции PutMessageForDataMatching.
Функция PutMessageForDataMatching(ИмяПланаОбмена, ИдентификаторУзла, ИдентификаторФайла)
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, ИдентификаторУзла);
		
	Если УзелОбмена = Неопределено Тогда
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найден узел плана обмена ""%2"" с идентификатором ""%3"".'"),
			ПредставлениеПрограммы, ИмяПланаОбмена, ИдентификаторУзла);
	КонецЕсли;
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ОбменДаннымиСлужебный.ПоместитьСообщениеДляСопоставленияДанных(УзелОбмена, ИдентификаторФайла);
	
КонецФункции

// Соответствует операции Ping.
Функция Ping()
	// Проверка связи.
	Возврат "";
КонецФункции

// Соответствует операции TestConnection.
Функция TestConnection(ИмяПланаОбмена, КодУзла, Результат)
	
	// Проверяем наличие прав для выполнения обмена.
	Попытка
		ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов(Истина);
	Исключение
		Результат = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	// Проверяем блокировку информационной базы для обновления.
	Попытка
		ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	Исключение
		Результат = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Проверяем наличие узла плана обмена (возможно узел уже удален).
	Если ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, КодУзла) = Неопределено Тогда
		
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ПредставлениеПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Представление();
			
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найдена настройка синхронизации данных ""%2"" с идентификатором ""%3"".'"),
			ПредставлениеПрограммы, ПредставлениеПланаОбмена, КодУзла);
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

Процедура ПроверитьБлокировкуИнформационнойБазыДляОбновления()
	
	Если ЗначениеЗаполнено(ОбновлениеИнформационнойБазыСлужебный.ИнформационнаяБазаЗаблокированаДляОбновления()) Тогда
		
		ВызватьИсключение НСтр("ru = 'Синхронизация данных временно недоступна в связи с обновлением приложения в Интернете.'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
														КодУзлаИнформационнойБазы,
														ИдентификаторФайла,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ДлительнаяОперацияРазрешена)
	
	КлючФоновогоЗадания = КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы,
		НСтр("ru = 'Выгрузка'"));
	
	Если ЕстьАктивныеФоновыеЗаданияСинхронизацииДанных(КлючФоновогоЗадания) Тогда
		ВызватьИсключение НСтр("ru = 'Синхронизация данных уже выполняется.'");
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	ПараметрыПроцедуры.Вставить("КодУзлаИнформационнойБазы", КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	ПараметрыПроцедуры.Вставить("ИспользоватьСжатие", Истина);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выгрузка данных через веб-сервис.'");
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	
	ПараметрыВыполнения.ЗапуститьНеВФоне = Не ДлительнаяОперацияРазрешена;
	ПараметрыВыполнения.ЗапуститьВФоне   = ДлительнаяОперацияРазрешена;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВСервисПередачиФайлов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ИдентификаторОперации = Строка(ФоновоеЗадание.ИдентификаторЗадания);
		ДлительнаяОперация = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ДлительнаяОперация = Ложь;
		Возврат;
	Иначе
		Сообщение = НСтр("ru = 'Ошибка при выгрузке данных через веб-сервис.'");
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			Сообщение = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииВыгрузкаДанныхВСервисПередачиФайлов(),
			УровеньЖурналаРегистрации.Ошибка, , , Сообщение);
		
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
													КодУзлаИнформационнойБазы,
													ИдентификаторФайла,
													ДлительнаяОперация,
													ИдентификаторОперации,
													ДлительнаяОперацияРазрешена)
	
													
	КлючФоновогоЗадания = КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы,
		НСтр("ru = 'Загрузка'"));
	
	Если ЕстьАктивныеФоновыеЗаданияСинхронизацииДанных(КлючФоновогоЗадания) Тогда
		ВызватьИсключение НСтр("ru = 'Синхронизация данных уже выполняется.'");
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	ПараметрыПроцедуры.Вставить("КодУзлаИнформационнойБазы", КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка данных через веб-сервис.'");
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	
	ПараметрыВыполнения.ЗапуститьНеВФоне = Не ДлительнаяОперацияРазрешена;
	ПараметрыВыполнения.ЗапуститьВФоне   = ДлительнаяОперацияРазрешена;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыИзСервисаПередачиФайлов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ИдентификаторОперации = Строка(ФоновоеЗадание.ИдентификаторЗадания);
		ДлительнаяОперация = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ДлительнаяОперация = Ложь;
		Возврат;
	Иначе
		
		Сообщение = НСтр("ru = 'Ошибка при загрузке данных через веб-сервис.'");
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			Сообщение = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаДанныхИзСервисаПередачиФайлов(),
			УровеньЖурналаРегистрации.Ошибка, , , Сообщение);
		
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры

Функция КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ПланОбмена, КодУзла, Действие)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'ПланОбмена:%1 КодУзла:%2 Действие:%3'"),
		ПланОбмена,
		КодУзла,
		Действие);
	
КонецФункции

Функция ЕстьАктивныеФоновыеЗаданияСинхронизацииДанных(КлючФоновогоЗадания)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Ключ", КлючФоновогоЗадания);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
	Возврат (АктивныеФоновыеЗадания.Количество() > 0);
	
КонецФункции

Функция ПолучитьИмяФайлаЧасти(PartNumber)
	
	Результат = "data.zip.[n]";
	
	Возврат СтрЗаменить(Результат, "[n]", Формат(PartNumber, "ЧГ=0"));
КонецФункции

Функция ВременныйКаталогВыгрузки(Знач ИдентификаторСессии)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = "{ИдентификаторСессии}";
	ВременныйКаталог = СтрЗаменить(ВременныйКаталог, "ИдентификаторСессии", Строка(ИдентификаторСессии));
	
	Результат = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов(), ВременныйКаталог);
	
	Возврат Результат;
КонецФункции

Функция НайтиФайлЧасти(Знач Каталог, Знач НомерФайла)
	
	Для КоличествоРазрядов = КоличествоРазрядовЧисла(НомерФайла) По 5 Цикл
		
		ФорматнаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧЦ=%1; ЧВН=; ЧГ=0", Строка(КоличествоРазрядов));
		
		ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("data.zip.%1", Формат(НомерФайла, ФорматнаяСтрока));
		
		ИменаФайлов = НайтиФайлы(Каталог, ИмяФайла);
		
		Если ИменаФайлов.Количество() > 0 Тогда
			
			Возврат ИменаФайлов;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Массив;
КонецФункции

Функция КоличествоРазрядовЧисла(Знач Число)
	
	Возврат СтрДлина(Формат(Число, "ЧДЦ=0; ЧГ=0"));
	
КонецФункции

#КонецОбласти
