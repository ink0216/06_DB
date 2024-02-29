--DISTINCT : SELECT절에만 사용가능
/* 
[JOIN 용어 정리]
JOIN이라는 SQL 기술이 있는데 
오라클인지, ANSI인지(좌/우)에 따라서
각자만의 규격이 다르고, 부르는 이름도 달라서 헷갈림->ANSI가 1999표준으로 제공해줌
->ANSI 방법으로 하면 거의 다 됨

  오라클       	  	                                SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인		                            내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인 		                        왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인   	                    	JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱		               			교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN : 테이블을 연결해서 큰 테이블 만들기
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 테이블은 2개 이상이지만, 수행 결과는 하나의 Result Set으로 나옴.
-- 테이블은 여러개여도 결과 집합은 하나만 나온다!!!!
-- FROM절에 JOIN이라는 구문 이용해서 이용하는 테이블을 늘려나가는 것!
-- 한 테이블의 한 컬럼을 기준으로 삼고
-- 다른 테이블을 준비하는데 그 테이블에, 처음 테이블의 기준과 똑같은 컬럼이 있어야 한다?
-- 한 테이블은 그대로 두고 다른 테이블에서 한 행씩 뜯어와서 붙이기
/* 
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가 됨.!!!!(연결고리 역할을 한다)
  공통점을 찾으면 연결됨   
*/

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 기존에 서로 다른 테이블의 데이터를 조회 할 경우 아래와 같이 따로 조회함.

-- 직원번호, 직원명, 부서코드, 부서명을 조회 하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-- 직원번호, 직원명, 부서코드는 EMPLOYEE테이블에 조회가능

-- 부서명은 DEPARTMENT테이블에서 조회 가능
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

SELECT *
FROM EMPLOYEE --EMPLOYEE테이블을 기준으로 삼아서
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID , DEPT_TITLE
FROM EMPLOYEE --EMPLOYEE테이블을 기준으로 삼아서
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); --DEPARTMENT테이블을 연결할건데 그 둘을 같은 값끼리 행 붙이기
--연결되는 컬럼이, 서로서로 없는 값이 있을 수도 있음(완전히 똑같을 필요 없고 공통된 값을 가지고만 있어도 연결 된다)
--컬럼값 같은 행을 찾아서 그 옆에 행 연결해줘
/*JOIN은 단순히 테이블을 두 개 나란히 붙이는 것이 아닌,
 * 기준 삼은 테이블의 한 컬럼을 지정해(위의 경우, DEPT_CODE 컬럼)
 * 다른 테이블에서 컬럼 값이 같은 행을 찾아
 * 
 * 기준 테이블 옆에 한 행씩 붙여나가며 큰 테이블 만듦
 * 
 * 근데 조인의 단점 : 느리다!!->혼자 쓰면 모르지만, 100만명,1000만명이 쓰는 경우 엄청 느려짐
 * */

-- 테이블의 별칭 지정하는 것은 ANSI 방법과 ORACLE 방법 모두에서 지정 가능하다!!!

-- 1. 내부 조인(INNER JOIN) ( == 등가 조인(EQUAL JOIN) OF ORACLE)
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.  
-- (== 일치하는 값이 없는 행은 조인에서 제외됨. )
-- 기준 테이블에 있었는데 다른 테이블에 없는 애는 삭제됨

-- 작성 방법 크게 ANSI구문과 오라클 구문 으로 나뉘고 
-- ANSI에서  USING과 ON을 쓰는 방법으로 나뉜다.

-- *ANSI 표준 구문
-- ANSI는 미국 국립 표준 협회를 뜻함, 미국의 산업표준을 제정하는 민간단체로 
-- 국제표준화기구 ISO에 가입되어있다.
-- ANSI에서 제정된 표준을 ANSI라고 하고 
-- 여기서 제정한 표준 중 가장 유명한 것이 ASCII코드이다.

-- *오라클 전용 구문
-- FROM절에 쉼표(,) 로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다



-- 1) 연결에 사용할 두 컬럼명이 다른 경우 --> JOIN ON 구문을 쓴다!!!(얘랑 얘랑 이름 다르지만 같아)

-- EMPLOYEE 테이블, DEPARTMENT 테이블을 참조하여
-- 사번, 이름, 부서코드, 부서명 조회

-- EMPLOYEE 테이블에 DEPT_CODE컬럼과 DEPARTMENT 테이블에 DEPT_ID 컬럼은 
-- 서로 같은 부서 코드를 나타낸다.
--> 이를 통해 두 테이블이 관계가 있음을 알고 조인을 통해 데이터 추출이 가능.

