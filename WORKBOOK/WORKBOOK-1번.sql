--WORKBOOK문제1번 여기에 풀기
--WORKBOOK문제2번 파일은 별도 파일에 7번문제까지만 풀기
------------------------------------------
--1번
SELECT DEPARTMENT_NAME "학과명", 
				CATEGORY "계열"  
FROM TB_DEPARTMENT;
--2번
SELECT DEPARTMENT_NAME ||'의 정원은'
||CAPACITY||'명 입니다.' "학과별 정원"
FROM TB_DEPARTMENT;
--3번
SELECT STUDENT_NAME 
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_SSN,8,1)='2'
AND
DEPARTMENT_NO='001'
AND 
ABSENCE_YN ='Y';
--4번(미완성)
SELECT STUDENT_NAME 
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110'
, 'A513119')
ORDER BY STUDENT_NAME DESC;
--5번
SELECT DEPARTMENT_NAME , CATEGORY 
FROM TB_DEPARTMENT 
WHERE 
CAPACITY BETWEEN 20 AND 30;
--6번
SELECT PROFESSOR_NAME 
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;
--7번
SELECT CLASS_NO 
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;
--8번
SELECT DISTINCT CATEGORY 
FROM TB_DEPARTMENT;
--9번
SELECT STUDENT_NO, STUDENT_NAME , 
STUDENT_SSN 
FROM TB_STUDENT 
WHERE 
STUDENT_NO LIKE 'A2%'
AND
STUDENT_ADDRESS  LIKE '%전주%' 
AND 
ABSENCE_YN ='N'; 

