--한 줄 주석 : ctrl+/
/*범위 주석 : ctrl + shift + /
 * SQL 1개 실행 : CTRL + ENTER
 * SQL 여러개 실행 : (블럭 처리 후) ALT + X 
 * */
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--계정 생성하기
CREATE USER KH_LIK IDENTIFIED BY KH1234;

--생성된 계정에 접속 + 기본 자원 관리 권한 추가하기
GRANT CONNECT, RESOURCE TO KH_LIK;

--객체 생성 공간 할당
ALTER USER KH_LIK
DEFAULT TABLESPACE SYSTEM
QUOTA UNLIMITED ON SYSTEM;
------------------------------------------------------------------------

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--계정 생성하기
CREATE USER WORKBOOK IDENTIFIED BY KH1234;
-- KH1234 == 비밀번호
--생성된 계정에 접속 + 기본 자원 관리 권한 추가하기
GRANT CONNECT, RESOURCE TO WORKBOOK;

--객체 생성 공간 할당
ALTER USER WORKBOOK
DEFAULT TABLESPACE SYSTEM
QUOTA UNLIMITED ON SYSTEM;
--이게 계정 만드는거고 
--왼쪽에 만드는게 빠른 로그인하는 방법 만드는거임 
