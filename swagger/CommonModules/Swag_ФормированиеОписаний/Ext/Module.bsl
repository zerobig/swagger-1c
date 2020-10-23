﻿// Возвращает структуру с описанием параметра HTTP сервиса
//
// Параметры:
//  Имя - Строка - наименование параметра
//  ОписаниеПараметра - Строка - описание параметра как оно будет выглядеть в документации
//  Тип - Строка - допустимые значения:
//   * 
//  Обязательный - Булево - признак того что это обязательный параметр
//  Устарел - Булево - признак deprecated
Функция ОписаниеПараметра(Имя, ОписаниеПараметра, Тип, Обязательный = Ложь, Устарел = Ложь) Экспорт
	
	Возврат Новый Структура("Имя, Описание, Тип, Обязательный, Устарел",
		Имя, ОписаниеПараметра, Тип, Обязательный, Устарел)
	
КонецФункции

// Возвращает структуру с описанием ответа HTTP сервиса
//
// Параметры:
//  Код - Число - код ответа HTTP (200, 201, 401, 404 и т.д.)
//  ОписаниеОтвета - Строка - описание ответа как он будет выглядеть в документации
//  МассивТиповMIME - Массив - массив структур получаемых через функцию ОписаниеТипаMIME
Функция ОписаниеОтвета(Код, ОписаниеОтвета, МассивТиповMIME = Неопределено) Экспорт
	
	Возврат Новый Структура("Код, Описание, МассивТиповMIME", Код, ОписаниеОтвета, МассивТиповMIME)
	
КонецФункции

// Возвращает структуру с описанием типа MIME ответа
//
// Параметры:
//  Заголовок - Строка - описание типа MIME (application/json, application/json-patch+json и т.д.)
//  Тип - Строка - допустимые значения:
//   * string
//   * array
//  Схема - Строка - наименование объекта как он задан через функцию ОписаниеОбъекта
Функция ОписаниеТипаMIME(Заголовок, Тип = Неопределено, Схема = Неопределено) Экспорт
	
	Возврат Новый Структура("Заголовок, Тип, Схема", Заголовок, Тип,
		?(ТипЗнч(Схема) = Тип("Строка"), "#/components/schemas/" + Схема, ""));
	
КонецФункции

// Возвращает структуру с описанием метода HTTP сервиса
//
// Параметры:
//  Метод - Строка - наименование метода как он описан в конфигураторе. Строится по принципу <Имя шаблона URL><Имя метода>
//  ОписаниеМетода - Строка - описание метода как оно будет выглядеть в документации
//  Параметры - Массив
//  Ответы - Массив
//  ТелоЗапроса - Структура - применяется для POST, PUT, CONNECT и PATCH
Функция ОписаниеМетода(Метод, ОписаниеМетода, Параметры, Ответы, ТелоЗапроса = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Описание, Параметры, Ответы, ТелоЗапроса",
		Метод, ОписаниеМетода, Параметры, Ответы, ТелоЗапроса)
	
КонецФункции

// Возвращает структуру с описанием объекта (модели)
//
// Параметры:
//  Имя - Строка - наименование объекта (модели)
//  Тип - Строка - допустимые значения:
//   * 
//  МассивСвойств - Массив - свойства объекта, которые, в свою очередь, могут включать другие объекты и т.д.
Функция ОписаниеОбъекта(Имя, Тип, МассивСвойств = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Тип, МассивСвойств", Имя, Тип, МассивСвойств);
	
КонецФункции

// Возвращает структуру с описанием свойства объекта (модели)
//
// Параметры:
//  Имя - Строка - наименование свойства объекта (модели)
//  ОписаниеСвойства - Строка - описание свойства объекта как оно будет выглядеть в документации
//  Nullable - Булево
//  Тип - Строка - допустимые значения:
//   * boolean;
//   * string;
//   * integer;
//   * number;
//   * array;
//   * object;
//  Формат - Строка - допустимые значения:
//   * для string:
//    - byte;
//    - binary;
//    - date;
//    - datetime;
//    - password;
//    - uuid; в спецификации вроде бы нет, но я видел в некоторых реализациях
//   * для integer:
//    - int32;
//    - int64; аналог long
//   * для number:
//    - float;
//    - double;
Функция ОписаниеСвойстваОбъекта(Имя, ОписаниеСвойства, Тип, Nullable = Ложь, Формат = Неопределено, Схема = Неопределено) Экспорт
	
	Возврат Новый Структура("Имя, Описание, Тип, Nullable, Формат, Схема",
		Имя, ОписаниеСвойства, Тип, Nullable, Формат, ?(ТипЗнч(Схема) = Тип("Строка"), "#/components/schemas/" + Схема, ""));
	
КонецФункции

//
//
//
Функция ОписаниеТелаЗапроса(ОписаниеТела, МассивТиповMIME = Неопределено) Экспорт
	
	Возврат Новый Структура("Описание, МассивТиповMIME", ОписаниеТела, МассивТиповMIME);
	
КонецФункции