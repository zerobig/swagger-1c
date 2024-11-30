﻿
#Область ПрограммныйИнтерфейс

// Возвращает ответ содержащий JSON описания HTTP сервисов конфигурации
//
// Параметры:
//   - Запрос - HTTPСервисЗапрос
//
// Возвращаемое значение:
//   - HTTPСервисОтвет
//
Функция ПолучитьSwaggerFileGET(Запрос) Экспорт
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	НаименованиеМакета = СтрЗаменить(Запрос["ПараметрыURL"].Получить("File"), ".", "_");
	НаименованиеМакета = "Swag_" + СтрЗаменить(НаименованиеМакета, "-", "_");
	Попытка
		
		Если НаименованиеМакета = "Swag_swagger_json" Тогда
			
			Ответ.Заголовки.Вставить("Content-Type", "application/json");
			Ответ.УстановитьТелоИзСтроки(СформироватьБазовыйSwaggerJson(СтрЗаменить(ПолучитьБазовыйURLСПортом(Запрос), "/swagger", "")),
				КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
			
		ИначеЕсли НаименованиеМакета = "Swag_swagger_js" Тогда

			Ответ.Заголовки.Вставить("Content-Type", "text/javascript");
			Ответ.УстановитьТелоИзСтроки("var spec = " + СформироватьБазовыйSwaggerJson(СтрЗаменить(ПолучитьБазовыйURLСПортом(Запрос), "/swagger", "")),
				КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
			
		Иначе
			Макет = ПолучитьОбщийМакет(НаименованиеМакета);
			Если Прав(НаименованиеМакета, 5) = "_html" Тогда
				
				Если НРег(Запрос.ПараметрыЗапроса.Получить("ui")) = "redoc" Тогда
					// https://github.com/Redocly/redoc/issues/1222
					Макет = ПолучитьОбщийМакет("Swag_redoc_index_html");
				ИначеЕсли НРег(Запрос.ПараметрыЗапроса.Получить("ui")) = "scalar" Тогда
					Макет = ПолучитьОбщийМакет("Swag_scalar_index_html");
				ИначеЕсли НРег(Запрос.ПараметрыЗапроса.Получить("ui")) = "stoplight" Тогда
					Макет = ПолучитьОбщийМакет("Swag_stoplight_index_html");
				ИначеЕсли НРег(Запрос.ПараметрыЗапроса.Получить("ui")) = "rapidoc" Тогда
					Макет = ПолучитьОбщийМакет("Swag_rapidoc_index_html");
				КонецЕсли;

				Ответ.Заголовки.Вставить("Content-Type", "text/html; charset=UTF-8");
				Данные = Макет.ПолучитьТекст();
				Ответ.УстановитьТелоИзСтроки(СтрЗаменить(Данные, "{БазовыйURL}", ПолучитьБазовыйURLСПортом(Запрос)),
					КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
				
			ИначеЕсли Прав(НаименованиеМакета, 4) = "_css" Тогда
					
				Ответ.Заголовки.Вставить("Content-Type", "text/css");
				Данные = Новый ТекстовыйДокумент;
				Данные.Прочитать(Макет.ОткрытьПотокДляЧтения(), КодировкаТекста.UTF8);
				Ответ.УстановитьТелоИзСтроки(Данные.ПолучитьТекст(),
					КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
					
			ИначеЕсли Прав(НаименованиеМакета, 3) = "_js" Тогда
				
				Ответ.Заголовки.Вставить("Content-Type", "text/javascript");
				Данные = Новый ТекстовыйДокумент;
				Данные.Прочитать(Макет.ОткрытьПотокДляЧтения(), КодировкаТекста.UTF8);
				Ответ.УстановитьТелоИзСтроки(Данные.ПолучитьТекст(),
					КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
					
			ИначеЕсли Прав(НаименованиеМакета, 4) = "_png" Тогда

				Ответ.Заголовки.Вставить("Content-Type", "image/png");
				Ответ.УстановитьТелоИзДвоичныхДанных(Макет);
				
			КонецЕсли;
		КонецЕсли;
		
		// TODO: Либо загрузить css и js без map, либо обрабатывать запросы на файлы .map
		
	Исключение
		ЗаписьЖурналаРегистрации(
			СтрШаблон(
				НСтр("ru = 'Ошибка получения файла из макета %1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				НаименованиеМакета),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Возврат Новый HTTPСервисОтвет(404);
	КонецПопытки;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьБазовыйURLСПортом(Запрос)
	
	БазовыйURL = Запрос.БазовыйURL;
	Если СтрНайти(Запрос.Заголовки["Host"], ":") > 0 Тогда
		МассивHost = СтрЗаменить(Запрос.Заголовки["Host"], ":", Символы.ПС);
		БазовыйURL = СтрЗаменить(БазовыйURL, СтрПолучитьСтроку(МассивHost, 1), Запрос.Заголовки["Host"])
	КонецЕсли;
	
	Возврат БазовыйURL;
	
КонецФункции

Функция СформироватьБазовыйSwaggerJson(БазовыйURL)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, Символы.Таб));
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // документ swagger
	
	СоздатьЗаголовокДокументаSwagger(ЗаписьJSON, БазовыйURL);
	ВсеОбъектыИТеги = СоздатьПути(ЗаписьJSON);
	СоздатьКомпоненты(ЗаписьJSON, ВсеОбъектыИТеги.Объекты);
	СоздатьОписанияТегов(ЗаписьJSON, ВсеОбъектыИТеги.Теги);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // документ swagger
	
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

Процедура СоздатьЗаголовокДокументаSwagger(ЗаписьJSON, БазовыйURL)
	
	//
	ЗаписьJSON.ЗаписатьИмяСвойства("openapi");
	ЗаписьJSON.ЗаписатьЗначение("3.0.0");
	
	//
	ЗаписьJSON.ЗаписатьИмяСвойства("info");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // info
	
	ЗаписьJSON.ЗаписатьИмяСвойства("description");
	ЗаписьJSON.ЗаписатьЗначение(Метаданные.Комментарий);
	ЗаписьJSON.ЗаписатьИмяСвойства("title");
	ЗаписьJSON.ЗаписатьЗначение(Метаданные.Имя);
	ЗаписьJSON.ЗаписатьИмяСвойства("version");
	ЗаписьJSON.ЗаписатьЗначение(Метаданные.Версия);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // info
	
	//
	ЗаписьJSON.ЗаписатьИмяСвойства("servers");
	ЗаписьJSON.ЗаписатьНачалоМассива(); // servers
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // конкретный один сервер
	
	ЗаписьJSON.ЗаписатьИмяСвойства("url");
	ЗаписьJSON.ЗаписатьЗначение(БазовыйURL);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // конкретный один сервер
	
	ЗаписьJSON.ЗаписатьКонецМассива(); // servers
	
КонецПроцедуры

Функция СоздатьПути(ЗаписьJSON)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("paths");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // paths
	
	ВсеОбъекты = Новый Массив;
	ВсеТеги = Новый Массив;
	
	Для каждого HTTPСервис Из Метаданные.HTTPСервисы Цикл
		Если HTTPСервис.Имя = "Swag_Сервис" Тогда
			Продолжить;
		КонецЕсли;
		
		СоздатьHTTPСервис(ЗаписьJSON, HTTPСервис, ВсеОбъекты, ВсеТеги);
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // paths
	
	Возврат Новый Структура("Объекты, Теги", ВсеОбъекты, ВсеТеги);
	
КонецФункции

Процедура СоздатьHTTPСервис(ЗаписьJSON, HTTPСервис, ВсеОбъекты, ВсеТеги)
	
	Попытка
		МодульОписанияHTTPСервиса = ОбщегоНазначения.ОбщийМодуль(HTTPСервис.Имя + "Описание");
		Описание = МодульОписанияHTTPСервиса.ПолучитьОписаниеHTTPСервиса();
		Объекты = МодульОписанияHTTPСервиса.ПолучитьОбъектыHTTPСервиса();
	Исключение
		ЗаписьЖурналаРегистрации("Swagger. Создать HTTP сервис", УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки());
	КонецПопытки;
	
	НаименованиеТега = ?(ЗначениеЗаполнено(HTTPСервис.Синоним), HTTPСервис.Синоним, HTTPСервис.Имя);
	ТегДобавлен = Ложь;
	
	Попытка
		ОписаниеHTTPСервиса = МодульОписанияHTTPСервиса.ПолучитьОбщеиеНастройки();
		Если ОписаниеHTTPСервиса.Свойство("НеОтображать") И ОписаниеHTTPСервиса.НеОтображать Тогда
			Возврат;
		КонецЕсли;
		
		Если ОписаниеHTTPСервиса.Свойство("Описание") И Не ПустаяСтрока(ОписаниеHTTPСервиса.Описание) Тогда
			ВсеТеги.Добавить(Новый Структура("Имя, Описание",
				НаименованиеТега, ОписаниеHTTPСервиса.Описание));
			
			ТегДобавлен = Истина;
		КонецЕсли;
	Исключение
		// Ничего делать не надо. Просто не задано описание HTTP-сервиса или не определена
		// функция получения общих настроек для данного HTTP-сервиса
	КонецПопытки;
	
	Если Не ТегДобавлен И Не ПустаяСтрока(HTTPСервис.Комментарий) Тогда
		ВсеТеги.Добавить(Новый Структура("Имя, Описание",
			НаименованиеТега, HTTPСервис.Комментарий));
	КонецЕсли;
	
	// Собираю все объекты в один массив для дальнейшего использования в секции schemas
	// СоздатьКомпоненты -> СоздатьСхемыОбъектов
	Если Не Объекты = Неопределено И ТиПЗнч(Объекты) = Тип("Массив") Тогда
		Для каждого ОбъектСервиса Из Объекты Цикл
			ВсеОбъекты.Добавить(ОбъектСервиса);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого ШаблонURL Из HTTPСервис.ШаблоныURL Цикл
		
		ЗаписьJSON.ЗаписатьИмяСвойства("/" + HTTPСервис.КорневойURL + ШаблонURL.Шаблон);
		ЗаписьJSON.ЗаписатьНачалоОбъекта();
		
		Для каждого Метод Из ШаблонURL.Методы Цикл

			ЗаписьJSON.ЗаписатьИмяСвойства(НРег(Метод.HTTPМетод));
			ЗаписьJSON.ЗаписатьНачалоОбъекта(); // метод
			
			СоздатьТэги(ЗаписьJSON, HTTPСервис);
			СоздатьОписаниеМетода(ЗаписьJSON, Описание, ШаблонURL, Метод);
			
			ЗаписьJSON.ЗаписатьКонецОбъекта(); // метод
			
		КонецЦикла;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьТэги(ЗаписьJSON, HTTPСервис)

	ЗаписьJSON.ЗаписатьИмяСвойства("tags");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	ЗаписьJSON.ЗаписатьЗначение(?(ЗначениеЗаполнено(HTTPСервис.Синоним),
		HTTPСервис.Синоним, HTTPСервис.Имя));
	ЗаписьJSON.ЗаписатьКонецМассива();

КонецПроцедуры

Процедура СоздатьОписаниеМетода(ЗаписьJSON, Описание, ШаблонURL, Метод)
	
	ОписаниеМетода = Swag_ОбработкаHTTP.ПолучитьЗначениеОписанияМетода(
		Описание, ШаблонURL.Имя + Метод.HTTPМетод, "Описание");

	Если ЗначениеЗаполнено(ОписаниеМетода) Тогда
		
		Если ТипЗнч(ОписаниеМетода) = Тип("Структура") Тогда
			
			Если ОписаниеМетода.Свойство("Описание") Тогда
				ЗаписьJSON.ЗаписатьИмяСвойства("summary");
				ЗаписьJSON.ЗаписатьЗначение(ОписаниеМетода.Описание);
			КонецЕсли;
			Если ОписаниеМетода.Свойство("ДетальноеОписание") Тогда
				ЗаписьJSON.ЗаписатьИмяСвойства("description");
				ЗаписьJSON.ЗаписатьЗначение(ОписаниеМетода.ДетальноеОписание);
			КонецЕсли;

		Иначе
			ЗаписьJSON.ЗаписатьИмяСвойства("summary");
			ЗаписьJSON.ЗаписатьЗначение(ОписаниеМетода);
		КонецЕсли;
		
	КонецЕсли;

	ЗаписьJSON.ЗаписатьИмяСвойства("parameters");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	ПараметрыМетода = Swag_ОбработкаHTTP.ПолучитьМассивЭлементовОписания(
		Описание, ШаблонURL.Имя + Метод.HTTPМетод, "Параметры");
	СоздатьОбъектыПараметров(ЗаписьJSON, ПараметрыМетода);
	ЗаписьJSON.ЗаписатьКонецМассива();
	
	//
	ОписаниеТелаЗапроса = Swag_ОбработкаHTTP.ПолучитьЗначениеОписанияМетода(
		Описание, ШаблонURL.Имя + Метод.HTTPМетод, "ТелоЗапроса");
	СоздатьТело(ЗаписьJSON, ОписаниеТелаЗапроса);
	
	//
	ОтветыМетода = Swag_ОбработкаHTTP.ПолучитьМассивЭлементовОписания(
		Описание, ШаблонURL.Имя + Метод.HTTPМетод, "Ответы");
	СоздатьОтветыМетода(ЗаписьJSON, ОтветыМетода);
	
	//
	СоздатьМассивДанныхОбАутентификации(ЗаписьJSON);
	
КонецПроцедуры

Процедура СоздатьОбъектыПараметров(ЗаписьJSON, ПараметрыМетода)
	
	Для каждого ПараметрМетода Из ПараметрыМетода Цикл
		
		ЗаписьJSON.ЗаписатьНачалоОбъекта(); // параметр
		
		ЗаписьJSON.ЗаписатьИмяСвойства("name");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.Имя);
		ЗаписьJSON.ЗаписатьИмяСвойства("description");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.Описание);
		ЗаписьJSON.ЗаписатьИмяСвойства("in");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.ТипПараметра);
		ЗаписьJSON.ЗаписатьИмяСвойства("required");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.Обязательный);
		ЗаписьJSON.ЗаписатьИмяСвойства("deprecated");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.Устарел);

		ЗаписьJSON.ЗаписатьИмяСвойства("schema");
		ЗаписьJSON.ЗаписатьНачалоОбъекта(); // schema
		
		ЗаписьJSON.ЗаписатьИмяСвойства("type");
		ЗаписьJSON.ЗаписатьЗначение(ПараметрМетода.ТипЗначения);
		
		Если ПараметрМетода.Свойство("Перечисление") И
			ТипЗнч(ПараметрМетода.Перечисление) = Тип("Массив") И
			(ПараметрМетода.ТипЗначения = Неопределено Или
			ПараметрМетода.ТипЗначения = "string" Или
			ПараметрМетода.ТипЗначения = "integer") Тогда
			
			СоздатьМассивПеречислений(ЗаписьJSON, ПараметрМетода.Перечисление)
		КонецЕсли;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта(); // schema

		ЗаписьJSON.ЗаписатьКонецОбъекта(); // параметр
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьТело(ЗаписьJSON, ТелоЗапроса)
	
	Если ЗначениеЗаполнено(ТелоЗапроса) Тогда
		ЗаписьJSON.ЗаписатьИмяСвойства("requestBody");
		ЗаписьJSON.ЗаписатьНачалоОбъекта(); // requestBody
		
		Если ТипЗнч(ТелоЗапроса.МассивТиповMIME) = Тип("Массив") И
			ТелоЗапроса.МассивТиповMIME.Количество() > 0 Тогда

			ЗаписьJSON.ЗаписатьИмяСвойства("content");
			ЗаписьJSON.ЗаписатьНачалоОбъекта(); // content
			
			Для каждого ТипMIME Из ТелоЗапроса.МассивТиповMIME Цикл
				
				ЗаписьJSON.ЗаписатьИмяСвойства(ТипMIME.Заголовок);
				ЗаписьJSON.ЗаписатьНачалоОбъекта(); // тип MIME
				
				ЗаписьJSON.ЗаписатьИмяСвойства("schema");
				ЗаписьJSON.ЗаписатьНачалоОбъекта(); // schema
				
				Если ЗначениеЗаполнено(ТипMIME.Тип) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("type");
					ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Тип);
					Если ТипMIME.Тип = "array" Тогда
						ЗаписьJSON.ЗаписатьИмяСвойства("items");
						ЗаписьJSON.ЗаписатьНачалоОбъекта(); // items
						
						ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
						ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Схема);
						
						ЗаписьJSON.ЗаписатьКонецОбъекта(); // items
					КонецЕсли;
				ИначеЕсли ЗначениеЗаполнено(ТипMIME.Схема) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
					ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Схема);
				КонецЕсли;
				
				ЗаписьJSON.ЗаписатьКонецОбъекта(); // schema
				
				ЗаписьJSON.ЗаписатьКонецОбъекта(); // тип MIME
				
			КонецЦикла;
			
			ЗаписьJSON.ЗаписатьКонецОбъекта(); // content
		КонецЕсли;
		
		ЗаписьJSON.ЗаписатьИмяСвойства("description");
		ЗаписьJSON.ЗаписатьЗначение(ТелоЗапроса.Описание);
		
		ЗаписьJSON.ЗаписатьКонецОбъекта(); // requestBody
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьОтветыМетода(ЗаписьJSON, ОтветыМетода)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("responses");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // responses
	
	Для каждого ОтветМетода Из ОтветыМетода Цикл
		
		ЗаписьJSON.ЗаписатьИмяСвойства(Строка(ОтветМетода.Код));
		ЗаписьJSON.ЗаписатьНачалоОбъекта(); // ответ
		
		ЗаписьJSON.ЗаписатьИмяСвойства("description");
		ЗаписьJSON.ЗаписатьЗначение(ОтветМетода.Описание);
		
		Если ТипЗнч(ОтветМетода.МассивТиповMIME) = Тип("Массив") И ОтветМетода.МассивТиповMIME.Количество() > 0 Тогда
			
			ЗаписьJSON.ЗаписатьИмяСвойства("content");
			ЗаписьJSON.ЗаписатьНачалоОбъекта(); // content
			
			Для каждого ТипMIME Из ОтветМетода.МассивТиповMIME Цикл
				
				ЗаписьJSON.ЗаписатьИмяСвойства(ТипMIME.Заголовок);
				ЗаписьJSON.ЗаписатьНачалоОбъекта(); // тип MIME
				
				ЗаписьJSON.ЗаписатьИмяСвойства("schema");
				ЗаписьJSON.ЗаписатьНачалоОбъекта(); // schema
				
				Если ЗначениеЗаполнено(ТипMIME.Тип) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("type");
					ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Тип);
					Если ТипMIME.Тип = "array" Тогда
						ЗаписьJSON.ЗаписатьИмяСвойства("items");
						ЗаписьJSON.ЗаписатьНачалоОбъекта(); // items
						
						ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
						ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Схема);
						
						ЗаписьJSON.ЗаписатьКонецОбъекта(); // items
					КонецЕсли;
				ИначеЕсли ЗначениеЗаполнено(ТипMIME.Схема) Тогда
					ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
					ЗаписьJSON.ЗаписатьЗначение(ТипMIME.Схема);
				КонецЕсли;
				
				ЗаписьJSON.ЗаписатьКонецОбъекта(); // schema
				
				ЗаписьJSON.ЗаписатьКонецОбъекта(); // тип MIME
				
			КонецЦикла;
			
			ЗаписьJSON.ЗаписатьКонецОбъекта(); // content
			
		КонецЕсли;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта(); // ответ
		
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // responses
	
