﻿Функция ПолучитьОписаниеHTTPСервиса() Экспорт
	
	Описание = Новый Массив;
	
	// ХранилищеИИдентификаторGET
	ХранилищеИИдентификаторGETПараметры = Новый Массив;
	ХранилищеИИдентификаторGETПараметры.Добавить(Swag_ФормированиеОписаний.ОписаниеПараметра("Storage", "Наименование логического хранилища", "path", Истина));
	ХранилищеИИдентификаторGETПараметры.Добавить(Swag_ФормированиеОписаний.ОписаниеПараметра("ID", "Идентификатор данных в логическом хранилище", "path", Истина));
	
	ХранилищеИИдентификаторGETОтветы = Новый Массив;
	ХранилищеИИдентификаторGETОтветы.Добавить(Swag_ФормированиеОписаний.ОписаниеОтвета(404, "Not found"));
	
	Описание.Добавить(Swag_ФормированиеОписаний.ОписаниеМетода("ХранилищеИИдентификаторGET", "Получение данных из логического хранилища", ХранилищеИИдентификаторGETПараметры, ХранилищеИИдентификаторGETОтветы));
	
	// ХранилищеИИдентификаторPOST
	ХранилищеИИдентификаторPOSTПараметры = Новый Массив;
	
	
	ХранилищеИИдентификаторPOSTОтветы = Новый Массив;
	
	
	Возврат Описание;
	
КонецФункции