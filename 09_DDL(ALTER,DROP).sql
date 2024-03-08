-- DDL(Data Definition Language) : 데이터 정의 언어로
-- 객체를 만들고(CREATE), 수정하고(ALTER), 삭제하는(DROP) 구문
-- 데이터(이름, 값)과 관련 없고 테이블의 컬럼/이름/제약조건을 바꾸는 것 == DDL

-- ALTER(바꾸다, 변조하다)
-- 수정 가능한 것 : 컬럼(추가/수정/삭제), 제약조건(추가/삭제)
--                  이름변경(테이블, 컬럼, 제약조건)

-- [작성법]
-- 테이블을 수정하는 경우
-- ALTER TABLE 테이블명 ADD|MODIFY|DROP 수정할 내용;

/*ALTER UPDATE MODIFY*/
--오라클의 여러 객체마다 ALTER문 작성법 다 다름

--------------------------------------------------------------------------------
-- 1. 제약조건 추가 / 삭제

-- * 작성법 중 [] 대괄호 : 생략 가능(선택)

-- 제약조건 추가 : ALTER TABLE 테이블명 
--                 ADD [CONSTRAINT 제약조건명] 제약조건(컬럼명) [REFERENCES 테이블명[(컬럼명)]];
--																											FK제약조건일 경우에는 REFERENCES도 써야한다
-- 제약조건 삭제 : ALTER TABLE 테이블명
--                 DROP CONSTRAINT 제약조건명;


-- 서브쿼리를 이용해서 DEPARTMENT 테이블 복사 --> NOT NULL 제약조건만 복사됨
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT; 
--서브쿼리의 결과를 복사해서 테이블을 만든다
-->근데 이 방식으로 복사하면 제약조건 복사가 NOT NULL만 복사됨

SELECT * 
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'DEPT_COPY';

-- DEPT_COPY 테이블에 PK 추가 (PRIMARY KEY 제약조건 추가)
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_PK PRIMARY KEY(DEPT_ID);

-- 제약조건들 추가 후 확인해보기
SELECT C1.TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'DEPT_COPY';
-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼에 UNIQUE 제약조건 추가
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY 테이블의 LOCATION_ID 컬럼에 CHECK 제약조건 추가
-- 컬럼에 작성할 수 있는 값은 L1, L2, L3, L4, L5 
-- 제약조건명 : LOCATION_ID_CHK
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT LOCATION_ID_CHK CHECK(LOCATION_ID IN ('L1', 'L2', 'L3', 'L4', 'L5')); 

-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가
-- * NOT NULL 다른 제약조건들과 다루는 방법이 다름
-->  NOT NULL을 제외한 제약 조건은 추가적인 조건으로 인식됨.(ADD/DROP) --NOT NULL 제외한 나머지 제약조건이 사용
-->  NOT NULL은 기존 컬럼의 성질을 변경하는 것으로 인식됨.(MODIFY) --NOT NULL은 다른 애들과 달리 ADD/DROP이 아닌 MODIFY를 써야한다
-- 다른 제약조건들은 들어올 수 있는 값을 지정하는데, NOT NULL은 값의 유/무를 제어하므로 다른 애들과 다름
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL; --NOT NULL은 ADD가 아닌 MODIFY 써야 한다!!!!
---------------------------
-- 제약조건들 삭제 후 확인해보기(위의 것과 같은 구문)
SELECT C1.TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'DEPT_COPY';
---------------------------
-- DEPT_COPY에 추가한 제약조건 중 PK 빼고 모두 삭제
/*SYS_C007458 ==NOT NULL
SYS_C007459 ==NOT NULL
SYS_C007463 ==NOT NULL
LOCATION_ID_CHK
DEPT_COPY_TITLE_U*/
--DEPT_COPY_TITLE_U 삭제
ALTER TABLE DEPT_COPY 
DROP CONSTRAINT DEPT_COPY_TITLE_U;

--LOCATION_ID_CHK 삭제
ALTER TABLE DEPT_COPY 
DROP CONSTRAINT LOCATION_ID_CHK;

--남은 세개는 NOT NULL 임
-- NOT NULL도 DROP으로 되긴 하긴 하는데 NOT NULL의 경우 MODIFY를 더 권장!!!
ALTER TABLE DEPT_COPY 
DROP CONSTRAINT SYS_C007459;
ALTER TABLE DEPT_COPY 
DROP CONSTRAINT SYS_C007463;
-- NOT NULL 제거 시 MODIFY 사용
ALTER TABLE DEPT_COPY 
MODIFY LOCATION_ID CONSTRAINT SYS_C007458 NULL; --NULL을 허용하겠다 --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/*제약 조건은 수정이 안되기 때문에 삭제 후 다시 생성하는 형식으로 수정을 진행한다!!!!!*/
---------------------------------------------------------------------------------
-- 2. 컬럼 추가/수정/삭제

