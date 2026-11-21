
-- Лабораторная работа №4: Программная реализация БД на SQL
-- Тема: Учёт заявок на техническое обслуживание и ремонт оборудования
-- Автор: Мкртчян Карен
-- СУБД: MariaDB / MySQL
-- Имя базы данных: service_desk_laba5

-- 1. Создание базы данных
DROP DATABASE IF EXISTS service_desk_laba5;
CREATE DATABASE service_desk_laba5 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE service_desk_laba5;

-- ЧАСТЬ 1. Создание структуры БД

-- Создание таблиц (с ограничениями CHECK согласно заданию)
CREATE TABLE sections (
    section_id VARCHAR(5) NOT NULL,
    name VARCHAR(100) NOT NULL,
    report_line VARCHAR(4) NOT NULL,
    CONSTRAINT pk_sections PRIMARY KEY (section_id),
    CONSTRAINT chk_sections_id CHECK (section_id IN ('АПП','ПРОГ','СЕТЬ','ПЕРИФ','КОНС'))
);

CREATE TABLE request_types (
    request_type_id VARCHAR(1) NOT NULL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT pk_request_types PRIMARY KEY (request_type_id),
    CONSTRAINT chk_request_types_id CHECK (request_type_id IN ('П','Э'))
);

CREATE TABLE employees (
    employee_id VARCHAR(6) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (employee_id)
);

