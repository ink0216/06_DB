/* VIEW
 * 서브쿼리 - 인라인뷰 : FROM절에 사용하는 서브쿼리 (실제 진짜 테이블이 아닌 가짜 테이블) 
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * 
 *  - "SELECT문의 실행 결과(RESULT SET)를 저장하는 객체"
 *  - SELECT가 조회를 위한 용도이므로 VIEW도 보는 용도의 객체 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리하다.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문(제약조건/컬럼 수정, 이름변경) 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     대부분 제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ ONLY];
 * 
 * --필수적인것만 써보면 테이블 복사 구문과 원형은 동일한데 여러 옵션이 추가될 수 있을 뿐임
 * CREATE  VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문); 
 * 
 *  1) OR REPLACE 옵션 : 이거 많이 씀
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성
 * 
 *  2) FORCE | NOFORCE 옵션 : 잘안씀(DB이관시에만 사용)
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 * (보통 테이블 만든 후에 뷰를 만드는데)
 * (뷰를 먼저 만들어놓고 테이블을 만들어야 하는 경우)
 * 
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정 : 잘안씀
 * 
 *  4) WITH CHECK OPTION 옵션 : 잘안씀
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 : 이거 많이 씀
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 * */

/**********************************************************************************************/
/* VIEW를 생성하기 위해서는 VIEW 생성 권한이 필요하다 !!!!*/
/*이거 관리자 계정 접속해서 한번만 해두면 VIEW 여러개 만들 수 있음 */
-- (관리자 계정 접속)
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE; --1) 관리자 계정으로 접속해서 이거 쓰고 실행하기
--GRANT CREATE VIEW TO 계정명;
GRANT CREATE VIEW TO KH_LIK; --2) 관리자 계정으로 접속해서 KH_LIK에게 VIEW만들 권한 부여
/**********************************************************************************************/
--아직 VIEW 생성 권한 안줬을 때 생성하려면 어떻게 될까?
CREATE VIEW V_EMP
AS SELECT EMP_ID 사번, EMP_NAME 이름, NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명
   FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
   JOIN JOB USING (JOB_CODE)
   ORDER BY 사번;
  --SELECT문의 결과인 RESULT SET을 그대로 저장하는 VIEW 객체 만들기

  -- ORA-01031: 권한이 불충분합니다
  -- VIEW는 권한이 있어야 생성할 수 있는 객체!!!!
  -- 권한 부여받으려면 관리자 계정에 접속해서 위의 1)과 2)를 해야함
  -->그 후에 VIEW 생성 구문 수행하기
  
--생성한 VIEW 조회하기
  SELECT * FROM V_EMP; --셀렉트문을 자주 봐야할 때 그 내용을 VIEW에 저장해놓고 이렇게 짧게 써서 볼 수 있다 + 그 테이블의 이름이 무엇인지 숨길 수 있다
  --VIEW 이용해서 조건식 등 원하는 것 다 할 수 있음 
  
--V_EMP 에서 대리직급 사원을 이름 오름차순으로 조회하기
  SELECT * FROM V_EMP WHERE 직급명='대리' ORDER BY 이름; --사용한 컬럼명(별칭) 그대로 써야 함!!!
  
  --VIEW 잘 쓰면 좋음!!!자주 조회해야하는 기다란 SELECT를 저장해놓고 짧게 불러와서 조회할 수 있다
----------------------------------------------------------------
  --옵션 5개 중 잘 쓰는것은 1,5번 두개임!!
  --CREATE OR REPLACE : 있으면 바꾸고 없으면 새로 만들겠다
  /*OR REPLACE 옵션 사용하기*/
  --> VIEW생성 시 같은 이름의 VIEW가 있으면 이걸로 변경하고 없으면 생성하겠다
/*DROP VIEW V_EMP; 
 * CREATE VIEW V_EMP AS; 이렇게 안하고 위 옵션 쓰면 됨*/
CREATE OR REPLACE VIEW V_EMP AS --V_EMP 이름의 VIEW존재해서 위 옵션 안쓰면 같은 이름의 객체가 있어서 생성 안되는데 옵션 사용해서 이걸로 바뀜
	SELECT EMP_ID 사번, EMP_NAME 이름, 
	NVL(DEPT_TITLE, '없음') 부서명, JOB_NAME 직급명, 
	NVL(LOCAL_NAME, '없음') 지역명
	FROM EMPLOYEE 
	NATURAL JOIN JOB
	LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
	ORDER BY EMP_ID;

