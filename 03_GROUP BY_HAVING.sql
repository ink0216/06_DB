/* SELECT문 해석 순서
  5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
  1 : FROM 참조할 테이블명
  2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
  3 : GROUP BY 그룹을 묶을 컬럼명
  4 : HAVING 그룹함수식 비교연산자 비교값
  6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST | LAST];
*/
-----------------------------------------------------------------------------------------------------------------------------------------
-- * GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을
--              하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ....
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러 개일 경우 오류 발생
-- 여러 개의 결과 값을 산출하기 위해 그룹 함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용


-------------------------------------------------------------------------
-- EMPLOYEE 테이블에서 부서코드, 부서(그룹) 별 급여 합계 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--GROUP BY 절을 쓰는 순간
--각각의 DEPT_CODE에 따라 각각의 그룹으로 묶임
--D9인 그룹, D6인 그룹, ...
--그룹함수 : 그룹 별로 함수가 적용된다
--그룹들 마다의 합계가 나오는데 그룹의 개수는 7개이므로 7행의 결과가 나옴 
--EMPLOYEE 테이블에서
--DEPT_CODE 컬럼 값이 같은 행들끼리 각각의 그룹으로 묶음
--각각의 그룹 별로 그룹함수(SUM 연산)이 적용돼서 수행됨
--DEPT_CODE : 묶인 그룹 이름
------------------------------------------------------------------------
-- EMPLOYEE 테이블에서 
-- 부서코드, 부서 별 급여의 합계, 부서 별 급여의 평균(정수처리, FLOOR), 인원 수를 조회하고 
-- 부서 코드 순으로 정렬
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE 
ORDER BY DEPT_CODE;
--그룹함수 : SUM, AVG, COUNT, MIN , MAX
-------------------------------------------------------------------------
-- EMPLOYEE 테이블에서 
-- 부서코드와 부서별 보너스를 받는 사원의 수를 조회하고 
-- 부서코드 순으로 정렬
--해석 순서때문에 두 방법이 행의 개수가 다름
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL --보너스를 받는 사람
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE; --6행
--EMPLOYEE 테이블에서
--보너스를 받는 사람들만 찾아서(여기서 "보너스 안받는 사람"들은 걸러짐)
--그 사람들을 부서코드 별로 묶고
--부서코드와 카운트 세기
--정렬
--방법 두번째 : COUNT(BONUS) 안에 컬럼명 그냥 쓰면 BONUS컬럼 값이 NULL인것은 자동으로 안 셈
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;--7행
--WHERE절이 없으니까 23행 전체를 그룹화해서 7개 부서 만듦 
--> 카운트 하다보니까 D2는 보너스 받는 사람 없더라
--EMPLOYEE테이블에서
--일단 부서코드별로 묶기->7가지(6가지 부서코드 + NULL인 부서코드)
--그 후에 그룹별로 부서코드랑 보너스가 NULL이 아닌 사람들의 수를 센다->D2에는 보너스 사람 없어서 0나옴
--정렬
-------------------------------------------------------------------------


-- EMPLOYEE 테이블에서
-- 성별과 성별 별 급여 평균(정수처리), 급여 합계, 인원 수 조회하고
-- 인원수로 내림차순 정렬
SELECT 
DECODE(SUBSTR(EMP_NO,8,1),'1','남성','2','여성') 성별
, FLOOR(AVG(SALARY)) "급여 평균"
, SUM(SALARY) "급여 합계"
, COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8,1)--SELECT절의 SUBSTR구문 그대로 쓰는 경우 성별이라고 못씀
ORDER BY COUNT(*) DESC;


-- * WHERE절 GROUP BY절을 혼합하여 사용
--> WHERE절은 각 컬럼 값에 대한 조건 (SELECT문 해석 순서를 잘 기억하는 것이 중요!!)


-- EMPLOYEE 테이블에서 부서코드가 'D5', 'D6'인 부서의 평균 급여 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5', 'D6')--9행으로 추리기
GROUP BY DEPT_CODE;--9행을 두 그룹으로 만들기

-- EMPLOYEE 테이블에서 직급 별 2000년도 이후 입사자들의 급여 합을 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
--WHERE HIRE_DATE >=TO_DATE('2000-01-01', 'YYYY-MM-DD'):이걸로 해도 되는듯!!
WHERE EXTRACT(YEAR FROM HIRE_DATE)>=2000
GROUP BY JOB_CODE;


