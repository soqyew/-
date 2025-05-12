-- Создаем базу данных PetShopNetwork
USE master;
GO
DROP DATABASE IF EXISTS PetShopNetwork;
GO
CREATE DATABASE PetShopNetwork;
GO
USE PetShopNetwork;
GO

-- 1. Создаем три таблицы узлов
CREATE TABLE Animal (
    id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    age INT,
    price DECIMAL(10,2)
) AS NODE;

CREATE TABLE Species (
    id INT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    habitat NVARCHAR(50)
) AS NODE;

CREATE TABLE Supplier (
    id INT PRIMARY KEY,
    company_name NVARCHAR(100) NOT NULL,
    rating DECIMAL(3,1)
) AS NODE;

-- 2. Создаем три таблицы ребер
CREATE TABLE BelongsToSpecies AS EDGE;    -- Животное принадлежит виду
CREATE TABLE SuppliedBy AS EDGE;         -- Поставщик поставляет животное
CREATE TABLE CareRecommendation AS EDGE; -- Рекомендации по уходу между видами

-- Добавляем ограничения соединения
ALTER TABLE BelongsToSpecies 
ADD CONSTRAINT EC_BelongsToSpecies CONNECTION (Animal TO Species);

ALTER TABLE SuppliedBy 
ADD CONSTRAINT EC_SuppliedBy CONNECTION (Supplier TO Animal);

ALTER TABLE CareRecommendation 
ADD CONSTRAINT EC_CareRecommendation CONNECTION (Species TO Species);
GO

-- 3. Заполняем таблицы узлов
-- Животные
INSERT INTO Animal (id, name, age, price) VALUES
(1, N'Барсик', 2, 150.00),
(2, N'Шарик', 3, 200.00),
(3, N'Кеша', 1, 100.00),
(4, N'Голди', 4, 300.00),
(5, N'Снежок', 2, 250.00),
(6, N'Рекс', 5, 400.00),
(7, N'Мурка', 1, 120.00),
(8, N'Чарли', 2, 180.00),
(9, N'Зевс', 3, 350.00),
(10, N'Люси', 4, 280.00);

-- Виды животных
INSERT INTO Species (id, name, habitat) VALUES
(1, N'Кошка', N'Домашняя'),
(2, N'Собака', N'Домашняя'),
(3, N'Попугай', N'Тропики'),
(4, N'Рыбка', N'Аквариум'),
(5, N'Хомяк', N'Клетка'),
(6, N'Черепаха', N'Террариум'),
(7, N'Кролик', N'Клетка'),
(8, N'Змея', N'Террариум'),
(9, N'Паук', N'Террариум'),
(10, N'Канарейка', N'Клетка');

-- Поставщики
INSERT INTO Supplier (id, company_name, rating) VALUES
(1, N'ЗооМир', 9.2),
(2, N'Питомец.ру', 8.8),
(3, N'ЭкзоПлюс', 9.0),
(4, N'АкваЛайф', 8.5),
(5, N'Фауна', 9.1),
(6, N'Друг', 8.7),
(7, N'ЭнималКейс', 8.9),
(8, N'ПтичийДвор', 8.6),
(9, N'РептилияХаб', 9.3),
(10, N'ГрызунХаус', 8.4);
-- 4. Создаем связи через таблицы ребер

-- Принадлежность животных к видам
INSERT INTO BelongsToSpecies ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Animal WHERE id = 1), (SELECT $node_id FROM Species WHERE id = 1)),  -- Барсик -> Кошка
((SELECT $node_id FROM Animal WHERE id = 2), (SELECT $node_id FROM Species WHERE id = 2)),  -- Шарик -> Собака
((SELECT $node_id FROM Animal WHERE id = 3), (SELECT $node_id FROM Species WHERE id = 3)),  -- Кеша -> Попугай
((SELECT $node_id FROM Animal WHERE id = 4), (SELECT $node_id FROM Species WHERE id = 4)),  -- Голди -> Рыбка
((SELECT $node_id FROM Animal WHERE id = 5), (SELECT $node_id FROM Species WHERE id = 5)),  -- Снежок -> Хомяк
((SELECT $node_id FROM Animal WHERE id = 6), (SELECT $node_id FROM Species WHERE id = 2)),  -- Рекс -> Собака
((SELECT $node_id FROM Animal WHERE id = 7), (SELECT $node_id FROM Species WHERE id = 1)),  -- Мурка -> Кошка
((SELECT $node_id FROM Animal WHERE id = 8), (SELECT $node_id FROM Species WHERE id = 7)),  -- Чарли -> Кролик
((SELECT $node_id FROM Animal WHERE id = 9), (SELECT $node_id FROM Species WHERE id = 8)),  -- Зевс -> Змея
((SELECT $node_id FROM Animal WHERE id = 10), (SELECT $node_id FROM Species WHERE id = 6)); -- Люси -> Черепаха

-- Связи поставщиков с животными
INSERT INTO SuppliedBy ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Supplier WHERE id = 1), (SELECT $node_id FROM Animal WHERE id = 1)),  -- ЗооМир -> Барсик
((SELECT $node_id FROM Supplier WHERE id = 2), (SELECT $node_id FROM Animal WHERE id = 2)),  -- Питомец.ру -> Шарик
((SELECT $node_id FROM Supplier WHERE id = 3), (SELECT $node_id FROM Animal WHERE id = 3)),  -- ЭкзоПлюс -> Кеша
((SELECT $node_id FROM Supplier WHERE id = 4), (SELECT $node_id FROM Animal WHERE id = 4)),  -- АкваЛайф -> Голди
((SELECT $node_id FROM Supplier WHERE id = 5), (SELECT $node_id FROM Animal WHERE id = 5)),  -- Фауна -> Снежок
((SELECT $node_id FROM Supplier WHERE id = 6), (SELECT $node_id FROM Animal WHERE id = 6)),  -- Друг -> Рекс
((SELECT $node_id FROM Supplier WHERE id = 7), (SELECT $node_id FROM Animal WHERE id = 7)),  -- ЭнималКейс -> Мурка
((SELECT $node_id FROM Supplier WHERE id = 8), (SELECT $node_id FROM Animal WHERE id = 8)),  -- ПтичийДвор -> Чарли
((SELECT $node_id FROM Supplier WHERE id = 9), (SELECT $node_id FROM Animal WHERE id = 9)),  -- РептилияХаб -> Зевс
((SELECT $node_id FROM Supplier WHERE id = 10), (SELECT $node_id FROM Animal WHERE id = 10)); -- ГрызунХаус -> Люси