SELECT * FROM V_EMP; --지역명 추가된 V_EMP로 변경됨
----------------------------------------------------------------
--VIEW도 INSERT/UPDATE/DELETE가 된다
/*WITH READ ONLY 옵션 사용하기*/

--DEPARTMENT 테이블을 복사한 DEPT_COPY2 테이블 생성하기
CREATE TABLE DEPT_COPY2 
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY2; --DEPT_TITLE컬럼만 NULL허용 상태임

--DEPT_COPY2 테이블의 DEPT_ID, LOCATION_ID 컬럼만을 이용해서 
--V_DCOPY2 VIEW생성하기
CREATE VIEW V_DCOPY2 AS
SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

SELECT * FROM V_DCOPY2; --컬럼 두개만 나옴
----------------------------------------------------------------
--뷰는 가상의 테이블이고
--뷰에 데이터 변경 시, 뷰의 데이터만 바뀔 것 같고 뷰의 원본인 테이블의 값은 그대로일 것 같지만
--뷰와 연결돼있는 진짜테이블(DEPT_COPY2)의 데이터가 바뀌는거임!!!
--V_DCOPY2 뷰를 이용해서 INSERT하기
INSERT INTO V_DCOPY2 VALUES('D0', 'L2');

--뷰에 INSERT 확인
SELECT * FROM V_DCOPY2; --제일 밑에 들어가있다

--원본테이블(DEPT_COPY2)에 INSERT 확인
SELECT * FROM DEPT_COPY2; --원본에도 들어가있고, DEPT_TITLE에 NULL허용상태여서 NULL로 들어가있음
-->VIEW에 데이터 수정 시, 원본의 데이터
--가상테이블(VIEW)은 값 저장/수정/삭제 불가!!!!!!!
-->그래서 연결된 원본이 변한다!!!!!!!!

--D0/NULL/L2 형식으로 대입된다 ->입력 안한 것은 NULL로 들어가는데 NULL은 DB에 많으면 좋지 않다
-->NULL은 DB의 무결성을 약하게 만드는 원인 (중복&NULL)
-->가능하면 NULL이 생기지 않도록 하는 것이 좋다!!!!

-->여기서 NULL이 생긴 원인 : 우리가 VIEW에 INSERT를 해서! ->VIEW에 INSERT 못하기 막아보기
----------------------------------------------------------------------
--READ ONLY 옵션
--WITH READ ONLY 옵션을 추가해서 읽기 전용으로 변경!!!

--DEPT_COPY2 테이블의 DEPT_ID, LOCATION_ID 컬럼만을 이용해서 
--V_DCOPY2 VIEW생성하기
CREATE OR REPLACE VIEW V_DCOPY2 AS --이미 같은 이름의 뷰 있으니까 있으면 변경하라는 구문
SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
WITH READ ONLY; -->VIEW에 DML(INSERT 등)할 수 없어지는 옵션

--다시 뷰를 이용해서 INSERT해보면?
INSERT INTO V_DCOPY2 VALUES('D0', 'L2'); --안됨
-- ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
--VIEW 사용 시 웬만하면 READ ONLY 옵션 넣어서 원본이 달라지는 것 막아놓기!!!!!
----------------------------------------------------------------
/* SEQUENCE(순서, 연속) : 많이 사용함
 * - 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
 *   (번호 생성기)
 * 
 * *** SEQUENCE 왜 사용할까?? ***
 * PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
 * 						 NOT NULL + UNIQUE의 의미를 가짐
 * 
 * PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용하면 좋다!
 * 테이블에 INSERT해야하는 PRIMARY KEY값을 하나하나 지정하는 게 아닌, 시퀀스를 이용해서 함
 * 
 *   [작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본 (몇 번부터 할까?)
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본 (몇씩 늘어날까?)
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1) (최대 몇까지 할까?)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승) (얘는 CYCLE(반복)때문에 있음)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정 (1~10 반복->근데 5에서부터 START한 경우 10까지 간 후 MINVALUE값으로 가서 다시 커짐)
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리(미리 만들어놓고 저장해 두는 곳) 기본값은 20바이트, 최소값은 2바이트
	-- 시퀀스의 캐시(CACHE) 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * 사용자가 100만명 단위 될 수 있어서 미리미리 만들어놓고 속도 향상시키려고 캐시메모리 만들어놓음
 * ** 사용법 **
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.
 * 						 (INCREMENT BY 만큼 증가된 수)
 * 						 단, 생성 후 처음 호출된 시퀀스인 경우
 * 						 START WITH에 작성된 값이 반환됨.
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴.
 * 						 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
 * 						== 마지막으로 호출한 NEXTVAL 값을 반환
 * */