КонецПроцедуры

Процедура СоздатьМассивДанныхОбАутентификации(ЗаписьJSON)

	ЗаписьJSON.ЗаписатьИмяСвойства("security");
	ЗаписьJSON.ЗаписатьНачалоМассива(); // security
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("basic");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	ЗаписьJSON.ЗаписатьКонецМассива();
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
	ЗаписьJSON.ЗаписатьКонецМассива(); // security

КонецПроцедуры

Процедура СоздатьКомпоненты(ЗаписьJSON, Объекты)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("components");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // components
	
	СоздатьСхемыОбъектов(ЗаписьJSON, Объекты);
	СоздатьСхемыАутентификации(ЗаписьJSON);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // components
	
КонецПроцедуры

Процедура СоздатьСхемыОбъектов(ЗаписьJSON, Объекты)
	
	Если ЗначениеЗаполнено(Объекты) И Объекты.Количество() > 0 Тогда
		
		ЗаписьJSON.ЗаписатьИмяСвойства("schemas");
		ЗаписьJSON.ЗаписатьНачалоОбъекта(); // schemas
		
		Для каждого ОбъектСервиса Из Объекты Цикл
			
			ЗаписьJSON.ЗаписатьИмяСвойства(ОбъектСервиса.Имя);
			ЗаписьJSON.ЗаписатьНачалоОбъекта(); // объект
			
			ЗаписьJSON.ЗаписатьИмяСвойства("type");
			ЗаписьJSON.ЗаписатьЗначение(ОбъектСервиса.Тип);
			
			Если ТипЗнч(ОбъектСервиса.МассивСвойств) = Тип("Массив") И ОбъектСервиса.МассивСвойств.Количество() > 0 Тогда
				ЗаписьJSON.ЗаписатьИмяСвойства("properties");
				ЗаписьJSON.ЗаписатьНачалоОбъекта(); // properties
				
				Для каждого СвойствоОбъекта Из ОбъектСервиса.МассивСвойств Цикл
					ЗаписьJSON.ЗаписатьИмяСвойства(СвойствоОбъекта.Имя);
					ЗаписьJSON.ЗаписатьНачалоОбъекта(); // свойство объекта
					
					ЗаписьJSON.ЗаписатьИмяСвойства("type");
					ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Тип);
					ЗаписьJSON.ЗаписатьИмяСвойства("description");
					ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Описание);
					
					Если СвойствоОбъекта.Свойство("Nullable") И
						СвойствоОбъекта.Nullable = Истина Тогда
						
						ЗаписьJSON.ЗаписатьИмяСвойства("nullable");
						ЗаписьJSON.ЗаписатьЗначение(Истина);
					КонецЕсли;
					
					Если СвойствоОбъекта.Свойство("Обязательный") И
						СвойствоОбъекта.Обязательный = Истина Тогда
						
						ЗаписьJSON.ЗаписатьИмяСвойства("require");
						ЗаписьJSON.ЗаписатьЗначение(Истина);
					КонецЕсли;
					
					Если СвойствоОбъекта.Свойство("Формат") И
						Не ПустаяСтрока(СвойствоОбъекта.Формат) Тогда
						
						ЗаписьJSON.ЗаписатьИмяСвойства("format");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Формат);
					КонецЕсли;
					
					Если СвойствоОбъекта.Свойство("Максимум") И
						ТипЗнч(СвойствоОбъекта.Максимум) = Тип("Число") Тогда
						
						ЗаписьJSON.ЗаписатьИмяСвойства("maximum");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Максимум);
					КонецЕсли;
					
					Если СвойствоОбъекта.Свойство("Минимум") И
						ТипЗнч(СвойствоОбъекта.Максимум) = Тип("Число") Тогда
						
						ЗаписьJSON.ЗаписатьИмяСвойства("minimum");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Минимум);
					КонецЕсли;
					
					Если СвойствоОбъекта.Тип = "array" Тогда
						ЗаписьJSON.ЗаписатьИмяСвойства("items");
						ЗаписьJSON.ЗаписатьНачалоОбъекта();
						ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Схема);
						ЗаписьJSON.ЗаписатьКонецОбъекта();
					ИначеЕсли СвойствоОбъекта.Тип = "object" Тогда
						ЗаписьJSON.ЗаписатьИмяСвойства("$ref");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Схема);
					ИначеЕсли ЗначениеЗаполнено(СвойствоОбъекта.Пример) Тогда
						ЗаписьJSON.ЗаписатьИмяСвойства("example");
						ЗаписьJSON.ЗаписатьЗначение(СвойствоОбъекта.Пример);
					КонецЕсли;
					
					Если СвойствоОбъекта.Свойство("Перечисление") И
						ТипЗнч(СвойствоОбъекта.Перечисление) = Тип("Массив") И
						(СвойствоОбъекта.Тип = Неопределено Или
						СвойствоОбъекта.Тип = "string" Или
						СвойствоОбъекта.Тип = "integer") Тогда
						
						СоздатьМассивПеречислений(ЗаписьJSON, СвойствоОбъекта.Перечисление)
					КонецЕсли;
					
					ЗаписьJSON.ЗаписатьКонецОбъекта(); // свойство объекта
				КонецЦикла;
				
				ЗаписьJSON.ЗаписатьКонецОбъекта(); // properties
			КонецЕсли;
			
			ЗаписьJSON.ЗаписатьКонецОбъекта(); // объект
			
		КонецЦикла;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта(); // schemas
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьСхемыАутентификации(ЗаписьJSON)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("securitySchemes");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // securitySchemes
	
	ЗаписьJSON.ЗаписатьИмяСвойства("basic");
	ЗаписьJSON.ЗаписатьНачалоОбъекта(); // basic
	
	ЗаписьJSON.ЗаписатьИмяСвойства("type");
	ЗаписьJSON.ЗаписатьЗначение("http");
	ЗаписьJSON.ЗаписатьИмяСвойства("scheme");
	ЗаписьJSON.ЗаписатьЗначение("basic");
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // basic
	
	ЗаписьJSON.ЗаписатьКонецОбъекта(); // securitySchemes
	
