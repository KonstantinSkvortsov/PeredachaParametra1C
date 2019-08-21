#Область ПрограммныйИнтерфейс

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив - Элементами массива являются общие модули.
//
Процедура ЗаполнитьОбработчикиПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  отправляемых сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив - Элементами массива являются общие модули.
//
Процедура ЗаполнитьОбработчикиОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Процедура вызывается при определении версии интерфейса сообщений, поддерживаемой как ИБ-корреспондентом,
//  так и текущей ИБ. В данной процедуре предполагается реализовывать механизмы поддержки обратной совместимости
//  со старыми версиями ИБ-корреспондентов.
//
// Параметры:
//  ИнтерфейсСообщения - Строка - Название программного интерфейса сообщения, для которого определяется версия.
//  ПараметрыПодключения - Структура - Параметры подключения к ИБ-корреспонденту.
//  ПредставлениеПолучателя - Строка - Представление ИБ-корреспондента.
//  Результат - Строка - Определяемая версия. Значение данного параметра может быть изменено в данной процедуре.
//
Процедура ПриОпределенииВерсииИнтерфейсаКорреспондента(Знач ИнтерфейсСообщения, Знач ПараметрыПодключения, Знач ПредставлениеПолучателя, Результат) Экспорт
	
КонецПроцедуры

#КонецОбласти
