#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.4.1.1");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Демонстрирует обновление данных подсистемы ""Дополнительные отчеты и обработки"" на основании отчетов и обработок из метаданных конфигурации.'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "2.4.1.1";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Обновить дополнительные отчеты и обработки'");
	Команда.Идентификатор = "ОбновитьДополнительныеОтчетыИОбработки";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	Возврат ПараметрыРегистрации;
КонецФункции

// Обработчик серверных команд.
//
// Параметры:
//   ИмяКоманды           - Строка    - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//           Может использоваться для чтения параметров обработки.
//           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//
Процедура ВыполнитьКоманду(Знач ИмяКоманды, Знач ПараметрыВыполнения) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		Возврат;
	#КонецЕсли
	
	ОтчетыИОбработки = Новый ТаблицаЗначений();
	ОтчетыИОбработки.Колонки.Добавить("ОбъектМетаданных");
	ОтчетыИОбработки.Колонки.Добавить("СтарыеИменаОбъектов", Новый ОписаниеТипов("Массив"));
	ОтчетыИОбработки.Колонки.Добавить("СтарыеИменаФайлов",   Новый ОписаниеТипов("Массив"));
	
	// Отчеты.
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Отчеты._ДемоОтчетПоСчетамНаОплатуГлобальный;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ГлобальныйОтчет");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительныйОтчет");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ГлобальныйОтчет.erf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительныйОтчет.erf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ДополнительныйОтчет.erf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Отчеты._ДемоОтчетПоСчетамНаОплатуКонтекстный;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("Отчет");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоКонтекстныйОтчет");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительныйОтчетНазначаемый");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительныйОтчетКонтекстный");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("Отчет.erf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительныйОтчетНазначаемый.erf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("КонтекстныйОтчет.erf");
	
	// Обработки.
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоУправлениеПолнотекстовымПоиском;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ГлобальнаяОбработка");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработка");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ГлобальнаяОбработка.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработка.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ДополнительнаяОбработка.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоЗаполнениеКонтрагентов;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ЗаполнениеОбъекта");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаЗаполненияНазначаемая");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаЗаполненияНазначаемая.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ЗаполнениеОбъекта.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоЗагрузкаЮридическихЛицКонтрагентов;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаИзФайла");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаИзФайла.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ЗагрузкаКонтрагентовИзФайла.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоПечатьСписанийТоваровСИспользованиемМакетаOpenOfficeXML;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ПечатнаяФорма");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаПечатиMSWordНазначаемая");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоПечатьСписанийТоваровСИспользованиемМакетаMSWord");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоПечатьСписанийТоваровСИспользованиемМакетаMSWord.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаПечатиMSWordНазначаемая.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("Печать_MSWord_OO.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("Печать_Word.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоПечатьСчетовНаОплатуПокупателю;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ПечатнаяФорма");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаПечатиMXLНазначаемая");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаПечатиMXLНазначаемая.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("Печать_MXL.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоВводНаОснованииОприходованийТоваров;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("СоздатьНаОсновании");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаСозданияСвязанныхОбъектовНазначаемая");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаСозданияСвязанныхОбъектовНазначаемая.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("СозданиеСвязанныхОбъектов.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоЗагрузкаНоменклатурыИзПрайсЛистаПрофилиБезопасности;
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("ЗагрузкаПрайсЛиста");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаПрайсЛиста");
	СтрокаТаблицы.СтарыеИменаОбъектов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаПрайсЛистаСПрофилем");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("ЗагрузкаПрайсЛиста.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаПрайсЛиста.epf");
	СтрокаТаблицы.СтарыеИменаФайлов.Добавить("_ДемоДополнительнаяОбработкаЗагрузкаПрайсЛистаСПрофилем.epf");
	
	СтрокаТаблицы = ОтчетыИОбработки.Добавить();
	СтрокаТаблицы.ОбъектМетаданных = Метаданные.Обработки._ДемоШаблонСообщенияДляЗаказаПокупателя;
	
	ДополнительныеОтчетыИОбработки.ЗагрузитьДополнительныеОтчетыИОбработкиИзМетаданных(ОтчетыИОбработки);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#КонецЕсли