-- INNER JOIN: 양쪽 테이블에 모두 존재하는 데이터만 반환.
-- LEFT JOIN: 왼쪽 테이블의 모든 데이터와 오른쪽 테이블의 일치하는 데이터 반환 (일치하지 않으면 NULL).
-- RIGHT JOIN: 오른쪽 테이블 기준으로 작동 (LEFT와 반대).
-- FULL JOIN: 양쪽 테이블의 모든 데이터를 포함 (일부 DBMS에서 지원).
-- 집합의 개념으로 보면 쉽다 a n b, a - b, b - a, a u b


-- 1. 다중 테이블과 JOIN
SELECT 열이름
FROM 테이블1
JOIN 테이블2 ON 테이블1.열 = 테이블2.열;

SELECT s.name, c.course_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

SELECT s.name, c.course_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;

-- 2. 집계 함수 (Aggregation Functions)
-- COUNT: 행의 개수
-- SUM: 열의 합계
-- AVG: 평균
-- MIN: 최소값
-- MAX: 최대값
SELECT 집계함수(열이름) FROM 테이블이름;

-- 학생 수 세기
SELECT COUNT(*) AS total_students FROM students;

-- 나이 평균
SELECT AVG(age) AS avg_age FROM students;

-- 강의별 수강생 수
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- GROUP BY와 HAVING
-- GROUP BY: 데이터를 그룹화.
-- HAVING: 그룹화된 결과에 조건 적용 (WHERE는 행 단위, HAVING은 그룹 단위).
-- 예제: 수강생이 2명 이상인 강의만 조회
SELECT c.course_name, COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
HAVING COUNT(e.student_id) >= 2;

--실습 예제
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students VALUES (1, '홍길동', 20), (2, '김영희', 22), (3, '이철수', 19);
INSERT INTO courses VALUES (101, '데이터베이스'), (102, '프로그래밍');
INSERT INTO enrollments VALUES (1, 1, 101), (2, 1, 102), (3, 2, 101);

-- 각 학생이 수강 중인 강의 이름 조회 (JOIN):
select s.name, c.course_name 
from students s
inner join enrollments e on s.student_id = e.student_id
inner join courses  c on  e.course_id = c.course_id

-- 강의별 수강생 수
select c.course_name, count(e.student_id)
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_name


