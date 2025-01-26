-- DDL (Data Definition Language): 데이터 구조 정의 (CREATE, ALTER, DROP)
-- DML (Data Manipulation Language): 데이터 조작 (INSERT, UPDATE, DELETE, SELECT)
-- DCL (Data Control Language): 권한 관리 (GRANT, REVOKE)
-- TCL (Transaction Control Language): 트랜잭션 관리 (COMMIT, ROLLBACK)

-- 테이블 생성(CREATE)
CREATE TABLE 테이블이름 (
    열이름 데이터타입 [제약조건],
    열이름 데이터타입 [제약조건]
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,  -- 고유 식별자, 중복 불가
    name VARCHAR(50),           -- 문자열, 최대 50자
    age INT                     -- 정수
);

주요 데이터 타입:
    INT: 정수
    VARCHAR(n): 가변 길이 문자열 (n은 최대 길이)
    DATE: 날짜
    TEXT: 긴 문자열

-- 데이터 삽입(INSERT)
INSERT INTO 테이블이름 (열1, 열2) VALUES (값1, 값2);
INSERT INTO students (student_id, name, age) 
VALUES (1, '홍길동', 20);
INSERT INTO students (student_id, name, age) 
VALUES (2, '김영희', 22);

-- 열이름을 생략하면 모든 열에 대해 순서대로 값을 입력
INSERT INTO students VALUES(3, '이철수', 19)

--데이터 조회
SELECT 열이름 FROM 테이블이름;

-- 모든 열 조회
SELECT * FROM students;  -- *는 모든 열을 의미

-- 특정 열 조회
SELECT name, age FROM students;

-- 조건 추가 (WHERE)
SELECT * FROM students WHERE age > 20;

-- 정렬 (ORDER BY)
select * from students order by age asc;

-- 데이터 수정 (UPDATE)
UPDATE 테이블이름 SET 열이름 = 새값 WHERE 조건;
UPDATE students SET age = 21 WHERE student_id = 1;
-- where 제거시 모든 행에 대해 실행된다.

-- 데이터 삭제 (DELETE)
DELETE FROM 테이블이름 WHERE 조건;
-- where 없으면 테이블의 모든 데이터 삭제

--테이블 삭제 (DROP)
DROP TABLE 테이블이름;
DROP TABLE students;

-- 실습예제

--테이블 생성
CREATE TABLE students(
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);
--데이터 삽입
INSERT INTO students VALUES(1, '안농', 20)
INSERT INTO students VALUES(2, '안농', 21)
INSERT INTO students VALUES(3, '안농', 22)

--조회 누구를 찾지?
select name from students where age < 21;

--수정 누구를 수정하지?
update students set age = 23 where name = '김영희'

--삭제 누구를 삭제하지?
delete students where student_id == 3




