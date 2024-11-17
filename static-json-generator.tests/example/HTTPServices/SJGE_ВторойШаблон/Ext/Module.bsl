// @swagger
// tags:
//   name: Example2
//   description: Примеры использования описания swagger
// tags:
//   - name: Tests2
//     description: Тестовые методы
//   - name: User2
//     description: Методы для управления пользователями
// components:
//   ResponseObject2:
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
// /second_example/first_template
//   get:
//     description: Получение данных
//     tags: [Example2, Tests2]
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
//           $ref: '#/components/ResponseObject2'
//
Функция ПервыйШаблонGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции
