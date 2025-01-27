-- 1. 뷰(View)
-- 뷰는 테이블처럼 보이지만 실제 데이터를 저장하지 않는 가상 테이블입니다. 쿼리 결과를 기반으로 생성되며, 자주 사용하는 복잡한 쿼리를 간소화하는 데 유용합니다.

-- 뷰의 개념
-- 정의: SELECT 쿼리를 저장한 객체로, 테이블처럼 조회 가능.
-- 용도:
-- 복잡한 쿼리 단순화.
-- 데이터 보안(특정 열/행만 노출).
-- 재사용성 향상.
-- 비유: "학생과 수강 정보를 자주 조회해야 할 때, 매번 긴 쿼리를 쓰는 대신 뷰로 저장."

CREATE VIEW 뷰이름 AS
SELECT 열이름
FROM 테이블
WHERE 조건;

CREATE VIEW student_courses AS
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

SELECT * FROM student_courses;

-- 뷰 수정 (제한적):
-- 단순 뷰(단일 테이블, 집계 함수 없음)만 수정 가능.

CREATE OR REPLACE VIEW student_courses AS
SELECT s.name, c.course_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

--뷰삭제
DROP VIEW student_courses;

-- 주의점
-- 뷰는 실제 데이터가 아니라 쿼리 결과를 보여줌 → 원본 테이블 변경 시 자동 반영.
-- 복잡한 뷰는 성능 저하 가능성 있음.

-- 2. 저장 프로시저(Stored Procedure)
-- 저장 프로시저는 데이터베이스에 저장된 일련의 SQL 명령어 집합으로, 함수처럼 호출해 실행할 수 있습니다.

-- 저장 프로시저의 개념
-- 정의: 자주 사용하는 작업을 미리 정의해 호출 가능.
-- 용도:
-- 비즈니스 로직 캡슐화.
-- 성능 최적화(서버에서 실행).
-- 보안 강화(직접 테이블 접근 제한).
-- 비유: "학생 등록 시 여러 테이블을 업데이트해야 할 때, 한 번의 호출로 처리."


CREATE PROCEDURE 프로시저이름 ([파라미터])
LANGUAGE SQL
AS $$
BEGIN
    -- SQL 코드
END;
$$;

--학생 삽입 프로시저
CREATE PROCEDURE add_student(p_name VARCHAR, p_age INT)
LANGUAGE SQL
AS $$
INSERT INTO students (student_id, name, age)
VALUES ((SELECT COALESCE(MAX(student_id), 0) + 1 FROM students), p_name, p_age);
$$;

--복잡한 프로시저 (수강 등록 + 로그)
CREATE PROCEDURE enroll_student(p_student_id INT, p_course_id INT)
LANGUAGE SQL
AS $$
BEGIN
    INSERT INTO enrollments (enrollment_id, student_id, course_id)
    VALUES ((SELECT COALESCE(MAX(enrollment_id), 0) + 1 FROM enrollments), p_student_id, p_course_id);
    INSERT INTO logs (student_id, action, timestamp)
    VALUES (p_student_id, 'Enrolled', NOW());
END;
$$;

create procedure enroll_student(p_strdent_id INT, p_coure_id INT)
language SQL
AS $$
BEGIN
    INSERT INTO enrollments (enrollment_id, student_id, course_id)
    VALUES ((select COALESCE(MAX(enrollment_id), 0) + 1 FROM enrollments), p_student_id, p_coure_id)
    INSERT INTO logs(student_id, action, timestamp)
    VALUES (p_student_id, 'Enrolled', NOW())
END;
$$

CALL enroll_student(3, 102);


--실습예제
-- 뷰생성
CREATE VIEW active_students AS
SELECT s.name, COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name
HAVING COUNT(e.course_id) > 0;

SELECT * FROM active_students;

--저장 프로시저
--학생 삭제 및 로그
CREATE PROCEDURE delete_student(p_student_id INT)
LANGUAGE SQL
AS $$
BEGIN
    INSERT INTO logs (student_id, action, timestamp)
    VALUES (p_student_id, 'Deleted', NOW());
    DELETE FROM enrollments WHERE student_id = p_student_id;
    DELETE FROM students WHERE student_id = p_student_id;
END;
$$;

CALL delete_student(2);

-- 뷰:
-- 자주 사용하는 쿼리를 뷰로 만들어 팀과 공유.
-- 읽기 전용으로 사용 권장.
-- 저장 프로시저:
-- 파라미터와 조건문(IF)으로 로직 확장 가능.
-- 디버깅 시 로그 테이블 활용.