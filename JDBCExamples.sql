--입력 받는 급여보다 많이 받는 사원의
	--사번, 이름, 급여, 직급명 조회하기
	SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
	FROM EMPLOYEE 
	JOIN JOB USING(JOB_CODE)
	WHERE SALARY >= 3000000
	ORDER BY SALARY DESC; --이걸 그대로 복사
	
	
	--새 테이블 생성(INSERT용)
	CREATE TABLE DEPARTMENT4
	AS SELECT * FROM DEPARTMENT;
	
	--DEPARTMENT4 테이블에
	--'D0', '기획개발팀', 'L2'삽입
	INSERT INTO DEPARTMENT4
	VALUES('D0', '기획개발팀', 'L2'); --실행 결과로 삽입된 행의 개수가 정수로 반환됨
	
	SELECT * FROM DEPARTMENT4;
	-- 사용자(개발자)가 직접 트랜잭션 제어 처리할거다(상황에 따라서 COMMIT하거나 ROLLBACK할거다)
	COMMIT;
	ROLLBACK;
	
