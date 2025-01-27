-- 1. 성능 튜닝
-- 성능 튜닝은 쿼리 실행 속도를 최적화하고 데이터베이스 자원을 효율적으로 사용하는 방법입니다.

-- 주요 개념
-- 실행 계획(Execution Plan): 쿼리가 어떻게 실행되는지 분석.
-- 인덱스 활용: 검색 속도 개선.
-- 쿼리 최적화: 불필요한 연산 줄이기.
-- 실행 계획 분석
-- 문법 (DBMS마다 약간 다름):
-- PostgreSQL: EXPLAIN 또는 EXPLAIN ANALYZE
-- MySQL: EXPLAIN

EXPLAIN SELECT name FROM students WHERE age = 20;

-- 인덱스 활용
-- 복합 인덱스
CREATE INDEX idx_age_name ON students(age, name);
-- 커버링 인덱스
CREATE INDEX idx_students_covering ON students(age, name);
SELECT name FROM students WHERE age = 20;

-- 쿼리 최적화
-- 불필요한 데이터 줄이기:
-- 비효율적
SELECT * FROM students WHERE age > 18;
-- 효율적
SELECT name, age FROM students WHERE age > 18;

-- 서브쿼리 대신 JOIN:
-- 서브쿼리
SELECT name FROM students WHERE student_id IN (SELECT student_id FROM enrollments);
-- JOIN
SELECT DISTINCT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;

-- 조건 먼저 필터링
SELECT name
FROM students
WHERE age > 20
AND student_id IN (SELECT student_id FROM enrollments);


--최적화 전:
SELECT s.name, c.course_name
FROM students s, courses c, enrollments e
WHERE s.student_id = e.student_id
AND e.course_id = c.course_id
AND s.age > 20;

--최적화 후:
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.age > 20;

-- 대용량 데이터 처리
-- 대용량 데이터를 다룰 때는 성능과 스케일링을 고려해야 합니다.

-- 파티셔닝(Partitioning)
-- 정의: 큰 테이블을 작은 조각으로 나누어 관리.
-- 종류:
-- 범위 파티셔닝: 값 범위로 나눔 (예: 연도별).
-- 리스트 파티셔닝: 특정 값 목록으로 나눔.

CREATE TABLE enrollments (
    enrollment_id SERIAL,
    student_id INT,
    course_id INT,
    enrollment_date DATE
) PARTITION BY RANGE (enrollment_date);

CREATE TABLE enrollments_2023 PARTITION OF enrollments
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE enrollments_2024 PARTITION OF enrollments
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

SELECT * FROM enrollments WHERE enrollment_date = '2023-06-01';

-- 샤딩(Sharding)
-- 정의: 데이터를 여러 데이터베이스 서버로 분산.
-- 방법: 애플리케이션 레벨 또는 DBMS 지원 (예: PostgreSQL Citus).
-- 예시: student_id를 기준으로 샤딩:
-- 서버 1: student_id 1~1000
-- 서버 2: student_id 1001~2000

-- 배치 처리
-- 대량 삽입:
INSERT INTO students (student_id, name, age)
SELECT generate_series(1, 10000), 'Student_' || generate_series(1, 10000), 20;

-- 대량 업데이트
UPDATE students
SET age = age + 1
WHERE student_id BETWEEN 1 AND 1000;


-- 캐싱
-- 자주 조회되는 데이터는 메모리 캐시(Redis, Memcached)에 저장
SELECT name FROM students WHERE student_id = 1; -- 캐시에서 먼저 확인

-- 실습예제
-- 인덱스 생성 및 실행 계획 확인:
CREATE INDEX idx_enrollment_date ON enrollments(enrollment_date);
EXPLAIN ANALYZE SELECT * FROM enrollments WHERE enrollment_date = '2023-06-01';

-- 파티셔닝 테스트:
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES (1, 101, '2023-06-01'), (2, 102, '2024-01-15');
SELECT * FROM enrollments_2023;

--배치삽입
INSERT INTO students (student_id, name, age)
SELECT i, 'User_' || i, 20 + (i % 10)
FROM generate_series(1, 1000) AS i;

-- 성능 튜닝:
-- 쿼리 실행 전 EXPLAIN으로 병목 확인.
-- 인덱스는 자주 검색되는 열에만 생성.
-- 대용량 데이터:
-- 파티셔닝/샤딩 설계 시 데이터 분포 고려.
-- 백업 및 복구 전략 병행.
