--SELECT EMP_NAME FROM EMPLOYEE;
/*SELECT(조회)
 * - 지정된 테이블에서 원하는 데이터를 선택해서 조회하는 SQL
 * - 작성된 구문에 맞는 행, 열 데이터가 조회됨
 * 		->조회된 결과 행의 집합 == RESULT SET(결과 집합)
 * 
 * - RESULT SET은 0행 이상이 포함될 수 있다
 * 		(조건에 맞는 행이 하나도 없을 수도 있기 때문에)
 * 
 */
/*[SELECT 작성법 -1.기초]
 * SELECT 컬럼명, 컬럼명, ...(원하는 만큼 작성 가능)
 * FROM 테이블명;
 *  -> 지정된 테이블에서 컬럼명이 일치하는 컬럼 값을 모두 조회하기
 * 
 * */
 --EMPLOYEE 테이블에서 
 --모든 행의 사번(EMP_ID), 이름(EMP_NAME), 급여(SALARY) 조회하기
 SELECT EMP_ID, EMP_NAME, SALARY
 FROM EMPLOYEE;
 
--EMPLOYEE 테이블에서 
 --모든 행의 이름(EMP_NAME), 입사일(HIRE_DATE) 조회하기
 SELECT EMP_NAME, HIRE_DATE
 FROM EMPLOYEE;
 --DB가 연월일시분초 형식으로 날짜 저장->요일 계산도 자동으로 됨(모든 시간 관련 데이터 저장)

--EMPLOYEE 테이블의 모든 행, 모든 컬럼 조회
--'모든' 의 뜻을 가지는 기호 == asterisk(*)== '모든, 포함하다'의 뜻을 지닌 기호
SELECT *
FROM EMPLOYEE;
--14개 컬럼 모두 다 라는 뜻

--DEPARTMENT 테이블의 부서코드, 부서명 조회하기
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

--DEPARTMENT 테이블의 모든 데이터 조회하기
SELECT * FROM DEPARTMENT;
------------------------------------------------------------------
/*컬럼 값 산술 연산*/
--컬럼 값 : 행과 열이 교차되는 테이블의 한 칸에 작성된 값
--SELECT문 작성 시
--컬럼명에 산술 연산을 직접 작성하면 
--조회 결과(RESULT SET)에 연산 결과가 반영되어 조회된다

--EMPLOYEE 테이블에서
--모든 사원의 이름, 급여, 급여+100만 조회해보기
SELECT EMP_NAME, SALARY, SALARY+1000000
FROM EMPLOYEE;

--EMPLOYEE 테이블에서
--모든 사원의 사번, 이름, 연봉 조회하기
SELECT EMP_ID, EMP_NAME, SALARY*12
FROM EMPLOYEE;

----------------------------------------------------
/*SYSDATE, SYSTIMESTAMP*/
--(시스템이 나타내고 있는) 현재 시간

-- SYSDATE : ms 단위는 기록하지 않음
--	(현재 시간의 연,월,일,시,분,초 조회)
-- SYSTIMESTAMP : ms 단위까지 기록 + 세계 표준시 표현(지역 설정 저장)
--	(현재 시간의 연,월,일,시,분,초,ms + 지역(local))
/*DUAL(DUmmy tAbLe) 테이블
 * dummy = 대체품(자동차 충돌 실험 시 인간 대신하는 마네킹)
 * ==>가짜 테이블(임시 테이블)
 * 	==실존하는 테이블이 아니고, 단순 데이터 조회 시 사용됨
 * 테이블에 존재하는 데이터가 아닌 테이블에 없는 데이터를 보고 싶을 때 사용
 * */
SELECT SYSDATE, SYSTIMESTAMP 
FROM DUAL;

/*날짜 데이터 연산하기 (+,-만 가능함!!)*/
--> +1 == 1일 추가
--> -1 == 1일 감소
--일 단위로 계산

--어제, 현재 시간, 내일, 모레 조회
SELECT SYSDATE-1, SYSDATE, SYSDATE+1, SYSDATE+2
FROM DUAL;

/*알아두면 도움 많이 됨(인스타 몇 분 전..)*/
--현재 시간, 한 시간 후, 1분 후, 10초 후 조회
SELECT SYSDATE, 
			SYSDATE+1/24, 
			SYSDATE +1/24/60,
			SYSDATE+1/24/60/6
FROM DUAL;

/*날짜 끼리 연산하기*/
-- 날짜-날짜 == 일 단위의 숫자 나옴
-- 1 == 1일 차이
-- 1.5 == 1일 12시간 차이

--TO_DATE('문자열', '패턴') : 
--'문자열'을 '패턴' 형태로 해석해서 DATE 타입으로 변경해주는 함수(날짜 형태로 바꿔줌)
-- '2024-02-26' ==> 'YYYY-MM-DD'로 저장해줌

/*문자열 리터럴 : '' (홑따옴표)*/
SELECT '2024-02-26', TO_DATE('2024-02-26', 'YYYY-MM-DD')
FROM DUAL;