-- Добавляем дополнительные связи между видами для сложных запросов
INSERT INTO CareRecommendation ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Species WHERE id = 1), (SELECT $node_id FROM Species WHERE id = 2)),  -- Кошка -> Собака
((SELECT $node_id FROM Species WHERE id = 2), (SELECT $node_id FROM Species WHERE id = 5)),  -- Собака -> Хомяк
((SELECT $node_id FROM Species WHERE id = 5), (SELECT $node_id FROM Species WHERE id = 7)),  -- Хомяк -> Кролик
((SELECT $node_id FROM Species WHERE id = 7), (SELECT $node_id FROM Species WHERE id = 6)),  -- Кролик -> Черепаха
((SELECT $node_id FROM Species WHERE id = 6), (SELECT $node_id FROM Species WHERE id = 8)),  -- Черепаха -> Змея
((SELECT $node_id FROM Species WHERE id = 8), (SELECT $node_id FROM Species WHERE id = 9)),  -- Змея -> Паук
((SELECT $node_id FROM Species WHERE id = 9), (SELECT $node_id FROM Species WHERE id = 10)), -- Паук -> Канарейка
((SELECT $node_id FROM Species WHERE id = 10), (SELECT $node_id FROM Species WHERE id = 3)), -- Канарейка -> Попугай
((SELECT $node_id FROM Species WHERE id = 3), (SELECT $node_id FROM Species WHERE id = 4)),  -- Попугай -> Рыбка
((SELECT $node_id FROM Species WHERE id = 4), (SELECT $node_id FROM Species WHERE id = 1)); -- Рыбка -> Кошка

-- 5.1. Найти всех животных вида "Кошка"
SELECT a.name AS AnimalName, s.name AS SpeciesName
FROM Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(a-(bs)->s)
AND s.name = N'Кошка';

-- 5.2. Найти поставщиков, которые поставляют собак
SELECT sup.company_name AS SupplierName, a.name AS AnimalName
FROM Supplier sup, SuppliedBy sb, Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(sup-(sb)->a-(bs)->s)
AND s.name = N'Собака';

-- 5.3. Найти все рекомендации по уходу для вида "Хомяк"
SELECT s1.name AS FromSpecies, s2.name AS ToSpecies
FROM Species s1, CareRecommendation cr, Species s2
WHERE MATCH(s1-(cr)->s2)
AND s1.name = N'Хомяк';

-- 5.4. Найти цепочку: Поставщик -> Животное -> Вид
SELECT 
    sup.company_name AS Supplier,
    a.name AS Animal,
    s.name AS Species
FROM Supplier sup, SuppliedBy sb, Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(sup-(sb)->a-(bs)->s);

-- 5.5. Найти животных, чьи виды имеют рекомендации от "Черепахи"
SELECT a.name AS AnimalName, s2.name AS RecommendedSpecies
FROM Animal a, BelongsToSpecies bs, Species s1, 
     CareRecommendation cr, Species s2
WHERE MATCH(a-(bs)->s1-(cr)->s2)
AND s1.name = N'Черепаха';

--------------

-- 6.1. Найти все рекомендации по уходу от "Кошки" (шаблон "+")
DECLARE @StartSpecies NVARCHAR(50) = N'Кошка';

WITH CarePaths AS (
    SELECT 
        s1.name AS StartSpecies,
        STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS Path,
        LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS EndSpecies
    FROM 
        Species AS s1,
        CareRecommendation FOR PATH AS cr,
        Species FOR PATH AS s2
    WHERE MATCH(SHORTEST_PATH(s1(-(cr)->s2)+))
    AND s1.name = @StartSpecies
)
SELECT StartSpecies, Path 
FROM CarePaths;


-- 6.2.  Запрос с SHORTEST_PATH
DECLARE @Supplier1 NVARCHAR(100) = N'ЗооМир';
DECLARE @Supplier2 NVARCHAR(100) = N'Фауна';

WITH SupplierConnections AS (
    SELECT 
        sup1.company_name AS StartSupplier,
        STRING_AGG(s.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ConnectionPath,
        LAST_VALUE(sup2.company_name) WITHIN GROUP (GRAPH PATH) AS EndSupplier
    FROM 
        Supplier AS sup1,
        SuppliedBy FOR PATH AS sb1,
        Animal FOR PATH AS a,
        BelongsToSpecies FOR PATH AS bs,
        Species FOR PATH AS s,
        BelongsToSpecies FOR PATH AS bs2,
        Animal FOR PATH AS a2,
        SuppliedBy FOR PATH AS sb2,
        Supplier FOR PATH AS sup2
    WHERE MATCH(SHORTEST_PATH(sup1(-(sb1)->a-(bs)->s<-(bs2)-a2<-(sb2)-sup2){1,5}))
    AND sup1.company_name = @Supplier1
)
SELECT StartSupplier, ConnectionPath 
FROM SupplierConnections
WHERE EndSupplier = @Supplier2;