-- ANSI(공통방법)
-- 연결에 사용할 컬럼명이 다른 경우 ON()을 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); --이 둘이 같은 값을 가지고 있어서 둘이 연결할거야
--등호가 들어가서 오라클에서 등가조인이라고 부름
--(DEPT_CODE = DEPT_ID)여기에서 이 둘의 순서 바꿔서 써도 상관 없음 (DEPT_ID=DEPT_CODE)
--순서가 중요한 것이 아니어서


-- 오라클 (JOIN이라는 단어를 작성하지 않음)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT --그냥 테이블을 두개 다 적고
WHERE DEPT_CODE = DEPT_ID; --WHERE절로 따로 씀

---------------------------------------------------------------------------------------
-- DEPARTMENT 테이블, LOCATION 테이블을 참조하여
-- 부서명, 지역명 조회하기

-- ANSI 방식
SELECT * FROM DEPARTMENT; --LOCATION_ID
SELECT * FROM LOCATION; --LOCATION_CODE

--연결되는 컬럼의 이름이 다른 경우==>ON 사용
SELECT DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
---------------------------------------------------
-- 오라클 방식
SELECT DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM DEPARTMENT, LOCATION 
WHERE LOCATION_ID = LOCAL_CODE;
---------------------------------------------------------------------------------------
-- 부서명이 '해외영업2부'인 사원의
-- 사번(EMP_ID), 이름(EMP_NAME), : EMPLOYEE
-- 부서명(DEPT_TITLE) : DEPARTMENT
--을 
-- 사번 오름차순으로 조회

--ANSI 방식
/*3*/SELECT EMP_ID, EMP_NAME, DEPT_TITLE
/*1-1*/FROM EMPLOYEE 
/*1-2*/JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
/*2*/WHERE DEPT_TITLE ='해외영업2부'
/*4*/ORDER BY EMP_ID;

--JOIN은 FROM절에 쓰는 것이어서 맨 처음에 해석된다

--ORACLE 방식
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID
AND 
DEPT_TITLE ='해외영업2부'
ORDER BY EMP_ID;

---------------------------------------------------------------------------------------
-- 2) 연결에 사용할 두 컬럼명이 같은 경우 -->JOIN USING 구문 사용!!!(JOIN할 때 이 컬럼 쓸거야)
-- EMPLOYEE 테이블, JOB테이블을 참조하여
-- 사번, 이름, 직급코드, 직급명 조회해보기

-- ANSI
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용함
SELECT EMP_ID, EMP_NAME, JOB_CODE 
FROM EMPLOYEE; --JOB_CODE(14행)

SELECT * FROM JOB; --JOB_CODE(2행)
SELECT EMP_ID, EMP_NAME, 
JOB_CODE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE); --이름 똑같은 애들인 JOB_CODE로 연결해
-->중복되는 부분 뺴고 그 옆부분만 행으로 잘라 붙임(14+2-1행)
-->컬럼이 16개가 아니라 15개인 이유
--		->컬럼 이름이 같아서 두 테이블의 같은 컬럼이 포개지듯이 합쳐짐
--ON은 이름이 달라서 따로따로 있음
-------------------------------------------------------
-- 오라클 -> 별칭 사용
-- 테이블 별로 별칭을 등록할 수 있음.
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
--WHERE JOB_CODE = JOB_CODE; --이렇게 쓰면 각각이 동일해서 누가 어떤 테이블의 것인지 몰라서 오류남
WHERE E.JOB_CODE = J.JOB_CODE; --이렇게 쓰면 각각이 동일해서 누가 어떤 테이블의 것인지 몰라서 오류남
-- ORA-00918: 열의 정의가 애매합니다
--> 작성된 컬럼이 어떤 테이블의 컬럼인지 구분할 수 없음
-->오라클 방식은 누구의 것인지 구분을 해줘야 한다
--> E, J처럼 별칭으로 쓸 수 있다

-- ON을 사용하면 컬럼값이 같은 컬럼이 두개가 나오는데 USING을 쓰면 하나만 나옴
--------------------------------------------------------------------------------------
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE --23행
/*INNER*/JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); 
--다 붙은 결과도 23행 나와야 함
--근데 하동운, 이오리가 누락돼서 21행만 나옴
-->왜 ? 그 둘의 DEPT_CODE가 NULL인데
--만약에 DEPARTMENT 테이블의 DEPT_ID컬럼에 NULL이 있으면 연결돼서 누락 안되는데
-- DEPT_CODE 값과 같은 값이 DEPT_ID컬럼에 존재하지 않아서 연결되지 않음
-->최종 결과에서 제외 ==INNER JOIN(기본값이라서 명시 안하면 INNER JOIN으로 됨)
SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE;
---------------------------------------------------------------------------------------------------------------

