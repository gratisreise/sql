-- 1. 서브쿼리(Subquery)
-- 서브쿼리는 쿼리 안에 포함된 또 다른 쿼리로, 복잡한 조건을 처리하거나 단계별로 데이터를 필터링할 때 유용합니다.

-- 서브쿼리의 유형
-- 단일 행 서브쿼리: 하나의 값 반환 (예: =, < 등 연산자와 사용).
-- 다중 행 서브쿼리: 여러 행 반환 (예: IN, ANY, ALL과 사용).
-- 상관 서브쿼리(Correlated Subquery): 외부 쿼리와 연동.

SELECT 열이름
FROM 테이블
WHERE 열이름 연산자 (SELECT 열이름 FROM 테이블 WHERE 조건);

--단일 행 서브쿼리:나이가 평균보다 높은 학생 조회
SELECT name, age
FROM students
WHERE age > (SELECT AVG(age) FROM students);

-- 다중 행 서브쿼리: 특정 강의(101)를 수강하는 학생 조회, 유사조인
SELECT name
FROM students
WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id = 101);

--상관 서브쿼리: 수강 기록이 있는 학생만 조회
SELECT name
FROM students s
WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id);


-- 2. 인덱스(Index)
-- 인덱스는 데이터 검색 속도를 높이기 위해 테이블의 열에 생성하는 구조입니다. 책의 색인처럼 작동합니다.

-- 인덱스의 개념
-- 장점: 검색(SELECT, WHERE, JOIN) 속도 향상.
-- 단점: 데이터 삽입/수정/삭제 시 추가 작업 필요 (성능 저하 가능).
-- 사용 사례: 자주 검색되는 열(예: student_id, name).


CREATE INDEX 인덱스이름 ON 테이블이름(열이름);


-- 인덱스 생성:
CREATE INDEX idx_student_name ON students(name);

-- 인덱스 확인 (DBMS마다 다름, MySQL 예시):
SHOW INDEX FROM students;

-- 인덱스 삭제:
DROP INDEX idx_student_name ON students;

SELECT * FROM students WHERE name = '홍길동';
-- 기존: 전체 테이블 스캔후 찾기
-- 변경: 해당 열에 바로 접근

-- 주의점
-- 기본 키(PRIMARY KEY)와 고유 키(UNIQUE)는 자동으로 인덱스 생성됨.
-- 너무 많은 인덱스는 저장 공간과 업데이트 성능에 부담.

-- WITH 절 (CTE, Common Table Expression)
-- 복잡한 쿼리를 간소화하기 위해 임시 결과 집합 정의.

WITH enrolled_students AS (
    SELECT s.name, COUNT(e.course_id) AS course_count
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    GROUP BY s.name
)
SELECT name, course_count
FROM enrolled_students
WHERE course_count > 1;


--DISTINCT
--중복 제거.
SELECT DISTINCT course_id FROM enrollments;


--실습 예제
INSERT INTO students VALUES (4, '박민재', 21);
INSERT INTO enrollments VALUES (4, 4, 102);

--서브쿼리
SELECT name
FROM students
WHERE age >= 20 AND student_id IN (SELECT student_id FROM enrollments);

--인덱스
CREATE INDEX idx_age ON students(age);
SELECT * FROM students WHERE age = 20;

--CTE
WITH course_stats AS (
    SELECT course_id, COUNT(student_id) AS student_count
    FROM enrollments
    GROUP BY course_id
)
SELECT c.course_name, cs.student_count
FROM courses c
JOIN course_stats cs ON c.course_id = cs.course_id;
