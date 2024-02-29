/*
    * SUBQUERY (서브쿼리) : 아무 문에서나 다 쓸 수 있다
    - 하나의 SQL문 안에 포함된 또다른 SQL문
    - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
    -- SELECT, FROM, WHERE, HAVING 절에서 사용가능

*/  

-- 서브쿼리 예시 1.
-- 부서코드가 노옹철사원과 같은 소속의 직원의 
-- 이름, 부서코드 조회하기

-- 1) 사원명이 노옹철인 사람의 부서코드 조회
SELECT DEPT_CODE 
FROM EMPLOYEE 
WHERE EMP_NAME ='노옹철';--홑따옴표가 문자열임

-- 2) 부서코드가 D9인 직원을 조회
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE ='D9';

-- 3) 부서코드가 노옹철사원과 같은 소속의 직원 명단 조회   
--> 위의 2개의 단계를 하나의 쿼리로!!! --> 1) 쿼리문을 서브쿼리로!!
--1번 조회의 결과인 'D9'를 2번의 조건으로 집어넣음
-->1번 결과를 도출했던 전체 세 식을 2번의 WHERE문에 집어넣기!!
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE =(
										SELECT DEPT_CODE 
										FROM EMPLOYEE 
										WHERE EMP_NAME ='노옹철' --'D9'이 결과로 나옴
);
------메인쿼리------///-------서브쿼리-----------

--최종 결과를 만드는, 밖의 쿼리가 메인쿼리
--메인쿼리를 만들 때 사용되는 작은 쿼리가 서브쿼리!!
                   
--서브쿼리가 소괄호로 씌워져있어서 우선순위 높아서 서브쿼리가 메인쿼리보다 더 먼저 수행됨 
--서브쿼리를 메인쿼리의 소괄호 안에 넣을 때에는 서브쿼리 마지막에 세미콜론 없어야 함! 
--메인쿼리 안에 있는 서브쿼리만 실행해보고싶으면 마우스로 드래그해서 블럭치고 CTRL ENTER하면 됨        
---------------------------------------------------------------------------                 
-- 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기
SELECT AVG(SALARY)
FROM EMPLOYEE;


-- 2) 직원들중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID , EMP_NAME ,JOB_CODE , SALARY
FROM EMPLOYEE
WHERE SALARY>=3047663;

-- 3) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원 조회
--> 위의 2단계를 하나의 쿼리로 가능하다!! --> 1) 쿼리문을 서브쿼리로!!
SELECT EMP_ID , EMP_NAME ,JOB_CODE , SALARY
FROM EMPLOYEE
WHERE SALARY>=(
								SELECT AVG(SALARY)
									FROM EMPLOYEE
);
-------------------------------------------------------------------

/*  서브쿼리 유형 (N : 자연수)

    - 단일행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 (결과가 1개 행만 나오는 것)
    	(1행 1열)
    
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
    	(N행 1열)
    	
    - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 자열된 항목수가 여러개 일 때
    	(1행 N열)
    	
    - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때 
    	(N행 N열)
    	
    	
    - 이제 어려운 것 두개
    - 상관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때 
                     메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
                     
    - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
    
   * 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름
    
*/


-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY) ->1행 1열
--    서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교 연산자 사용
--    <, >, <=, >=, =, !=/^=/<>

-------------------------------------------------------------------------------
-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회
SELECT EMP_NAME ,JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY>(SELECT AVG(SALARY) FROM EMPLOYEE) --평균급여 나옴
ORDER BY JOB_CODE;
-------------------------------------------------------------------------------
-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급명, 부서코드, 급여, 입사일을 조회
SELECT EMP_ID , EMP_NAME , JOB_NAME, DEPT_CODE , SALARY, HIRE_DATE 
FROM EMPLOYEE 
NATURAL JOIN JOB
--NATURAL JOIN(자연 조인) : 컬럼명, 타입 일치하는 컬럼끼리 자동으로 연결해주는 것
--똑같은 컬럼을 찾아서 이용해서 조인 
WHERE SALARY=(SELECT MIN(SALARY) FROM EMPLOYEE);
--가장 적은 급여를 조회해서 그 값과 같은 SALARY 가지는 사원을 찾으면 됨
-------------------------------------------------------------------------------
-- 노옹철 사원의 급여보다 많이 받는 직원의 
-- 사번, 이름, 부서, 직급, 급여를 조회 -->노홍철의 급여를 조회해서 그거보다 더 많이 받는 사람 조회
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SALARY > 
  (SELECT SALARY
	FROM EMPLOYEE
	WHERE EMP_NAME='노옹철');
        
