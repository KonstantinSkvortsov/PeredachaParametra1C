
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	ИнициализироватьРеквизитыФормы();
	
	ИнициализироватьСвойстваФормы();
	
	УстановитьНачальноеОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТаблицуЭтаповНастройки();
	ОбновитьОтображениеТекущегоСостоянияНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УзелОбмена)
		Или Не НастройкаСинхронизацииЗавершена(УзелОбмена)
		Или (НастройкаРИБ И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ И Не НачальныйОбразСоздан(УзелОбмена))Тогда
		ТекстПредупреждения = НСтр("ru = 'Настройка синхронизации данных еще не завершена.
		|Завершить работу с помощником? Настройку можно будет продолжить позже.'");
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
			ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("ЗакрытаФормаПомощникаСозданияОбменаДанными");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияРезервноеКопированиеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если РезервноеКопирование Тогда
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаОбработкиРезервногоКопирования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодробноеОписаниеСинхронизацииДанных(Команда)
	
	ОбменДаннымиКлиент.ОткрытьПодробноеОписаниеСинхронизации(ПодробнаяИнформацияПоОбмену);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыПодключения(Команда)
	
	Если Не НастройкаНовойСинхронизации
		Или (ЗначениеЗаполнено(УзелОбмена) И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ) Тогда
		Если МодельСервиса Тогда
			СтрокаПредупреждение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Настройка подключения к ""%1"" уже выполнена.
				|Редактирование параметров подключения не предусмотрено.'"), УзелОбмена);
			ПоказатьПредупреждение(, СтрокаПредупреждение);
			Возврат;
		Иначе
			Отбор              = Новый Структура("Корреспондент", УзелОбмена);
			ЗначенияЗаполнения = Новый Структура("Корреспондент", УзелОбмена);
			
			ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор,
				ЗначенияЗаполнения, "НастройкиТранспортаОбменаДанными", ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("ИмяПланаОбмена",         ИмяПланаОбмена);
	ПараметрыПомощника.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
	Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
		ПараметрыПомощника.Вставить("ПродолжениеНастройкиВПодчиненномУзлеРИБ");
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НастроитьПараметрыПодключенияЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.НастройкаПодключения",
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанных(Команда)
	
	ОповещениеПродолжения = Новый ОписаниеОповещения("НастроитьПравилаОтправкиИПолученияДанныхПродолжение", ЭтотОбъект);
	
	// Для плана обмена XDTO перед настройкой правил выгрузки и загрузки
	// должны быть получены настройки корреспондента.
	Если НастройкаXDTO Тогда
		СостояниеНастройки = СостояниеНастройкиСинхронизации(УзелОбмена);
		Если Не СостояниеНастройки.НастройкаСинхронизацииЗавершена
			И Не СостояниеНастройки.ПолученыНастройкиXDTOКорреспондента Тогда
			
			ПараметрыЗагрузки = Новый Структура;
			ПараметрыЗагрузки.Вставить("УзелОбмена", УзелОбмена);
			
			ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.ЗагрузкаНастроекXDTO",
				ПараметрыЗагрузки, ЭтотОбъект, , , , ОповещениеПродолжения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПродолжитьНастройку",            Истина);
	Результат.Вставить("ПолученыДанныеДляСопоставления", ПолученыДанныеДляСопоставления);
	
	ВыполнитьОбработкуОповещения(ОповещениеПродолжения, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразРИБ(Команда)
	
	ПараметрыПомощника = Новый Структура("Ключ, Узел", УзелОбмена, УзелОбмена);
			
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("СоздатьНачальныйОбразРИБЗавершение", ЭтотОбъект);
	ОткрытьФорму(ИмяФормыСозданияНачальногоОбраза,
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСопоставлениеИЗагрузкуДанных(Команда)
	
	ОповещениеПродолжения = Новый ОписаниеОповещения("ВыполнитьСопоставлениеИЗагрузкуДанныхПродолжение", ЭтотОбъект);
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("ОтправитьДанные",     Ложь);
	ПараметрыПомощника.Вставить("НастройкаРасписания", Ложь);
	
	Если ЭтоОбменСПриложениемВСервисе Тогда
		ПараметрыПомощника.Вставить("ОбластьДанныхКорреспондента", ОбластьДанныхКорреспондента);
	КонецЕсли;
	
	ВспомогательныеПараметры = Новый Структура;
	ВспомогательныеПараметры.Вставить("ПараметрыПомощника",  ПараметрыПомощника);
	ВспомогательныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеПродолжения);
	
	ОбменДаннымиКлиент.ОткрытьПомощникСопоставленияОбъектовОбработкаКоманды(УзелОбмена,
		ЭтотОбъект, ВспомогательныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНачальнуюВыгрузкуДанных(Команда)
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("УзелОбмена", УзелОбмена);
	ПараметрыПомощника.Вставить("НачальнаяВыгрузка");
	
	Если МодельСервиса Тогда
		ПараметрыПомощника.Вставить("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
		ПараметрыПомощника.Вставить("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыполнитьНачальнуюВыгрузкуДанныхЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ПомощникИнтерактивногоОбменаДанными.Форма.ВыгрузкаДанныхДляСопоставления",
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	РасписаниеВыполненияОбменаДанными = ПредопределенноеРасписаниеКаждыйЧас();
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеВыполненияОбменаДанными);
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СостояниеНастройкиСинхронизации(УзелОбмена)
	
	Результат = Новый Структура;
	Результат.Вставить("НастройкаСинхронизацииЗавершена",           НастройкаСинхронизацииЗавершена(УзелОбмена));
	Результат.Вставить("НачальныйОбразСоздан",                      НачальныйОбразСоздан(УзелОбмена));
	Результат.Вставить("ПолученоСообщениеСДаннымиДляСопоставления", ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена));
	Результат.Вставить("ПолученыНастройкиXDTOКорреспондента",       ПолученыНастройкиXDTOКорреспондента(УзелОбмена));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолученыНастройкиXDTOКорреспондента(УзелОбмена)
	
	НастройкиКорреспондента = ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФорматаКорреспондента(УзелОбмена, "ОтправкаПолучение");
	
	Возврат НастройкиКорреспондента.Количество() > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция НачальныйОбразСоздан(УзелОбмена)
	
	Возврат РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.НачальныйОбразСоздан(УзелОбмена);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеКаждыйЧас()
	
	Возврат ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными().ПредопределенноеРасписаниеКаждыйЧас();
	
КонецФункции

&НаСервереБезКонтекста
Процедура СоздатьСценарийОбменаДаннымиПоРасписанию(УзелОбмена, Расписание)
	
	Справочники.СценарииОбменовДанными.СоздатьСценарий(УзелОбмена, Расписание);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыПодключенияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено
		И ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Если РезультатЗакрытия.Свойство("УзелОбмена") Тогда
			УзелОбмена = РезультатЗакрытия.УзелОбмена;
		КонецЕсли;
		
		Если МодельСервиса Тогда
			РезультатЗакрытия.Свойство("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
			РезультатЗакрытия.Свойство("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
		КонецЕсли;
		
		Если РезультатЗакрытия.Свойство("ЕстьДанныеДляСопоставления")
			И РезультатЗакрытия.ЕстьДанныеДляСопоставления Тогда
			ПолученыДанныеДляСопоставления = Истина;
		КонецЕсли;
		
		Если РезультатЗакрытия.Свойство("ПассивныйРежим")
			И РезультатЗакрытия.ПассивныйРежим Тогда
			ДоступнаИнтерактивнаяОтправка = Ложь;
		КонецЕсли;
		
		ЗаполнитьТаблицуЭтаповНастройки();
		ОбновитьОтображениеТекущегоСостоянияНастройки();
		
		Если ТекущийЭтапНастройки = "НастройкаПодключения" Тогда
			ПерейтиКСледующемуЭтапуНастройки();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанныхПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатЗакрытия.ПродолжитьНастройку Тогда
		Возврат;
	КонецЕсли;
	
	ДоступнаИнтерактивнаяОтправка = ДоступнаИнтерактивнаяОтправка
		И Не (ОбменДаннымиВызовСервера.ВариантОбменаДанными(УзелОбмена) = "ТолькоПолучение");
	
	Если РезультатЗакрытия.ПолученыДанныеДляСопоставления
		И Не ПолученыДанныеДляСопоставления Тогда
		ПолученыДанныеДляСопоставления = РезультатЗакрытия.ПолученыДанныеДляСопоставления;
	КонецЕсли;
	
	ЗаполнитьТаблицуЭтаповНастройки();
	ОбновитьОтображениеТекущегоСостоянияНастройки();
	
	ПараметрыПомощника = Новый Структура;
	
	Если ПустаяСтрока(ИмяФормыПомощникаНастройкиСинхронизацииДанных) Тогда
		ПараметрыПомощника.Вставить("Ключ", УзелОбмена);
		ПараметрыПомощника.Вставить("ИмяФормыПомощника", "ПланОбмена.[ИмяПланаОбмена].ФормаОбъекта");
		
		ПараметрыПомощника.ИмяФормыПомощника = СтрЗаменить(ПараметрыПомощника.ИмяФормыПомощника,
			"[ИмяПланаОбмена]", ИмяПланаОбмена);
	Иначе
		ПараметрыПомощника.Вставить("УзелОбмена", УзелОбмена);
		ПараметрыПомощника.Вставить("ИмяФормыПомощника", ИмяФормыПомощникаНастройкиСинхронизацииДанных);
	КонецЕсли;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("НастроитьПравилаОтправкиИПолученияДанныхЗавершение", ЭтотОбъект);
	
	ОткрытьФорму(ПараметрыПомощника.ИмяФормыПомощника,
		ПараметрыПомощника, ЭтотОбъект, , , , ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПравилаОтправкиИПолученияДанныхЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НастройкаПравил"
		И НастройкаСинхронизацииЗавершена(УзелОбмена) Тогда
		Оповестить("Запись_УзелПланаОбмена");
		Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
			ОбновитьИнтерфейс();
		КонецЕсли;
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСопоставлениеИЗагрузкуДанныхПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "СопоставлениеИЗагрузка"
		И ВыполненаЗагрузкаДанныхДляСопоставления(УзелОбмена) Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбразРИБЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НачальныйОбразРИБ"
		И НачальныйОбразСоздан(УзелОбмена) Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНачальнуюВыгрузкуДанныхЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТекущийЭтапНастройки = "НачальнаяВыгрузкаДанных"
		И РезультатЗакрытия = УзелОбмена Тогда
		ПерейтиКСледующемуЭтапуНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		
		СоздатьСценарийОбменаДаннымиПоРасписанию(УзелОбмена, Расписание);
		
		Если ТекущийЭтапНастройки = "НастройкаРасписания" Тогда
			ПерейтиКСледующемуЭтапуНастройки();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеТекущегоСостоянияНастройки()
	
	Если ПустаяСтрока(ТекущийЭтапНастройки) Тогда
		// Все этапы завершены.
		Для Каждого ЭтапНастройки Из ЭтапыНастройки Цикл
			Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
			Элементы[ЭтапНастройки.Кнопка].Шрифт = ЭтапНастройки.ШрифтОбычный;
			
			// Зеленый флажок только для основных этапов настройки.
			Если ВсеЭтапыНастройки[ЭтапНастройки.Название] = "Основное" Тогда
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Успешно"];
			Иначе
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Пустой"];
			КонецЕсли;
		КонецЦикла;
	Иначе
		
		ТекущийЭтапНайден = Ложь;
		Для Каждого ЭтапНастройки Из ЭтапыНастройки Цикл
			Если ЭтапНастройки.Название = ТекущийЭтапНастройки Тогда
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Текущий"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ЭтапНастройки.ШрифтЖирный;
				ТекущийЭтапНайден = Истина;
			ИначеЕсли Не ТекущийЭтапНайден Тогда
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Истина;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Успешно"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ЭтапНастройки.ШрифтОбычный;
			Иначе
				Элементы["Группа" + ЭтапНастройки.Название].Доступность = Ложь;
				Элементы["Панель" + ЭтапНастройки.Название].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Название + "Пустой"];
				Элементы[ЭтапНастройки.Кнопка].Шрифт = ЭтапНастройки.ШрифтОбычный;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭтапНастройки Из ВсеЭтапыНастройки Цикл
			СтрокиЭтапы = ЭтапыНастройки.НайтиСтроки(Новый Структура("Название", ЭтапНастройки.Ключ));
			Если СтрокиЭтапы.Количество() = 0 Тогда
				Элементы["Группа" + ЭтапНастройки.Ключ].Доступность = Ложь;
				Элементы["Панель" + ЭтапНастройки.Ключ].ТекущаяСтраница = Элементы["Страница" + ЭтапНастройки.Ключ + "Пустой"];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуЭтапуНастройки()
	
	СледующаяСтрока = Неопределено;
	ТекущийЭтапНайден = Ложь;
	Для Каждого СтрокаЭтапыНастройки Из ЭтапыНастройки Цикл
		Если ТекущийЭтапНайден Тогда
			СледующаяСтрока = СтрокаЭтапыНастройки;
			Прервать;
		КонецЕсли;
		
		Если СтрокаЭтапыНастройки.Название = ТекущийЭтапНастройки Тогда
			ТекущийЭтапНайден = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если СледующаяСтрока <> Неопределено Тогда
		ТекущийЭтапНастройки = СледующаяСтрока.Название;
		Если ВсеЭтапыНастройки[ТекущийЭтапНастройки] <> "Основное" Тогда
			ТекущийЭтапНастройки = "";
		КонецЕсли;
	Иначе
		ТекущийЭтапНастройки = "";
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьОтображениеТекущегоСостоянияНастройки", 0.2, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкаСинхронизацииЗавершена(УзелОбмена)
	
	Возврат ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(УзелОбмена);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыполненаЗагрузкаДанныхДляСопоставления(УзелОбмена)
	
	Возврат Не ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
	
КонецФункции

#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ИнициализироватьСвойстваФормы()
	
	Если ПустаяСтрока(ЗаголовокПомощникаСозданияОбмена) Тогда
		Если НастройкаРИБ Тогда
			Заголовок = НСтр("ru = 'Настройка распределенной информационной базы'");
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Настройка синхронизации данных с ""%1""'"),
				НаименованиеКонфигурацииКорреспондента);
		КонецЕсли;
	Иначе
		Заголовок = ЗаголовокПомощникаСозданияОбмена;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	НастройкаНовойСинхронизации = Параметры.Свойство("НастройкаНовойСинхронизации");
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Если НастройкаНовойСинхронизации Тогда
		ИмяПланаОбмена         = Параметры.ИмяПланаОбмена;
		ИдентификаторНастройки = Параметры.ИдентификаторНастройки;
		
		ПродолжениеНастройкиВПодчиненномУзлеРИБ = Параметры.Свойство("ПродолжениеНастройкиВПодчиненномУзлеРИБ");
		
		Если Не ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
			Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() Тогда
				ИмяПланаОбменаРИБ = ОбменДаннымиСервер.ГлавныйУзел().Метаданные().Имя;
				
				ПродолжениеНастройкиВПодчиненномУзлеРИБ = (ИмяПланаОбмена = ИмяПланаОбменаРИБ)
					И Не Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Получить();
				
			КонецЕсли;
		КонецЕсли;
		
		Если ПродолжениеНастройкиВПодчиненномУзлеРИБ Тогда
			ОбменДаннымиСервер.ПриПродолженииНастройкиПодчиненногоУзлаРИБ();
			УзелОбмена = ОбменДаннымиСервер.ГлавныйУзел();
		КонецЕсли;
	Иначе
		УзелОбмена = Параметры.УзелОбмена;
		
		ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелОбмена);
		ИдентификаторНастройки = ОбменДаннымиСервер.СохраненныйВариантНастройкиУзлаПланаОбмена(УзелОбмена);
		
		Если МодельСервиса Тогда
			Параметры.Свойство("ОбластьДанныхКорреспондента",  ОбластьДанныхКорреспондента);
			Параметры.Свойство("ЭтоОбменСПриложениемВСервисе", ЭтоОбменСПриложениемВСервисе);
		КонецЕсли;
	КонецЕсли;
	
	ВидТранспорта = Неопределено;
	Если ЗначениеЗаполнено(УзелОбмена) Тогда
		НастройкаЗавершена = НастройкаСинхронизацииЗавершена(УзелОбмена);
		ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелОбмена);
		ЕстьНастройкиТранспорта = ЗначениеЗаполнено(ВидТранспорта);
	КонецЕсли;
	
	РезервноеКопирование = Не МодельСервиса
		И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ");
		
	Если РезервноеКопирование Тогда
		МодульРезервноеКопированиеИБСервер = ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеИБСервер");
		
		НавигационнаяСсылкаОбработкиРезервногоКопирования =
			МодульРезервноеКопированиеИБСервер.НавигационнаяСсылкаОбработкиРезервногоКопирования();
	КонецЕсли;
		
	НастройкаРИБ  = ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена);
	НастройкаXDTO = ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена);
	
	ДоступнаИнтерактивнаяОтправка = Не НастройкаРИБ;
	НастройкаУниверсальногоОбмена = ОбменДаннымиПовтИсп.ЭтоУзелСтандартногоОбменаДанными(ИмяПланаОбмена); // без правил конвертации
	
	Если НастройкаНовойСинхронизации
		Или НастройкаРИБ
		Или НастройкаУниверсальногоОбмена Тогда
		ПолученыДанныеДляСопоставления = Ложь;
	ИначеЕсли МодельСервиса Тогда
		ПолученыДанныеДляСопоставления = ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
	Иначе
		Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM
			Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
			Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WSПассивныйРежим
			Или Не ЕстьНастройкиТранспорта Тогда
			ПолученыДанныеДляСопоставления = ОбменДаннымиСервер.ПолученоСообщениеСДаннымиДляСопоставления(УзелОбмена);
		Иначе
			ПолученыДанныеДляСопоставления = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ЗначенияНастроекДляВарианта = ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена,
		"НаименованиеКонфигурацииКорреспондента,
		|КраткаяИнформацияПоОбмену,
		|ЗаголовокПомощникаСозданияОбмена,
		|ПодробнаяИнформацияПоОбмену,
		|ИмяФормыСозданияНачальногоОбраза,
		|ИмяФормыПомощникаНастройкиСинхронизацииДанных",
		ИдентификаторНастройки);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияНастроекДляВарианта);
	
	Если ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза)
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.[ФормаСозданияНачальногоОбраза]";
		ИмяФормыСозданияНачальногоОбраза = СтрЗаменить(ИмяФормыСозданияНачальногоОбраза,
			"[ФормаСозданияНачальногоОбраза]", "СозданиеНачальногоОбразаСФайлами");
	КонецЕсли;
	
	ТекущийЭтапНастройки = "";
	Если НастройкаНовойСинхронизации Тогда
		ТекущийЭтапНастройки = "НастройкаПодключения";
	Иначе
		Если Не НастройкаСинхронизацииЗавершена(УзелОбмена) Тогда
			ТекущийЭтапНастройки = "НастройкаПравил";
		ИначеЕсли НастройкаРИБ
			И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
			И Не НачальныйОбразСоздан(УзелОбмена) Тогда
			Если Не ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза) Тогда
				ТекущийЭтапНастройки = "НачальныйОбразРИБ";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ВсеЭтапыНастройки = Новый Структура;
	ВсеЭтапыНастройки.Вставить("НастройкаПодключения",    "Основное");
	ВсеЭтапыНастройки.Вставить("НастройкаПравил",         "Основное");
	ВсеЭтапыНастройки.Вставить("НачальныйОбразРИБ",       "Основное");
	ВсеЭтапыНастройки.Вставить("СопоставлениеИЗагрузка",  "Основное");
	ВсеЭтапыНастройки.Вставить("НачальнаяВыгрузкаДанных", "Основное");
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьЭтапНастройки(Название, Кнопка)
	
	СтрокаЭтап = ЭтапыНастройки.Добавить();
	СтрокаЭтап.Название     = Название;
	СтрокаЭтап.Кнопка       = Кнопка;
	СтрокаЭтап.ШрифтОбычный = Новый Шрифт(Элементы[Кнопка].Шрифт, , , Ложь);
	СтрокаЭтап.ШрифтЖирный  = Новый Шрифт(Элементы[Кнопка].Шрифт, , , Истина);
	
	Возврат СтрокаЭтап;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуЭтаповНастройки()
	
	ЭтапыНастройки.Очистить();
	
	Если ЕстьНастройкиТранспорта
		Или НастройкаНовойСинхронизации Тогда
		ДобавитьЭтапНастройки("НастройкаПодключения", "НастроитьПараметрыПодключения");
	КонецЕсли;
	
	ДобавитьЭтапНастройки("НастройкаПравил", "НастроитьПравилаОтправкиИПолучения");
	
	Если НастройкаРИБ
		И Не ПродолжениеНастройкиВПодчиненномУзлеРИБ
		И Не ПустаяСтрока(ИмяФормыСозданияНачальногоОбраза) Тогда
		ДобавитьЭтапНастройки("НачальныйОбразРИБ", "СоздатьНачальныйОбразРИБ");
	КонецЕсли;
	
	Если Не НастройкаРИБ
		И Не НастройкаУниверсальногоОбмена
		И ПолученыДанныеДляСопоставления Тогда
		ДобавитьЭтапНастройки("СопоставлениеИЗагрузка", "ВыполнитьСопоставлениеИЗагрузкуДанных");
	КонецЕсли;
		
	Если ДоступнаИнтерактивнаяОтправка
		И (ЕстьНастройкиТранспорта
			Или НастройкаНовойСинхронизации) Тогда
		ДобавитьЭтапНастройки("НачальнаяВыгрузкаДанных", "ВыполнитьНачальнуюВыгрузкуДанных");
	КонецЕсли;
	
	// Видимость элементов настройки.
	Для Каждого ЭтапНастройки Из ВсеЭтапыНастройки Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"Группа" + ЭтапНастройки.Ключ,
			"Видимость",
			ЭтапыНастройки.НайтиСтроки(Новый Структура("Название", ЭтапНастройки.Ключ)).Количество() > 0);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНачальноеОтображениеЭлементовФормы()
	
	Элементы.ДекорацияКраткаяИнформацияПоОбменуНадпись.Заголовок = КраткаяИнформацияПоОбмену;
	Элементы.ГруппаРезервноеКопирование.Видимость = РезервноеКопирование;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти