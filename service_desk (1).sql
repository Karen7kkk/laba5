-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Ноя 14 2026 г., 09:39
-- Версия сервера: 10.4.28-MariaDB
-- Версия PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `service_desk`
--

-- --------------------------------------------------------

--
-- Структура таблицы `employees`
--

CREATE TABLE `employees` (
  `employee_id` varchar(6) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `position` varchar(50) NOT NULL
) ;

--
-- Дамп данных таблицы `employees`
--

INSERT INTO `employees` (`employee_id`, `full_name`, `position`) VALUES
('000201', 'Сидоров И.И.', 'Инженер'),
('000202', 'Кузнецов П.С.', 'Старший инженер'),
('000203', 'Морозов А.В.', 'Инженер'),
('000204', 'Волкова Е.С.', 'Ведущий инженер'),
('000205', 'Новиков Д.К.', 'Инженер');

-- --------------------------------------------------------

--
-- Структура таблицы `records`
--

CREATE TABLE `records` (
  `work_type_id` varchar(7) NOT NULL,
  `report_month` date NOT NULL,
  `request_type_id` varchar(1) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `employee_id` varchar(6) NOT NULL
) ;

--
-- Дамп данных таблицы `records`
--

INSERT INTO `records` (`work_type_id`, `report_month`, `request_type_id`, `quantity`, `employee_id`) VALUES
('АПП-01', '2025-11-01', 'П', 120, '000201'),
('АПП-01', '2025-11-01', 'Э', 85, '000201'),
('АПП-01', '2025-12-01', 'П', 140, '000201'),
('АПП-01', '2025-12-01', 'Э', 92, '000201'),
('АПП-02', '2025-12-01', 'П', 45, '000201'),
('АПП-02', '2025-12-01', 'Э', 30, '000201'),
('КОНС-01', '2025-12-01', 'П', 450, '000202'),
('КОНС-01', '2025-12-01', 'Э', 35, '000205'),
('ПЕРИФ-0', '2025-12-01', 'П', 150, '000204'),
('ПЕРИФ-0', '2025-12-01', 'Э', 45, '000204'),
('ПРОГ-01', '2025-12-01', 'П', 326, '000202'),
('ПРОГ-01', '2025-12-01', 'Э', 180, '000202'),
('ПРОГ-02', '2025-12-01', 'П', 231, '000202'),
('СЕТЬ-01', '2025-12-01', 'П', 95, '000203'),
('СЕТЬ-01', '2025-12-01', 'Э', 60, '000203');

-- --------------------------------------------------------

--
-- Структура таблицы `request_types`
--

CREATE TABLE `request_types` (
  `request_type_id` varchar(1) NOT NULL,
  `name` varchar(20) NOT NULL
) ;

--
-- Дамп данных таблицы `request_types`
--

INSERT INTO `request_types` (`request_type_id`, `name`) VALUES
('П', 'Плановая'),
('Э', 'Экстренная');

-- --------------------------------------------------------

--
-- Структура таблицы `sections`
--

CREATE TABLE `sections` (
  `section_id` varchar(5) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Название раздела IT-услуг',
  `report_line` varchar(4) NOT NULL
) ;

--
-- Дамп данных таблицы `sections`
--

INSERT INTO `sections` (`section_id`, `name`, `report_line`) VALUES
('АПП', 'Аппаратное обеспечение', '1.1'),
('КОНС', 'Консультации пользователей', '1.5'),
('ПЕРИФ', 'Периферийное оборудование', '1.4'),
('ПРОГ', 'Программное обеспечение', '1.2'),
('СЕТЬ', 'Сетевая инфраструктура', '1.3');

-- --------------------------------------------------------

--
-- Структура таблицы `work_types`
--

CREATE TABLE `work_types` (
  `work_type_id` varchar(7) NOT NULL,
  `name` varchar(100) NOT NULL,
  `section_id` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `work_types`
--

INSERT INTO `work_types` (`work_type_id`, `name`, `section_id`) VALUES
('АПП-01', 'Замена HDD', 'АПП'),
('АПП-02', 'Замена БП', 'АПП'),
('КОНС-01', 'Консультация по ПО', 'КОНС'),
('ПЕРИФ-0', 'Замена картриджа', 'ПЕРИФ'),
('ПРОГ-01', 'Установка ОС', 'ПРОГ'),
('ПРОГ-02', 'Обновление антивируса', 'ПРОГ'),
('СЕТЬ-01', 'Настройка сетевого принтера', 'СЕТЬ');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`);

--
-- Индексы таблицы `records`
--
ALTER TABLE `records`
  ADD PRIMARY KEY (`work_type_id`,`report_month`,`request_type_id`),
  ADD KEY `fk_records_request_types` (`request_type_id`),
  ADD KEY `fk_records_employees` (`employee_id`);

--
-- Индексы таблицы `request_types`
--
ALTER TABLE `request_types`
  ADD PRIMARY KEY (`request_type_id`),
  ADD UNIQUE KEY `uq_request_types_name` (`name`);

--
-- Индексы таблицы `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`section_id`),
  ADD UNIQUE KEY `uq_sections_name` (`name`);

--
-- Индексы таблицы `work_types`
--
ALTER TABLE `work_types`
  ADD PRIMARY KEY (`work_type_id`),
  ADD KEY `fk_work_types_sections` (`section_id`);

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `records`
--
ALTER TABLE `records`
  ADD CONSTRAINT `fk_records_employees` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_records_request_types` FOREIGN KEY (`request_type_id`) REFERENCES `request_types` (`request_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_records_work_types` FOREIGN KEY (`work_type_id`) REFERENCES `work_types` (`work_type_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `work_types`
--
ALTER TABLE `work_types`
  ADD CONSTRAINT `fk_work_types_sections` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
