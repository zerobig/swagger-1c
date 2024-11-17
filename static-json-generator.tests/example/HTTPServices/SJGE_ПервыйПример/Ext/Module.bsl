
#Область ОписанияТегов

// @swagger
// tags:
//   name: Example1
//   description: Примеры использования описания swagger

// @swagger
// tags:
//   - name: Tests1
//     description: Тестовые методы
//   - name: User1
//     description: Методы для управления пользователями

#КонецОбласти

#Область ОписанияОбъектов

// @swagger
// components:
//   ResponseObject1:
//     required:
//       - param1
//       - param2
//     properties:
//       param1:
//         type: string
//       param2:
//         type: string
//       param3:
//         type: string

#КонецОбласти

#Область Методы

// @swagger
// /first_example/first_template
//   get:
//     description: Получение данных
//     tags: [Example1, Tests1]
//     produces:
//       - application/json
//     parameters:
//       - name: param1
//         description: Входящий параметр
//         in: formData
//         required: true
//         type: string
//     responses:
//       200:
//         description: Возвращает очень интересный ответ
//         schema:
//           type: object
//           $ref: '#/components/ResponseObject1'
//
 Функция ПервыйШаблонGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

// @swagger
// /first_example/first_template
//   post:
//     description: Отправка данных
//     responses:
//       200:
//         description: Возвращает статус помещения данных в БД
//
Функция ПервыйШаблонPOST(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

Функция ВторойШаблонGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

#КонецОбласти
