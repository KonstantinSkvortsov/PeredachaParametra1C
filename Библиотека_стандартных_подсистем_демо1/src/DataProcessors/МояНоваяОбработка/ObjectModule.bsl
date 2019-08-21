/////////////////////////////////////////////////////////////////////////
// ********************************************************************
// Функции для использования системой БСП
//Функция ВерсияСтандартныхФункцийОтчетов()
	//Версия стандартных подсистем 3.0.1.428

Функция СведенияОВнешнейОбработке() Экспорт
    ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("3.0.1.428");
    ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
    ПараметрыРегистрации.Версия = "06.08.2019";
	ПараметрыРегистрации.Вставить("Информация", 
			"Моя обработка.
			|
			|История изменений:
			|06.08.2019
			|			Первая версия.
			|");
	ПараметрыРегистрации.БезопасныйРежим	=	Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
    Команда.Представление = НСтр("ru = 'Моя новая обработка'");
    Команда.Идентификатор = "МояНоваяОбработка";
    Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
    Команда.ПоказыватьОповещение = Ложь;

    Возврат ПараметрыРегистрации; 
КонецФункции