--------------------------------------------------------------------------------
-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계를 조회 

-- 1) 부서별 급여 합 중 가장 큰값 조회
SELECT  MAX(SUM(SALARY))
FROM EMPLOYEE 
GROUP BY DEPT_CODE;



-- 2) 부서별 급여합이 17700000인 부서의 부서명과 급여 합 조회
SELECT DEPT_TITLE , SUM(SALARY)
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY)=17700000; --17700000이게 1번의 결과임
--DEPT_TITLE, DEPT_CODE, DEPT_NAME중 아무거나로 GROUP BY 해도 됨
-- 3) >> 위의 두 서브쿼리 합쳐 부서별 급여 합이 큰 부서의 부서명, 급여 합 조회
SELECT DEPT_TITLE , SUM(SALARY)--메인커리
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY)=(
	SELECT  MAX(SUM(SALARY))
	FROM EMPLOYEE 
	GROUP BY DEPT_CODE --서브쿼리
);
------------------------------------------------------------------------
--부서별 인원 수가 3명 이상인 부서의 
--부서명D, 인원 수E 조회하기 --이건 서브쿼리 문제 아님
SELECT NVL(DEPT_TITLE, '없음') "부서명" , COUNT(*) "인원 수"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)--이 두개의 순서 바뀌어도 상관없음
--																						(DEPT_ID=DEPT_CODE)
GROUP BY DEPT_TITLE 
HAVING COUNT(*)>=3;
                      
------------------------------------------------------------------------
--부서별 인원 수가 가장 적은 부서의 
--부서명D, 인원 수E 조회하기 --이건 서브쿼리문제임                
SELECT NVL(DEPT_TITLE, '없음') "부서명" , COUNT(*) "인원 수"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)--이 두개의 순서 바뀌어도 상관없음
--																						(DEPT_ID=DEPT_CODE)
GROUP BY DEPT_TITLE 
HAVING COUNT(*)=(SELECT MIN(COUNT(*)) FROM EMPLOYEE GROUP BY DEPT_CODE);
--부서 없는 사람이 있는 부서가, 인원수가 가장 적은 부서이다
-------------------------------------------------------------------------

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY) ->N행 1열 ->IN / ANY / ALL 연산자 사용가능
--    서브쿼리의 조회 결과 값의 개수가 여러행일 때 

/*
    >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 x
    
    - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
                    혹은 없다면 이라는 의미(가장 많이 사용!)
                    IN(서브쿼리)
                    IN(A,B,C,D)
    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
                     
    - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
                     가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
    - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
    
*/
-------------------------------------------------------------------------------
-- 부서별 최고 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회
--1) 부서별 최고 급여 조회하기
SELECT MAX(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE;
/*SELECT MAX(SALARY) FROM EMPLOYEE : 전체 사원 중 최고급여 조회됨*/

--2) 부서별 최고 급여 받는 직원 조회
SELECT EMP_NAME , JOB_CODE, DEPT_CODE , SALARY
FROM EMPLOYEE
WHERE SALARY IN (
	SELECT MAX(SALARY)
	FROM EMPLOYEE 
	GROUP BY DEPT_CODE
); --IN 내부 서브쿼리 결과 7행 ->다중행 서브쿼리

-------------------------------------------------------------------------------
-- 사수에 해당하는 직원(누군가의 사수인 직원)에 대해 조회 
--  사번, 이름, 부서명, 직급명, 구분(사수 / 직원)

-- 1) 사수에 해당하는 사원 번호 조회--서브쿼리
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급명 조회 --메인쿼리
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE);
--여기서는 JOIN의 순서 중요하지 않음!

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (이때, 구분은 '사수'로)
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN ( --EMP-ID가 MANAGER ID와 같은 사람
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
);--6명이 지금 누군가의 사수 역할을 하고있다

-- 4) 일반 직원에 해당하는 사원들 정보 조회 (이때, 구분은 '사원'으로)
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN ( --EMP-ID가 MANAGER ID가 아닌 사람
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
); --17행
--3번과 4번의 사람들 합치면 전체 사람들 됨
 

