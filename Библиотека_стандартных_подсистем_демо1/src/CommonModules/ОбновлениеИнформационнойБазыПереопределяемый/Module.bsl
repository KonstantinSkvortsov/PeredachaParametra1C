#Область ПрограммныйИнтерфейс

// Позволяет переопределить различные сообщения, выводимые пользователю.
// 
// Параметры:
//  Параметры - Структура - со свойствами:
//    * ПоясненияДляРезультатовОбновления - Строка - текст подсказки, указывающий путь
//                                          к форме "Результаты обновления программы".
//    * ПараметрыСообщенияОНевыполненныхОтложенныхОбработчиках - Структура - сообщение о
//                                          наличии невыполненных отложенных обработчиков обновления
//                                          на прошлую версию при попытке обновления.
//       * ТекстСообщения                 - Строка - текст сообщения, выводимый пользователю. По умолчанию
//                                          текст сообщения построен с учетом того, что обновление можно
//                                          продолжить, т.е. параметр ЗапрещатьПродолжение = Ложь.
//       * КартинкаСообщения              - БиблиотекаКартинок: Картинка - картинка, выводимая слева от сообщения.
//       * ЗапрещатьПродолжение           - Булево - если Истина, продолжить обновление будет невозможно. По умолчанию Ложь.
//    * РасположениеОписанияИзмененийПрограммы - Строка - описывает расположение команды, по которой можно
//                                          открыть форму с описанием изменений в новой версии программы.
//    * МногопоточноеОбновление           - Булево - если Истина, то в один момент времени могут выполняться сразу
//                                          несколько обработчиков обновления. По умолчанию - Ложь.
//                                          Это влияет, как на количество потоков выполнения обработчиков обновления,
//                                          так и количество потоков регистрации данных для обновления.
//                                          ВАЖНО: Перед включением ознакомьтесь с документацией.
//    * КоличествоПотоковОбновленияИнформационнойБазыПоУмолчанию - Строка - количество потоков отложенного обновления
//                                          используемое, когда не задано значение для константы
//                                          КоличествоПотоковОбновленияИнформационнойБазы. По умолчанию равно 1.
//
Процедура ПриОпределенииНастроек(Параметры) Экспорт
	
	// _Демо начало примера
	_ДемоОбновлениеИнформационнойБазыБСП.ПриОпределенииНастроек(Параметры);
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
// Здесь можно разместить любую нестандартную логику обновления данных, 
// например, иначе проинициализировать сведения о версиях тех или иных подсистем
// с помощью ОбновлениеИнформационнойБазы.ВерсияИБ, ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ,
// и ОбновлениеИнформационнойБазы.ЗарегистрироватьНовуюПодсистему.
//
// Пример:
//  Для того чтобы отменить штатную процедуру перехода с другой программы, регистрируем 
//  сведения о том, что основная конфигурации уже актуальной версии:
//  ВерсииПодсистем = ОбновлениеИнформационнойБазы.ВерсииПодсистем();
//  Если ВерсииПодсистем.Количество() > 0 И ВерсииПодсистем.Найти(Метаданные.Имя, "ИмяПодсистемы") = Неопределено Тогда
//    ОбновлениеИнформационнойБазы.ЗарегистрироватьНовуюПодсистему(Метаданные.Имя, Метаданные.Версия);
//  КонецЕсли;
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// В зависимости от тех или иных условий можно отключить штатное открытие формы
// с описанием изменений в новой версии программы при первом входе в нее (после обновления),
// а также выполнить другие действия.
//
// Не рекомендуется выполнять в данной процедуре какую-либо обработку данных.
// Такие процедуры следует оформлять штатными обработчиками обновления, выполняемыми на каждую версию "*".
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия после обновления. Как правило, соответствует Метаданные.Версия.
//   ИтерацииОбновления     - Массив - массив структур, описывающих сведения об обновлении каждой
//                                     библиотеки и конфигурации, с ключами:
//       * Подсистема              - Строка - имя библиотеки или конфигурации.
//       * Версия                  - Строка - например, "2.1.3.39". Номер версии библиотеки (конфигурации).
//       * ЭтоОсновнаяКонфигурация - Булево - Истина, если это основная конфигурация, а не библиотека.
//       * Обработчики             - ТаблицаЗначений - все обработчики обновления библиотеки, описание колонок
//                                   см. в ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//       * ВыполненныеОбработчики  - ДеревоЗначений - выполненные обработчики обновления, библиотеке и номеру версии,
//                                   описание колонок см. в ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//       * ИмяОсновногоСерверногоМодуля - Строка - имя модуля библиотеки (конфигурации), который предоставляет
//                                        основные сведения о ней: имя, версия и т.д.
//       * ОсновнойСерверныйМодуль      - ОбщийМодуль - общий модуль библиотеки (конфигурации), который предоставляет
//                                        основные сведения о ней: имя, версия и т.д.
//       * ПредыдущаяВерсия             - Строка - например, "2.1.3.30". Номер версии библиотеки (конфигурации) до обновления.
//   ВыводитьОписаниеОбновлений - Булево - если установить Ложь, то не будет открыта форма
//                                с описанием изменений в новой версии программы. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - признак того, что обновление выполнилось в монопольном режиме.
//
// Пример:
//  Для обхода выполненных обработчиков обновления:
//  Для Каждого ИтерацияОбновления Из ИтерацииОбновления Цикл
//  	Для Каждого Версия Из ИтерацияОбновления.ВыполненныеОбработчики.Строки Цикл
//  		
//  		Если Версия.Версия = "*" Тогда
//  			// Группа обработчиков, которые выполняются регулярно при каждой смене версии.
//  		Иначе
//  			// Группа обработчиков, которые выполнились для определенной версии.
//  		КонецЕсли;
//  		
//  		Для Каждого Обработчик Из Версия.Строки Цикл
//  			...
//  		КонецЦикла;
//  		
//  	КонецЦикла;
//  КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
	Знач ИтерацииОбновления, ВыводитьОписаниеОбновлений, Знач МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке документа с описанием изменений в новой версии программы,
