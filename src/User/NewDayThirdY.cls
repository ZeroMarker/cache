/// Function：数据操作
/// CreateDate：2023-09-13
/// Creator:yanghongrui
Class User.NewDayThirdY Extends %RegisteredObject
{

/// Function:数据新增
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsCode,CrsDesc,CrsActive
/// Output：1:成功，0:失败
/// Others:w ##class(User.NewDayThirdY).InsertData("01","函数","Y")
ClassMethod InsertData(CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsCode="" "0^课程号为空"
	q:CrsDesc="" "0^课程名为空"
	q:$d(^User.DHCCourseCI("Code",CrsCode)) "0^课程号重复"
	&SQL(
		INSERT INTO DHC_CourseC(Crs_Code,Crs_Desc,Crs_Active)
		VALUES (:CrsCode,:CrsDesc,:CrsActive)
	
		)
	if (SQLCODE=0)
	{
		s result=1_"^"_%ROWID
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Function:数据新增(PLIST)
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsCode^CrsDesc^CrsActive
/// Output：1:成功，0:失败
/// Others:w ##class(User.NewDayThirdY).AddData("10^数电^Y")
ClassMethod AddData(DataStr As %String) As %String
{
	q:DataStr="" "0^入参为空"
	s CrsCode=$p(DataStr,"^",1)
	q:CrsCode="" "0^课程号为空"
	q:$d(^User.DHCCourseCI("Code",CrsCode)) "0^课程号重复"
	s CrsDesc=$p(DataStr,"^",2)
	q:CrsDesc="" "0^课程名为空"
	s CrsActive=$p(DataStr,"^",3)
	k PLIST
	s PLIST(2)=CrsCode
	s PLIST(3)=CrsDesc
	s PLIST(4)=CrsActive
	&SQL(
		INSERT INTO DHC_CourseC
		VALUES :PLIST()
	)
	if (SQLCODE=0)
	{
		s result=1_"^"_%ROWID
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Function:数据新增(PLIST)
/// CreateDate：2023-09-18
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsCode^CrsDesc^CrsActive
/// Output：1:成功，0:失败
/// Others:w ##class(User.NewDayThirdY).AddDataY("杨红蕊01^1050^小单人床F")
/// w ##class(User.NewDayThirdY).AddDataY("杨红蕊02^1000^大单人床A")
/// w ##class(User.NewDayThirdY).AddDataY("杨红蕊03^1020^单人床C")
/// w ##class(User.NewDayThirdY).AddDataY("杨红蕊04^1030^贵单人床D")
/// w ##class(User.NewDayThirdY).AddDataY("杨红蕊04^1030^便宜单人床B")
ClassMethod AddDataY(DataStr As %String) As %String
{
	q:DataStr="" "0^入参为空"
	s PatName=$p(DataStr,"^",1)
	q:PatName="" "0^姓名为空"
	q:$d(^TempBYHR("Name",PatName)) "0^姓名重复"
	s BEDNO=$p(DataStr,"^",2)
	q:BEDNO="" "0^床号为空"
	s BEDDesc=$p(DataStr,"^",3)
	k PLIST
	s PLIST(2)=PatName
	s PLIST(3)=BEDNO
	s PLIST(4)=BEDDesc
	&SQL(
		INSERT INTO TempB_YangHongRuiB
		VALUES :PLIST()
	)
	if (SQLCODE=0)
	{
		s result=1_"^"_%ROWID
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Function：修改数据
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Others: w ##class(User.NewDayThirdY).UpdateData("1","08","fangfa","Y")
ClassMethod UpdateData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^User.DHCCourseCD(CrsRowId)) "0^数据不存在"
	&SQL(
		UPDATE DHC_CourseC SET Crs_Code=:CrsCode, Crs_Desc=:CrsDesc,Crs_Active=:CrsActive
		WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s result=1
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Function：PLIST修改
/// w ##class(User.NewDayThirdY).UpdatePLISTData("1", "08", "FANGFA", "N")
ClassMethod UpdatePLISTData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^User.DHCCourseCD(CrsRowId)) "0^数据不存在"
	k PLIST
	s PLIST(2)=CrsCode
	s PLIST(3)=CrsDesc
	s PLIST(4)=CrsActive
	&SQL(
		UPDATE DHC_CourseC VALUES :PLIST()
		WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s result=1
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Function:数据查询
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:
/// Output：
/// Others: d ##class(User.NewDayThirdY).GetSQLLIST()
ClassMethod GetSQLLIST() As %String
{
	s sqlstr="SELECT Crs_Code, Crs_Desc, Crs_Active FROM DHC_CourseC"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(sqlstr)
		d rs.Execute()
		while (rs.Next())
		{
			s CrsCode=$g(rs.Data("Crs_Code"))
			s CrsDesc=$g(rs.Data("Crs_Desc"))
			s CrsActive=$g(rs.Data("Crs_Active"))
			w CrsCode_" "_CrsDesc_" "_CrsActive
			w !
		}
	}
}

/// Function:查询单条数据
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table: DHC_CourseC
/// Input:CrsRowId
/// Output:
/// Others: w ##class(User.NewDayThirdY).GetsingleData("08")
ClassMethod GetsingleData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s CrsCode="",  CrsDesc=""
	&SQL(
		SELECT Crs_Code, Crs_Desc INTO :CrsCode,:CrsDesc FROM DHC_CourseC
	)
	if (SQLCODE=0)
	{
		s result=CrsCode_" "_CrsDesc
	}
	else
	{
		s result="没查到数据"
	}
	q result
}

/// Function:查询单条数据(PLIST)
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table: DHC_CourseC
/// Input:CrsRowId
/// Output:
/// Others: d ##class(User.NewDayThirdY).GetsingleDataN("08")
ClassMethod GetsingleDataN(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	k PLIST
	s CrsCode="", CrsDesc=""
	&SQL(
		SELECT Crs_Code ,Crs_Desc  INTO :PLIST() FROM DHC_CourseC
	)
	if (SQLCODE=0)
	{
		s count=$o(PLIST(""),-1)
		for i=2:1:count
		{
			w PLIST(i)_" "
		}
	}
	else
	{
		s result="没查到数据"
	}
	//q result
}

/// Function：数据删除
/// Others: w ##class(User.NewDayThirdY).DeleteData("1")
ClassMethod DeleteData(CrsRowId As %String) As %String
{

	q:CrsRowId="" "CrsRowId为空"
	//q:'$d(^User.Study.DHCCourseD(CrsCode)) "0^数据不存在"
	&SQL(
		DELETE FROM DHC_CourseC
		WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s result="删除成功"
	}
	else
	{
		s result="删除失败"
	}
	q result
}

}