-- 5) 3, 4의 조회 결과를 하나로 합치고싶다 -> SELECT절 SUBQUERY
-- * SELECT 절에도 서브쿼리 사용할 수 있음
-- 누구는 사원, 누구는 사수 ,...
-->방법 1 ) 집합 연산(UNION, UNION ALL)이용(합집합)
 SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN ( --EMP-ID가 MANAGER ID와 같은 사람
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
) --3번 그대로 복사
UNION /*ALL -> 이때에는 두 집합의 교집합 없어서 UNION이나 UNION ALL이나 동일*/
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN ( --EMP-ID가 MANAGER ID가 아닌 사람
	SELECT DISTINCT MANAGER_ID
	FROM EMPLOYEE
	WHERE MANAGER_ID IS NOT NULL
);--4번 그대로 복사
-->방법 2) 선택 함수(DECODE(딱딱 떨어질 때 사용 가능), CASE(언제든 쓸 수 있음))
--근데 DECODE쓰면 각 경우를 다 정해야 해서 부적합
SELECT EMP_ID , EMP_NAME , DEPT_TITLE, JOB_NAME, 
	CASE --WHEN THEN ELSE 구문임! --"구분"이라는 한 컬럼을 만듦
		WHEN EMP_ID IN (
			SELECT DISTINCT MANAGER_ID
			FROM EMPLOYEE
			WHERE MANAGER_ID IS NOT NULL
		)
		THEN '사수' --저 괄호 안에 있으면 '사원'이라고 하겠다
		ELSE '사원' --저 괄호 안이 아니면 '사원'이라고 하겠다
	END "구분"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
ORDER BY EMP_ID; 

-------------------------------------------------------------------------------
-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- > 과장들 중에 가장 적게 받는 과장을 먼저 찾고
-- 그 과장보다 더 많이 받는 대리 조회
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요

-- > ANY, < ANY : 여러개의 결과값 중에서 하나라도 큰 / 작은 경우
--                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가? =>그러면 결과에 포함시킴
--																													아니면 결과에서 제외시킴

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID , EMP_NAME , JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='대리'; --6명

-- 2) 직급이 과장인 직원들 급여 조회
SELECT SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='과장';

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원
-- 3-1) MIN을 이용하여 단일행 서브쿼리를 만듦.
SELECT EMP_ID , EMP_NAME , JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='대리'
AND SALARY >(
	SELECT MIN(SALARY)
	FROM EMPLOYEE 
	JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME='과장'
);

-- 3-2) ANY를 이용하여 과장 중 가장 급여가 적은 직원 초과하는 대리를 조회
SELECT EMP_ID , EMP_NAME , JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='대리'
AND SALARY > ANY( --여기 있는 것중에 아무거나 뽑은 것 보다 크면 통과
	SELECT SALARY --220만, 250만, 376만
	FROM EMPLOYEE 
	JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME='과장'
);
--255만이 저 세 숫자들 중 어느 하나보다 크면 통과돼서 결과에 포함됨
--200만이 저 세 숫자들 중 어느 것보다도 크지 않으므로 결과에서 제외

--240만이라면 220만보다 크므로, 대리가 어느 과장보다 더 많이받는 것이므로 결과에 포함됨

------------------------------------------------------------------------------


-- > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
--                     가장 큰 값 보다 크냐? / 가장 작은 값 보다 작냐?
-- 여러 개 나온 것 전체보다 모두 커야 통과(결과에 포함), 여러개 중 하나라도 만족 안되면 결과에 포함 안됨 
---------------------------------------------------------------------------------
-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 직원 찾기
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연산자를 사용하세요

--우선 과장 찾는 메인쿼리
SELECT EMP_ID , EMP_NAME , JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='과장'
AND SALARY > ALL (
--서브쿼리에서 차장 찾기 하면 됨 ->차장들의 모든 급여가 나옴
	SELECT SALARY 
	FROM EMPLOYEE 
	JOIN JOB USING (JOB_CODE)
	WHERE JOB_NAME='차장'
);--결과 모두 보다 더 큰 SALARY 가지는 과장만 조회
----------------------------------------------------------------------------------------
-- 서브쿼리 중첩 사용(응용편!) ----이거 다시보기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!(코드확인)


-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.

-- 1) LOCATION 테이블을 통해 NATIONAL_CODE가 KO인 LOCAL_CODE 조회
SELECT LOCAL_CODE  
FROM LOCATION
WHERE NATIONAL_CODE ='KO'; --'L1'이라는 1행 1열 나옴 ->단일행 서브쿼리!!!!!!!!!!!!


