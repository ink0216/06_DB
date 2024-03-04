--PDF2
--3번 워크북, 서브쿼리 실습문제, JOIN 실습문제도 해야함
--1번
SELECT STUDENT_NO 학번, STUDENT_NAME 이름,
ENTRANCE_DATE 입학년도
FROM TB_STUDENT 
WHERE DEPARTMENT_NO ='002'
ORDER BY ENTRANCE_DATE;
--2번
SELECT PROFESSOR_NAME, 
PROFESSOR_SSN 
FROM TB_PROFESSOR 
WHERE LENGTH(PROFESSOR_NAME) !='3';
--3번
--만 나이 : 생일 지나야 한살씩 커지는 것
--교수의 생일, 오늘 날짜 비교 ->MONTHS_BETWEEN
SELECT PROFESSOR_NAME 교수이름 ,
TRUNC(MONTHS_BETWEEN(SYSDATE,
TO_DATE(19||SUBSTR(PROFESSOR_SSN, 1,6)))/12)  "나이"
--SUBSTR(PROFESSOR_SSN, 1,6)는 CHAR인데 DATE로 바꿔줘야함 ->TO_DATE로 감싸기
--|| : 이어쓰기 -> 50년이 안넘는 사람들은 2050년으로 계산됨
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8,1)='1' 
ORDER BY 나이;
--4번(이거 왜 결과 행 개수가 다르게 나오지)->이름이 네글자인 사람이 두명 있었어서!!
SELECT SUBSTR(PROFESSOR_NAME, 2) "이름" --두 번째 칸부터 길이를 지정하거나
--길이 지정 안하는 경우, 자동으로 끝까지 자르는 것으로 됨
FROM TB_PROFESSOR 
WHERE LENGTH(PROFESSOR_NAME)='3'
ORDER BY PROFESSOR_NAME DESC;
--이름이 네 글자인 경우도 동일하게 이름 부분만 나오게하고 싶으면->선택함수 이용
SELECT 
CASE 
	WHEN LENGTH(PROFESSOR_NAME)=3
	THEN SUBSTR(PROFESSOR_NAME,2)
	
	WHEN LENGTH(PROFESSOR_NAME)=4
	THEN SUBSTR(PROFESSOR_NAME,3)
END 이름
FROM TB_PROFESSOR;

--5번
--이건 만나이가 아닌, 그냥 연도만 빼서 하면 된다
--주민등록번호와 입학일자 이용
SELECT STUDENT_NO , STUDENT_NAME 
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)
-TO_NUMBER(19||SUBSTR(STUDENT_SSN,1,2))>19;
--EXTRACT : 날짜에서 원하는 것만 뽑아서 정수로 반환받는 것
--생년을 뽑아서 앞에 19를 붙이면 1998 이런식으로 문자열이 되는데
--그걸 TO_NUMBER 해서 숫자로 바꿈
--버전2
		
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)
 - EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6),'YYYYMMDD')) > 19;	
--6번
SELECT STUDENT_NO , STUDENT_NAME 
FROM TB_STUDENT 
WHERE STUDENT_NO NOT LIKE 'A%';
--7번
SELECT ROUND(AVG(POINT), 1) 평점
FROM TB_GRADE 
WHERE STUDENT_NO ='A517178';
--8번
SELECT DEPARTMENT_NO 학과번호 
,COUNT(*) "학생수(명)"
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ; 
--9번
SELECT COUNT(*)
FROM TB_STUDENT 
WHERE COACH_PROFESSOR_NO IS NULL;
--10번 
SELECT SUBSTR(TERM_NO, 1,4) 년도 , ROUND(AVG(POINT),1) "년도 별 평점"
FROM TB_STUDENT 
JOIN TB_GRADE USING (STUDENT_NO)
WHERE STUDENT_NO ='A112113'
GROUP BY SUBSTR(TERM_NO, 1,4)
ORDER BY 년도;
--11번 
SELECT DEPARTMENT_NO 학과코드명 , 
SUM(DECODE(ABSENCE_YN, 'Y', 1, 0)) "휴학생 수"
--ABSENCE_YN이게 Y이면 1이고, Y가 아니면 0으로 됨 
--> 그룹으로 묶어서 그것의 합 구하면, COUNT(*) 말고도 수를 구할 수 있음 
FROM TB_STUDENT 
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;
--12번
SELECT STUDENT_NAME 동일이름, COUNT(*) "동명인 수"
FROM TB_STUDENT 
GROUP BY STUDENT_NAME 
HAVING COUNT(*)>1
ORDER BY STUDENT_NAME; 
--13번 --GROUP BY 중간 집계 ROLLUP / CUBE 어떻게 하는지 모르겠어서 일단 스킵....(미완성)
SELECT SUBSTR(TERM_NO, 1,4) "년도", SUBSTR(TERM_NO, 5) "학기", 
ROUND(AVG(POINT),1)"평점"
FROM TB_GRADE
WHERE STUDENT_NO ='A112113'
GROUP BY TERM_NO
ORDER BY 년도;





