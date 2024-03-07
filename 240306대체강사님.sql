--테이블 생성 : create 
--실행하고 커밋하고 (왼쪽 상단 커밋 버튼) 테이블 폴더 우클릭해서 REFRESH하면 됨
CREATE TABLE TB_GRADE (
--학년과 관련된 테이블
--테이블명 : TB_GRADE
--네이버 블로그, 카페, 쇼핑, 뉴스
--벌쳐? 모든 것을 넣어줄 수 있는 공간 (VARCHAR)
--유저명 varchar2(100)
-- varchar 란 : 숫자 영어 한글 등 모든 문자를 넣을 수 있는 공간
-- varchar1 : 처음 만든거여서 공간도 작아서 넣을 수 있는 양이 적음
-- varchar2 : varchar1이 너무 용량이 작아서 공간을 더 넓게 쓸 수 있는 것
--100 : 글자가 들어갈 수 있는 크기(100정도의 공간만 쓸거야)
--또는 글자 수를 제한하는 용도로도 사용(3글자까지만 입력하도록 만드는 등)
--100이라고 해서 무조건 100칸 다 안채워도 되고 0부터 100 사이만 채워도 됨
	GRADE_CODE VARCHAR2(10) PRIMARY KEY, --번호
	-- PRIMARY KEY : 만들어진 정보에 기본으로 부여되는 기본값 key
	GRADE_NAME VARCHAR2(20) --이름
);
CREATE TABLE TB_AREA (
	--사는 지역
	AREA_CODE VARCHAR2(10) PRIMARY KEY, --학년
	-- PRIMARY KEY : 만들어진 정보에 기본으로 부여되는 기본값 key
	-- PRIMARY KEY : 중복값 못쓰도록 함 (아이디 중복 방지)
	AREA_NAME VARCHAR2(20) --이름
);
/*
--TB_MEMBER 테이블 생성하기
CREATE TABLE TB_MEMBER (
	--유저 아이디 / 유저 패스워드 / 유저 이름
	MemberID Varchar2(20) PRIMARY KEY, 
	MemberPWD Varchar2(20),
	Member_Name Varchar2(50), 
	GRADE Varchar2(10),
	Area_code Varchar2(10),
	Foreign key ? 
--Grade와 Area 연결해주기
);
*/
--GRADE 에 테이블 데이터 넣기! Insert
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('10', '일반회원'); --GRADE_CODE에는 10, GRADE_NAME에는 일반회원 넣기
--등급 넣어줌(얼마 이상 구매 시 A 회원, 얼마 이상 구매 시 S회원 등등)
/*
20 우수회원 
30 특별회원
40 골드회원
50 플래티넘
60 다이아몬드
*/
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('20', '우수회원');
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('30', '특별회원');
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('40', '골드회원');
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('50', '플래티넘회원');
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) 
VALUES ('60', '다이아몬드');
----------------------------------------------
--다 (실행 - 커밋) 반복 후 테이블 REFRESH하기

-- TB_MEMBER 테이블 생성 
CREATE TABLE TB_MEMBER ( MEMBERID VARCHAR2(20) PRIMARY KEY, MEMBERPWD VARCHAR2(20), MEMBER_NAME VARCHAR2(50), 
GRADE VARCHAR2(10), AREA_CODE VARCHAR2(10), 
FOREIGN KEY (GRADE) REFERENCES TB_GRADE(GRADE_CODE), FOREIGN KEY (AREA_CODE) REFERENCES TB_AREA(AREA_CODE) );

-- 데이터 삽입 -- TB_GRADE 테이블 데이터 삽입 
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) VALUES ('10', '일반회원'); 
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) VALUES ('20', '우수회원'); 
INSERT INTO TB_GRADE (GRADE_CODE, GRADE_NAME) VALUES ('30', '특별회원');

-- TB_AREA 테이블 데이터 삽입 
INSERT INTO TB_AREA (AREA_CODE, AREA_NAME) VALUES ('02', '서울'); 
INSERT INTO TB_AREA (AREA_CODE, AREA_NAME) VALUES ('031', '경기'); 
INSERT INTO TB_AREA (AREA_CODE, AREA_NAME) VALUES ('032', '인천');