-- 2)DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고 있는 DEPT_ID를 조회
SELECT DEPT_ID 
FROM DEPARTMENT
WHERE LOCATION_ID = ( --L1과 동일한 것 찾기
	SELECT LOCAL_CODE  
	FROM LOCATION
	WHERE NATIONAL_CODE ='KO' --5행 ->다중행 서브쿼리!!!!!!!!!!!!!!!!!!!!!!
);


-- 3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가지는 사원을 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN (
	SELECT DEPT_ID 
	FROM DEPARTMENT
	WHERE LOCATION_ID = ( --L1과 동일한 것 찾기
		SELECT LOCAL_CODE  
		FROM LOCATION
		WHERE NATIONAL_CODE ='KO' --5행 ->다중행 서브쿼리!!!!!!!!!!!!!!!!!!!!!!
)
);
-----------------------------------------------------------------------

-- 3. 다중열 서브쿼리 (단일행 = 결과값은 한 행) ->1행 N열
--    서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회        

-- 1) 퇴사한 여직원 조회
SELECT EMP_NAME, DEPT_CODE ,JOB_CODE
FROM EMPLOYEE 
WHERE ENT_YN='Y' --퇴사 여부가 Y이면서
AND SUBSTR(EMP_NO,8,1)='2';--여직원
--퇴사 여부는 EMPLOYEE테이블의 ENT_YN이 퇴직 여부 나타냄 N : 퇴직 안했어//Y : 퇴직했어

--결과 : 
-- 이태림 D8 J6

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 (다중 열 서브쿼리)
-- 단일행 서브쿼리 이용
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y' -- 퇴사 여부 'Y'
	AND SUBSTR(EMP_NO,8,1) = '2'
)
AND JOB_CODE = (
	SELECT JOB_CODE
	FROM EMPLOYEE
	WHERE ENT_YN = 'Y' -- 퇴사 여부 'Y'
	AND SUBSTR(EMP_NO,8,1) = '2'
);                      

--다중 열 서브쿼리 이용
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE 
FROM EMPLOYEE
--DEPT_CODE , JOB_CODE  이 두개를 비교해보고싶음
WHERE (DEPT_CODE , JOB_CODE) = (
--비교할 값 두개를 원한다
-->서브쿼리도 두 값이 한번에 나와야 함
SELECT DEPT_CODE ,JOB_CODE
FROM EMPLOYEE 
WHERE ENT_YN='Y' --퇴사 여부가 Y이면서
AND SUBSTR(EMP_NO,8,1)='2' --D8  J6
); --값을 비교할 때 하나씩 비교하는 것이 아닌, 여러 값을 묶음으로 묶어서 묶음 전체의 값이 각각 같은지 비교하는 것
-- 			==다중 열 서브쿼리

-------------------------- 연습문제 -------------------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE , DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) = (
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE 
WHERE EMP_NAME='노옹철'
)
--노옹철 빼고 조회
AND EMP_NAME !='노옹철';


-- 2. 2000년도에 입사E한 사원의 부서E와 직급E이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE , JOB_CODE , HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE , JOB_CODE)= (
	SELECT DEPT_CODE , JOB_CODE  
	FROM EMPLOYEE 
	WHERE EXTRACT(YEAR FROM HIRE_DATE)=2000
);

-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일     
SELECT EMP_ID , EMP_NAME, DEPT_CODE , MANAGER_ID , EMP_NO , HIRE_DATE  
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID)=(
SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE 
WHERE SUBSTR(EMP_NO,1,2)='77'
AND 
SUBSTR(EMP_NO,8,1)='2'
);
----------------------------------------------------------------------
--다중행 ->
-- 4. 다중행 다중열 서브쿼리 ->(COL,COL) IN (서브쿼리, 이 서브쿼리가 다중행 다중열이 나와야 한다)
--    서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -4)    

-- 1) 급여를 200, 600만 받는 직원 (200만, 600만이 평균급여라 생각 할 경우)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY IN (2000000, 6000000);

-- 2) 직급별 평균 급여
SELECT JOB_CODE,TRUNC(AVG(SALARY),-4)
FROM EMPLOYEE 
GROUP BY JOB_CODE;