КонецПроцедуры

Процедура СоздатьМассивПеречислений(ЗаписьJSON, Перечисления, Nullable = Ложь)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("enum");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	Для каждого ЭлементПеречисления Из Перечисления Цикл
		ЗаписьJSON.ЗаписатьЗначение(ЭлементПеречисления);
	КонецЦикла;
	
	Если Nullable Тогда
		ЗаписьJSON.ЗаписатьЗначение(Null);
	КонецЕсли;
	
	ЗаписьJSON.ЗаписатьКонецМассива();
	
КонецПроцедуры

Процедура СоздатьОписанияТегов(ЗаписьJSON, Теги)
	
	ЗаписьJSON.ЗаписатьИмяСвойства("tags");
	ЗаписьJSON.ЗаписатьНачалоМассива(); // tags
	
	Для каждого Тег Из Теги Цикл
		
		ЗаписьJSON.ЗаписатьНачалоОбъекта();
		
		ЗаписьJSON.ЗаписатьИмяСвойства("name");
		ЗаписьJSON.ЗаписатьЗначение(Тег.Имя);

		ЗаписьJSON.ЗаписатьИмяСвойства("description");
		ЗаписьJSON.ЗаписатьЗначение(Тег.Описание);
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		
	КонецЦикла;

	ЗаписьJSON.ЗаписатьКонецМассива(); // tags
	
КонецПроцедуры

#КонецОбласти