-- TB_MEMBER 테이블 데이터 삽입 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('hong01', 'pass01', '홍길동', '10', '02'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('leess99', 'pass02', '이순신', '10', '032'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('SS50000', 'pass03', '신사임당', '30', '031'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('1u93', 'pass04', '아이유', '30', '02'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('pcs1234', 'pass05', '박철수', '20', '031'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('you_is', 'pass06', '유재석', '10', '02'); 
INSERT INTO TB_MEMBER (MEMBERID, MEMBERPWD, MEMBER_NAME, GRADE, AREA_CODE) 
VALUES ('kyh9876', 'pass07', '김영희', '20', '031');
---------------------------------------------------------------------------------------------------
--SELECT문
--모든 회원의 이름과 등급을 조회하기
SELECT MEMBER_NAME, GRADE_NAME 
FROM TB_MEMBER M --별칭
JOIN TB_GRADE G ON M.GRADE = G.GRADE_CODE;
---------------------------------------------------
--등급이 일반회원(등급=10)인 회원을 조회하기
SELECT * 
FROM TB_MEMBER M
WHERE GRADE='10';
---------------------------------------------------
--경기도 지역에 거주하는 회원의 아이디와 이름 조회하기
SELECT MEMBERID, MEMBER_NAME, AREA_CODE
FROM TB_MEMBER M
WHERE AREA_CODE='031';
----------------------------------------------------
--등급이 우수회원이고 이름에 '이'가 포함된 회원의 이름을 조회하기
--SELECT문을 이용해서 회원의 이름만 조회하기
SELECT MEMBER_NAME
--어디서 회원의 이름을 가져올 것인가!
-->TB_MEMBER 테이블에서 회원의 이름을 FROM을 이용해서 가져오기
FROM TB_MEMBER M 
--등급이 우수회원이고 이름에 '이'가 포함되어야 함
-->어떻게 우수회원인지 확인하고
-->이름에 이가 포함되는지는 어떻게 알 것인가?
-->MEMBER 테이블에서 우수회원은 20으로 적어놓음
-->'이'라는 단어가 앞에 들어가는지 뒤에 들어가는지 상관없다면
-->'이'를 기준으로 앞/뒤에 %를 붙여서 '이'가 포함되는 지 확인하면됨!
WHERE GRADE='20'
AND 
MEMBER_NAME LIKE '%이%';
-----------------------------------------------------
--등급이 '일반회원'인 회원의 이름을 알파벳 순으로 정렬하기
SELECT MEMBER_NAME 
FROM TB_MEMBER M
WHERE GRADE ='10'
ORDER BY MEMBER_NAME; --기본값 : 오름차순
----------------------------------------------------
--등급이 '특별회원'이고 이름에 '신'이 포함된 회원의 아이디와 이름 조회하기
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER M
WHERE GRADE='30'
AND 
MEMBER_NAME LIKE '%신%';
----------------------------------------------------
--서울 지역에 거주하고 일반회원 등급인 회원의 이름 조회하기
SELECT MEMBER_NAME --회원의 이름만 보기
FROM TB_MEMBER M
JOIN TB_AREA A ON (M.AREA_CODE=A.AREA_CODE)
JOIN TB_GRADE G ON (G.GRADE_CODE=M.GRADE)
WHERE AREA_NAME ='서울'
AND 
GRADE_NAME='일반회원';
----------------------------------------------------
--특정 지역의 회원 수 조회하기
SELECT AREA_NAME , COUNT(*)
FROM TB_MEMBER M
JOIN TB_AREA A ON (M.AREA_CODE=A.AREA_CODE) 
GROUP BY AREA_NAME;
----------------------------------------------------
--특정 회원의 지역 정보 조회하기
SELECT MEMBER_NAME, AREA_NAME 
FROM TB_MEMBER M
JOIN TB_AREA A ON (M.AREA_CODE=A.AREA_CODE);
----------------------------------------------------
--일반회원과 우수회원의 수 비교하기
SELECT GRADE_NAME, COUNT(*)
FROM TB_MEMBER M
JOIN TB_GRADE G ON (G.GRADE_CODE=M.GRADE)
WHERE GRADE_NAME IN ('일반회원', '우수회원')
GROUP BY GRADE_NAME;
-----------------------------------------------------
--SS50000 회원의 등급과 이름 조회하기
SELECT GRADE_NAME , MEMBER_NAME 
FROM TB_MEMBER M
JOIN TB_GRADE G ON (G.GRADE_CODE=M.GRADE)
WHERE MEMBERID='SS50000';
------------------------------------------------------
--서브쿼리
--SELECT를 활용한 서브쿼리 예제
--TB_MEMBER 테이블에서 GRADE가 우수회원이면서 
--AREA_CODE가 '031'인 회원의 회원 이름 조회하기
SELECT MEMBER_NAME 
FROM TB_MEMBER M
WHERE GRADE= (
		SELECT GRADE_CODE 
		FROM TB_GRADE 
		WHERE GRADE_NAME='우수회원')
AND AREA_CODE ='031';
-------------------------------------------------------
--TB_MEMBER 테이블에서 GRADE가 일반회원이면서
--AREA_CODE가 02가 아닌 회원의 아이디를 조회하기
SELECT MEMBERID
FROM TB_MEMBER M 
WHERE GRADE=(
		SELECT GRADE_CODE 
		FROM TB_GRADE 
		WHERE GRADE_NAME='일반회원')

AND 
AREA_CODE !='02';
--------------------------------------------------------------
--TB_MEMBER 테이블에서 GRADE가 '특별회원'이면서 
--AREA_CODE가 '031'이 아닌 회원들의 회원 이름 조회하기
SELECT MEMBER_NAME 
FROM TB_MEMBER M
WHERE GRADE=(
		SELECT GRADE_CODE 
		FROM TB_GRADE 
		WHERE GRADE_NAME='특별회원')
AND 
AREA_CODE !='031';
--------------------------------------------------------------
--TB_MEMBER 테이블에서 AREA_CODE가 031이거나 032인 회원들의 이름 조회하기
SELECT MEMBER_NAME 
FROM TB_MEMBER 
WHERE AREA_CODE IN ('031', '032');
--------------------------------------------------------------
--SELECT, ROWNUM을 활용한 예제
--ROWNUM == 만들어진 것에 임의로 번호를 부여해서 특정 행 선택 시에 사용하기도 함
--ROWNUM 이란 ? 
--SELECT 해온 데이터에 번호를 붙이는 것!!!!
--번호를 붙여서 원하는 만큼의 갯수만 가져오고 싶을 때 사용함!
--EX ) 랭킹 TOP10위까지만 보고싶을 때! 딱 TOP3에게만 상 주고 나머지는 참가상만 주고싶을 때
--오름차순 내림차순
--EX) PAGING 쇼핑몰에서 페이지 넘길 때 6개씩만 한번에 보고싶을 떄 사용하기도 함
---------------------------------------------------------------------------
--TB_MEMBER 회원들 중에서 ROWNUM이 3이하인 데이터 조회하기
SELECT *
FROM TB_MEMBER
WHERE ROWNUM<=3;
--그냥 랜덤 순서대로 1,2,3 ROWNUM 찍혀서 조회된거임
--------------------------------------------------------------------------
--TB_MEMBER 테이블에서
--지역코드가 031인 회원 중에서 처음 3명의 아이디와 이름 조회하기
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER 
WHERE AREA_CODE ='031'
AND 
ROWNUM<=3;
-------------------------------------------------------------------------
--TB_MEMBER에서 이름 순으로 상위 3개 멤버 조회하기 
--ROWNUM사용 / 서브쿼리 사용 / 서브쿼리 안에 ORDER BY
SELECT MEMBERID , MEMBER_NAME 
FROM (
	SELECT MEMBERID, MEMBER_NAME, ROWNUM AS RN --AS 별칭
	FROM TB_MEMBER
	ORDER BY MEMBER_NAME)
WHERE RN<=3;
---------------------------------------------------------------------------
--시험문제

SELECT AREA_NAME 지역명, MEMBERID 아이디, M1.MEMBER_NAME 이름, GRADE_NAME 등급명
FROM TB_MEMBER M1
JOIN TB_GRADE ON (GRADE=GRADE_CODE)
JOIN TB_AREA A ON (M1.AREA_CODE = A.AREA_CODE)
WHERE M1.AREA_CODE = (
SELECT AREA_CODE 
FROM TB_MEMBER M2
WHERE M2.MEMBER_NAME=’김영희’
)
AND 
M1.MEMBER_NAME !='김영희'
ORDER BY M1.MEMBER_NAME;
--------------------------------------------------------------
--오라클 실습 문제
--1: TB_AREA 테이블에서 지역 코드가 '02'인 지역의 이름을 조회
SELECT AREA_NAME 
FROM TB_AREA 
WHERE AREA_CODE ='02';
--2: TB_AREA 테이블에서 지역 코드가 '02'인 지역의 이름을 조회
SELECT 
FROM TB_AREA 
WHERE AREA_CODE ='02';
--3: TB_MEMBER 테이블에서 모든 회원의 이름과 등급을 조회
SELECT MEMBER_NAME 이름, GRADE 등급
FROM TB_MEMBER;
--4: TB_MEMBER 테이블에서 이름이 '이순신'인 회원의 아이디를 조회
SELECT MEMBERID 
FROM TB_MEMBER 
WHERE MEMBER_NAME ='이순신';
--5: TB_MEMBER 테이블에서 등급이 '20'인 회원의 이름과 지역 코드를 조회
SELECT MEMBER_NAME , AREA_CODE 
FROM TB_MEMBER 
WHERE GRADE ='20';
--6: TB_MEMBER 테이블에서 지역이 '서울'인 회원의 아이디와 이름을 조회
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER 
WHERE AREA_CODE =(
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME='서울'
);
--7: TB_MEMBER 테이블에서 등급이 '특별회원'인 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE = (
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
);
--8: TB_MEMBER 테이블에서 이름이 '홍길동'이거나 '박철수'인 회원의 아이디를 조회
SELECT MEMBERID 
FROM TB_MEMBER 
WHERE MEMBER_NAME IN ('홍길동', '박철수');
--9: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 지역 코드가 '031'인 회원의 이름을 조회
SELECT MEMBER_NAME 
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND AREA_CODE ='031';
--10: TB_MEMBER 테이블에서 아이디가 'kyh9876'인 회원의 등급을 조회
SELECT GRADE
FROM TB_MEMBER 
WHERE MEMBERID ='kyh9876';
--11: TB_MEMBER 테이블에서 등급이 '일반회원'이면서 지역이 '경기' 또는 '인천'인 회원의 아이디와 이름을 조회
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND AREA_CODE IN (
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME IN ('경기', '인천')
);
--12: TB_MEMBER 테이블에서 등급이 '특별회원'인 회원 중에서 지역이 '서울'이 아닌 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
)
AND 
AREA_CODE != (
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME='서울'
);

--13: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 이름이 '김영희'인 회원의 등급과 지역을 조회
SELECT GRADE, AREA_CODE
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND MEMBER_NAME ='김영희';
--14: TB_MEMBER 테이블에서 등급이 '일반회원'이고 지역이 '경기'인 회원 중에서 가입일이 2024년 3월 1일 이후인 회원의 이름을 조회
--미완성(가입일????????)
SELECT MEMBER_NAME 
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND AREA_CODE =(
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME='경기'
)
--AND JOIN_DATE >TO_DATE('2024-03-01', 'YYYY-MM-DD');
AND "나중에 사용자가 가입한 날짜를 지정할 컬럼명을 작성" >TO_DATE('2024-03-01', 'YYYY-MM-DD');
--15: TB_MEMBER 테이블에서 등급이 '특별회원'이면서 아이디가 'SS50000'이거나 '1u93'인 회원의 지역을 조회
SELECT AREA_CODE 
FROM TB_MEMBER  
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
)
AND MEMBERID IN ('SS50000', '1u93');
--16: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 이름에 '유'가 포함된 회원의 아이디를 조회
SELECT MEMBERID 
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND MEMBER_NAME LIKE '%유%';
--17: TB_MEMBER 테이블에서 등급이 '일반회원'이면서 가입일이 현재 날짜보다 이전인 회원의 수를 조회
--미완성(가입일????????)
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
--AND JOIN_DATE >SYSDATE;
AND "나중에 사용자가 가입한 날짜를 지정할 컬럼명을 작성" >SYSDATE;
--------------------------------------------------------------------
--TO_DATE : 사용자가 원하는 날짜 형식으로 넘겨주는 것
--어떤 사람은 연도도 명시해서 주길 원하고 어떤 사람은 연도는 명시 안하고 월/일만 명시해서 받길 바람->그 요구에 맞춰주는 것
--사람마다 양식이 달라서 양식을 통일할 때 많이 사용
--'YYYY-MM-DD'로 많이 씀
--왜 대문자로 할까? -> 월과 분이 M이 겹쳐서 단위가 큰 연월일은 대문자, 시분초는 소문자!로 씀
--TO_DATE = 'YYYY-MM-DD' 문자열로 저장된 날짜를 DATE 형식으로 변환하는 함수
--YYYY MM DD : 년 월 일 표기
--hh mm ss : 시 분 초 표기
---------------------------------------------------------------------
--JOIN_DATE : 사용자가 가입한 날짜를 나타내는 컬럼명(지금은 없어서 못쓰는데 쓸려면 해당 이름의 컬럼이 있어야 함)
--SYSDATE : 내 컴퓨터에서 보이는 현재 날짜, 현재 시간을 나타냄(시스템에 있는 데이터)
--SYS : 현재 날짜 관련
----------------------------------------------------------------------------------------------
--18: TB_MEMBER 테이블에서 등급이 '특별회원'이면서 가장 오래된 회원의 아이디를 조회하
--미완성(가입일????????)
--19: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 이름이 '신사임당'이 아닌 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND MEMBER_NAME !='신사임당';
--20: TB_MEMBER 테이블에서 등급이 '일반회원'이면서 지역이 '서울'인 회원의 이름과 등급을 조회 단, 결과를 등급에 따라 내림차순으로 정렬
SELECT MEMBER_NAME , GRADE
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND AREA_CODE =(
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME='서울'
)
ORDER BY GRADE DESC;

--21: TB_MEMBER 테이블에서 회원 이름의 길이가 4 이상인 회원의 아이디와 이름을 조회
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER 
WHERE LENGTH(MEMBER_NAME)>=4;
--22: TB_MEMBER 테이블에서 등급이 '특별회원'이면서 이름이 '김영희'가 아닌 회원의 아이디를 조회
SELECT MEMBERID 
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
)
AND MEMBER_NAME !='김영희';
--23: TB_MEMBER 테이블에서 등급이 '일반회원'인 회원 중에서 이름이 '김영희'이거나 '아이유'인 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND MEMBER_NAME IN ('김영희', '아이유');
--24: TB_MEMBER 테이블에서 등급이 '특별회원'이 아니면서 이름이 '홍길동'이 아닌 회원의 아이디를 조회
SELECT MEMBERID 
FROM TB_MEMBER 
WHERE GRADE !=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
)
AND MEMBER_NAME !='홍길동';
--25: TB_MEMBER 테이블에서 등급이 '일반회원'이면서 지역이 '인천' 또는 '경기'인 회원의 아이디와 이름을 조회
SELECT MEMBERID , MEMBER_NAME 
FROM TB_MEMBER 
WHERE GRADE =(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND AREA_CODE IN (
SELECT AREA_CODE 
FROM TB_AREA 
WHERE AREA_NAME IN ('인천', '경기')
);
--26: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 이름이 '홍길동'이 아니면서 가장 최근에 가입한 회원의 아이디를 조회
--미완성(가입일?????????????)
SELECT 
FROM TB_MEMBER 
WHERE GRADE =(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND MEMBER_NAME !='홍길동'
AND ;
--27: TB_MEMBER 테이블에서 등급이 '우수회원'이면서 가장 최근에 가입한 회원의 이름을 조회
--미완성(가입일?????????????)
--28: TB_MEMBER 테이블에서 등급이 '일반회원'이면서 이름에 '김'이 들어가는 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE =(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='일반회원'
)
AND MEMBER_NAME LIKE '%김%';
--29: TB_MEMBER 테이블에서 등급이 '특별회원'이 아닌 회원의 수를 조회
SELECT COUNT(*)
FROM TB_MEMBER 
WHERE GRADE !=(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='특별회원'
);
--30: TB_MEMBER 테이블에서 등급이 '우수회원'인 회원 중에서 아이디의 길이가 가장 긴 회원의 이름을 조회
SELECT MEMBER_NAME 
FROM TB_MEMBER 
WHERE GRADE =(
SELECT GRADE_CODE
FROM TB_GRADE 
WHERE GRADE_NAME='우수회원'
)
AND LENGTH(MEMBERID)=(
SELECT MAX(LENGTH(MEMBERID))
FROM TB_MEMBER
);