--  1  2  3  4 5 . 6 7
-- -4 -3 -2 -1 0   1 2
-- 3) 본인 직급의 평균 급여를 받고 있는 직원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE (JOB_CODE, SALARY) IN (
	SELECT JOB_CODE,TRUNC(AVG(SALARY),-4)
	FROM EMPLOYEE 
	GROUP BY JOB_CODE --7행 2열
);
-------------------------------------------------------------------------------
-- 이전에는 서브쿼리를 먼저 수행한 후 메인쿼리를 수행했는데
-- 상관커리에서는 메인커리가 더 먼저 수행되고 서브쿼리가 나중에 수행됨

-- 5. 상[호연]관 서브쿼리 : 매우어렵!!!!!!!!!!!!!!근데 필요!!!!!!!!!!!!!!!!!!!!!!!!!!!
--    상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
--    메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조임

-- ***************************************************************
-- ***************************************************************
-- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고(수행하고)
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함
-- ***************************************************************
-- ***************************************************************
---------------------------------------------------------------------------------------
-- 직급별 급여 평균보다 급여를 많이 받는 직원의 
-- 이름, 직급코드, 급여 조회
-- 모든 사람들을 조회해서 그 JOB_CODE의 평균보다 많이 받는 직원만 결과에 포함시키기
-- 한 행씩 JOB_CODE를 읽고, JOB_CODE의 평균이 얼마인지 보러갔다가 SALARY로 다시 돌아와서 큰지 작은지 비교
-- 이걸 23행을 하나씩 다 해야함
-- 메인쿼리에서 서브쿼리 갔다가 다시 메인쿼리로 돌아오는 것을 23번 해야 함 한명씩 다
/* 1) 메인 쿼리 1행에서, 필요한 값을 서브쿼리로 전달함(위의 경우 JOB_CODE)
 * 2) 서브쿼리에서 전달 받은 값을 이용해서 SELECT를 수행함
 * 		->SELECT 결과를 다시 메인쿼리로 반환해줌
 * 3) 메인 쿼리에서, 서브쿼리로부터 반환 받은 값을 이용해
 * 		해당 행의 결과에의 포함 여부를 결정한다
 * */
--메인쿼리의 한 행 전체를 서브쿼리로 보낸다
SELECT JOB_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
--J5의 평균 급여 : 2820000

SELECT EMP_NAME, JOB_CODE, SALARY 
FROM EMPLOYEE MAIN --메인쿼리 테이블 별칭 MAIN
WHERE SALARY >(
	SELECT AVG(SALARY)
	FROM EMPLOYEE SUB --서브쿼리 테이블 별칭 SUB
	WHERE SUB.JOB_CODE=MAIN.JOB_CODE /*메인한테 받은 행의 값*/
	--평균을 조회할 건데, 메인한테 전달받은 JOB_CODE 직급의 평균 급여를 조회하는 구문==서브쿼리
	-->평균급여가 딱 하나 나오면 그걸 메인쿼리로 가져가서 실행
); --최종 결과 사람들이 자기 직급보다 많이 받는 사람들 리스트임



----------------------------------------------------------------------------------------
-- 부서별 입사일이 가장 빠른 사원의
--    사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
--    입사일이 빠른 순으로 조회하세요
--    단, 퇴사한 직원은 제외하고 조회하세요->메인쿼리가 아닌, 서브쿼리에 써야 함

--특정 부서에서 가장빠른 입사일이 언제인지 알아보기

--D1부서에서 가장빠른 입사일이 언제인지 알아보기
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE ='D1';

