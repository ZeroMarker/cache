/// Fucntion:面向对象增删改查
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
Class web.study.ZyzFWork Extends %RegisteredObject
{

/// Fucntion:数据新增
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:Code:代码, Desc:名称, Active:有效性
/// Output:
/// Others:w ##class(web.study.ZyzFWork).AddData("07","社会","Y")
ClassMethod AddData(Code As %String, Desc As %String, Active As %String) As %String
{
	q:Code="" "课程代码为空"
	q:$d(^User.DHCZYZCourseI("Code",Code)) "课程代码已存在"
	q:Desc="" "课程名称为空"
	s obj=##class(User.DHCZYZCourse).%New()
	s result=""
	if (obj)
	{
		s obj.CrsCode=Code //代码
		s obj.CrsDesc=Desc //名称
		s obj.CrsActive=Active //有效性
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s CrsRowId=obj.%Id()
			s result="新增成功^"_CrsRowId
		} 
		else
		{
			TROLLBACK
			s result="新增失败^"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	q result
}

/// Fucntion:数据删除
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:RowId
/// Output:
/// Others:w ##class(web.study.ZyzFWork).DeleteData("7")
ClassMethod DeleteData(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^User.DHCZYZCourseD(RowId)) "数据不存在"
	s obj=##class(User.DHCZYZCourse).%OpenId(RowId) //打开对象
	s result=""
	if (obj)
	{
		TSTART
		s sc=##class(User.DHCZYZCourse).%DeleteId(RowId) //删除对象
		if ($$$ISOK(sc))
		{
			TCOMMIT
			s result="删除成功"	
		}
		else
		{
			TROLLBACK
			s result="删除失败"
		}
		d obj.%Close()
	}
	q result
}

/// Fucntion:数据查询
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:RowId
/// Output:单条信息
/// Others:w ##class(web.study.ZyzFWork).GetData("8")
ClassMethod GetData(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	s obj=##class(User.DHCZYZCourse).%OpenId(RowId)
	if (obj)
	{
		s CrsCode=obj.CrsCode
		s CrsDesc=obj.CrsDesc
		s:obj.CrsActive'="" CrsActive=obj.CrsActive
		s json={}
		d json.%Set("CrsCode",CrsCode)
		d json.%Set("CrsDesc",CrsDesc)
        d:CrsActive'="" json.%Set("CrActive",CrsActive)
		s result=json.%ToJSON()
		d obj.%Close()
	
	}
	else 
	{
		s result="数据不存在"
	}
	q result
}

/// Fucntion:数据修改
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:RowId
/// Output:
/// Others:w ##class(web.study.ZyzFWork).UpdateData("8","13","生物","Y")
ClassMethod UpdateData(RowId As %String, Code As %String, Desc As %String, Active As %String) As %String
{
	q:Code="" "课程代码为空"
	q:Desc="" "课程名称为空"
	s obj=##class(User.DHCZYZCourse).%OpenId(RowId) //打开对象			
	if (obj)
	{
		s obj.CrsCode=Code
		s obj.CrsDesc=Desc
		s:Active'="" obj.CrsActive=Active
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s result="修改成功"
		} 
		else
		{
			TROLLBACK
			s result="修改失败^"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	else
	{
		s result="数据不存在"
	}
	q result
}

/// Fucntion:子表的数据新增
/// CreateDate:2023-09-15
/// Creator:zhangyizhu
/// Table:DHCZYZT_StudentCourse
/// Input:ParRef: 父表id, ScCrsDR:课程id, ScScore:分数
/// Output:
/// Others:w ##class(web.study.ZyzFWork).InsertData("3","1","100")
ClassMethod InsertData(ParRef As %String, ScCrsDR As %String, ScScore As %String) As %String
{
	q:ParRef="" "父表id为空"
	q:ScCrsDR="" "课程id为空"
	s obj=##class(User.DHCZYZTStudentCourse).%New(ParRef) b
	if (obj)
	{
		d obj.StudentParRefSetObjectId(ParRef) //父表id
		d obj.ScCrsDRSetObjectId(ScCrsDR) //课程表id
		s:ScScore'="" obj.ScScore=ScScore
		TSTART
		s sc = obj.%Save()
		if (sc=1)
		{
			s id=obj.%Id()
			TCOMMIT
			s result="新增成功^"_id
		}
		else
		{
			TROLLBACK
			s result="新增失败^"_$system.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	else
	{
		s result="父表数据不存在"
	}
}

}
