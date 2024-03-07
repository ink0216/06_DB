-- TCL(Transaction Control Language) : 트랜잭션 제어 언어
-- (Transaction : 업무, 처리)

/* TRANSACTION이란?
 - 데이터베이스의 논리적 연산 단위
 
 - 데이터 변경 사항을 묶어 하나의 트랜잭션에 담아 처리함.

 - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE (DML)
 -- DBeaver Java
 -- DB나 Java에서 INSERT, UPDATE, DELETE 하면 바로 DB에 반영되지 않고
 -- 중간의 트랜잭션에 변경내용들이 임시로 저장되고 
 -- DB에 집어넣고 싶을 때 COMMIT을 함!!!
 -- COMMIT = 인도하다, 위탁하다(DB에게 넘김)
 -- 실수로 잘못 변경사항을 만든 경우, ROLLBACK을 해서 트랜잭션 안에 들어있는 내용을 다 지우는 것!
 -- COMMIT = 변경사항을 DB로 넘겨주는 것
 -- DB는 신뢰도가 중요하고, 무결성을 지켜야 함(중복되면 안됨)
 
 EX) INSERT 수행 --------------------------------> DB 반영(X)
   
     INSERT 수행 --> 트랜잭션에 추가 --> COMMIT --> DB 반영(O)
     커밋을 해야 DB에 들어가는거다
     INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 안됨


    1) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영/저장
    
    2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
                 마지막 COMMIT 상태로 돌아감.
                 COMMIT 하면 트랜잭션 내용들이 DB에 반영되고 트랜잭션 내부의 내용은 모두 삭제됨(빈 통으로 됨)
                
    3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
                   ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
                   저장 지점까지만 일부 ROLLBACK 
                   == ROLLBACK할 지점 지정!!!
    
    [SAVEPOINT 사용법]
    
    SAVEPOINT 포인트명1;
    ...
    SAVEPOINT 포인트명2;
    ...
    ROLLBACK TO 포인트명1; -- 포인트1 지점 까지 데이터 변경사항 삭제
    --포인트명1까지 돌아간다. 

*/
--DEPARTMENT 테이블 복사해서 DEPARTMENT3 테이블 생성
CREATE TABLE DEPARTMENT3 AS
SELECT * FROM DEPARTMENT2;

SELECT * FROM DEPARTMENT3;

/* - INSERT INTO 테이블명 VALUES(값...)
 * - INSERT INTO 테이블명(컬럼명...) VALUES(값...)
 * 
 * - UPDATE 테이블명 SET 컬럼명=변경값 [WHERE절]
 * 
 * - DELETE FROM 테이블명 [WHERE절]*/
--'D0', '경리부', 'L2'삽입하기
INSERT INTO DEPARTMENT3 
VALUES('D0', '경리부', 'L2');

SELECT * FROM DEPARTMENT3;
-----------------------------------------------------------------------------------------
-- DEPARTMENT3 테이블
-- DEPT_ID가 'D9'인 부서의 이름과 지역코드를
-- '전략기획팀', 'L3' 로 수정.
UPDATE DEPARTMENT3 
SET DEPT_TITLE ='전략기획팀', LOCATION_ID ='L3'
WHERE DEPT_ID ='D9';
--확인
SELECT * FROM DEPARTMENT3;
/*현재 트랜잭션에 저장된 DML(INSERT 하나, UPDATE 하나)구문을
 * 실제로 DB에 반영하는 COMMIT하기*/
COMMIT;

/*트랜잭션에 저장된 내용 삭제 = ROLLBACK*/
ROLLBACK;--COMMIT과 ROLLBACK 사이에 수행한 DML이 없으므로 ROLLBACK 해도 변화 없음
SELECT * FROM DEPARTMENT3;
----------------------------------------------------------------------------------------------
--DEPT_ID가 'D0'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D0'; --하나 삭제됨

--DEPT_ID가 'D9'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D9'; --하나 삭제됨

--DEPT_ID가 'D8'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D8'; --하나 삭제됨

--총 3행 삭제함
SELECT * FROM DEPARTMENT3; --삭제된 3행이 트랜잭션에만 저장되고 트랜잭션의 내용을 보여준 것 뿐 DB에는 반영 아직 안됨
/*트랜잭션에 저장된 DML(DELETE 3번) 모두 삭제하기==ROLLBACK*/
ROLLBACK;

SELECT * FROM DEPARTMENT3; --그럼 다 살아났다
-------------------------------------------------------------------------------------------
/*SAVEPOINT*/
--DEPT_ID가 'D0'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D0'; --하나 삭제됨

SAVEPOINT "SP1";--쌍따옴표 써야 함 
--"SP1" 저장 지점 설정

--DEPT_ID가 'D9'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D9'; --하나 삭제됨

SAVEPOINT "SP2";

--DEPT_ID가 'D8'인 행을 삭제하기
DELETE FROM DEPARTMENT3 
WHERE DEPT_ID='D8'; --하나 삭제됨

SAVEPOINT "SP3";
--DEPARTMENT3 전체 삭제
DELETE FROM DEPARTMENT3;

SELECT * FROM DEPARTMENT3; --아무것도 안나옴
----------------------------------------------------------------------
--SP3까지 ROLLBACK하기
ROLLBACK TO "SP3";
SELECT * FROM DEPARTMENT3; --7행까지 복구됨

--SP2까지 ROLLBACK하기
ROLLBACK TO "SP2";
SELECT * FROM DEPARTMENT3; --8행까지 복구됨

--SP1까지 ROLLBACK하기
ROLLBACK TO "SP1";
SELECT * FROM DEPARTMENT3; --9행까지 복구됨

--'D0'도 복구하고 싶으면 그냥 ROLLBACK하면 됨
ROLLBACK;
SELECT * FROM DEPARTMENT3; --10행까지 복구됨