------------------------------------------------------------------------
-- * 여러 컬럼을 묶어서 그룹으로 지정 가능
-- *** GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
--  SELECT절에 명시한 조회하려는 컬럼 중
--  그룹함수가 적용되지 않은 컬럼은
--  모두 GROUP BY절에 작성되어 있어야함!!!->안그러면 오류남
-->왜?->DEPT_CODE는 그걸로 묶여서 7행이 나오는데, 
--JOB_CODE는 그걸로 묶이지 않아서 7행이 안 나와서 행의 개수 안맞아서 오류남

--ORDER BY절에서 부서코드로 크게 정렬해놓고 그 안에서 다른 것으로 그 안에서 정렬하고
--또 그 안에서도 다른 것으로 그 안에서 정렬
--GROUP BY도 똑같이 크게 두 개로 그룹 나누고, 그 안에서 또 앞/뒤로 나누고,,, 할 수 있다

-- EMPLOYEE 테이블에서 부서 별로 같은 직급인 사원의 급여 합계를 조회하고
-- 부서 코드 오름차순으로 정렬
--이 순서대로 묶으면 됨
SELECT DEPT_CODE , JOB_CODE, COUNT(*), SUM(SALARY) "급여 합계"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE ;

-- EMPLOYEE 테이블에서 부서 별로 급여 등급이 같은 직원의 수를 조회하고
-- 부서코드, 급여 등급 오름차순으로 정렬
SELECT DEPT_CODE, SAL_LEVEL, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, SAL_LEVEL 
ORDER BY DEPT_CODE , SAL_LEVEL;
--------------------------------------------------------------------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 "그룹에 대한 조건"을 설정할 때 사용
--			행이 아닌, 그룹을 지은 후에 어떠한 그룹만 조회하겠다 하고 그룹을 조건으로 뽑아내는 것
-- HAVING : 그룹에 대한 조건
-- WHERE : 행에 대한 조건
--WHERE절 : WHERE절 조건으로, 지정된 전체 테이블에서 원하는 행들 골라내는 역할
--					지정된 테이블에서 어떤 행만을 조회 결과로 삼을건지 조건을 지정하는 구문
--					(테이블 내에 특정 행만 뽑아서 쓰겠다는 조건문)

-- HAVING 컬럼명 | 함수식 비교연산자 비교값

-- 부서별 평균가 급여 3000000원 이상인 부서를 조회하여 부서코드 오름차순으로 정렬
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
--WHERE SALARY>=3000000 --급여가 300만 이상인 행(사원)만 조회하겠다
GROUP BY DEPT_CODE 
HAVING AVG(SALARY)>=3000000 --그룹 급여 평균이 300만 이상인 그룹만 조회하겠다
ORDER BY DEPT_CODE;
/*SELECT DEPT_CODE , AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; : 부서별 평균급여 확인용*/


-- 부서별 그룹의 급여 합계 중 9백만원을 초과하는 부서코드와 급여 합계 조회
-- 부서 코드 순으로 정렬
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE 
HAVING SUM(SALARY)>9000000
ORDER BY DEPT_CODE;



                      
------ 연습 문제 ------

-- 1. EMPLOYEE 테이블에서 각 부서별 가장 높은 급여, 가장 낮은 급여를 조회하여
-- 부서 코드 오름차순으로 정렬하세요.
SELECT DEPT_CODE, MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE 
ORDER BY DEPT_CODE;


-- 2.EMPLOYEE 테이블에서 각 직급별 보너스를 받는 사원의 수를 조회하여
-- 직급코드 오름차순으로 정렬하세요
SELECT JOB_CODE , COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY JOB_CODE;
--COUNT(*) : 각 직급별로 인원수


-- 3.EMPLOYEE 테이블에서 
-- 부서별 70년대생의 급여 평균이 300만 이상인 부서를 조회하여
-- 부서 코드 오름차순으로 정렬하세요
SELECT DEPT_CODE, AVG(SALARY) "급여 평균"
FROM EMPLOYEE
--WHERE TO_NUMBER(SUBSTR(EMP_NO,1,2)) BETWEEN 70 AND 79 
WHERE SUBSTR(EMP_NO,1,1)='7' --한 자리 잘랐을 때 그 숫자가 7이면 70년대생!!
GROUP BY DEPT_CODE
HAVING AVG(SALARY)>=3000000
ORDER BY DEPT_CODE; 
--------------------------------------------------------------------------------------------------------------                     

-- 집계함수(ROLLUP, CUBE) : 쓸 일 거의 없음(SQLD 자격증에서만 나옴)
-- 그룹 별 산출한 결과 값의 집계를 계산하는 함수
-- GOURP BY 절에만 작성하는 함수


