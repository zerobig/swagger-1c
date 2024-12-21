﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру с описанием параметра HTTP сервиса
//
// Параметры:
//  Имя - Строка - наименование параметра
//  ОписаниеПараметра - Строка - описание параметра как оно будет выглядеть в документации
//  ТипПараметра - Строка - допустимые значения: query, path, header, form
//  Обязательный - Булево - признак того что это обязательный параметр
//  Устарел - Булево - признак deprecated
//  ТипЗначения - Строка - допустимые значения:  boolean, string, integer, number, array, object
//
// Возвращаемое значение:
//  Структура - описание параметра
//
Функция ОписаниеПараметра(Имя, ОписаниеПараметра, ТипПараметра, Обязательный = Ложь, Устарел = Ложь,
	ТипЗначения = "string", Перечисление = Неопределено) Экспорт
	
	Если ТипПараметра = "path" Тогда
		Обязательный = Истина;
	КонецЕсли;
	
	Возврат Новый Структура("Имя, Описание, ТипПараметра, Обязательный, Устарел, ТипЗначения, Перечисление",
		Имя, ОписаниеПараметра, ТипПараметра, Обязательный, Устарел, ТипЗначения, Перечисление)
	
КонецФункции

// Возвращает структуру с описанием ответа HTTP сервиса
//
// Параметры:
//  Код - Число - код ответа HTTP (200, 201, 401, 404 и т.д.)
//  ОписаниеОтвета - Строка - описание ответа как он будет выглядеть в документации
//  МассивТиповMIME - Массив из см. Swag_ФормированиеОписаний.ОписаниеТипаMIME
//
// Возвращаемое значение:
//  Структура - описание сервиса
//
Функция ОписаниеОтвета(Код, ОписаниеОтвета, МассивТиповMIME = Неопределено) Экспорт
	
	Возврат Новый Структура("Код, Описание, МассивТиповMIME", Код, ОписаниеОтвета, МассивТиповMIME)
	
КонецФункции

// Возвращает структуру с описанием типа MIME ответа
//
// Параметры:
//  Заголовок - Строка - описание типа MIME (application/json, application/json-patch+json и т.д.)
//  Тип - Строка - допустимые значения: string, array
//  Схема - Строка - наименование объекта как он задан через функцию ОписаниеОбъекта
//
// Возвращаемое значение:
//  Структура - описание MIME ответа
//
Функция ОписаниеТипаMIME(Заголовок, Тип = Неопределено, Схема = Неопределено) Экспорт
	
	Возврат Новый Структура("Заголовок, Тип, Схема", Заголовок, Тип,
		?(ТипЗнч(Схема) = Тип("Строка"), "#/components/schemas/" + Схема, ""));
	
КонецФункции

// Возвращает структуру с описанием метода HTTP сервиса
//
// Параметры:
//  Метод - Строка - наименование метода как он описан в конфигураторе.
//                   Строится по принципу <Имя шаблона URL><Имя метода>
//  ОписаниеМетода - Строка - описание метода как оно будет выглядеть в документации
//  Параметры - Массив из см. Swag_ФормированиеОписаний.ОписаниеПараметра
//  Ответы - Массив из см. Swag_ФормированиеОписаний.ОписаниеОтвета
//  ТелоЗапроса - Структура - применяется для POST, PUT, CONNECT и PATCH
//
// Возвращаемое значение:
//  Структура - описание метода HTTP сервиса
//
Функция ОписаниеМетода(Метод, ОписаниеМетода, Параметры, Ответы, ТелоЗапроса = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Описание, Параметры, Ответы, ТелоЗапроса",
		Метод, ОписаниеМетода, Параметры, Ответы, ТелоЗапроса)
	
КонецФункции

// Возвращает структуру с описанием объекта (модели)
//
// Параметры:
//  Имя              - Строка - наименование объекта (модели)
//  Тип              - Строка - допустимые значения
//  МассивСвойств    - Массив из см. Swag_ФормированиеОписаний.ОписаниеОбъекта
//  ОбязательныеПоля - Строка - наименования полей, разделенные запятыми
//
// Возвращаемое значение:
//  Структура - описание объекта (модели)
//
Функция ОписаниеОбъекта(Имя, Тип, МассивСвойств = Неопределено, ОбязательныеПоля = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Тип, МассивСвойств, ОбязательныеПоля",
		Имя, Тип, МассивСвойств, ОбязательныеПоля);
	