--테스트용 테이블 생성하기
CREATE TABLE TB_TEST(--컬럼이 두개인 테이블 생성
 TEST_NO NUMBER PRIMARY KEY, --제약조건
 TEST_NAME VARCHAR2(30) NOT NULL --제약조건
);

--SEQUENCE 생성하기
--TEST_NO에 대한 SEQUENCE 생성
CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 --100번부터 시작(시작번호 100) 
--옵션 순서는 위에 적힌대로 해야함!
INCREMENT BY 5 --5씩 증가 --NEXTVAL(다음번호,다음번호,...) 호출 마다 5씩 증가한다
MAXVALUE 150 --증가 가능한 최대값 150
NOMINVALUE -- 최소값 없음
NOCYCLE -- 반복 없음 (최대값까지 증가한 후에 반복 안하겠다)
NOCACHE; --미리 생성해두는 시퀀스 번호 없음
--------------------------------------------------
--현재 시퀀스 번호 확인하기 ->CURRVAL (CURRENT VALUE) 사용!!!

--단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생. 확인해보기
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL;
--ORA-08002: 시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션(현재 접속)에서는 정의 되어 있지 않습니다
--CURRVAL가 변수같은건데 호출한 적이 없어서 아직 비어있어 == 마지막으로 호출한 NEXTVAL 값을 반환
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; --위의 것을 한 후에 이걸 실행해야 오류안남

--NEXTVAL 호출 시마다 INCREMENT BY에 작성된 값만큼 증가함
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; --105
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; --110
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; --115
SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; --120
------------------------------------------------------------------------------
--이걸 INSERT할 때 이용해보겠다
--TB_TEST 테이블 INSERT시 시퀀스 사용하기
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL , '홍길동' );--125가 나올 차례임
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL , '김영희' );--130가 나올 차례임
INSERT INTO TB_TEST VALUES(SEQ_TEST_NO.NEXTVAL , '박철수' );--135가 나올 차례임

SELECT * FROM TB_TEST;--세명 잘 들어가있음
-----------------------------------------------------------------------------
--UPDATE에도 쓸 수 있음(DELETE는 쓸 게 없음)
--TB_TEST 테이블 UPDATE시 시퀀스 사용하기
--TB_TEST에서 TEST_NO 컬럼 값이 가장 작은 컬럼 값(홍길동)을 
--다음 시퀀스 번호(140)로 변경하겠다

UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NO=(
SELECT MIN(TEST_NO) FROM TB_TEST
);

SELECT * FROM TB_TEST; --홍길동의 번호가 125->140 변경됐다
-------------------------------------------------
--한번 더 하면 영희가 145로 바뀜
UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NO=(
SELECT MIN(TEST_NO) FROM TB_TEST
);

SELECT * FROM TB_TEST; --김영희의 번호가 130->145 변경됐다
----------------------------------------------------------
-- 한 번 더!
UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NO = ( SELECT MIN(TEST_NO) FROM TB_TEST );

SELECT * FROM TB_TEST; -- 박철수 135-> 150 으로 변경


-- 한 번 더! - 오류
UPDATE TB_TEST
SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NO = ( SELECT MIN(TEST_NO) FROM TB_TEST );
--  ORA-08004: 시퀀스 SEQ_TEST_NO.NEXTVAL exceeds MAXVALUE은 
-- 사례로 될 수 없습니다
--> 시퀀스는 MAXVALUE 값을 초과해서 증가할 수 없다
--------------------------------

-- SEQUENCE 변경(ALTER)
-->CREATE 구문과 비슷하지만 START WITH 옵션만 제외됨 (만들어질 때에만 지정할 수 있고, 그 후에는 변경 불가)
/*
 [작성법] --START WITH 옵션 하나 빠짐
  ALTER SEQUENCE 시퀀스이름
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
*/	

--SEQ_TEST_NO 시퀀스의 최대값을 200으로 변경해보기
ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;

-----------------------------------------------------

