--테이블 생성 : create 
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
	GRADE_CODE VARCHAR2(10) PRIMARY KEY, --학년
	-- PRIMARY KEY : 만들어진 정보에 기본으로 부여되는 기본값 key
	GRADE_NAME VARCHAR2(20) --이름
);
CREATE TABLE TB_AREA (
	--사는 지역
	AREA_CODE VARCHAR2(10) PRIMARY KEY, --학년
	-- PRIMARY KEY : 만들어진 정보에 기본으로 부여되는 기본값 key
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