-- 2. 외부 조인(OUTER JOIN) : 방향성 있음(LEFT/RIGHT/FULL(양방향) JOIN)

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
-->  *반드시 OUTER JOIN임을 명시해야 한다.
-->연결되지 않은 행도 결과에 포함시키겠다
-- OUTER JOIN과 비교할 INNER JOIN 쿼리문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
/*INNER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


-- 1) LEFT [OUTER] JOIN  : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 
-- 컬럼 수를 기준으로 JOIN
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--'JOIN'을 기준으로 왼쪽에 있는 테이블(EMPLOYEE)의 모든 행이 최종 결과(REUSLT SET)에 포함되도록 하는 JOIN
-- ==LEFT JOIN
-- ==(DEPT_CODE가 NULL인데 DEPT_ID에 NULL이 없어서 INNER JOIN에서는 누락됐던 하동운, 이오리도 
-- 결과에 포함돼서 나와야함)
-- DEPT_CODE = DEPT_ID인 행이 없어도 JOIN 왼쪽에 있는 테이블의 행은 다 나와야한다


-- 오라클 구문(거의 안씀)
-- 헷갈림 LEFT JOIN이면 오른쪽에 뭘 쓰고 RIGHT JOIN이면 왼쪽에 뭘 씀
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID(+);
--왼쪽의 DEPT_CODE의 값이
--DEPT_ID와 일치하지 않아도 결과에 포함시키라는 것!

--------------------------------------------------------------------------------------
-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 
-- 오른편에 기술된 테이블의  컬럼 수를 기준으로 JOIN
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--'JOIN'을 기준으로 오른쪽에 있는 테이블(DEPARTMENT)의 모든 행이 최종 결과(REUSLT SET)에 포함되도록 하는 JOIN
-- ==RIGHT JOIN

-- 오라클 구문
-- 헷갈림 LEFT JOIN이면 오른쪽에 뭘 쓰고 RIGHT JOIN이면 왼쪽에 뭘 씀
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;
--------------------------------------------------------------------------------------
-- 3) FULL [OUTER] JOIN   : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ** 오라클 구문은 FULL OUTER JOIN을 사용 못함
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--'JOIN'을 기준으로 양쪽에 있는 테이블(EMPLOYEE,DEPARTMENT)의 모든 행이 
--최종 결과(REUSLT SET)에 포함되도록 하는 JOIN
-- ==FULL JOIN
--ERP (전사적 자원관리 시스템) : 내용이 있든 없든 다 보여야 하니까 FULL OUTER JOIN 많이 씀

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+); -- 오류 발생



---------------------------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN == CARTESIAN PRODUCT) : 거의 안씀
--  조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합)
-- 곱집합
--> 모든 경우의 수를 보고싶은 경우 빼고는 직접 작성하는 경우가 거의 없음!!!
		-->근데 자연 조인 실패 시, 결과로 교차 조인 결과가 출력됨
			--(교차 조인 결과가 보이면 -> 아, 내가 자연 조인 잘못 썼구나 생각하면 됨)(실패시의 모습이라고 알아두기)
SELECT EMP_NAME , DEPT_CODE , DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME, DEPT_CODE; --십자가(교차해서 JOIN)
--23*9=207행 (모든 조합 경우의 수 다 나옴)

---------------------------------------------------------------------------------------------------------------

-- 4. 비등가 조인(NON EQUAL JOIN) : 잘 쓸 수 있으면 좋음 
--컬럼이 다 같아서 아무 컬럼을 이용해서 조인해도 되지만 원하는 것을 구하려면 적절히 지정해야 함!

-- '='(등호)를 사용하지 않는 JOIN 문
--  지정한 컬럼 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

-- 사원의 급여가
-- SAL_LEVEL에 작성된 최소(MIN_SAL) ~ 최대(MAX_SAL) 
-- 범위의 급여가 맞을 때만 결과에 포함하겠다는 JOIN
SELECT EMP_NAME , E.SAL_LEVEL ,MIN_SAL, SALARY, MAX_SAL 
FROM EMPLOYEE E
--JOIN SAL_GRADE S ON(E.SAL_LEVEL = S.SAL_LEVEL) : 등가조인(=포함)
JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);
--등급에 따라 급여를 얼마의 범위를 줄 지 정해둔 테이블
--범위에 들어가는 사람들만 JOIN시킴
---------------------------------------------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블을 조인.
-- 자기 자신과 조인을 맺음

-->요령 : 똑같은 테이블이 2개 있다고 생각하면 쉽다!!!!

--EMPLOYEE 테이블에서
--각 사원의 이름, 사수(관리자 사번) 이름을 조회하기
-- ANSI 표준
SELECT EMP.EMP_NAME 사원명, MGR.EMP_NAME 사수명 
FROM EMPLOYEE EMP -- EMP : 사원
LEFT JOIN EMPLOYEE MGR ON (EMP.MANAGER_ID=MGR.EMP_ID);--MGR : 매니저
--같은 테이블이지만 서로 다른 E1, E2 테이블로 생각하기



-- 오라클 구문
SELECT EMP.EMP_NAME 사원명, MGR.EMP_NAME 사수명 
FROM EMPLOYEE EMP , EMPLOYEE MGR
WHERE EMP.MANAGER_ID=MGR.EMP_ID(+);


---------------------------------------------------------------------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
--> 없을 경우 교차조인이 됨.

--EMPLOYEE.JOB_CODE (CHAR(2)
--JOB.JOB_CODE      (CHAR(2)
--컬럼 이름, 자료형, 저장하는 자료도 똑같아 ->이런 애들이 NATURAL JOIN의 대상이 된다 
-->컬럼명, 컬럼의 자료형이 모두 일치! ==NATURAL JOIN의 대상

--NATURAL JOIN 안쓰고 JOIN해보기(INNER JOIN만 함)
SELECT EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE); --이름 같으므로 USING으로 포개듯이 겹쳐서 조회하기

--NATURAL JOIN 쓰고 JOIN해보기
SELECT EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB ; --알아서 분석해서 이름과 자료형 같은 컬럼 찾아서 알아서 조인해줌
---------------------------------------------------------------------
/*NATURAL JOIN 실패 --> CROSS JOIN의 결과가 조회됨*/
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
NATURAL JOIN DEPARTMENT;
--EMPLOYEE랑 DEPARTMENT를 자연 조인할거야
-->207행 나옴->NATURAL JOIN 실패하고 CROSS JOIN의 결과가 나옴
--==NATURAL JOIN 실패!!
---------------------------------------------------------------------------------------------------------------

