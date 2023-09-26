Import SQLUser

Class User.gzyDay4 Extends %Persistent
{

/// Function:数据新增
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:GZY_DHC_Course
/// Input:CrsCode,CrsDesc,CrsActiveFlag
/// Output:result
/// Others:w ##class(User.gzyDay4).AddData("02","语文","Y")
ClassMethod AddData(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "0^Code为空"
	q:$d(^User.GZYDHCCourseI("Code",CrsCode)) "0^课程号重复"
	q:CrsDesc="" "0^Desc为空"
	s obj=##class(User.GZYDHCCourse).%New()
	if (obj)
	{
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag
		TSTART
		s sc=obj.%Save() 
		if (sc=1)
		{
			TCOMMIT
			s CrsRowId=obj.%Id()
			s result="成功^"_CrsRowId
		}
		else
		{
			TROLLBACK
			s result="失败^"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	q result
}

/// Function:数据修改
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:GZY_DHC_Course
/// Input:CrsRowId,CrsCode,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:  w ##class(User.gzyDay4).UpdateData("2","地理","Y")
ClassMethod UpdateData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	s obj=##class(User.GZYDHCCourse).%OpenId(CrsRowId)
	if (obj)
	{
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s result="成功"
		}
		else
		{
			TROLLBACK
			s result="失败"
		}
		d obj.%Close()
	}
	else
	{
		s result="对象不存在"
	}
	q result
}

/// Function:数据保存
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:GZY_DHC_Course
/// Input:CrsRowId,CrsCode,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:  w ##class(User.gzyDay4).SaveData("1","地理","Y")
ClassMethod SaveData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "0^Code为空"
	q:CrsDesc="" "0^Desc为空"
	if (CrsRowId="")
	{
		s obj=##class(User.GZYDHCCourse).%New()
	}
	else
	{
		s obj=##class(User.GZYDHCCourse).%OpenId(CrsRowId)
	}
	if (obj)
	{
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag
		TSTART
		s sc=obj.%Save() 
		if (sc=1)
		{
			TCOMMIT
			s CrsRowId=obj.%Id()
			s result="成功^"_CrsRowId
		}
		else
		{
			TROLLBACK
			s result="失败^"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	q result
}

/// Function:数据查询
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:GZY_DHC_Course
/// Input:CrsRowId
/// Output:result
/// Others:w ##class(User.gzyDay4).OpenData("1")
ClassMethod OpenData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s obj=##class(User.GZYDHCCourse).%OpenId(CrsRowId)
	if ($ISOBJECT(obj))
	{
		s CrsCode= obj.CrsCode
		s CrsDesc= obj.CrsDesc
		s CrsActiveFlag= obj.CrsActiveFlag
		s json={}
		d json.%Set("CrsCode",CrsCode)
		d json.%Set("CrsDesc",CrsDesc)
		d json.%Set("CrsActiveFlag",CrsActiveFlag)
		s result=json.%ToJSON()
		d obj.%Close()
	}
	else
	{
		s result="没有查到数据"
	}
	q result
}

/// Function:数据删除
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:GZY_DHC_Course
/// Input:CrsRowId
/// Output:result
/// Others:w ##class(User.gzyDay4).DeleteData(1)
ClassMethod DeleteData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	q:'$d(^User.GZYDHCCourseD(CrsRowId)) "0^数据不存在"
	s obj=##class(User.GZYDHCCourse).%OpenId(CrsRowId)
	if (obj)
	{
		TSTART
		s sc=##class(User.GZYDHCCourse).%DeleteId(CrsRowId)
		if ($$$ISOK(sc))
		{
			TCOMMIT
			s result=1
		}
		else
		{
			TROLLBACK
			s result=0
		}
		d obj.%Close()
	}
	q result
}

Storage Default
{
<Data name="gzyDay4DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.gzyDay4D</DataLocation>
<DefaultData>gzyDay4DefaultData</DefaultData>
<IdLocation>^User.gzyDay4D</IdLocation>
<IndexLocation>^User.gzyDay4I</IndexLocation>
<StreamLocation>^User.gzyDay4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