CREATE TABLE work_types (
    work_type_id VARCHAR(7) NOT NULL,
    name VARCHAR(100) NOT NULL,
    section_id VARCHAR(5) NOT NULL,
    CONSTRAINT pk_work_types PRIMARY KEY (work_type_id),
    CONSTRAINT fk_work_types_sections FOREIGN KEY (section_id) REFERENCES sections(section_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE records (
    work_type_id VARCHAR(7) NOT NULL,
    report_month DATE NOT NULL,
    request_type_id VARCHAR(1) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    employee_id VARCHAR(6) NOT NULL,
    CONSTRAINT pk_records PRIMARY KEY (work_type_id, report_month, request_type_id),
    CONSTRAINT chk_records_quantity CHECK (quantity >= 0),
    CONSTRAINT fk_records_work_types FOREIGN KEY (work_type_id) REFERENCES work_types(work_type_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_records_request_types FOREIGN KEY (request_type_id) REFERENCES request_types(request_type_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_records_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Изменение структуры таблиц (ALTER TABLE) - требование лабораторной
-- Пример 1: Добавление поля (например, для будущего расширения)
ALTER TABLE employees ADD COLUMN phone VARCHAR(20) NULL;
-- Пример 2: Удаление добавленного поля (откат)
ALTER TABLE employees DROP COLUMN phone;

-- Вставка записей (INSERT INTO)
INSERT INTO sections (section_id, name, report_line) VALUES
('АПП', 'Аппаратное обеспечение', '1.1'),
('ПРОГ', 'Программное обеспечение', '1.2'),
('СЕТЬ', 'Сетевая инфраструктура', '1.3'),
('ПЕРИФ', 'Периферийное оборудование', '1.4'),
('КОНС', 'Консультации пользователей', '1.5');

INSERT INTO request_types (request_type_id, name) VALUES
('П', 'Плановая'), ('Э', 'Экстренная');

INSERT INTO employees (employee_id, full_name, position) VALUES
('000201', 'Сидоров И.И.', 'Инженер'),
('000202', 'Кузнецов П.С.', 'Ведущий инженер'),
('000203', 'Морозов А.В.', 'Инженер'),
('000204', 'Волкова Е.С.', 'Ведущий инженер'),
('000205', 'Новиков Д.К.', 'Инженер');

INSERT INTO work_types (work_type_id, name, section_id) VALUES
('АПП-01', 'Замена HDD', 'АПП'),
('АПП-02', 'Замена БП', 'АПП'),
('ПРОГ-01', 'Установка ОС', 'ПРОГ'),
('ПРОГ-02', 'Обновление антивируса', 'ПРОГ'),
('СЕТЬ-01', 'Настройка сетевого принтера', 'СЕТЬ'),
('ПЕРИФ-01', 'Замена картриджа', 'ПЕРИФ'),
('КОНС-01', 'Консультация по ПО', 'КОНС');

INSERT INTO records (work_type_id, report_month, request_type_id, quantity, employee_id) VALUES
('АПП-01', '2025-11-01', 'П', 120, '000201'),
('АПП-01', '2025-11-01', 'Э', 85, '000201'),
('АПП-01', '2025-12-01', 'П', 135, '000201'),
('АПП-01', '2025-12-01', 'Э', 92, '000201'),
('АПП-02', '2025-12-01', 'П', 45, '000201'),
('АПП-02', '2025-12-01', 'Э', 30, '000201'),
('ПРОГ-01', '2025-12-01', 'П', 310, '000202'),
('ПРОГ-01', '2025-12-01', 'Э', 180, '000202'),
('ПРОГ-02', '2025-12-01', 'П', 220, '000202'),
('СЕТЬ-01', '2025-12-01', 'П', 95, '000203'),
('СЕТЬ-01', '2025-12-01', 'Э', 60, '000203'),
('ПЕРИФ-01', '2025-12-01', 'П', 150, '000204'),
('ПЕРИФ-01', '2025-12-01', 'Э', 45, '000204'),
('КОНС-01', '2025-12-01', 'П', 450, '000202'),
('КОНС-01', '2025-12-01', 'Э', 35, '000205');

-- Обновление и удаление записей (UPDATE / DELETE) - требование лабораторной
-- Пример UPDATE: Исправление должности (устранение аномалии изменения)
UPDATE employees SET position = 'Старший инженер' WHERE employee_id = '000202';

-- Пример UPDATE: Корректировка данных (+5% к плановым заявкам ПРОГ)
UPDATE records r JOIN work_types wt ON r.work_type_id = wt.work_type_id
SET r.quantity = ROUND(r.quantity * 1.05)
WHERE wt.section_id = 'ПРОГ' AND r.report_month = '2025-12-01' AND r.request_type_id = 'П';

-- Пример DELETE: Удаление ошибочной записи
DELETE FROM records WHERE work_type_id = 'АПП-02' AND report_month = '2025-12-01' AND request_type_id = 'Э';
-- (Для сохранения контрольного примера из ЛР №3 восстановим её)
INSERT INTO records (work_type_id, report_month, request_type_id, quantity, employee_id) VALUES ('АПП-02', '2025-12-01', 'Э', 30, '000201');

-- Создание пользователей и наделение правами (CREATE USER / GRANT)
CREATE USER IF NOT EXISTS 'engineer'@'localhost' IDENTIFIED BY 'eng_pass';
CREATE USER IF NOT EXISTS 'head_of_it'@'localhost' IDENTIFIED BY 'head_pass';
CREATE USER IF NOT EXISTS 'analyst'@'localhost' IDENTIFIED BY 'anl_pass';

-- ✅ ИСПРАВЛЕНО: везде используется service_desk_laba5 вместо service_desk
GRANT SELECT ON service_desk_laba5.work_types TO 'engineer'@'localhost';
GRANT SELECT, INSERT, UPDATE ON service_desk_laba5.records TO 'engineer'@'localhost';

GRANT SELECT ON service_desk_laba5.* TO 'head_of_it'@'localhost';
GRANT INSERT, UPDATE, DELETE ON service_desk_laba5.sections TO 'head_of_it'@'localhost';
GRANT INSERT, UPDATE, DELETE ON service_desk_laba5.work_types TO 'head_of_it'@'localhost';

GRANT SELECT ON service_desk_laba5.records TO 'analyst'@'localhost';
GRANT SELECT ON service_desk_laba5.work_types TO 'analyst'@'localhost';
GRANT SELECT ON service_desk_laba5.sections TO 'analyst'@'localhost';

FLUSH PRIVILEGES;

-- Выгрузка метаданных (DESCRIBE)
-- Преподаватель может выполнить эти команды для проверки структуры:
DESCRIBE sections;
DESCRIBE work_types;
DESCRIBE request_types;
DESCRIBE employees;
DESCRIBE records;

-- ЧАСТЬ 2. Запросы на выборку (SELECT)

-- 1. Неявное соединение с фильтром (WHERE) и сортировкой (ORDER BY)
SELECT s.name AS 'Раздел', wt.name AS 'Тип работ', r.quantity AS 'Кол-во', e.full_name AS 'Сотрудник'
FROM sections s, work_types wt, records r, employees e
WHERE s.section_id = wt.section_id AND wt.work_type_id = r.work_type_id 
  AND r.employee_id = e.employee_id AND r.report_month = '2025-12-01' AND r.request_type_id = 'П'
ORDER BY s.report_line, wt.work_type_id;

-- 2. Явное соединение таблиц (JOIN)
SELECT s.report_line AS 'Строка', s.name AS 'Раздел',
       SUM(CASE WHEN rt.request_type_id='П' THEN r.quantity ELSE 0 END) AS 'Плановые',
       SUM(CASE WHEN rt.request_type_id='Э' THEN r.quantity ELSE 0 END) AS 'Экстренные',
       SUM(r.quantity) AS 'Всего'
FROM records r
JOIN work_types wt ON r.work_type_id = wt.work_type_id
JOIN sections s ON wt.section_id = s.section_id
JOIN request_types rt ON r.request_type_id = rt.request_type_id
WHERE r.report_month = '2025-12-01'
GROUP BY s.report_line, s.name
ORDER BY s.report_line;

-- 3. Агрегирующие операции (SUM, AVG, COUNT, MAX, MIN)
SELECT SUM(r.quantity) AS 'Всего заявок',
       SUM(CASE WHEN rt.name='Плановая' THEN r.quantity ELSE 0 END) AS 'Плановых',
       ROUND(AVG(r.quantity), 2) AS 'Среднее',
       MAX(r.quantity) AS 'Макс', MIN(r.quantity) AS 'Мин'
FROM records r JOIN request_types rt ON r.request_type_id = rt.request_type_id;

-- 4. Группировка (GROUP BY) и фильтрация групп (HAVING)
SELECT wt.work_type_id AS 'Код', wt.name AS 'Тип работ', SUM(r.quantity) AS 'Всего заявок'
FROM records r JOIN work_types wt ON r.work_type_id = wt.work_type_id
WHERE r.report_month = '2025-12-01'
GROUP BY wt.work_type_id, wt.name
HAVING SUM(r.quantity) > 200
ORDER BY SUM(r.quantity) DESC;

-- 5. Вложенные подзапросы с оператором IN
-- Задача: Найти всех сотрудников, которые вносили данные по работам раздела 'ПРОГ'
SELECT DISTINCT e.full_name AS 'Сотрудник', e.position AS 'Должность'
FROM employees e
WHERE e.employee_id IN (
    SELECT r.employee_id 
    FROM records r
    JOIN work_types wt ON r.work_type_id = wt.work_type_id
    WHERE wt.section_id = 'ПРОГ'
);

-- 6. Вложенный подзапрос с оператором ALL
-- Задача: Найти типы работ, количество заявок по которым за декабрь 2025 превышает МАКСИМАЛЬНОЕ количество заявок любого другого типа работ в ноябре 2025
SELECT wt.name AS 'Тип работ', r.quantity AS 'Количество (Дек)'
FROM records r
JOIN work_types wt ON r.work_type_id = wt.work_type_id
WHERE r.report_month = '2025-12-01'
  AND r.quantity > ALL (
      SELECT quantity 
      FROM records 
      WHERE report_month = '2025-11-01'
  );

-- 7. Функции управления потоком (CASE)
-- Задача: Присвоить статус нагрузке сотрудника на основе общего количества обработанных заявок
SELECT e.full_name AS 'Сотрудник',
       SUM(r.quantity) AS 'Всего заявок',
       CASE 
           WHEN SUM(r.quantity) > 500 THEN 'Высокая нагрузка'
           WHEN SUM(r.quantity) BETWEEN 200 AND 500 THEN 'Средняя нагрузка'
           ELSE 'Низкая нагрузка'
       END AS 'Статус нагрузки'
FROM employees e
JOIN records r ON e.employee_id = r.employee_id
GROUP BY e.employee_id, e.full_name;

-- 8. Создание постоянного представления (VIEW)
-- Задача: Создать представление для быстрого доступа к месячной сводке по разделам (самый популярный запрос из ЛР №1)
CREATE VIEW IF NOT EXISTS view_monthly_summary AS
SELECT s.report_line AS 'Строка', 
       s.name AS 'Раздел',
       SUM(CASE WHEN rt.request_type_id='П' THEN r.quantity ELSE 0 END) AS 'Плановые',
       SUM(CASE WHEN rt.request_type_id='Э' THEN r.quantity ELSE 0 END) AS 'Экстренные',
       SUM(r.quantity) AS 'Всего'
FROM records r
JOIN work_types wt ON r.work_type_id = wt.work_type_id
JOIN sections s ON wt.section_id = s.section_id
JOIN request_types rt ON r.request_type_id = rt.request_type_id
GROUP BY s.report_line, s.name;

-- Проверка работы представления
SELECT * FROM view_monthly_summary WHERE `Строка` = '1.2'; -- Смотрим только Программное обеспечение

-- 9. Временное представление с использованием WITH (Common Table Expression - CTE)
-- Задача: Найти средний объем заявок по каждому разделу и сравнить его с общим средним по отделу
WITH SectionStats AS (
    SELECT s.name AS 'Раздел', AVG(r.quantity) AS 'AvgQty'
    FROM records r
    JOIN work_types wt ON r.work_type_id = wt.work_type_id
    JOIN sections s ON wt.section_id = s.section_id
    GROUP BY s.name
),
GlobalAvg AS (
    SELECT AVG(quantity) AS 'TotalAvg' FROM records
)
SELECT ss.'Раздел', ss.'AvgQty', ga.'TotalAvg',
       CASE WHEN ss.'AvgQty' > ga.'TotalAvg' THEN 'Выше среднего' ELSE 'Ниже среднего' END AS 'Сравнение'
FROM SectionStats ss, GlobalAvg ga;

-- 10. Анализ и оптимизация запросов (EXPLAIN и CREATE INDEX)
-- Сначала посмотрим план выполнения запроса без индекса
EXPLAIN SELECT * FROM records WHERE employee_id = '000202';

-- Создаем индекс для ускорения поиска по сотруднику
CREATE INDEX idx_records_employee ON records(employee_id);

-- Создаем индекс для ускорения поиска по дате отчета
CREATE INDEX idx_records_month ON records(report_month);

-- Смотрим план выполнения после создания индексов (должен появиться тип 'ref' или 'range' вместо 'ALL')
EXPLAIN SELECT * FROM records WHERE employee_id = '000202' AND report_month = '2025-12-01';

-- 11. Механизм транзакций (START TRANSACTION)
-- Задача: Безопасно перенести данные сотрудника (например, при ошибке ввода)
START TRANSACTION;

-- Шаг 1: Удаляем ошибочную запись
DELETE FROM records 
WHERE work_type_id = 'АПП-01' AND report_month = '2025-12-01' AND request_type_id = 'П' AND employee_id = '000201';

-- Шаг 2: Проверяем, что удалили (внутри транзакции видим изменения)
SELECT COUNT(*) AS 'Остаток после удаления' FROM records WHERE work_type_id = 'АПП-01' AND report_month = '2025-12-01' AND request_type_id = 'П';

-- Если всё верно, подтверждаем изменения
COMMIT; 
-- Если бы была ошибка, мы бы написали ROLLBACK;

-- 12. Подготовленный запрос (PREPARE, EXECUTE, DEALLOCATE)
-- Задача: Динамический поиск заявок по типу работ
PREPARE stmt_get_work_stats FROM 'SELECT wt.name, SUM(r.quantity) as Total FROM records r JOIN work_types wt ON r.work_type_id = wt.work_type_id WHERE wt.work_type_id = ? GROUP BY wt.name';

-- Устанавливаем переменную с нужным кодом
SET @work_code = 'КОНС-01';

-- Выполняем запрос
EXECUTE stmt_get_work_stats USING @work_code;

-- Освобождаем память
DEALLOCATE PREPARE stmt_get_work_stats;