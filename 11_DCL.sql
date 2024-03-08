/* 계정(사용자)

* 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
                모든 권한과 책임을 가지는 계정.
                ex) sys(최고관리자), system(sys에서 권한 몇개 제외된 관리자)


* 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
                작업을 수행할 수 있는 계정으로
                업무에 필요한 최소한의 권한만을 가지는 것을 원칙으로 한다.
                ex) bdh계정(각자 이니셜 계정), workbook 등
            관리자 계정 이외의 모든 계정들==사용자계정
   ==>이런 권한 제어하는 언어!
   권한 주고받을 때 DCL 사용
*/

/* DCL(Data Control Language) : 

 계정에 DB, DB객체에 대한 접근 권한을 부여하고 회수하는 언어
 
- GRANT : 권한 부여
- REVOKE : 권한 회수

* 권한의 종류

1) 시스템 권한 : DB접속, 객체 생성 권한

CRETAE SESSION   : 데이터베이스 접속 권한(SESSION은 접속해야 만들어짐)
CREATE TABLE     : 테이블 생성 권한
CREATE VIEW      : 뷰 생성 권한
CREATE SEQUENCE  : 시퀀스 생성 권한
CREATE PROCEDURE : 함수(프로시져, SQL 여러개 묶어 한번에 실행하는 PLSQL구문) 생성 권한
CREATE USER      : 사용자(계정) 생성 권한
DROP USER        : 사용자(계정) 삭제 권한
DROP ANY TABLE   : 임의 테이블 삭제 권한


2) 객체 권한 : 특정 객체를 "조작"할 수 있는 권한 (만들 수 있는 권한 아니고 "조작*이용"할 수 있는 권한임)

  권한 종류                 설정 객체
    SELECT              TABLE, VIEW, SEQUENCE
    INSERT              TABLE, VIEW
    UPDATE              TABLE, VIEW
    DELETE              TABLE, VIEW
    ALTER               TABLE, SEQUENCE
    REFERENCES          TABLE
    INDEX               TABLE
    EXECUTE             PROCEDURE

*/

--계정 생성하기

/*관리자 계정으로 접속해서 하는 것(여기서부터)*/
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
--> '오라클 SQL을 예전 방식처럼 사용하겠다'
	--> 이렇게 해야 계정명 작성 시 원하는대로 작성이 가능해진다

--사용자 계정 생성하기
CREATE USER TEST_USER IDENTIFIED BY TEST1234; --비밀번호

--생성만 된거지 접속은 안됨
-- ORA-01045: 사용자 TEST_USER는 CREATE SESSION 권한을 가지고있지 않음; 로그온이
-- 거절되었습니다
-->접속 권한이 없어서 로그인이 불가능하다

--[생성한 사용자 계정에 접속 권한 부여하기]
GRANT CREATE SESSION TO TEST_USER;
--SESSION :접속 시 생성되는 객체
/*관리자 계정으로 접속해서 하는 것(여기까지)*/

/*TEST_USER 계정으로 접속*/
--테이블 생성하기
CREATE TABLE TB_MEMBER(
	MEMBER_NO NUMBER PRIMARY KEY, --회원번호
	MEMBER_ID VARCHAR2(30) NOT NULL,
	MEMBER_PW VARCHAR2(30) NOT NULL
);
--SQL Error [1031] [42000]: ORA-01031: 권한이 불충분합니다
--접속 권한만 줬지, 테이블 만들 권한도 안받았고, TABLESPACE(테이블 생성 공간)도 없어서 생성 불가함
--테이블 생성할 권한 없음
-- + 테이블 생성할 권한 줘도 TABLESPACE 없어서 생성이 불가함

/*다시 관리자 계정 접속하기*/

--테이블 생성 권한 부여하기
GRANT CREATE TABLE TO TEST_USER; --TEST_USER에게 테이블 생성 권한 부여함

--TABLESPACE(TABLE 포함하는 객체 생성 공간) 할당하기
--관리자계정>STARAGE>TABLESPACE 폴더>USERS에 공간 부여하는게 좋음(SYSTEM에는 이미 많이 들어있어서)
ALTER USER TEST_USER 
DEFAULT TABLESPACE USERS
--기본적으로 USERS 공간에 저장할거야
QUOTA 10M ON USERS;
--용량은 10메가 정도 줄거야
--USERS의 10메가정도만 이용할 수 있게 줄거야

/*다시 TEST_USER 계정으로 접속하기*/
CREATE TABLE TB_MEMBER(
	MEMBER_NO NUMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(30) NOT NULL,
	MEMBER_PW VARCHAR2(30) NOT NULL
); --이제는 실행 된다
--TEST_USER에게
--CREATE SESSION/CREATE TABLE 권한 이거 두개만 줬음 (시퀀스, 프로시저는 아직 못만듦)
-----------------------------------------------------------------------------
/* ROLE(역할 == 권한의 묶음, 권한명 단순화) 
 * 
 * CONNECT(접속) : DB 접속 권한 (CREATE SESSION)
 * 
 * RESOURCE(자원) : DB 기본 객체 8개 생성 권한
 * */

/*관리자 계정 접속하기*/
--ROLE에 어떤 권한이 있는지 확인하는 방법
--ROLE에 묶여있는 권한 확인하는 방법
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE='CONNECT';

SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE='RESOURCE';
--PRIVS : PRIVELEDGE(권한)

--TEST_USER 계정에 CONNECT, RESOURCE 롤 부여하기
GRANT CONNECT, RESOURCE TO TEST_USER; --두 개의 권한(2+8=10개 권한)이 부여됨
----------------------여기까지가 SYSTEM 권한-------------------------------------
--객체 권한 테스트
--TEST_USER 계정이랑 KH_LIK 계정 이용

/*TEST_USER 계정 접속하기*/
--KH_LIK 계정의 EMPLOYEE 테이블 조회하기
SELECT * FROM KH_LIK.EMPLOYEE;--아직은 안됨
--SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
-->접근 권한이 없어서 보이지 않음

/*KH_LIK 계정 접속*/
--TEST_USER 계정에 EMPLOYEE 테이블 조회 권한을 부여하기
--다른 계정에서 내 계정에 저장된 테이블을 볼 수 있게 하겠다
GRANT SELECT ON EMPLOYEE TO TEST_USER; --EMPLOYEE테이블에 대한 SELECT 권한을 부여하겠다

/*TEST_USER 계정 접속*/
SELECT * FROM KH_LIK.EMPLOYEE; --이제 잘보인다!!!!
-->나중에 권한을 뺏으면 못들어가게 됨
----------------------------------------------------------------------
--권한 뺏기 해보기
/*KH_LIK 계정 접속*/
--TEST_USER의 EMPLOYEE테이블 조회 권한 다시 회수하기
REVOKE SELECT ON EMPLOYEE FROM TEST_USER; --TEST_USER에게서 뺏겠다

/*TEST_USER 계정 접속*/
SELECT * FROM KH_LIK.EMPLOYEE; --권한 뺏겨서 안보인다!
--SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다



