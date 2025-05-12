-- ������� ���� ������ PetShopNetwork
USE master;
GO
DROP DATABASE IF EXISTS PetShopNetwork;
GO
CREATE DATABASE PetShopNetwork;
GO
USE PetShopNetwork;
GO

-- 1. ������� ��� ������� �����
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

-- 2. ������� ��� ������� �����
CREATE TABLE BelongsToSpecies AS EDGE;    -- �������� ����������� ����
CREATE TABLE SuppliedBy AS EDGE;         -- ��������� ���������� ��������
CREATE TABLE CareRecommendation AS EDGE; -- ������������ �� ����� ����� ������

-- ��������� ����������� ����������
ALTER TABLE BelongsToSpecies 
ADD CONSTRAINT EC_BelongsToSpecies CONNECTION (Animal TO Species);

ALTER TABLE SuppliedBy 
ADD CONSTRAINT EC_SuppliedBy CONNECTION (Supplier TO Animal);

ALTER TABLE CareRecommendation 
ADD CONSTRAINT EC_CareRecommendation CONNECTION (Species TO Species);
GO

-- 3. ��������� ������� �����
-- ��������
INSERT INTO Animal (id, name, age, price) VALUES
(1, N'������', 2, 150.00),
(2, N'�����', 3, 200.00),
(3, N'����', 1, 100.00),
(4, N'�����', 4, 300.00),
(5, N'������', 2, 250.00),
(6, N'����', 5, 400.00),
(7, N'�����', 1, 120.00),
(8, N'�����', 2, 180.00),
(9, N'����', 3, 350.00),
(10, N'����', 4, 280.00);

-- ���� ��������
INSERT INTO Species (id, name, habitat) VALUES
(1, N'�����', N'��������'),
(2, N'������', N'��������'),
(3, N'�������', N'�������'),
(4, N'�����', N'��������'),
(5, N'�����', N'������'),
(6, N'��������', N'���������'),
(7, N'������', N'������'),
(8, N'����', N'���������'),
(9, N'����', N'���������'),
(10, N'���������', N'������');

-- ����������
INSERT INTO Supplier (id, company_name, rating) VALUES
(1, N'������', 9.2),
(2, N'�������.��', 8.8),
(3, N'��������', 9.0),
(4, N'��������', 8.5),
(5, N'�����', 9.1),
(6, N'����', 8.7),
(7, N'����������', 8.9),
(8, N'����������', 8.6),
(9, N'�����������', 9.3),
(10, N'����������', 8.4);
-- 4. ������� ����� ����� ������� �����

-- �������������� �������� � �����
INSERT INTO BelongsToSpecies ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Animal WHERE id = 1), (SELECT $node_id FROM Species WHERE id = 1)),  -- ������ -> �����
((SELECT $node_id FROM Animal WHERE id = 2), (SELECT $node_id FROM Species WHERE id = 2)),  -- ����� -> ������
((SELECT $node_id FROM Animal WHERE id = 3), (SELECT $node_id FROM Species WHERE id = 3)),  -- ���� -> �������
((SELECT $node_id FROM Animal WHERE id = 4), (SELECT $node_id FROM Species WHERE id = 4)),  -- ����� -> �����
((SELECT $node_id FROM Animal WHERE id = 5), (SELECT $node_id FROM Species WHERE id = 5)),  -- ������ -> �����
((SELECT $node_id FROM Animal WHERE id = 6), (SELECT $node_id FROM Species WHERE id = 2)),  -- ���� -> ������
((SELECT $node_id FROM Animal WHERE id = 7), (SELECT $node_id FROM Species WHERE id = 1)),  -- ����� -> �����
((SELECT $node_id FROM Animal WHERE id = 8), (SELECT $node_id FROM Species WHERE id = 7)),  -- ����� -> ������
((SELECT $node_id FROM Animal WHERE id = 9), (SELECT $node_id FROM Species WHERE id = 8)),  -- ���� -> ����
((SELECT $node_id FROM Animal WHERE id = 10), (SELECT $node_id FROM Species WHERE id = 6)); -- ���� -> ��������

