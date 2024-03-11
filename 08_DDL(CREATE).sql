/* --이 내용이 다음주 시험의 주 내용!
- 데이터 딕셔너리란?
자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
데이터 딕셔너리는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
- 데이터베이스가 만드는 테이블인데 사전 테이블이라고 부름
- 사전을 보면 자동적으로 순서대로 정리돼있어서 열람, 수정 등의 관리를 효율적으로 할 수 있음
- 데이터 변화 생기면 그에 따라 알파벳 순서 등으로 자동적으로 순서 정렬해서 저장함
---------------------------------------------------------------------------------
- 딕셔너리 뷰 = 데이터 딕셔너리에서 필요한 데이터만 모아서 볼 수 있는 가상의 테이블 == 데이터 딕셔너리의 일부분
- 큰 데이터 딕셔너리 표에서 이것만 봐야지~하고 만들어놓은 가상 테이블 = 딕셔너리 뷰
-그 중의 하나가 User-tables임!

- User_tables : 자신의 계정이 소유한 객체 등에 관한 정보를 조회 할 수 있는 딕셔너리 뷰

*/
SELECT * FROM USER_TABLES;
--로그인한 유저가 만든 테이블이 다 보임(실제로 존재하는 테이블은 아님)
--------------------------------------------------------------------------------------------------------------------
-- SELECT = DQL (DATA QUERY LANGUAGE, 데이터 있냐 묻고 조회)
-- DML(DATA MANIPULATION LANGUAGE) : 
-- TCL : COMMIT, ROLLBACK하던거
-- 나중에 DCL도 나옴!!!!(다섯 개 다 의미*사용법 알아야 함)

-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어


-- 객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP) 등
-- 데이터의 전체 구조를 정의하는 언어로 주로 DB관리자, 설계자가 사용함

-- 오라클(DB)에서의 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
--                   인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER)
--                   프로시져(PROCEDURE), 함수(FUNCTION),
--                   동의어(SYNONYM), 사용자(USER)
-- 테이블 생성 = 컬럼 생성
-- 테이블은 컬럼만 만들어 놓고, 행은 데이터를 삽입해야 생김
-- 컬럼이 모자르면 컬럼 추가 OR 컬럼명을 변경 OR 컬럼의 타입 변경 == ALTER
-- DROP == 테이블 전체 삭제
--------------------------------------------------------------------------------------------------------------------

-- CREATE

-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거 할 수 있음 

-- 1. 테이블 생성하기
-- 테이블이란?
-- 행(row)과 열(column)으로 구성되는 가장 기본적인 데이터베이스 객체
-- 데이터베이스 내에서 모든 데이터는 테이블을 통해서 저장된다.


-- [표현식] 
/*
    CREATE TABLE 테이블명 (
        컬럼명 자료형(크기), --해당 컬럼에 어떤 자료형을 저장할 지 지정 
        컬럼명 자료형(크기),
        ...);
*/

/* 자료형
    NUMBER : 숫자형(정수, 실수)
    
    NUMBER(자릿수) : 몇 자리인지 크기도 지정할 수 있음
    
    ** CHAR(크기) : "고정길이" 문자형 (2000BYTE까지 쓸 수 있음) ==>VARCHAR2보다 약간 빠름
        -> ex) CHAR(10) 컬럼에 'ABC' 3BYTE 문자열만 저장해도 10BYTE 저장공간을 모두 사용. 
        	==CHAR(10) : 해당 컬럼에 문자는 10칸까지만 저장 가능->ABC쓰면 앞의 7칸도 그대로 남아있음(없어지지 않음)
        							(칸 수 고정=>쓸모 없는 공간 많이 생겨서 VARCHAR2씀)
        CHAR==문자열
    ** VARCHAR2(크기) : "가변길이" 문자형 (4000 BYTE) ==>메모리 효율은 좋음=>가장 많이 씀
    *		==>두 번 일해야해서 CHAR보다 약간 느림(근데 차이는 작음)
        -> ex) VARCHAR2(10) 컬럼에 'ABC' 3BYTE 문자열만 저장하면 나머지 7BYTE를 반환함.
        ==VARIABLE같은 CHAR ==변하는 CHAR (10칸 만들었는데 3개의 문자만 들어온 경우 앞의 7칸은 반환)
    DATE : 날짜 타입
    BLOB : 대용량 이진수 데이터 (4GB)
    CLOB : 대용량 문자 데이터 (4GB)
    --영어,숫자는 한 글자에 1바이트
*/
------------------------------------------------------------------------
-- MEMBER 테이블 생성
--회원 테이블에 어떤 컬럼이 필요할까..?
--1) 필요한 컬럼 : 아이디, 비밀번호, 이름, 주민번호, 가입일
--2) 컬럼명을 영어로 지정 + 자료형 지정
	/* UTF-8 문자SET : 
	 * 영어, 숫자, 기본 특수문자(키보드에 있는 특수문자) == 1BYTE
	 * 나머지 == 3BYTE (한글 포함) */
	/*한글은 한 글자당 3바이트여서 이름이 5글자인 사람까지 저장 가능하게 하려면 15BYTE로 제한해야함*/

		/*아이디 : MEMBER_ID / 자료형 : VARCHAR2(20) (사람마다 아이디 길이 다르므로)
		/*비밀번호 : MEMBER_PW / 자료형 : VARCHAR2(20) 괄호 안의 숫자로 아이디/비밀번호의 글자 수 제한할 수 있음
		/*이름 : MEMBER_NAME / 자료형 : VARCHAR2(15) (한글 5글자까지)
		/*주민번호 : MEMBER_SSN / 자료형 : CHAR(14) (주민번호는 항상 14글자 고정이니까 VARCHAR쓸 이유 없음)
		/*가입일 : ENROLL_DATE / 자료형 : DATE (MS 단위도 하고싶으면 TIMESTAMP쓰면 됨)
		 * */
CREATE TABLE "MEMBER"(
MEMBER_ID VARCHAR2(20),
MEMBER_PW VARCHAR2(20),
MEMBER_NAME VARCHAR2(15),
MEMBER_SSN CHAR(14),
ENROLL_DATE DATE DEFAULT SYSDATE --현재 시간을 기본값으로 지정
/*DEFAULT(=기본값) : 컬럼의 기본값을 지정 (필수요소는 아님!!!! 해도 되고 안해도 되고)
 * ==> INSERT, UPDATE시 해당 컬럼에 값을 넣지 않으면 
 * 			지정한 기본값이 들어간다!!!*/
);


-- 만든 테이블 확인
SELECT * FROM "MEMBER";

SELECT * FROM USER_TABLES;--만든 MEMBER테이블 리스트에 올라감

-- 2. 컬럼에 주석 달기(컬럼명 설명)
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PW IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_SSN IS '회원 주민번호';
COMMENT ON COLUMN MEMBER.ENROLL_DATE  IS '회원 가입일';

--SQL 여러 줄 한번에 실행 : 드래그 한 후 ALT+X!!!!

-- USER_TABLES : 사용자가 작성한 테이블을 확인 하는 뷰
-- 데이터 딕셔너리에 정의되어 있음
SELECT * FROM USER_TABLES;

-- DESC문 : 테이블의 구조를 표시 (이건 몰라도 됨!!)
--DESC MEMBER; --여기서는 안되고 cmd 창에서 sqlplus에서 하면 되는 구문!!

-- MEMBER 테이블에 샘플 데이터 삽입
INSERT INTO "MEMBER" 
VALUES('MEM01', '123ABC', '홍길동', '990102-1234567', 
TO_DATE('2024-03-06')); --TO_DATE('2024-03-06') : '2024-03-06'문자열을 DATE로 바꿈


--  데이터  삽입 확인
SELECT * FROM "MEMBER";
COMMIT; --DML 수행 내용(INSERT한 내용)을 DB에 반영하겠다

-- 추가 샘플 데이터 삽입
-- 가입일 -> SYSDATE를 활용
INSERT INTO "MEMBER"
VALUES('MEM02', 'QWER1234', '김영희', '980808-1234567', SYSDATE);

-- 가입일 -> DEFAULT 활용(테이블 생성 시 정의된 값이 반영됨)
INSERT INTO "MEMBER"
VALUES('MEM03', 'ASDF1234', '박철수', '970303-1234567', DEFAULT);

SELECT * FROM "MEMBER"; --세 명 들어있음 확인하기
-- 가입일 -> INSERT 시 미작성 하는 경우 -> DEAFULT 값이 반영됨
INSERT INTO "MEMBER"(MEMBER_ID, MEMBER_PW, MEMBER_NAME, MEMBER_SSN)
VALUES('MEM04', 'ZXCV1234', '신짱구', '960606-1234567');
--네 개의 컬럼에만 값을 집어넣겠다

--  데이터  삽입 확인
SELECT * FROM "MEMBER"; --짱구 가입일 실행 시간(디폴트 값) 들어감


--------------------------------------------------------------------------------------------------------------------


-- 제약 조건(CONSTRAINTS) : 문자인데 이런 모양의 문자만/다른 테이블의 문자만/중복불가 등의 5가지 종류있음

/*
    사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약.
    ***데이터 무결성 보장을 목적으로 함.***
    *-무결 : 결점이 없는, 신뢰있는 데이터

    + 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
    + 데이터의 수정/삭제 가능여부 검사등을 목적으로 함 
        --> 제약조건을 위배하는 DML 구문은 수행할 수 없음!!!!
    
    제약조건 종류
    PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY. : 모두 다 알아야 함!!!
    
*/

