////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки в модели сервиса", процедуры
//  и функции с повторным использованием возвращаемых значений.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает фиксированную массив, содержащий имена констант, регулирующих доступность
//  использования дополнительных отчетов и обработок в модели сервиса.
//
Функция РегулирующиеКонстанты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("НезависимоеИспользованиеДополнительныхОтчетовИОбработокВМоделиСервиса");
	Результат.Добавить("ИспользованиеКаталогаДополнительныхОтчетовИОбработокВМоделиСервиса");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Функция возвращает массив, содержащий имена реквизитов справочника ДополнительныеОтчетыИОбработки,
//  которые запрещено изменять при наличии связи с поставляемыми обработками.
//
Функция КонтролируемыеРеквизиты() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("БезопасныйРежим");
	Результат.Добавить("ХранилищеОбработки");
	Результат.Добавить("ИмяОбъекта");
	Результат.Добавить("Версия");
	Результат.Добавить("Вид");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

// Функция возвращает соответствие элементов перечисления ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса
//  подробному описанию причины отключения.
//
Функция РасширенныеОписанияПричинБлокировки() Экспорт
	
	Причины = Перечисления.ПричиныОтключенияДополнительныхОтчетовИОбработокВМоделиСервиса;
	
	Результат = Новый Соответствие();
	Результат.Вставить(Причины.БлокировкаАдминистраторомСервиса, НСтр("ru = 'Использование дополнительной обработки запрещено из-за нарушений правил сервиса!'"));
	Результат.Вставить(Причины.БлокировкаВладельцем, НСтр("ru = 'Использование дополнительной обработки запрещено владельцем обработки!'"));
	Результат.Вставить(Причины.ОбновлениеВерсииКонфигурации, НСтр("ru = 'Использование дополнительной обработки временно недоступно по причине выполнения обновления приложения. Данный процесс может занять несколько минут. Приносим извинения на доставленные неудобства.'"));
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти