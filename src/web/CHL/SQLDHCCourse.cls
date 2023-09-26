Class web.CHL.SQLDHCCourse Extends %RegisteredObject
{

// 陈洪亮

// w ##class(web.CHL.SQLDHCCourse).AddData("1^Math^Y")

ClassMethod AddData(CrsStr) As %String
{
	s CrsCode = $p(CrsStr,"^",1)
	s CrsDesc = $p(CrsStr,"^",2)
	s CrsActiveFlag = $p(CrsStr,"^",3)
	q:CrsCode="" "课程号为空"
	q:CrsDesc="" "课程描述为空"
	q:$d(^DHCCOURSECHL(0,"Code",CrsCode)) "课程号重复"
	&sql(
		INSERT INTO User_CHL.DHC_Course (Crs_Code, Crs_Desc, Crs_ActiveFlag)
		VALUES(:CrsCode,:CrsDesc,:CrsActiveFlag)
	)
	if (SQLCODE=0) {
		s result = 1_"^"_%ROWID
	}
	else {
		s result = 0_"^"_%msg
	}
	q result
}

// 陈洪亮

// w ##class(web.CHL.SQLDHCCourse).DeleteData(2)

ClassMethod DeleteData(CrsId) As %String
{
	&sql(
		DELETE FROM User_CHL.DHC_Course 
		WHERE Crs_RowId = :CrsId	
	)
	if (SQLCODE=0) {
		s result = 1_"^"_%ROWID
	}
	else {
		s result = 0_"^"_%msg
	}
	q result
}

// 陈洪亮

// w ##class(web.CHL.SQLDHCCourse).UpdateData("2^2^English^Y")

ClassMethod UpdateData(CrsStr) As %String
{
	q:CrsStr="" "输入为空"
	s CrsId = $p(CrsStr,"^",1)
	s CrsCode = $p(CrsStr,"^",2)
	s CrsDesc = $p(CrsStr,"^",3)
	s CrsActiveFlag = $p(CrsStr,"^",4)
	q:CrsId="" "课程Id为空"
	q:'$d(^DHCCOURSECHL(CrsId)) "数据不存在"
	&sql(
		UPDATE User_CHL.DHC_Course 
		SET Crs_Code=:CrsCode, Crs_Desc=:CrsDesc, Crs_ActiveFlag=:CrsActiveFlag
		WHERE Crs_RowId = :CrsId	
	)
	if (SQLCODE=0) {
		s result = 1_"^"_%ROWID
	}
	else {
		s result = 0_"^"_%msg
	}
	q result
}

// 陈洪亮

// d ##class(web.CHL.SQLDHCCourse).QueryData(1)

ClassMethod QueryData(CrsId) As %String
{
	q:CrsId="" "课程Id为空"
	q:'$d(^DHCCOURSECHL(CrsId)) "数据不存在"
	s CrsCode=""
	s CrsDesc=""
	&sql(
		SELECT Crs_Code, Crs_Desc INTO :CrsCode,:CrsDesc FROM User_CHL.DHC_Course 
		WHERE 	Crs_RowId = :CrsId
	)
	if (SQLCODE=0) {
		s result = 1_"^"_%ROWID
	}
	else {
		s result = 0_"^"_%msg
	}
	w "课程号："_CrsCode_" "_"课程描述: "_CrsDesc
	q result
}

// 陈洪亮

// d ##class(web.CHL.SQLDHCCourse).QueryDataList()

ClassMethod QueryDataList()
{
		s sqlstr="SELECT Crs_Code, Crs_Desc, Crs_ActiveFlag FROM User_CHL.DHC_Course"
		s rs = ##class(%ResultSet).%New()
		if (rs) {
			d rs.Prepare(sqlstr)
			d rs.Execute()
			
			while(rs.Next()) {
				s CrsCode=rs.Data("Crs_Code")
				s CrsDesc=rs.Data("Crs_Desc")
				s CrsActiveFlag=rs.Data("Crs_ActiveFlag")
				w "课程号："_CrsCode_" 课程描述"_CrsDesc_" 有效标志"_CrsActiveFlag,!
			}
		}
}

}
