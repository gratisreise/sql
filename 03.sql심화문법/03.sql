-- 1. 트랜잭션(Transaction)
-- 트랜잭션은 데이터베이스에서 하나의 논리적 작업 단위를 의미하며, 작업이 모두 성공하거나 모두 실패해야 하는 상황을 보장합니다.
-- 트랜잭션의 개념
-- 정의: 일련의 SQL 작업을 묶어 "모두 완료되거나 전혀 실행되지 않도록" 관리.
-- 비유: 은행 송금 - 계좌 A에서 돈을 빼고 계좌 B에 넣는 작업이 모두 성공해야 함. 중간에 실패하면 원래 상태로 복구.

-- ACID 속성:
-- Atomicity(원자성): 작업이 모두 실행되거나 모두 취소.
-- Consistency(일관성): 데이터베이스가 규칙(무결성 제약)을 유지.
-- Isolation(격리성): 트랜잭션 간 간섭 방지.
-- Durability(지속성): 완료된 작업은 영구 저장.

-- 주요 명령어
-- BEGIN (또는 START TRANSACTION): 트랜잭션 시작.
-- COMMIT: 트랜잭션 성공, 변경 사항 저장.
-- ROLLBACK: 트랜잭션 실패, 변경 사항 취소.

BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
-- 에러 발생 가정 (예: 계좌 2가 없음)
ROLLBACK;

-- 2. 트리거(Trigger)
-- 트리거는 특정 이벤트(데이터 삽입, 수정, 삭제)가 발생할 때 자동으로 실행되는 코드입니다.

-- 트리거의 개념
-- 정의: 테이블에 대한 작업(INSERT, UPDATE, DELETE) 발생 시 실행되는 프로시저.
-- 용도:
-- 데이터 무결성 유지.
-- 로그 기록.
-- 자동 계산.
-- 비유: "학생이 등록되면 자동으로 환영 이메일을 보내는 시스템."

CREATE TRIGGER 트리거이름
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON 테이블이름
FOR EACH ROW
BEGIN
    -- 실행할 SQL 코드
END;

--학생 정보 수정 시 로그 기록:

CREATE TRIGGER log_student_update
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
    INSERT INTO logs (student_id, action, timestamp)
    VALUES (OLD.student_id, 'Updated', NOW());
END;

-- OLD와 NEW:
-- OLD: 변경 전 데이터.
-- NEW: 변경 후 데이터 (INSERT나 UPDATE에서 사용).

-- 학생 삭제 시 로그:
CREATE TRIGGER log_student_delete
AFTER DELETE ON students
FOR EACH ROW
BEGIN
    INSERT INTO logs (student_id, action, timestamp)
    VALUES (OLD.student_id, 'Deleted', NOW());
END;


--실습 예제
BEGIN;
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
-- 계좌 2에 돈을 넣는 중 오류 가정
ROLLBACK;

-- 트랜잭션:
-- 항상 COMMIT 또는 ROLLBACK으로 끝낼 것.
-- 오류 처리를 위해 TRY...CATCH 사용 가능 (DBMS에 따라 다름).
-- 트리거:
-- 복잡한 로직은 저장 프로시저로 분리 고려.
-- 디버깅 시 트리거가 실행되는지 로그로 확인.