-- 7. 다중 조인 : 이건 잘 알아야 함!!
-- N개의 테이블을 조회할 때 사용  (순서 중요!!!!!!!!)

--EMPLOYEE, DEPARTMENT, LOCATION 3개 테이블을 조인하기
--근데 조인은 한 번에 두개밖에 못해서
--EMPLOYEE, DEPARTMENT를 먼저 조인하고 그 결과에 LOCATION을 또 조인하면 됨
--> JOIN 두번 하면 됨

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--1) EMPLOYEE-DEPARTMENT 1차 조인
--2) 1차 조인 결과에 LOCATION 2차 조인
-->DEPARTMENT와 조인해야 LOCATION_ID 생기고, 그걸 이용해서 LOCATION랑 또 조인

-- 오라클 전용
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION 
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

-- 조인 순서를 지키지 않은 경우(에러발생)
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE 
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
---- ORA-00904: "LOCATION_ID": 부적합한 식별자
--1) EMPLOYEE랑 LOCATION 조인 시 
--	LOCATION_ID 컬럼이 존재하지 않아 JOIN 실패
-------------------------------------------------------------
/*여러 테이블 조인 시, 조인 순서를 지키지 않아도 되는 경우*/
--이름, 직급명, 부서명 조회하기
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
--이 때에는 두개의 JOIN문의 순서를 바꿔도 문제 없이 수행됨
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

--[다중 조인 연습 문제]

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여를 조회하세요

-- ANSI
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) 
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME='대리'
AND 
LOCAL_NAME LIKE 'ASIA%';--엄청 큰 테이블 만들고 조건에 맞는 것들만 조회할거임
-- 오라클 전용
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME, SALARY
FROM EMPLOYEE, JOB, DEPARTMENT, LOCATION
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE --1,2번 테이블 조인
AND DEPT_CODE = DEPT_ID --첫 조인의 결과에 3번 테이블 조인하기
AND LOCATION_ID = LOCAL_CODE --세 테이블이 조인된 결과에 4번 테이블 조인하기
AND JOB_NAME='대리'
AND LOCAL_NAME LIKE 'ASIA%';



--나중에 문제는 다 ANSI 방법으로 하기!!!!!!!


---------------------------------------------------------------------------------------------------------------