--D5부서에서 가장빠른 입사일이 언제인지 알아보기
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE ='D5';
--변하는 'D5'자리에 메인쿼리의 행이 하나씩 들어오도록 만들기
---------------------------------------------
SELECT EMP_ID , EMP_NAME , DEPT_CODE 
, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE "MAIN" --별칭
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE HIRE_DATE = (
/*서브쿼리의 주제 : 메인쿼리에서 전달받은 행의 컬럼 값 중
 * DEPT_CODE 값을 전달받아 그 전달받은 부서에서의 가장 빠른 입사일을 조회하는 코드*/
--조회해서 가장빠른 입사일과 그 사람의 입사일이 같으면 최종 결과에 그 사람 포함시킴
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE "SUB" --별칭에 쌍따옴표 써도 됨
WHERE NVL("SUB".DEPT_CODE, '소속없음') 
= NVL("MAIN".DEPT_CODE, '소속없음') --뭐가 누구 것인지 구분 안돼서 별칭 사용
--		---------------- 밑줄친 이 부분은 메인쿼리에서 한명한명 볼 때마다 값이 계속 바뀔 거임
-- 하동운은 DEPT_CODE가 NULL인데 NULL은 비교가 불가능하기 때문에
-- NVL을 이용해서 NULL이 아닌 비교 가능한 실제 값으로 변경
-- 소속 없음 중에서 가장 입사일 빠른 사람을 찾을 수 있게 된다
AND ENT_YN != 'Y'
)
ORDER BY HIRE_DATE;
--선동일의 입사일이 D9에서 가장 빠른 입사일이 맞는지 검사해보겠다
--퇴사한 사람 빼는 코드를 서브쿼리에 넣어야 함 ->그래야 그 사람 말고 그 부서에서 퇴사한 사람 뺐을 때 입사일 가장 빠른 사람을 찾음
-----------------------------------------------------------------------------------------
--사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회하기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID 
FROM EMPLOYEE "MAIN"
--LEFT JOIN : JOIN구문 기준 왼쪽에 있는 테이블의 모든 행이 결과에 포함될거다
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE EXISTS (
	SELECT EMP_ID 
	FROM EMPLOYEE "SUB"
	WHERE "SUB".EMP_ID="MAIN".MANAGER_ID  --서브쿼리의 결과가 있으면 TRUE가 돼서 메인쿼리도 됨
	--메인에서 전달받은 아이디를 서브쿼리에 넣었을 때 맞으면 TRUE
);
--WHERE EXISTS (서브쿼리)
-->서브쿼리 수행 결과(RESULT SET)에 행이 하나라도 존재한다면 TRUE, 없으면 FALSE

----------------------------------------------------------------------------------

-- 6. 스칼라 서브쿼리 == SELECT 절에 작성하는 단일행 서브쿼리!!! 셀렉적에 값이 하나만 나오는 쿼리를 쓰므로 스칼라 쿼리라고 함
--    SELECT절에 사용되는 서브쿼리 결과로 1행만 반환
--    SQL에서 단일 값을 가르켜 '스칼라'라고 함
-->SELECT절에 서브쿼리 쓸 수 있다!!!!근데 단일행 서브쿼리를 쓸 수 있음
----------------------------------------------------------------------------
-- 각 직원들이 속한 직급의 급여 평균 조회
SELECT EMP_NAME, JOB_CODE, JOB_CODE ||'의 평균 급여',
(SELECT FLOOR(AVG(SALARY)) 
 FROM EMPLOYEE SUB
 WHERE SUB.JOB_CODE = MAIN.JOB_CODE 
 ) "평균 급여"
FROM EMPLOYEE MAIN;
--메인쿼리의 값이 서브쿼리에 영향을 줌 ->상관쿼리

-----------------------------------------------------------------------------
-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단 관리자가 없는 경우 '없음'으로 표시
-- (스칼라 + 상관 쿼리)
SELECT EMP_ID, EMP_NAME, MANAGER_ID , 
NVL((
	SELECT EMP_NAME 
	FROM EMPLOYEE "SUB"--별칭
	WHERE "SUB".EMP_ID ="MAIN".MANAGER_ID  --서브의 사번이 메인의 매니저아이디인 것의 이름이 끝에 나왔으면 좋겠다
	--이 서브쿼리 수행 결과가 이름이 나오거나, 아니면 NULL이 나오므로 이 전체를 NVL로 감싸야 함
),'없음') "관리자명"--별칭
FROM EMPLOYEE "MAIN"; --이태림도 매니저 아이디 있긴 한데 그 아이디 가지는 사람 번호가 없어서 이태림도 매니저 없는거임




-----------------------------------------------------------------------


-- 7. 인라인 뷰(INLINE-VIEW)
--    FROM 절에서 서브쿼리를 사용하는 경우로
--    서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신에 사용한다.

-- FROM절에 테이블을 안 쓰고 서브쿼리를 쓰는 것
-- 셀렉트의 결과를 테이블로 쓰는 것