--날짜끼리 빼는 것 해보기
--오늘-어제(24시간 차이) ==1(하루가 기준이므로)
SELECT TO_DATE('2024-02-26', 'YYYY-MM-DD')
		-TO_DATE('2024-02-25', 'YYYY-MM-DD')
		FROM DUAL;
	
--현재 시간 - 어제 0시 0분 0초 = 1.52929398148
SELECT SYSDATE-TO_DATE('2024-02-25', 'YYYY-MM-DD')
FROM DUAL;
--EMPLOYEE 테이블에서
--모든 사원의 이름, 입사일, 근무 일수(현재 시간-입사일) 조회하기
SELECT EMP_NAME, HIRE_DATE , SYSDATE-HIRE_DATE 
FROM EMPLOYEE;

-- CEIL(숫자) : 정수로 올림 처리
--현재 시간 - 내 생년월일
SELECT CEIL((SYSDATE-TO_DATE('1998-02-16', 'YYYY-MM-DD'))/365)
--한국식 나이
FROM DUAL;

--------------------------------------------------------------
--조회되는 컬럼 이름을 지정하는 '별칭'
--조회된 내용이 무엇인지 적어놓는 것
/*컬럼명 별칭 지정하기*/

-- 별칭 지정 방법						<별칭의 조건>
-- 1) 컬럼명 AS 별칭   :  문자O, 띄어쓰기 X, 특수문자 X
-- 2) 컬럼명 AS "별칭" : 	문자O, 띄어쓰기 O, 특수문자 O
-- 3) 컬럼명 별칭      : 	문자O, 띄어쓰기 X, 특수문자 X
-- 4) 컬럼명 "별칭"    :  문자O, 띄어쓰기 O, 특수문자 O

-- "" 의미
-- 1) 대/소문자 구분
-- 2) 특수문자, 띄어쓰기 인식

-- < 쌍따옴표("")의 의미 >
--HTML/JS : String("", ''모두 String을 의미) 
--JAVA : String(""만 String을 의미, ''는 char를 의미)
--DB(Oracle) : String이 아닌, "" 사이의 글자를 그대로 인식하라는 의미!!!(text의미)

--ORACLE에서 문자열(STRING)은''이다!!
-- CEIL(숫자) : 정수로 올림 처리
--현재 시간 - 내 생년월일
SELECT 
CEIL((SYSDATE-TO_DATE('1998-02-16', 'YYYY-MM-DD'))/365)AS 나이나이나이
--한국식 나이
FROM DUAL;

--EMPLOYEE 테이블에서
--사번, 사원 이름, 급여, 연봉(급여*12) 조회하기
--단, 컬럼명은 위에 작성된 그대로 조회하기
SELECT EMP_ID AS 사번,
			EMP_NAME AS "사원 이름", --띄어쓰기 있으므로 쌍따옴표 사용!
			SALARY 급여,
			SALARY*12 "연봉(급여*12)"
FROM EMPLOYEE; 
-----------------------------------------------------------------
/*연결 연산자(||)
 * 이전에는 ||는 OR 연산자였는데 여기서는 그거 아님!!
 * 연결 연산자 : 문자열 이어쓰기(JS/자바에서는 +로 연결하던 건데 여기서는 +로 안됨!!)*/
SELECT EMP_ID||EMP_NAME --200선동일 이런 식으로 두 컬럼이 붙어서 나옴
FROM EMPLOYEE;
-----------------------------------------------------------------
/*컬럼명 자리에 리터럴 직접 작성하기
 * ==>조회 결과(RESULT SET)의 모든 행에 
 * 		컬럼명 자리에 작성한 리터럴 값이 추가된다*/
SELECT EMP_NAME, SALARY, '원', 100, SYSDATE --'원' : 리터럴 값 자체
FROM EMPLOYEE;
-----------------------------------------------------------------
/*DISTINCT(별개의, 전혀 다른)
 * - 조회 결과 집합(RESULT SET)에서
 * 		지정된 컬럼의 값이 중복되는 경우
 * 		이를 한 번만 표시할 때 사용*/
--EMPLOYEE 테이블에서
--모든 사원의 부서 코드 조회하기
SELECT DEPT_CODE 
FROM EMPLOYEE; 

--EMPLOYEE 테이블에서
--사원들이 속해있는 전체 부서 코드만 조회하기(여러 번 표시하지 않음)

SELECT * FROM DEPARTMENT; --9개 부서 중 사람이 없는 부서도 있음

-- 사람이 존재하는 부서를 한번씩만 찾기(여러 명 있는 부서 한번만 찾아서 중복 제거할 때 사용)
SELECT DISTINCT DEPT_CODE 
FROM EMPLOYEE; 
-----------------------------------------------------------------
--EMPLOYEE 테이블에 존재하는
--직급 코드의 종류 조회
SELECT DISTINCT JOB_CODE  
FROM EMPLOYEE;
-----------------------------------------------------------------
--TRUE/FALSE나오는 것 이용해서 해보기(여기에 부합하는 것만 보겠다)