-- [연습문제]

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 
-- 사원명E, 주민번호E, 부서명D, 직급명J을 조회하시오.
SELECT EMP_NAME, EMP_NO, DEPT_TITLE , JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID )
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO,1,1)='7'
AND 
SUBSTR(EMP_NO,8,1) ='2'
AND 
SUBSTR(EMP_NAME,1,1)='전';
      
      
-- 2. 이름에 '형'자가 들어가는 직원들의 사번E, 사원명E, 직급명J을 조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_NAME 
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE EMP_NAME LIKE '%형%';


-- 3. 해외영업 1부, 2부(D)에 근무하는 사원의 
-- 사원명E, 직급명J, 부서코드E, 부서명D을 조회하시오.
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID )
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');

--4. 보너스포인트E를 받는 직원들의 사원명E, 보너스포인트E, 부서명D, 근무지역명L을 조회하시오.
SELECT EMP_NAME, BONUS, DEPT_TITLE , LOCAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID )
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
WHERE BONUS IS NOT NULL;
--5. 부서E가 있는 사원의 사원명E, 직급명J, 부서명D, 지역명L 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE , LOCAL_NAME
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID )
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
WHERE DEPT_CODE IS NOT NULL;
-- 6. 급여등급별 최소급여(MIN_SAL)S를 초과해서 받는 직원들의
--사원명E, 직급명J, 급여E, 연봉(보너스포함)E을 조회하시오.
--연봉에 보너스포인트를 적용하시오.
SELECT EMP_NAME , JOB_NAME, SALARY, SUM(SALARY*BONUS)
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN SAL_GRADE USING (SAL_LEVEL)
WHERE SALARY>MIN_SAL;--미완성


-- 7.한국(KO)과 일본(JP) L에 근무하는 직원들의 
-- 사원명E, 부서명D, 지역명, 국가명L을 조회하시오.
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, 
LOCAL_NAME 지역명, 
DECODE(NATIONAL_CODE, 'KO', '한국', '일본')
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID )
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
WHERE NATIONAL_CODE IN ('KO', 'JP');
-- 8. 같은 부서E에 근무하는 직원들의 사원명E, 부서코드E, 동료이름E을 조회하시오.
-- SELF JOIN 사용
SELECT 
FROM EMPLOYEE E1;--미완성



-- 9. 보너스포인트E가 없는 직원들 중에서 직급코드E가 J4와 J7인 직원들의 사원명E, 직급명J, 급여S를 조회하시오.
-- 단, JOIN, IN 사용할 것
SELECT EMP_NAME, JOB_NAME , SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN SAL_GRADE USING (SAL_LEVEL)
WHERE BONUS IS NULL 
AND  
JOB_CODE IN ('J4', 'J7');
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- [연습문제 선생님답]

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 
-- 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO,1,1) = '7'
AND   SUBSTR(EMP_NO,8,1) = '2'
AND   EMP_NAME LIKE '전%';

      
      
-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명을 조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB -- JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%형%';


-- 3. 해외영업 1부, 2부에 근무하는 사원의 
-- 사원명, 직급명, 부서코드, 부서명을 조회하시오.
-- + 사번 오름차순 정렬
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부')
ORDER BY EMP_ID;


--4. 보너스포인트를 받는 직원들의 
--사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;


--5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
/*INNER*/ 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);


-- 하동운, 이오리도 포함
SELECT EMP_NAME, JOB_NAME,  NVL(DEPT_TITLE,'없음'), NVL(LOCAL_NAME,'없음')
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);


-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의
--사원명, 직급명, 급여, 연봉(보너스포함)을 조회하시오.
--연봉에 보너스포인트를 적용하시오.
SELECT EMP_NAME, JOB_NAME, SALARY,
	SALARY * (1 + NVL(BONUS,0) ) * 12 연봉
	--NVL(BONUS,0) == BONUS값이 있으면 그 값, BONUS값이 NULL이면 0
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE MIN_SAL < SALARY
ORDER BY EMP_ID;



-- 7.한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, 
	LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');
--WHERE NATIONAL_CODE IN ('KO', 'JP');


-- 8. 같은 부서에 근무하는 직원들의 사원명E, 부서코드E, 동료이름E을 조회하시오.
-- SELF JOIN 사용
--SELECT *
SELECT A.EMP_NAME, A.DEPT_CODE, B.EMP_NAME
FROM EMPLOYEE A
JOIN EMPLOYEE B ON (A.DEPT_CODE = B.DEPT_CODE)
WHERE A.EMP_ID != B.EMP_ID
ORDER BY 1;


-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 
-- J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
-- 단, JOIN, IN 사용할 것
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN ('J4', 'J7')
AND BONUS IS NULL;