-- 제약 조건 확인
-- USER_CONSTRAINTS : 사용자가 작성한 제약조건을 확인 하는 딕셔너리 뷰 
--DESC USER_CONSTRAINTS;
SELECT * FROM USER_CONSTRAINTS;

-- USER_CONS_COLUMNS : 제약조건이 걸려 있는 컬럼을 확인 하는 딕셔너리 뷰 
--DESC USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS;



-- 1. NOT NULL 
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정시 NULL값을 허용하지 않도록 컬럼레벨에서 제한
-- 값이 없으면 안된다는 제약조건 거는 것
-- 회원가입 시 필수입력 * 있는 애들은 이거 사용

/*NOT NULL은 컬럼 레벨로만 설정 가능!!!!!*/
/*제약조건 레벨 : 컬럼레벨/테이블 레벨 */
CREATE TABLE USER_USED_NN(
--NOT NULL 제약조건 사용해서 테이블 만들어보기
		--회원번호는 필수적으로 존재해야 함
    USER_NO NUMBER NOT NULL, --컬럼 레벨 제약 조건 설정(컬럼명 작성시에 같이 작성하는 제약조건)
    --회원번호는 NUMBER타입이고, NULL이면 안됨
    --제약조건은 테이블 만드는 동시에 진행
    
    USER_ID VARCHAR2(20) ,
    USER_PWD VARCHAR2(30) ,
    USER_NAME VARCHAR2(30) ,
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);


INSERT INTO USER_USED_NN
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--맨 앞에 NUMBER타입인 숫자가 있어서 정상 실행됨(NULL이 아니어서)

INSERT INTO USER_USED_NN
VALUES(NULL, NULL, NULL, NULL, NULL, '010-1234-5678', 'hong123@kh.or.kr');
--> NOT NULL 제약 조건에 위배되어 오류 발생 (첫 번째 것이 NULL이어서 오류남, 첫 번째는 NULL이 되면 안되는 제약조건 지정함!!!)
--나머지 NULL들은 들어갈 수 있음(NOT NULL 제약조건 걸지 않아서)
-- ORA-01400: cannot insert NULL into ("KH"."USER_USED_NN"."USER_NO")

--------------------------------------------------------------------------------------------------------------------
-- 2. UNIQUE 제약조건 
-- 컬럼에 입력 값에 대해서 중복을 제한하는 제약조건
-- 컬럼레벨에서 설정 가능, 테이블 레벨에서 설정 가능!!!!!!!
-- 단, UNIQUE 제약 조건이 설정된 컬럼에 NULL 값은 중복 삽입 가능.
-- 한 컬럼에 똑같은 값이 하나밖에 있을 수 없다!!!!!!

DROP TABLE USER_USED_UK; --테이블 삭제
-- UNIQUE 제약 조건 테이블 생성
CREATE TABLE USER_USED_UK( --UNIQUE (KEY)
    USER_NO NUMBER,
    
    --USER_ID VARCHAR2(20) UNIQUE, --컬럼 레벨 제약조건 설정(제약조건의 이름 지정 안해서 이상하게 자동 지정된 것->사용 X)
    --아이디는 중복이 있으면 안됨
    USER_ID VARCHAR2(20) CONSTRAINT USER_ID_U UNIQUE,
    --CONSTRAINT 제약조건명 제약조건종류
    --컬럼 레벨 제약조건 설정(제약조건의 이름 지정O)
    
    USER_PWD VARCHAR2(30) ,
    
    USER_NAME VARCHAR2(30), --테이블 레벨로 UNIQUE 제약조건 설정해보기 ->맨 밑에 쓰면 됨
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    
    --테이블 레벨 영역(테이블의 제일 아래쪽)--
    --UNIQUE(USER_NAME) --테이블레벨 제약조건(제약조건의 이름 지정 X) (해당 컬럼에 UNIQUE 제약조건 설정)
    CONSTRAINT USER_NAME_U UNIQUE(USER_NAME)
    --USER_NAME 컬럼에 UNIQUE 제약조건 설정할건데 그 제약조건 이름이 USER_NAME_U 야
);