/******************/
/**** WHERE 절 ****/
/******************/

-- 테이블에서 조건을 충족하는 행만 조회할 때 사용
-- WHERE절에는 조건식(true/false)만 작성

-- 비교 연산자 : >, <, >=, <=, = (같다, 등호1개), (!= == <>) (같지 않다)
-- 논리 연산자 : AND, OR, NOT
-- || : 연결연산자!

--[전체 절 6가지]
--SELECT절
--FROM절 (JOIN)
--WHERE절
--GROUP BY절
--HAVING절
--ORDER BY절

--프로젝트 시 어떻게 쓰느냐에 따라 코드 길이 달라짐
/* [SELECT 작성법 - 2]
 * 
 * SELECT 컬럼명, 컬럼명, ...
 * FROM 테이블명
 * WHERE 조건식; --특정 행에서만 검색
 * -> 지정된 테이블 모든 행에서 
 *   컬럼명이 일치하는 컬럼 값 조회
 * */


--EMPLOYEE 테이블에서 SALARY 컬럼만 봐서 300만원 초과하는 행만 선택하겠다
--급여가 300만원을 초과하는 사원의 
--사번, 이름, 급여, 부서 코드 조회하기
/*해석 순서!!!*/
/*3*/ SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE --해당 컬럼만 보기
/*1*/FROM EMPLOYEE --이 테이블에서
/*2*/WHERE SALARY>3000000; --이걸 만족하는 행을 찾아서
/*FROM절로 지정된 테이블에서 
 * WHERE절로 조건에 맞는 행을 먼저 추려내고 추려진 결과 행들 중에서 
 * SELECT절에 원하는 컬럼만 조회하기
 */
---------------------------------------------------------------
--EMPLOYEE 테이블에서 연봉이 5천만원 이하인 사원의
--사번, 이름, 연봉 조회하기
SELECT DEPT_CODE, EMP_NAME, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY*12<=50000000;
---------------------------------------------------------------
--EMPLOYEE테이블에서
--부서코드가 'D9'이 아닌 사원의
--이름, 부서코드, 전화번호 조회
SELECT EMP_NAME "이름", DEPT_CODE "부서코드", PHONE "전화번호"
FROM EMPLOYEE
WHERE DEPT_CODE <>'D9';
---------------------------------------------------------------
--EMPLOYEE테이블에서
--부서코드가 'D9'인 사원의
--이름, 부서코드, 전화번호 조회
SELECT EMP_NAME "이름", DEPT_CODE "부서코드", PHONE "전화번호"
FROM EMPLOYEE
WHERE DEPT_CODE ='D9';
--둘의 합은 21명인데 전체 사원수는 23명!!두명은 왜 증발했을까? 그들이 NULL이어서
--------------------------------------------------------
/*NULL 비교하기*/
-- 컬럼명 = NULL (X)
-- 컬럼명 != NULL (X)
-- => =, !=, < 등의 비교연산자는 '값'을 비교하는 연산자이기 때문이다!!!!
--근데 DB에서 NULL은 참조하지 않는다는 값이 아닌, 그냥 진짜 빈칸으로 비어있다는 표시임
--		(저장된 값이 없다라는 의미!!! -> 빈칸인지 아닌지 검사하는 함수를 써야 함!!!)

--컬럼명 IS NULL / 컬럼명 IS NOT NULL (O)
-- ==컬럼 값이 존재하지 않는 경우 / 존재하는 경우 
--EMPLOYEE 테이블에서 DEPT_CODE가 없는 사원만 조회하기
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL; --2행/23행
----------------------------------------------------------------
--EMPLOYEE 테이블에서 DEPT_CODE가 있는 사원만 조회하기
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;--21행/23행
----------------------------------------------------------------
/*논리 연산자 사용해보기(AND, OR)*/
/*NOT : 논리 부정 연산자*/
--EMPLOYEE 테이블에서
--부서 코드가 'D6'인 사원 중
--급여가 300만을 초과하는 사원의
--이름, 부서코드, 급여 조회
SELECT EMP_NAME , DEPT_CODE , SALARY
FROM EMPLOYEE 
WHERE DEPT_CODE ='D6' AND SALARY>3000000; --두 조건이 모두 참이어야 함
--자바였다면 List<Employee> 
----------------------------------------------------------------
--EMPLOYEE테이블에서
--급여가 300만 이상, 500만 이하인 사원의
--사번, 이름, 급여 조회하기
SELECT EMP_ID ,EMP_NAME , SALARY
FROM EMPLOYEE
WHERE SALARY>=3000000 AND SALARY<=5000000; --6행
----------------------------------------------------------------
--EMPLOYEE테이블에서
--급여가 300만 미만이거나 또는 500만 초과인 사원의(위와 반대 범위)
--사번, 이름, 급여 조회하기
SELECT EMP_ID ,EMP_NAME , SALARY
FROM EMPLOYEE
WHERE SALARY<3000000 OR SALARY>5000000; --17행
----------------------------------------------------------------