// которое выводится пользователю при первом входа в программу (после обновления).
//
// Параметры:
//   Макет - ТабличныйДокумент - описание изменений в новой версии программы, автоматически
//                               сформированное из общего макета ОписаниеИзмененийСистемы.
//                               Макет можно программно модифицировать или заменить на другой.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Позволяет переопределить очередь отложенных обработчиков обновления, выполняемых в
// параллельном режиме. Может понадобиться, когда отложенные обработчики библиотек
// обрабатывают те же данные, что и обработчики основной конфигурации.
// Например, есть обработчики библиотеки и конфигурации, которые обрабатывают справочник
// Контрагенты, при этом обработчик конфигурации должен выполниться раньше, чтобы данные
// обновились корректно. В таком случае в данной процедуре нужно указать новый номер очереди
// для обработчика библиотеки, который будет больше, чем у обработчика конфигурации.
//
// Параметры:
//  ОбработчикИОчередь - Соответствие - где:
//    * Ключ     - Строка - полное имя обработчика обновления.
//    * Значение - Число  - номер очереди, который необходимо установить обработчику.
//
Процедура ПриФормированииОчередейОтложенныхОбработчиков(ОбработчикИОчередь) Экспорт
	
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Вызывается для получения списка обработчиков обновления, вызов которых нужно пропустить.
// Отключать можно только обработчики обновления с номером версии "*".
//
// Параметры:
//  ОтключаемыеОбработчики - ТаблицаЗначений - с колонками:
//     * ИдентификаторБиблиотеки - Строка - имя конфигурации или идентификатор библиотеки.
//     * Версия -                - Строка - номер версии конфигурации, в которой нужно отключить
//                                          выполнение обработчика.
//     * Процедура -             - Строка - имя процедуры обработчика обновления,
//                                          которого необходимо отключить.
//
// Пример:
//   НовоеИсключение = ОтключаемыеОбработчики.Добавить();
//   НовоеИсключение.ИдентификаторБиблиотеки = "СтандартныеПодсистемы";
//   НовоеИсключение.Версия = "*";
//   НовоеИсключение.Процедура = "ВариантыОтчетов.Обновить";
//
Процедура ПриОтключенииОбработчиковОбновления(ОтключаемыеОбработчики) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