-- 컬럼 추가 : ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);
-- 디폴트 : 아무것도 안 적었을 때 기본으로 들어가는 값
-- CREATE TABLE할 때 이 컬럼에 아무것도 안적었을 때 디폴트값 뭘로 할거야~~

-- 컬럼 수정 : ALTER TABLE 테이블명 MOIDFY 컬럼명 데이터타입;   (데이터 타입 변경)
--             ALTER TABLE 테이블명 MOIDFY 컬럼명 DEFAULT '값'; (기본값 변경)

--> ** 데이터 타입 수정 시 컬럼에 저장된 데이터 크기 미만으로 변경할 수 없다.


-- 컬럼 삭제 : ALTER TABLE 테이블명 DROP (삭제할컬럼명);
--             ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

--> ** 테이블에는 최소 1개 이상의 컬럼이 존재해야 되기 때문에 모든 컬럼 삭제 X

-- 테이블이란? 행과 열로 이루어진 데이터베이스의 가장 기본적인 객체


-- (추가)
-- DEPT_COPY 컬럼에 CNAEM VARCHAR2(20) 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);
ALTER TABLE DEPT_COPY 
ADD (CNAEM VARCHAR2(20));

SELECT * FROM DEPT_COPY; --CNAEM이라는 컬럼이 추가됨

-- (추가)
-- DEPT_COPY 테이블에 LNAME VARCHAR2(30) 기본값 '한국' 컬럼 추가
ALTER TABLE DEPT_COPY 
ADD (LNAME VARCHAR2(30) DEFAULT '한국');

SELECT * FROM DEPT_COPY; --디폴트 값이 들어감
--컬럼이 만들어지면서 DEFAULT 값으로 채워진다
-------------------------------------------------------------------------------------------
-- (수정)
-- DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 CHAR(2) -> VARCHAR2(3)으로 변경
-- ALTER TABLE 테이블명 MOIDFY 컬럼명 데이터타입;
ALTER TABLE DEPT_COPY 
MODIFY DEPT_ID VARCHAR2(3);
--------------------------------------------------------------------------------------
-- (수정 에러 상황)
-- DEPT_TITLE 컬럼의 데이터타입을 VARCHAR2(10)으로 변경
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE VARCHAR2(10);
--VARCHAR2(35) -> VARCHAR2(10)
-- ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음

SELECT DEPT_TITLE FROM DEPT_COPY; --인사관리부는 총 15바이트가 이미 들어있는데 10바이트로 바꾸려니 안되는 거임
--이미 저장된 데이터보다 컬럼의 크기를 작게 변경할 수 없다!!!!
-----------------------------------------------------------------------------------------------
-- (기본값 수정)
-- LNAME 기본값을 '한국' -> '대한민국' 으로 변경
-- ALTER TABLE 테이블명 MOIDFY 컬럼명 DEFAULT '값'; 
ALTER TABLE DEPT_COPY 
MODIFY LNAME DEFAULT '대한민국';

SELECT * FROM DEPT_COPY; --기본값 바뀐다고 처음에 기본값으로 이미 저장된 한국이 대한민국으로 바뀌지 않음 ->바꾸려면 UPDATE 구문 써야함

--LNAME 컬럼 값을 모두 '대한민국'으로 변경하기
UPDATE DEPT_COPY 
--SET LNAME='대한민국'; --이렇게 써도 됨
SET LNAME=DEFAULT; --이렇게 써도 됨

SELECT * FROM DEPT_COPY;

COMMIT; --DML 내용을 DB에 반영하겠다
-------------------------------------------------------------------------------
-- (삭제)
-- DEPT_COPY에 추가한 컬럼(CNAEM, LNAME) 삭제
-->  ALTER TABLE 테이블명 DROP(삭제할컬럼명);
ALTER TABLE DEPT_COPY DROP(CNAEM);
SELECT * FROM DEPT_COPY;
-->  ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
SELECT * FROM DEPT_COPY;