-- 셀렉트문 안에 있어서 인라인
-- VIEW : 조회만 가능한 가상 테이블(보여지기만 하는 애)
-- RESULT SET은 테이블 모양만 하고 있는 데이터이고, 거기에 삽입, 수정 불가
----------------------------------------------------------------------
-- 인라인뷰를 활용한 TOP-N분석 (TOP5,,,TOP10 이런거)
-- 전 직원 중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회하기
--1) 전 직원의 급여 내림차순으로 조회
SELECT EMP_NAME, SALARY 
FROM EMPLOYEE 
ORDER BY SALARY DESC;
--2) ROWNUM : 행 번호를 나타내는 가상의 컬럼(존재함) ->행 번호를 나타내 주는 것
-->SELECT 절이 해석될 당시의 행 번으롤 기입한다!!!!! 
--행 번호를 줘서 몇명까지만 조회하기
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE
WHERE ROWNUM<=5;

--3) ROWNUM을 이용해서 급여 상위 5명 조회하기
SELECT ROWNUM , EMP_NAME, SALARY 
FROM EMPLOYEE 
--WHERE ROWNUM<=5
ORDER BY SALARY DESC;
--ROWNUM이 뒤죽박죽인 이유 
-- : ORDER BY절보다 SELECT절이 먼저 해석돼서 
--		SELECT절 해석 당시에는 ROWNUM 순서가 급여 순서가 아닌, 조회된 행 순서로 지정돼서 그렇게 1번부터 지정돼서 문제가됨
--ORDER BY가 SELECT절보다 먼저 해석되면 해결됨
/*인라인뷰를 이용해서 문제 해결하기!!!*/
SELECT ROWNUM, EMP_NAME, SALARY 
FROM (
	/*급여 내림차순으로 정렬된 EMPLOYEE 테이블 조회하는 서브쿼리*/
 SELECT EMP_NAME, SALARY 
 FROM EMPLOYEE 
 ORDER BY SALARY DESC --이 서브쿼리의 결과로 정렬된 테이블이 메인쿼리의 테이블 역할을 할거임 
)
WHERE ROWNUM<=5;

------------------------------------------------------------------------------------------------
-- * ROWNUM 사용 시 주의사항 *
-- ROWNUM을 WHERE절에 사용할 때
-- 항상 범위에 "1부터 연속적인 범위"가 포함되어야 한다(꼭 1부터 시작해야함)
SELECT ROWNUM, EMP_NAME, SALARY 
FROM  (SELECT EMP_NAME, SALARY --급여 높은 사람부터 정렬하는 서브쿼리
	   FROM EMPLOYEE
	   ORDER BY SALARY DESC)
--WHERE ROWNUM = 1; -- 급여가 제일 높은 사람 1행만 조회
--WHERE ROWNUM = 2; -- 2행만 조회 --> 실패 (2등만 보고싶다고 해서 2라고 하면 안됨)
--WHERE ROWNUM BETWEEN 2 AND 10; --> 1부터 포함해야된다! ->2등부터 10등까지만 보고싶다고 해서 2부터 하면 안됨
WHERE ROWNUM BETWEEN 1 AND 10; --> 1부터 포함해야된다!
--------------------------------------------------------------------------------------------
-- 부서 별 급여 평균이 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회
SELECT ROWNUM, DEPT_CODE, DEPT_TITLE, "평균 급여" --SELECT절에 컬럼 쓸 때 FROM절의 테이블의 컬럼과 이름 똑같이 써야 함
--																								인라인 뷰에 표시된 컬럼명을 사용해야한다
FROM(
	/*이런게 인라인 뷰임(서브쿼리의 결과가 메인쿼리의 테이블이 되는 것!)*/
	--이만큼이 테이블임
	SELECT DEPT_CODE , DEPT_TITLE, FLOOR(AVG(SALARY)) "평균 급여"
	FROM EMPLOYEE 
	LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
	GROUP BY DEPT_CODE , DEPT_TITLE
	ORDER BY "평균 급여" DESC
	--GROUP BY 절에는 어떤 컬럼을 써야하는가? SELECT절 중에서 그룹함수 작성된 컬럼 빼고 나머지를 다 GROUP BY절에 쓰면 된다
)
WHERE ROWNUM<=3; --1~3행까지만 조회(TOP1,2,3)
------------------------------------------------------------------------

-- 8. WITH
--    서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게 함
--    인라인뷰로 사용될 서브쿼리에 주로 사용됨
--    실행 속도도 빨라진다는 장점이 있다. 