КонецФункции

// Устарела. Следует использовать ОписаниеРеквизитаОбъекта
// Возвращает структуру с описанием свойства объекта (модели)
//
// Параметры:
//  Имя              - Строка - наименование свойства объекта (модели)
//  ОписаниеСвойства - Строка - описание свойства объекта как оно будет выглядеть в документации
//  Nullable         - Булево
//  Тип              - Строка - допустимые значения: boolean, string, integer, number, array, object
//  Формат           - Строка - допустимые значения:
//                              для string - byte, binary, date, datetime, password, uuid (последнее в спецификации
//                              вроде бы нет, но я видел в некоторых реализациях)
//                              для integer - int32, int64 (последнее аналог long)
//                              для number - float, double
//  Схема            - Строка -
//  Пример           - Строка -
//  Перечисление     - Массив -
//
// Возвращаемое значение:
//  Структура - описание свойства объекта (модели)
//
Функция ОписаниеСвойстваОбъекта(Имя, ОписаниеСвойства, Тип, Nullable = Ложь, Формат = Неопределено,
	Схема = Неопределено, Пример = Неопределено, Перечисление = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Описание, Тип, Nullable, Формат, Схема, Пример, Перечисление",
		Имя, ОписаниеСвойства, Тип, Nullable, Формат, ?(ТипЗнч(Схема) = Тип("Строка"), "#/components/schemas/" + Схема, ""),
		Пример, Перечисление);
	
КонецФункции

// Возвращает минимально заполненную структуру с описанием реквизита объекта (модели)
//
// Параметры:
//  Имя   - Строка - наименование реквизита объекта (модели)
//  Тип   - Строка - допустимые значения: boolean, string, integer, number, array, object
//  Схема - Строка - название объекта для массива (array) или объекта (object)
//
// Возвращаемое значение:
//  Структура - описание свойства объекта (модели)
//
Функция ОписаниеРеквизитаОбъекта(Имя, Тип, Схема = Неопределено) Экспорт
	
	Если Тип = "array" Или Тип = "object" Тогда
		СхемаСПрефиксом = ?(ТипЗнч(Схема) = Тип("Строка"),
			"#/components/schemas/" + Схема, Неопределено);
	Иначе
		СхемаСПрефиксом = Неопределено;
	КонецЕсли;
	// { Андриянов Р.В. - 11.12.2024 - ITERP1C-2967
	//Возврат Новый Структура("Имя, Тип, Схема, Описание, Nullable, Обязательный, Формат,
	//	|Максимум, Минимум, НеВключаяМаксимум, НеВключаяМинимум, МаксимальнаяДлина, МинимальнаяДлина,
	//	|Пример, Перечисление", Имя, Тип, СхемаСПрефиксом);

	Возврат Новый Структура("Имя, Тип, Схема, Описание, Nullable, Обязательный, ТипМассива, Формат,
		|Максимум, Минимум, НеВключаяМаксимум, НеВключаяМинимум, МаксимальнаяДлина, МинимальнаяДлина,
		|Пример, Перечисление", Имя, Тип, СхемаСПрефиксом);
	// }

КонецФункции

// Возвращает структуру с описанием тела запроса
//
// Параметры:
//  ОписаниеТела - Строка - описание тела запроса как оно будет выглядеть в документации
//  МассивТиповMIME - Массив из см. Swag_ФормированиеОписаний.ОписаниеТипаMIME
//
// Возвращаемое значение:
//  Структура - описание тела запроса
//
Функция ОписаниеТелаЗапроса(ОписаниеТела, МассивТиповMIME = Неопределено) Экспорт
	
	Возврат Новый Структура("Описание, МассивТиповMIME", ОписаниеТела, МассивТиповMIME);
	
КонецФункции

#КонецОбласти
