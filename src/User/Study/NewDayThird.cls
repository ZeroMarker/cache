Import SQLUSER

/// Function：数据操作
/// CreateDate：2023-09-13
/// Creator:yanghongrui
Class User.Study.NewDayThird Extends %RegisteredObject
{

/// Function:数据新增
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table:DHC_StudentY
/// Input:StCode,StName,StSexDR,StDob
/// Output：1:成功，0:失败
/// Others:w ##class(User.Study.NewDayThird).InsertData("12","小ba","1","2023-09-13")
ClassMethod InsertData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "0^学号为空"
	q:StName="" "0^姓名为空"
	q:$d(^User.DHCStudentYI("Code",StCode)) "0^学号重复"
	s:StDob'="" StDob=$zdh(StDob,3) //2020-01-01格式
	&SQL(
		INSERT INTO DHC_StudentY(St_Code,St_Name,St_Sex_DR,St_Dob)
		VALUES (:StCode,:StName,:StSexDR,:StDob)
	
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
/// Table:DHC_StudentF
/// Input:StCode^StName^StSexDR^StDob
/// Output：1:成功，0:失败
/// Others:w ##class(User.Study.NewDayThird).AddData("30^doctor^2^2019-01-02")
ClassMethod AddData(DataStr As %String) As %String
{
	q:DataStr="" "0^入参为空"
	s StCode=$p(DataStr,"^",1)
	q:StCode="" "0^学号为空"
	q:$d(^User.DHCStudentYI("Code",StCode)) "0^学号重复"
	s StName=$p(DataStr,"^",2)
	q:StName="" "0^姓名为空"
	s StrSexDR=$p(DataStr,"^",3)
	s StDob=$p(DataStr,"^",4)
	s:StDob'="" StDob=$zdh(StDob,3) //2020-01-01格式
	k PLIST
	s PLIST(2)=StCode
	s PLIST(3)=StName
	s PLIST(4)=StSexDR
	s PLIST(5)=StDob
	&SQL(
		INSERT INTO DHC_StudentY
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
/// Table:DHC_StudentY
/// Others: w ##class(User.Study.NewDayThird).UpdateData("25","nurse","2","2023-09-13")
ClassMethod UpdateData(StRowId As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StRowId="" "0^StRowId为空"
	q:'$d(^User.DHCStudentYD(StRowId)) "0^数据不存在"
	s:StDob'="" StDob=$zdh(StDob,3)
	&SQL(
		UPDATE DHC_StudentY SET St_Name=:StName,St_Sex_DR=:StSexDR,St_Dob=:StDob
		WHERE St_RowId=:StRowId
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
/// w ##class(User.Study.NewDayThird).UpdatePLISTData("12","护士","2","2023-09-13")
ClassMethod UpdatePLISTData(StRowId As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StRowId="" "0^StRowId为空"
	q:'$d(^User.DHCStudentYD(StRowId)) "0^数据不存在"
	s:StDob'="" StDob=$zdh(StDob,3)
	k PLIST
	s PLIST(2)=StName
	s PLIST(3)=StSexDR
	s PLIST(4)=StDob
	&SQL(
		UPDATE DHC_StudentY VALUES :PLIST()
		WHERE St_RowId=:StRowId
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
/// Table:DHC_StudentY
/// Input:
/// Output：
/// Others: d ##class(User.Study.NewDayThird).GetSQLLIST()
ClassMethod GetSQLLIST() As %String
{
	s sqlstr="SELECT St_Code, St_Name, St_Sex_DR, St_Dob FROM DHC_StudentY"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(sqlstr)
		d rs.Execute()
		while (rs.Next())
		{
			s StCode=$g(rs.Data("St_Code"))
			s StName=$g(rs.Data("St_Name"))
			s StSexDR=$g(rs.Data("St_Sex_DR"))
			s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)
			s StDob=$g(rs.Data("St_Dob"))
			s:StDob'="" StDob=$zd(StDob,3)
			w StCode_" "_StName_" "_StSexDR_" "_StDob
			w !
		}
	}
}

/// Function:查询单条数据
/// CreateDate：2023-09-13
/// Creator:yanghongrui
/// Table: DHC_StudentF
/// Input:StRowId
/// Output:
/// Others: w ##class(User.Study.NewDayThird).GetsingleData(12)
ClassMethod GetsingleData(StRowId As %String) As %String
{
	q:StRowId="" "StRowId为空"
	s StCode="", StName=""
	&SQL(
		SELECT St_Code ,St_Name INTO :StCode,:StName FROM DHC_StudentY
	)
	if (SQLCODE=0)
	{
		s result=StCode_" "_StName
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
/// Table: DHC_StudentY
/// Input:StRowId
/// Output:
/// Others: d ##class(User.Study.NewDayThird).GetsingleDataN(12)
ClassMethod GetsingleDataN(StRowId As %String) As %String
{
	q:StRowId="" "StRowId为空"
	k PLIST
	s StCode="", StName=""
	&SQL(
		SELECT St_Code ,St_Name ,St_Sex_DR INTO :PLIST() FROM DHC_StudentY
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
/// Others: w ##class(User.Study.NewDayThird).DeleteData(25)
ClassMethod DeleteData(StRowId As %String) As %String
{

	q:StRowId="" "StRowId为空"
	//q:'$d(^User.DHCStudentYD(StRowId)) "0^数据不存在"
	&SQL(
	DELETE FROM DHC_StudentY
	WHERE St_RowId=:StRowId
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