INSERT INTO USER_USED_UK
VALUES(1, 'user01', 'pass01', '가길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_USED_UK
VALUES(1, 'user01', 'pass01', '나길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 같은 아이디인 데이터가 이미 테이블에 있으므로 UNIQUE 제약 조건에 위배되어 오류발생
--무결성 제약 조건(KH_LIK.USER_ID_U)에 위배됩니다 ->오류 시 어떤 제약조건 위배했는지 알 수 있게 제약조건의 이름 지어놓음

INSERT INTO USER_USED_UK
VALUES(1, NULL, 'pass01', '다길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 아이디에 NULL 값 삽입 가능. (UNIQUE에는 NULL들어가지 말라는 것은 아님)

INSERT INTO USER_USED_UK
VALUES(1, NULL, 'pass01', '라길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> 아이디에 NULL 값 중복 삽입 가능.(중복되는 값을 허용하지 않는 게 UNIQUE인데 값이 없을 때에는 그에 반하지 않아서 들어감)

SELECT  * FROM USER_USED_UK; --나길동 빼고 3행 조회


-- 오류 보고에 나타나는 SYS_C008635 같은 제약 조건명으로
-- 해당 제약 조건이 설정된 테이블명, 컬럼, 제약 조건 타입 조회 
-- 제약조건 이름을 검색할 수 있는 SQL문
SELECT UCC.TABLE_NAME, UCC.COLUMN_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
AND UCC.CONSTRAINT_NAME = '제약조건명'; --제약조건명 자리에 제약조건 이름 검색하면 됨


---------------------------------------


-- UNIQUE 복합키 : 테이블 레벨로만 지정 가능하다!!!
-- 두 개 이상의 컬럼을 묶어서 하나의 UNIQUE 제약조건을 설정함
-- 한 컬럼에만 UNIQUE 제약조건 주면 아래의 2,3,4번째 허용 안됨
--두 컬럼을 묶어서 UNIQUE 제약조건 설정 시 두 컬럼값이 모두 같은 경우에만 중복저장 안되고 하나라도 다르면 저장 가능함
--A 1 (O)
--A 2 (O)
--B 1 (O)
--B 2 (X)
CREATE TABLE USER_USED_UK2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    
    -- 테이블레벨 복합키 설정 (소괄호 안에는 하고싶은 만큼 컬럼 작성 가능)
    CONSTRAINT USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)
  
);




INSERT INTO USER_USED_UK2
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_USED_UK2
VALUES(2, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> UNIQUE와 관련 없는 USER_NO가 다름
--ORA-00001: 무결성 제약 조건(KH_LIK.USER_ID_NAME_U)에 위배됩니다
--중복되는게 들어오면 안된다

INSERT INTO USER_USED_UK2
VALUES(2, 'user02', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
--> USER_ID가 다름
-->이름은 똑같지만 아이디가 달라서 삽입 됨

SELECT * FROM USER_USED_UK2;
--아이디와 이름을 묶어서 둘 다 같을 때에만 중복으로 처리해서 추가 막음
----------------------------------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEE; --사번은 중복 안되고 꼭 있어야 함
-- 이게 5개 중에서 제일 중요!!!!!!(의미가 중요함!!)
-- 3. PRIMARY KEY(기본키) 제약조건 

-- 테이블에서 한 행의 정보를 찾기위해 사용할 컬럼을 의미함 EX) 210번인 사람의 정보 볼래 하면 210번으로 검색하면 그 사람의 정보 다 나옴
-->아이디 숫자처럼 모두 값이 다르면서 간단한 형태의 값이 저장된 컬럼을 PRIMARY KEY로 많이 씀
-- 테이블에 대한 식별자(IDENTIFIER) 역할을 함
-- NOT NULL + UNIQUE 제약조건의 의미 (값이 없으면 안되고 중복되면 안됨)
-- 한 테이블당 한 개만 설정할 수 있음
-- 컬럼레벨, 테이블레벨 둘다 설정 가능함
-- 한 개 컬럼에 설정할 수도 있고, 여러개의 컬럼을 묶어서 설정할 수 있음(복합키도 가능)
-->여러 컬럼에 하고싶으면 묶어서 하나로 해서 적용시켜야 함


CREATE TABLE USER_USED_PK(
    -- USER_NO NUMBER PRIMARY KEY, --컬럼레벨, 제약조건 이름 지정 X
    USER_NO NUMBER /*CONSTRAINT USER_NO_PK PRIMARY KEY*/, --컬럼레벨, 제약조건 이름 지정 O
    
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    
    --테이블레벨
    CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
); --이거 실행함

INSERT INTO USER_USED_PK
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_USED_PK
VALUES(1, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr');
--> 기본키 중복으로 오류 (1 이 겹쳐서)
-- ORA-00001: 무결성 제약 조건(KH_BDH.USER_NO_PK)에 위배됩니다

INSERT INTO USER_USED_PK
VALUES(NULL, 'user03', 'pass03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr');
--> 기본키가 NULL 이므로 오류
-- ORA-01400: NULL을 ("KH_BDH"."USER_USED_PK"."USER_NO") 안에 삽입할 수 없습니다

---------------------------------------

-- PRIMARY KEY 복합키 (테이블 레벨만 가능)
CREATE TABLE USER_USED_PK2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    CONSTRAINT PK_USERNO_USERID PRIMARY KEY(USER_NO, USER_ID) -- 복합키
);

INSERT INTO USER_USED_PK2
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_USED_PK2
VALUES(1, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr');
--아이디부분이 다르므로 잘 됨
INSERT INTO USER_USED_PK2
VALUES(2, 'user01', 'pass01', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr');
--NUMBER가 다르므로 잘 됨
INSERT INTO USER_USED_PK2
VALUES(1, 'user01', 'pass01', '신사임당', '여', '010-9999-9999', 'sin123@kh.or.kr');
-- 회원 번호와 아이디 둘다 중복 되었을 때만 제약조건 위배 에러 발생
--둘다 중복돼서 에러 발생
-- ORA-00001: 무결성 제약 조건(KH_BDH.PK_USERNO_USERID)에 위배됩니다

SELECT * FROM USER_USED_PK2; --홍길동 이순신 유관순

-- PRIMARY KEY는 NULL이 들어갈 수 없음
INSERT INTO USER_USED_PK2
VALUES(NULL, 'user01', 'pass01', '신사임당', '여', '010-9999-9999', 'sin123@kh.or.kr');
--복합키에서 중복 여부는 모든 컬럼을 묶어서 검사하고(모든 컬럼의 값이 같을 때에만 중복 처리)
--NOT NULL은 각 컬럼 별로 검사함
----------------------------------------------------------------------------------------------------------------
-- 5가지 제약조건 중에서 이게 두 번째로 중요!!!!!
-- 4. FOREIGN KEY(외부키 / 외래키) 제약조건
 
-- PRIMARY KEY로 FOREIGN KEY를 설정 가능

-- 참조(REFERENCES)된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
	-->다른 테이블이 제공하는 컬럼에는 PK(PRIMARY KEY) (100%) 또는 U(UNIQUE) 제약조건이 설정되어 있어야 한다
	-->PK가 잘 설정되어 있어야 FOREIGN KEY도 잘 설정할 수 있다



-- FOREIGN KEY제약조건에 의해서 테이블간의 관계(RELATIONSHIP)가 형성됨
	-->두 테이블간의 관계가 형성된다
	--EMPLOYEE 테이블의 이 컬럼에는 DEPARTMENT 테이블의 이 컬럼에 있는 값만 쓸 수 있다 라는 제약조건을 거는 것!!!
	-- 왜 외부 테이블에 있는 컬럼값을 사용할까?
	--DEPARTMENT 테이블에서 해당 컬럼은 PRIMARY KEY로 지정돼있음(식별자 역할, 컬럼값 알면 그 행의 정보 알 수 있음)
	--외부의 테이블을 참조할수 있게 함
	--데이터를 신뢰도 있게 해줌

-- 제공되는 값 외에는 NULL을 사용할 수 있음 
	--참조할 만한 값이 없어 하면 NULL 하면 됨
------------------------------------------------------------------------------------------
-- 컬럼레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할 테이블명 [(참조할컬럼)] [삭제룰]
-- REFERENCES : 참조
-------------------------------------------------------------------------------------------
-- 테이블레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]
--------------------------------------------------------------------------------------------
-- * 참조될 수 있는 컬럼은 PRIMARY KEY컬럼과, UNIQUE 지정된 컬럼만 외래키로 사용할 수 있음
--참조할 테이블의 참조할 컬럼명이 생략이 되면, PRIMARY KEY로 설정된 컬럼이 자동 참조할 컬럼이 됨

CREATE TABLE USER_GRADE(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO USER_GRADE VALUES (10, '일반회원');
INSERT INTO USER_GRADE VALUES (20, '우수회원');
INSERT INTO USER_GRADE VALUES (30, '특별회원');

SELECT * FROM USER_GRADE;


CREATE TABLE USER_USED_FK(
  USER_NO NUMBER PRIMARY KEY,
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  --FK제약조건을 컬럼레벨로 설정하는 방법
  GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK1 REFERENCES USER_GRADE(GRADE_CODE)
  --PRIMARY KEY설정된 컬럼만 참조 가능
  
);

--가장 끝에 있는 번호에 주목!
--10,20,30,NULL만 들어갈 수 있음
--USER_GRADE(GRADE_CODE)에 10,20,30만 써져있어서 
--USER_USED_FK 테이블의 GRADE_CODE에도 10,20,30,NULL 까지만 들어갈 수 있음
--저 네개의 값만 들어갈 수 있다고 제약조건 주는거임
--FK : 
INSERT INTO USER_USED_FK
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK
VALUES(2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);
--이건 중복이라고 하지 않음 (같은 위치를 참조하므로)

INSERT INTO USER_USED_FK
VALUES(3, 'user03', 'pass03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK
VALUES(4, 'user04', 'pass04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', null);
--> NULL 사용 가능.

SELECT * FROM USER_USED_FK;

INSERT INTO USER_USED_FK
VALUES(5, 'user05', 'pass05', '윤봉길', '남', '010-6666-1234', 'yoon123@kh.or.kr', 50);
--> 50이라는 값은 USER_GRADE 테이블 GRADE_CODE 컬럼에서 제공하는 값이 아니므로
 -- 외래키 제약 조건에 위배되어 오류 발생.
--ORA-02291: 무결성 제약조건(KH_LIK.GRADE_CODE_FK1)이 위배되었습니다
-- 부모 키가 없습니다 == 참조하는 테이블(USER_GRADE)에 값이 존재하지 않음
/***********************************************/
--USER_GRADE : 부모(참조를 당하는 테이블)
--USER_USED_FK : 자식 (부모를 참조하는 테이블)
/***********************************************/
/*FK를 설정하면 장점은? */
/* JOIN : 두 테이블에서 같은 값을 가지고 있는 컬럼을 기준으로 연결
 * (FK 제약조건이 설정되어있지 않아도 사용 가능하긴 한데, FK 제약조건이 설정되어있으면 무조건 그것을 이용해서 JOIN가능)
 * 
 * FK 제약조건이 설정된 부모 - 자식 테이블
 * -> 무조건 JOIN 가능
 *  */
SELECT * FROM USER_USED_FK 
LEFT JOIN USER_GRADE USING (GRADE_CODE); --조인해서 두 테이블을 한 번에 합쳐서 조회하게 만들 수 있다
---------------------------------------

-- * FOREIGN KEY 삭제 옵션 
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를 
-- 어떤식으로 처리할 지에 대한 내용을 설정할 수 있다.

SELECT * FROM USER_GRADE;
SELECT * FROM USER_USED_FK;

-- 1) ON DELETE RESTRICTED(삭제 제한)로 기본값 지정되어 있음
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함
-- 자식이 부모의 값을 참조하고 있을 때에는 부모의 값을 지우지 못하게 하겠다 == 삭제 제한
----------------------------------------------------------------------------------------------
-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않으므로 삭제가 가능함.(자식의 행들 중 아무도 참조하고 있지 않음)
DELETE FROM USER_GRADE
WHERE GRADE_CODE=20; --GRADE_CODE가 20인 행을 지우겠다
-- 잘 됨 (참조를 안 당하고 있어서)

-- GRADE_CODE 30 삭제해보기
DELETE FROM USER_GRADE
WHERE GRADE_CODE=30;
--ORA-02292: 무결성 제약조건(KH_LIK.GRADE_CODE_FK1)이 위배되었습니다- 자식 레코드가 발견되었습니다
--30을 지울려고 했더니 자식이 30을 기록하고 있네? 그럼 지우면 안돼~~
------------------------------------------------------------------------------------------------
-- 2) ON DELETE SET NULL : 부모키 삭제시 자식키를 NULL로 변경하는 옵션 (부모의 요소가 DELETE되면 자식에게 NULL을 세팅해라)
CREATE TABLE USER_GRADE2(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE2 VALUES (10, '일반회원');
INSERT INTO USER_GRADE2 VALUES (20, '우수회원');
INSERT INTO USER_GRADE2 VALUES (30, '특별회원');

-- ON DELETE SET NULL 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK2(
  USER_NO NUMBER PRIMARY KEY,
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  GRADE_CODE NUMBER,
  
  --테이블레벨 FK+삭제옵션
  --FK는 길어서 테이블레벨로 많이 함
  CONSTRAINT GRADE_CODE_FK2 
  FOREIGN KEY (GRADE_CODE) --FK는 어떤 테이블의 무슨 컬럼을 참조할 지 적어야 한다
  REFERENCES USER_GRADE2(GRADE_CODE) --USER_GRADE2 테이블의 GRADE_CODE컬럼을 참조할거야
  ON DELETE SET NULL --부모키가 삭제되면, 그 부모키를 참조하던 자식의 값을 NULL로 변경하겠다
);

--샘플 데이터 삽입
INSERT INTO USER_USED_FK2
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK2
VALUES(2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_USED_FK2
VALUES(3, 'user03', 'pass03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK2
VALUES(4, 'user04', 'pass04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_USED_FK2;

-- 부모 테이블인 USER_GRADE2에서 GRADE_COEE =10 삭제
--> ON DELETE SET NULL 옵션이 설정되어 있어 오류없이 삭제됨.
DELETE FROM USER_GRADE2 
WHERE GRADE_CODE=10; --ON DELETE RESTRICTED 였으면 실행 안됐을건데 ON DELETE SET NULL여서 잘 됨

SELECT * FROM USER_GRADE2; --부모거에서 10 삭제됨
SELECT * FROM USER_USED_FK2; --자식거에는 10을 참조하던 컬럼값이 NULL로 바뀌어있음

------------------------------------------------------------------------------------------------
-- 3) ON DELETE CASCADE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제가 됨
-- CASCADE = 종속(내부,하위에 존재하는 것)
-- 종속된 모든 것을 삭제
-- 부모의 행 하나가 사라지면 그 행을 참조하던 자식의 행들도 다 삭제됨(행이 사라짐)
CREATE TABLE USER_GRADE3(
  GRADE_CODE NUMBER PRIMARY KEY,
  GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE3 VALUES (10, '일반회원');
INSERT INTO USER_GRADE3 VALUES (20, '우수회원');
INSERT INTO USER_GRADE3 VALUES (30, '특별회원');

-- ON DELETE CASCADE 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK3(
  USER_NO NUMBER PRIMARY KEY,
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  GENDER VARCHAR2(10),
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50),
  GRADE_CODE NUMBER,
  
  --테이블레벨
  CONSTRAINT GRADE_CODE_FK3 --GRADE_CODE_FK3라는 이름을 줄거다
  FOREIGN KEY(GRADE_CODE) --USER_USED_FK3의 GRADE_CODE
  REFERENCES USER_GRADE3(GRADE_CODE)--USER_GRADE3의 GRADE_CODE
  ON DELETE CASCADE --부모 키 삭제 시 그 키를 참조하는 자식의 행도 모두 삭제
  
);

--샘플 데이터 삽입
INSERT INTO USER_USED_FK3
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK3
VALUES(2, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_USED_FK3
VALUES(3, 'user03', 'pass03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK3
VALUES(4, 'user04', 'pass04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', null);

COMMIT;

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;
--다 만들어졌다
---------------------------------------------------------------------
-- 부모 테이블인 USER_GRADE3에서 GRADE_CODE =10 삭제
--> ON DELETE CASECADE 옵션이 설정되어 있어 오류없이 삭제됨.
DELETE FROM USER_GRADE3
WHERE GRADE_CODE=10; --삭제 성공

-- ON DELETE CASECADE 옵션으로 인해 참조키를 사용한 행이 삭제됨을 확인
SELECT * FROM USER_GRADE3; --10번 지워짐
SELECT * FROM USER_USED_FK3; --10 참조하던 애들도 같이 삭제됨
----------------------------------------------------------------------------------------------------------------
-- NOT NULL/UNIQUE/PRIMARY KEY/FOREIGN KEY
-- 5. CHECK 제약조건 : 컬럼에 기록되는 값에 조건 설정을 할 수 있음

-- FK와 비슷한 면이 있음
-- FK : PK를 참조하는 값만 넣을 수 있다
-- CHECK : 이 값들만 들어올 수 있다고 우리가 지정해 놓는 것!

-- CHECK (컬럼명 비교연산자 비교값)
-- 주의 : 비교값은 리터럴(딱 떨어지는 값)만 사용할 수 있음, 변하는 값이나 함수 사용 못함
CREATE TABLE USER_USED_CHECK(
  USER_NO NUMBER PRIMARY KEY,
  USER_ID VARCHAR2(20) UNIQUE,
  USER_PWD VARCHAR2(30) NOT NULL,
  USER_NAME VARCHAR2(30),
  
  --컬럼레벨로 CHECK 제약조건 설정
  --소괄호 내부에 조건식 작성
  GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여')),
  --GENDER에 들어가는 값이 남 이나 여 가 맞는지 검사 ->충족해야 넣을 수 있음
  --이 제약조건을 테이블레벨로 옮기려면 
  PHONE VARCHAR2(30),
  EMAIL VARCHAR2(50)
  --테이블레벨(이거는 컬럼레벨과 작성법이 똑같음!)
  --CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여'))
);

INSERT INTO USER_USED_CHECK
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');

INSERT INTO USER_USED_CHECK
VALUES(2, 'user02', 'pass02', '홍길동', '남자', '010-1234-5678', 'hong123@kh.or.kr');
-- GENDER 컬럼에 CHECK 제약조건으로 '남' 또는 '여'만 기록 가능한데 '남자'라는 조건 이외의 값이 들어와 에러 발생
-- 두 개의 값이 아니므로
--ORA-02290: 체크 제약조건(KH_LIK.GENDER_CHECK)이 위배되었습니다
------------------------------------------------------------------------
--FK : 다른 테이블의 PK값만 참조하는 값만 사용할 수 있게 하겠다
--CHECK : 다음의 값들만 사용할 수 있게 하겠다

-- CHECK 제약 조건은 범위로도 설정 가능.

 
 ----------------------------------------------------------------------------------------------------------------

-- [연습 문제]
-- 회원가입용 테이블 생성(USER_TEST)
-- 컬럼명 : USER_NO(회원번호) - 기본키(PK_USER_TEST), 
--         USER_ID(회원아이디) - 중복금지(UK_USER_ID),
--         USER_PWD(회원비밀번호) - NULL값 허용안함(NN_USER_PWD),
--         PNO(주민등록번호) - 중복금지(UK_PNO), NULL 허용안함(NN_PNO),
--         GENDER(성별) - '남' 혹은 '여'로 입력(CK_GENDER),
--         PHONE(연락처),
--         ADDRESS(주소),
--         STATUS(탈퇴여부) - NOT NULL(NN_STATUS), 'Y' 혹은 'N'으로 입력(CK_STATUS)
-- 각 컬럼의 제약조건에 이름 부여할 것
-- 5명 이상 INSERT할 것



----------------------------------------------------------------------------------------------------------------

-- 8. SUBQUERY를 이용한 테이블 생성
-- 컬럼명, 데이터 타입, 값이 복사되고, 제약조건은 NOT NULL 만 복사됨

-- 1) 테이블 전체 복사
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
--EMPLOYEE를 서브쿼리를 이용해서 카피해서 새 테이블 생성
--데이터와 컬럼명은 복사되지만, 제약조건은 NOT NULL만 복사됨!(PK,FK이런것들은 아무것도 카피,복제 안됨)
SELECT * FROM EMPLOYEE_COPY;
-->EMPLOYEE의 NOT NULL 제약조건을 제외한 다른 제약조건들은 복사가 안됨!!
-->또한 DEFAULT, COMMENT값도 복사가 안됨!!!!
-->테이블 복사 후 필요하다면 또 다 설정해줘야 함
----------------------------------------------
-- 2) JOIN 후 원하는 컬럼만 테이블로 복사 
CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_NAME, NVL(DEPT_TITLE, '소속없음') DEPT_TITLE, JOB_NAME
	 FROM EMPLOYEE
	 LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
	 JOIN JOB USING (JOB_CODE)
	 ORDER BY EMP_NAME; --이 서브쿼리의 결과로 나오는 테이블 모양 그대로 테이블 새로 만들기

SELECT * FROM EMPLOYEE_COPY2; --위의 모양 그대로 나온다
-----------------------------------------------------------------------------------------------
-- 9. 제약조건 추가
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 
--  FOREIGN KEY(컬럼명) REFERENCES 참조 테이블명(참조컬럼명)
     --> 참조 테이블의 PK를 기본키를 FK로 사용하는 경우 참조컬럼명 생략 가능
                                                                                                                                                      
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;

-- 테이블 제약 조건 확인
SELECT * 
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';

-- NOT NULL 제약 조건만 복사된 EMPLOYEE_COPY 테이블에
-- EMP_ID 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD CONSTRAINT PK_EMP_COPY PRIMARY KEY(EMP_ID); --이거 실행하면 제약조건이 6개로 하나 늘어남


-- * 수업시간에 활용하던 테이블에는 FK 제약조건 없는상태이므로 추가!!
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 
-- FOREIGN KEY(컬럼명) REFERENCES 참조 테이블명(참조컬럼명)

-- EMPLOYEE테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조 컬럼은 DEPARTMENT의 기본키
ALTER TABLE EMPLOYEE 
ADD CONSTRAINT DEPT_CODE_FK
FOREIGN KEY(DEPT_CODE) --DEPT_CODE를 FOREIGN KEY로 설정할건데
--REFERENCES DEPARTMENT(DEPT_ID);--FOREIGN KEY는 혼자 못쓰고 참조하는 것을 써야 한다
REFERENCES DEPARTMENT; --소괄호 안쓰면 자동으로 DEPARTMENT테이블의 PK컬럼을 참조하도록 세팅됨

---
-- EMPLOYEE테이블의 JOB_CODE 외래키 제약조건 추가
-- 참조 테이블은 JOB, 참조 컬럼은 JOB의 기본키
ALTER TABLE EMPLOYEE 
ADD CONSTRAINT JOB_CODE_FK
FOREIGN KEY(JOB_CODE) 
REFERENCES JOB; --기본키를 참조

-- EMPLOYEE테이블의 SAL_LEVEL 외래키 제약조건 추가
-- 참조 테이블은 SAL_GRADE, 참조 컬럼은 SAL_GRADE의 기본키
ALTER TABLE EMPLOYEE 
ADD CONSTRAINT SAL_LEVEL_FK
FOREIGN KEY(SAL_LEVEL) 
REFERENCES SAL_GRADE; --기본키를 참조

-- DEPARTMENT테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키
ALTER TABLE DEPARTMENT 
ADD CONSTRAINT LOCATION_ID_FK
FOREIGN KEY(LOCATION_ID) 
REFERENCES LOCATION; --기본키(PK컬럼)를 참조

-- LOCATION테이블의 NATIONAL_CODE에 외래키 제약조건 추가
-- 참조 테이블은 NATIONAL, 참조 컬럼은 NATIONAL의 기본키
ALTER TABLE LOCATION 
ADD CONSTRAINT NATIONAL_CODE_FK
FOREIGN KEY(NATIONAL_CODE) 
REFERENCES NATIONAL; --기본키(PK컬럼)를 참조