--DEPT_TITLE, LOCATION_ID 컬럼도 삭제해보기
ALTER TABLE DEPT_COPY DROP (DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
SELECT * FROM DEPT_COPY;

--마지막 남은 DEPT_ID 컬럼도 삭제 시도해보기
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
-- 테이블에 행은 0개여도 허용되지만, 열은 0개일 수 없음!!!!!!
-------------------------------------------------------------------
-- * DDL(CREATE, ALTER, DROP) / DML(INSERT, UPDATE, DELETE)을 혼용해서 사용할 경우 발생하는 문제점
-- DML을 수행하여 트랜잭션에 변경사항이 저장된 상태에서
-- COMMIT/ROLLBACK 없이 DDL 구문을 수행하게되면
-- DDL 수행과 동시에 선행 DML이 자동으로 COMMIT 되어버림.

-- DDL 마음대로 계속 할 떄엔 트랜잭션에 저장되다가 음 뭐 만들어야지~~하고 CREATE 하면 
-- DDL은 트랜잭션에 저장되지 않고 DB로 바로 직행하는데 그 때 JAVA와 DB 사이의 스트림을 통해서 DB로 가는데
-- 중간에 트랜잭션이 막고있으면 DDL구문이 DB로 직행할 때 트랜잭션의 내용도 같이 밀고 DB로 들어가버려서 모든 내용이 DB에 반영돼버림

--> 결론 : DML/DDL 혼용해서 사용하지 말자!!!

--이제 DEPT_ID만 남음
INSERT INTO DEPT_COPY VALUES('D0'); -- 'D0' 삽입
SELECT * FROM DEPT_COPY;
ROLLBACK; -- 트랜잭션에서 'D0' INSERT 내용을 삭제
SELECT * FROM DEPT_COPY;


INSERT INTO DEPT_COPY VALUES('D0'); -- 'D0' 다시 삽입 (DML)
SELECT * FROM DEPT_COPY; -- 트랜잭션에 남아있음

ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(4); -- DDL 수행
ROLLBACK; --이거 수행 시 D0가 지워져야 하는데 DDL이 밀고 가버려서 이제 지워지지 않음
SELECT * FROM DEPT_COPY; -- 'D0'가 사라지지 않음
-------------------------------------------------------------------------------
-- 3. 테이블 삭제

-- [작성법]
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];
CREATE TABLE TB1( --부모
    TB1_PK NUMBER PRIMARY KEY,
    TB1_COL NUMBER
);

CREATE TABLE TB2( --자식
    TB2_PK NUMBER PRIMARY KEY,
    TB2_COL NUMBER REFERENCES TB1 -- TB1 테이블의 PK 값을 참조
);

-- 일반 테이블 삭제(DEPT_COPY)(누군가의 부모/자식 관계가 아닌 테이블)
DROP TABLE DEPT_COPY; -- Table DEPT_COPY이(가) 삭제되었습니다.

SELECT * FROM DEPT_COPY; --삭제돼서 조회되지 않음

-- ** 관계가 형성된 테이블 중 부모테이블(TB1) 삭제 **
DROP TABLE TB1;
-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다 (누군가가 날 참조하고 있어서 막 지우면 안된다)
--> 다른 테이블이 TB1 테이블을 참조하고 있어서 삭제 불가능.

-- 해결 방법 1 : 자식 -> 부모 테이블 순서로 삭제하기 (부모를 참조하고 있던 자식 테이블을 없앤 후에는 부모 테이블 삭제 가능)
-- (참조하는 테이블이 없으면 삭제 가능)
DROP TABLE TB2; --선
DROP TABLE TB1; -- 후 (삭제 성공)


-- 해결 방법 2 : CASCADE CONSTRAINTS 삭제 옵션 사용 ->많은 테이블들이 연결돼있어서 테이블 지우기 힘들 때 이거 사용하면 해결됨
--> 제약조건까지 모두 삭제 
-- == FK 제약조건으로 인해 삭제가 원래는 불가능 하지만, 제약조건을 없애버려서 FK 관계를 해제
-- TB1에 연결된 제약조건을 없애버리겠다
DROP TABLE TB1 CASCADE CONSTRAINTS; -- 원래는 안됐는데 삭제 성공
DROP TABLE TB2;         
---------------------------------------------------------------------------------

-- 4. 컬럼, 제약조건, 테이블 이름 변경(RENAME)

-- 테이블 복사
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT; --지웠었는데 다시 만들기

-- 복사한 테이블에 PK 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT PK_DCOPY PRIMARY KEY(DEPT_ID);

-- 1) 컬럼명 변경 : ALTER TABLE 테이블명 RENAME COLUMN 컬럼명 TO 변경명; 
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY; --값은 가만히 있고 컬럼명만 바뀜

-- 2) 제약조건명 변경 : ALTER TABLE 테이블명 RENAME CONSTRAINT 제약조건명 TO 변경명;
ALTER TABLE DEPT_COPY RENAME CONSTRAINT PK_DCOPY TO DEPT_COPY_PK;

-- 3) 테이블명 변경 : ALTER TABLE 테이블명 RENAME TO 변경명;
ALTER TABLE DEPT_COPY RENAME TO DCOPY;
SELECT * FROM DCOPY;
SELECT * FROM DEPT_COPY; -- 이름이 변경되어 DEPT_COPY 테이블명으로 조회 불가(그 이름의 테이블 이제 존재하지 않음)






