-- VIEW, SEQUENCE 삭제

DROP VIEW V_DCOPY2;
DROP SEQUENCE SEQ_TEST_NO; 



------------------------------------------------------------------------
--인덱스 객체 : 테이블의 특정 컬럼에 대해서만 동작하는 객체(특정 컬럼이 더 효율적으로 움직일 수 있게 도와주는 객체)
--INSERT시 테이블에 들어가는 순서가 맘대로 랜덤으로 섞여서 들어감 -> 인덱스에서 차례로 정렬해주면 빨리 찾아갈 수 있음(JAVA에서 HASHCODE처럼) 
/* INDEX(색인)
 * - SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 
 *   컬럼에 대하여 생성하는 객체
 * 
 * - 인덱스 내부 구조는 B* 트리 형식으로 되어있음.
 * 
 * 
 * ** INDEX의 장점 **
 * - 이진 트리 형식으로 구성되어 자동 정렬 및 검색 속도 증가. ->정렬된 것을 찾는 것이 더 빠름
 * 
 * - 조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌
 *   인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에
 *   시스템의 부하가 낮아짐.
 * 
 * ** 인덱스의 단점 **
 * - 데이터 변경(INSERT,UPDATE,DELETE) 작업 시 
 * 	 이진 트리 구조에 변형이 일어남
 *    -> DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.(데이터가 들어올 때마다 다시 정렬을 해야 한다)
 * 
 * - 인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비)
 * 
 * - 인덱스 생성 시간이 필요함.
 * 
 * 
 * ----------------------------------------------------------------
 *  [작성법] : 인덱스 객체를 별도로 만드는 것인데 이건 잘 안씀!!
 *  CREATE [UNIQUE] INDEX 인덱스명
 *  ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
 * 
 *  DROP INDEX 인덱스명;
 * 
 * 
 *  ** 인덱스가 자동 생성되는 경우 **
 *  -> PK 또는 UNIQUE 제약조건이 설정된 컬럼이면 그 컬럼에 대해 
 *    UNIQUE INDEX가 자동 생성된다. ->별도로 생성하는 구문 쓸 필요 없음
 * */
--인덱스 사용 방법! -> WHERE절에 INDEX가 지정된 컬럼 언급하기! ->이걸 이용하면 인덱스를 사용해서 검색을 빠르게 할 수 있다!!!

SELECT * FROM EMPLOYEE; --인덱스 사용 X(느림)
SELECT * FROM EMPLOYEE
WHERE EMP_ID !=0; --인덱스 사용 O(빠름)
--EMP_ID에 PK설정돼있어서 자동으로 인덱스 생성됐다
--조건이 무엇이든 그냥 WHERE절에 언급돼있으면 됨
-->인덱스를 사용했지만,,,,데이터 양이 적어서 구분이 안됨 ->데이터 양 많아지면 속도 차이 느껴짐
----------------------------------------------------------------
-- 인덱스 확인용 테이블 생성
CREATE TABLE TB_IDX_TEST(
    TEST_NO NUMBER PRIMARY KEY, -- 자동으로 인덱스가 생성됨.
    TEST_ID VARCHAR2(20) NOT NULL
);
--샘플데이터 100만개 넣기 (PLSQL, 절차적 SQL, )

-- TB_IDX_TEST 테이블에 샘플데이터 100만개 삽입 (PLSQL 사용)
BEGIN
    FOR I IN 1..1000000
    LOOP 
        INSERT INTO TB_IDX_TEST VALUES( I , 'TEST' || I );
    END LOOP;
    
    COMMIT;
END;

--100만개가 다 됐는지 카운트해보기
SELECT COUNT(*) FROM TB_IDX_TEST;

--인덱스 사용 안하고 50만번째 데이터 찾아보기(인덱스 없는 컬럼을 이용해서 조회 )
SELECT * FROM TB_IDX_TEST 
WHERE TEST_ID='TEST500000';--0.04S 소요 --이 컬럼은 인덱스 지정 안된 일반 컬럼임

--인덱스 사용 O 50만번째 데이터 찾아보기(인덱스 있는 컬럼을 이용해서 조회 )=>데이터 양 많으면 인덱스 쓰는게 좋다!!!!
SELECT * FROM TB_IDX_TEST 
WHERE TEST_NO=500000; --0.007S 소요
--TEST_NO는 PK설정돼있어서 인덱스 자동 생성됨