-----------------------------------------------------------------------------------------------
-- 전 직원의 급여 순위 
-- 순위, 이름, 급여 조회
-- 단, 1~10위 까지만 조회하기 
SELECT ROWNUM 순위, 이름, 급여--SELECT절에는 FROM절의 테이블의 컬럼 중에서만 쓸 수 있음!!!!!
---																		-->이름도 조회하고 싶으면 서브쿼리에서도 이름도 조회해서 테이블에 컬럼 만들어놔야함
-- 서브쿼리에서 사용한 별칭 그대로 써야한다!!!
FROM (
	--전 직원의 급여 내림차순 정리
	SELECT EMP_NAME 이름, SALARY 급여
	FROM EMPLOYEE 
	ORDER BY SALARY DESC
)
WHERE ROWNUM <=10;
--------------------------------------------------------------------------
--이것을 더 간단히 쓰는 방법 : WITH
WITH TOP_SALARY --서브쿼리의 이름을 TOP_SALARY 라고 지정함
AS (
	SELECT EMP_NAME 이름, SALARY 급여
	FROM EMPLOYEE 
	ORDER BY SALARY DESC
)
SELECT ROWNUM 순위, 이름, 급여
FROM TOP_SALARY --서브쿼리에 이름 줬음 TOP_SALARY라고
WHERE ROWNUM <=10; --서브쿼리에 이름을 줘서 필요한 시점에 사용할 수 있게 만들면 메인쿼리가 더 간단해진듯함
-- 근데 WITH 쓰는 것이 서브쿼리를 미리 해석해놓고 하는 거라 효율 좋음(속도도 더 빠름)
----------------------------------------------------------------------------------------
-- 9. RANK() OVER / DENSE_RANK() OVER : 순위매기기와 관련된 함수

-- 급여를 많이 받는 순서대로 조회하기
SELECT EMP_NAME, SALARY 
FROM EMPLOYEE 
ORDER BY SALARY DESC;
--------------------------------------------------------------------
-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
--               EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위
SELECT EMP_NAME, SALARY , 
RANK() OVER(ORDER BY SALARY DESC)
FROM EMPLOYEE; --정렬도 시켜주고 정렬된 거에 맞춰서 순위도 맞춰줌
--SELECT절에 썼는데 ORDER BY절처럼 정렬도 됨
--동점인 경우 21등으로 넘어가는데
--20등으로 하는 경우를 DENSE_RANK
----------------------------------------------------------------------
-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
--                     EX) 공동 1위가 2명이어도 다음 순위는 2위
SELECT EMP_NAME, SALARY , 
DENSE_RANK() OVER(ORDER BY SALARY DESC)
FROM EMPLOYEE;
-----------------------------------------------------------------------

-- SELECT 관련 KEY POINT !! --

/* 1. 테이블 구조 파악
 * 
 * 2. SELECT 해석 순서
 *   + 별칭 사용이 가능한 부분 별칭 지정은 보통 SELECT절에서 하므로 SELECT절 해석 이후인 ORDER BY절에서만 별칭 사용가능
 * 근데 인라인뷰는 1번으로 해석되는 순서여서 모든 부분에서 인라인뷰에서 설정한 별칭을 사용할 수 있다
 *    EX) ORDER BY 절에서는 SELECT절에서 해석된 별칭 사용 가능
 * 	  EX) 인라인뷰에서 지정된 별칭을 메인쿼리에서도 똑같이 사용해야된다
		 * [해석 순서]
		 * 5 SELECT 어떤 컬럼만 볼거야
		 * 1 FROM + JOIN
		 * 2 WHERE 테이블 중에서 어떤 행만 조회할거다
		 * 3 GROUP BY WHERE절로 선택된 행들을 그룹화시킬거다
		 * 4 HAVING 만들어진 그룹에 대한 조건
		 * 6 ORDER BY 어떤 순서로 볼건지 정렬
 * 
 * 3. 여러 테이블을 이용한 SELECT 진행 시
 *    컬럼명이 겹치는 경우 이를 해결하는 방법
 * 			[문제 상황]   					[해결 방법]
 *    EX) 셀프 조인 ->같은 테이블 두개이므로 컬럼명이 다 겹쳐서 테이블별로 별칭 지정해서 해결하기!!!
 *    EX) 상관 쿼리 -> 테이블별로 별칭 지정하기!!!
 *    EX) 다른 테이블이여도 컬럼명이 같을 때 -> 테이블별로 별칭 지정하거나 테이블명.컬럼명 형식으로 작성하기!!!
 * 
 *  4. 조회하려는 데이터 (목적, 요구사항)을 확실하게 파악해야한다
 * */