-- ����� ����������� � ���������
INSERT INTO SuppliedBy ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Supplier WHERE id = 1), (SELECT $node_id FROM Animal WHERE id = 1)),  -- ������ -> ������
((SELECT $node_id FROM Supplier WHERE id = 2), (SELECT $node_id FROM Animal WHERE id = 2)),  -- �������.�� -> �����
((SELECT $node_id FROM Supplier WHERE id = 3), (SELECT $node_id FROM Animal WHERE id = 3)),  -- �������� -> ����
((SELECT $node_id FROM Supplier WHERE id = 4), (SELECT $node_id FROM Animal WHERE id = 4)),  -- �������� -> �����
((SELECT $node_id FROM Supplier WHERE id = 5), (SELECT $node_id FROM Animal WHERE id = 5)),  -- ����� -> ������
((SELECT $node_id FROM Supplier WHERE id = 6), (SELECT $node_id FROM Animal WHERE id = 6)),  -- ���� -> ����
((SELECT $node_id FROM Supplier WHERE id = 7), (SELECT $node_id FROM Animal WHERE id = 7)),  -- ���������� -> �����
((SELECT $node_id FROM Supplier WHERE id = 8), (SELECT $node_id FROM Animal WHERE id = 8)),  -- ���������� -> �����
((SELECT $node_id FROM Supplier WHERE id = 9), (SELECT $node_id FROM Animal WHERE id = 9)),  -- ����������� -> ����
((SELECT $node_id FROM Supplier WHERE id = 10), (SELECT $node_id FROM Animal WHERE id = 10)); -- ���������� -> ����

-- ��������� �������������� ����� ����� ������ ��� ������� ��������
INSERT INTO CareRecommendation ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Species WHERE id = 1), (SELECT $node_id FROM Species WHERE id = 2)),  -- ����� -> ������
((SELECT $node_id FROM Species WHERE id = 2), (SELECT $node_id FROM Species WHERE id = 5)),  -- ������ -> �����
((SELECT $node_id FROM Species WHERE id = 5), (SELECT $node_id FROM Species WHERE id = 7)),  -- ����� -> ������
((SELECT $node_id FROM Species WHERE id = 7), (SELECT $node_id FROM Species WHERE id = 6)),  -- ������ -> ��������
((SELECT $node_id FROM Species WHERE id = 6), (SELECT $node_id FROM Species WHERE id = 8)),  -- �������� -> ����
((SELECT $node_id FROM Species WHERE id = 8), (SELECT $node_id FROM Species WHERE id = 9)),  -- ���� -> ����
((SELECT $node_id FROM Species WHERE id = 9), (SELECT $node_id FROM Species WHERE id = 10)), -- ���� -> ���������
((SELECT $node_id FROM Species WHERE id = 10), (SELECT $node_id FROM Species WHERE id = 3)), -- ��������� -> �������
((SELECT $node_id FROM Species WHERE id = 3), (SELECT $node_id FROM Species WHERE id = 4)),  -- ������� -> �����
((SELECT $node_id FROM Species WHERE id = 4), (SELECT $node_id FROM Species WHERE id = 1)); -- ����� -> �����

-- 5.1. ����� ���� �������� ���� "�����"
SELECT a.name AS AnimalName, s.name AS SpeciesName
FROM Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(a-(bs)->s)
AND s.name = N'�����';

-- 5.2. ����� �����������, ������� ���������� �����
SELECT sup.company_name AS SupplierName, a.name AS AnimalName
FROM Supplier sup, SuppliedBy sb, Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(sup-(sb)->a-(bs)->s)
AND s.name = N'������';

-- 5.3. ����� ��� ������������ �� ����� ��� ���� "�����"
SELECT s1.name AS FromSpecies, s2.name AS ToSpecies
FROM Species s1, CareRecommendation cr, Species s2
WHERE MATCH(s1-(cr)->s2)
AND s1.name = N'�����';

-- 5.4. ����� �������: ��������� -> �������� -> ���
SELECT 
    sup.company_name AS Supplier,
    a.name AS Animal,
    s.name AS Species
FROM Supplier sup, SuppliedBy sb, Animal a, BelongsToSpecies bs, Species s
WHERE MATCH(sup-(sb)->a-(bs)->s);

-- 5.5. ����� ��������, ��� ���� ����� ������������ �� "��������"
SELECT a.name AS AnimalName, s2.name AS RecommendedSpecies
FROM Animal a, BelongsToSpecies bs, Species s1, 
     CareRecommendation cr, Species s2
WHERE MATCH(a-(bs)->s1-(cr)->s2)
AND s1.name = N'��������';

--------------

-- 6.1. ����� ��� ������������ �� ����� �� "�����" (������ "+")
DECLARE @StartSpecies NVARCHAR(50) = N'�����';

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


-- 6.2.  ������ � SHORTEST_PATH
DECLARE @Supplier1 NVARCHAR(100) = N'������';
DECLARE @Supplier2 NVARCHAR(100) = N'�����';

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