-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
--	중간중간에 그룹별 합계를 구한다
-- 그룹별로 묶여진 값에 대한 '중간 집계'와 '총 집계'를 계산하여 자동으로 추가하는 함수
-- * 인자로 전달받은 그룹중에서 가장 먼저 지정한 그룹별 합계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서 
-- 각 부서에 소속된 직급 별 급여합, 
-- 부서 별 급여 합,
-- 전체 직원 급여 총합 조회

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;
--중간중간마다 각 부서의 총 합이 껴있음
--맨 마지막에는 총 인원의 총 합이 있음


------------------------------------------------


-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수이다.
-- * 그룹으로 지정된 모든 그룹에 대한 집계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서 각 부서 마다 직급별 급여합,
-- 부서 전체 급여 합,

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;
--중간집계하는것은 ROLLUP이랑 똑같은데 마지막에 

-- ROLLUP 결과에 아래 두 SQL문의 결과가 추가됨
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE; --각 직급별 급여합 구하기

---------------------------------------------------------------------------------------------------------------------------------
-- * SET OPERATION(집합 연산)
-- 여러 개의 SELECT 결과물을 하나의 쿼리로 만드는 연산자
-- 여러가지의 조건이 있을 때 그에 해당하는 여러개의 결과값을 결합시키고 싶을때 사용
-- 초보자들이 사용하기 쉽다.(조건들을 어떻게 엮어야 되는지 덜 생각해도 되니깐)
-- (주의) 집합 연산에 사용되는 SELECT문은 SELECT절이 동일해야함

-- UNION은 OR 같은 개념 (합집합) --> 중복 제거
-- INTERSECT는 AND 같은 개념 (교집합)
-- UNION ALL은 OR 결과 값에 AND 결과값이 더해진거(합집합 + 교집합) --> 중복 미제거
-- MINUS는 차집합 개념 


-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- 중복된 영역을 제외하여 하나로 합친다.
------------------------------------------------------------------------
-- 부서코드가 'D5' 또는 'D6'인 사원 이름, 부서코드 조회
-- 부서코드가 'D5' 조회 : 6행
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' --결과집합 하나

UNION
-- 부서코드가 'D6' 조회 : 3행
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE ='D6';--결과집합 하나(6+3=9행)
------------------------------------------------------------------------

-- INTERSECT : 여러개의 SELECT한 결과에서 공통 부분만 결과로 추출 (교집합)

-- 부서코드가 'D5' 이면서 급여가 300만 초과하는 사원의
-- 이름, 부서코드, 급여 조회

-- 부서코드가 'D5' 조회 : 6행
SELECT EMP_NAME , DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' --결과집합 하나

INTERSECT

-- 급여가 300만 초과하는 사원 : 8행
SELECT EMP_NAME , DEPT_CODE, SALARY 
FROM EMPLOYEE 
WHERE SALARY>3000000;

--두 집합에서 겹치는 사람 두명 나옴(교집합=2)

------------------------------------------------------------------------
-- UNION ALL : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- UNION과의 차이점은 중복영역을 모두 포함시킨다. (합집합 +  교집합)

-- 부서코드가 'D5' 이거나 급여가 300만 초과하는 사원의
-- 이름, 부서코드, 급여 조회 (중복 포함)

-- 부서코드가 'D5' 조회 : 6행
SELECT EMP_NAME , DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' --결과집합 하나

UNION ALL --중복되는 거 있어도 하나로 안합치고, 두번 쓰기 : 14행

-- 급여가 300만 초과하는 사원 : 8행
SELECT EMP_NAME , DEPT_CODE, SALARY 
FROM EMPLOYEE 
WHERE SALARY>3000000;
------------------------------------------------------------------------
-- MINUS : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분만 추출
--(차집합)
-- 부서 코드 D5 중 급여가 300만 초과인 직원 제외
SELECT EMP_NAME , SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'

MINUS

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY>3000000;
---------------------------------------------------------------------
-- 집합 연산자 실제 사용 예시

-- * 집합 연산자 사용 시
--   컬럼의 타입만 일치하면 연산 수행이 가능하다 *

--사번이 200번인 사람의 이름(문자열), SALARY(숫자)
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE EMP_ID = 200

UNION 

--PHONE(문자열), 1000000(숫자)
SELECT PHONE, 1000000 FROM EMPLOYEE
WHERE EMP_ID = 201

UNION 

--홍길동(문자열), 4000000(숫자)
SELECT '홍길동', 4000000 FROM DUAL;

--조회된 결과의 타입 순서가 같다면 전혀 관련 없는 것도 묶어서 한 표에 볼 수 있다!!!!!
--문자열, 숫자 순서임
