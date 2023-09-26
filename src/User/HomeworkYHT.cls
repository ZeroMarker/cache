Class User.HomeworkYHT Extends %RegisteredObject
{

/// Creator: 杨洪涛
/// Function: 根据RowId查找人员性别
/// d ##class(User.HomeworkYHT).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
	q:AdmRowId=""
	s ADMStr=$g(^PAADM(AdmRowId))
	s PAPMIDR=$p(ADMStr,"^",1)
	s PAPMIStr=$g(^PAPER(PAPMIDR,"ALL"))
	s PatSexDR=$p(PAPMIStr,"^",7)
	s SexStr=$g(^CT("SEX",PatSexDR))
	s SexDesc=$p(SexStr,"^",2)
	w SexDesc,!
}

/// Creator: 杨洪涛
/// Function: 查找所有学生信息
/// d ##class(User.HomeworkYHT).GetStudentInfo()
ClassMethod GetStudentInfo() As %String
{
	s RowId=0
	for{
		s RowId=$o(^StudentInfoSQLYHT(RowId))
		q:RowId=""
		s StCode=$p($g(^StudentInfoSQLYHT(RowId)),"^",1)
		s StName=$p($g(^StudentInfoSQLYHT(RowId)),"^",2)
		s StSexDR=$p($g(^StudentInfoSQLYHT(RowId)),"^",3)
		s StSexDesc=""
		s:StSexDR'="" StSexDesc=$p($g(^CT("SEX",StSexDR)),"^",2)
		s StDob=$p($g(^StudentInfoSQLYHT(RowId)),"^",4)
		s:StDob'="" StDob=$zd(StDob,3)
		s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDesc_",出生日期:"_StDob
		w result,!
	}
}

/// Creator: 杨洪涛
/// Function: 查找所有课程信息
/// d ##class(User.HomeworkYHT).GetCourseInfo()
ClassMethod GetCourseInfo() As %String
{
	s RowId=0
	for{
		s RowId=$o(^CourseSQLYHT(RowId))
		q:RowId=""
		s CrsCode=$p($g(^CourseSQLYHT(RowId)),"^",1)
		s CrsDesc=$p($g(^CourseSQLYHT(RowId)),"^",2)
		s CrsActiveFlag=$p($g(^CourseSQLYHT(RowId)),"^",3)
		s result="课程编号:"_CrsCode_",课程名称:"_CrsDesc_",课程是否有效:"_CrsActiveFlag
		w result,!
	}
}

/// Creator: 杨洪涛
/// Function: 新增一条课程信息
/// w ##class(User.HomeworkYHT).InsertCourse("10044","数字电路","Y")
ClassMethod InsertCourse(Code As %String, Desc As %String, ActiveFlag As %String) As %String
{
	q:Code="" "课程编号为空"
	q:Desc="" "课程名称为空"
	q:ActiveFlag="" "课程是否有效标志为空"
	q:$d(^CourseSQLYHT("0","Code",Code)) "课程编号重复"
	&SQL( INSERT INTO DHC_CourseYHT (Crs_Code,Crs_Desc,Crs_ActiveFlag) 
		VALUES (:Code,:Desc,:ActiveFlag) )
	if (SQLCODE=0)
	{
		s result="新增成功"	
	}
	else
	{
		s result="新增失败^"_%msg	
	}
	q result
}

/// Creator: 杨洪涛
/// Function: 更新一条课程信息
/// w ##class(User.HomeworkYHT).UpdateCourse("1","10066","模拟电路","Y")
ClassMethod UpdateCourse(RowId As %String, Code As %String, Desc As %String, ActiveFlag As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^CourseSQLYHT(RowId)) "数据不存在"
	&SQL( UPDATE DHC_CourseYHT SET Crs_Code=:Code,Crs_Desc=:Desc,Crs_ActiveFlag=:ActiveFlag
		WHERE Crs_RowId=:RowId )
	if (SQLCODE=0)
	{
		s result="更新成功"	
	}
	else
	{
		s result="更新失败^"_%msg	
	}
	q result
}

/// Creator: 杨洪涛
/// Function: 查询课程信息
/// d ##class(User.HomeworkYHT).SearchCourse()
ClassMethod SearchCourse() As %String
{
	s StrSql="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag FROM DHC_CourseYHT ORDER BY Crs_Code Desc"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	While(result.Next())
	{
		s CrsCode=result.Data("Crs_Code")
		s CrsDesc=result.Data("Crs_Desc")
		s CrsActiveFlag=result.Data("Crs_ActiveFlag")
		w "课程编号:"_CrsCode_",课程名称:"_CrsDesc_",课程是否有效:"_CrsActiveFlag,!	
	}
}

/// Creator: 杨洪涛
/// Function: 删除一条课程信息
/// w ##class(User.HomeworkYHT).DeleteCourse("3")
ClassMethod DeleteCourse(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^CourseSQLYHT(RowId)) "数据不存在"
	&SQL( DELETE FROM DHC_CourseYHT 
		WHERE Crs_RowId=:RowId )
	if (SQLCODE=0)
	{
		s result="删除成功"	
	}
	else
	{
		s result="删除失败^"_%msg	
	}
	q result
}

/// Function: 对象方式新增课程信息
/// Creator: 杨洪涛
/// Input: Code,Desc,ActiveFlag
/// Output: result
/// others: w ##class(User.HomeworkYHT).AddCourseByOBJ("10099","计算机基础","N")
ClassMethod AddCourseByOBJ(Code As %String, Desc As %String, ActiveFlag As %String) As %String
{
	q:Code="" "课程编号为空"
	q:Desc="" "课程名称为空"
	q:ActiveFlag="" "课程是否有效标志为空"
	q:$d(^CourseSQLYHT("0","Code",Code)) "课程编号重复"	
	s obj=##class(User.DHCCourseYHT).%New()
	if (obj)
	{
		s obj.CrsCode=Code
		s obj.CrsDesc=Desc
		s obj.CrsActiveFlag=ActiveFlag	
	}
	else {q "新建对象失败"}
	TSTART
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s RowId=obj.%Id()
		s result="新增成功^"_RowId	
	}
	else 
	{
		TROLLBACK
		s result="新增失败,出错原因^"_$SYSTEM.Status.GetErrorText(sc)
	}
	d obj.%Close()
	q result
}

/// Function: 对象方式删除课程信息
/// Creator: 杨洪涛
/// Input: RowId
/// Output: result
/// others: w ##class(User.HomeworkYHT).DeleteCourseByOBJ("2")
ClassMethod DeleteCourseByOBJ(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^CourseSQLYHT(RowId)) "数据不存在"
	TSTART
	s sc=##class(User.DHCCourseYHT).%DeleteId(RowId)
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="删除成功^"_RowId	
	}
	else 
	{
		TROLLBACK
		s result="删除失败,出错原因^"_$SYSTEM.Status.GetErrorText(sc)
	}
	q result
}

/// Function: 对象方式更新课程信息
/// Creator: 杨洪涛
/// Input: RowId,Code,Desc,ActiveFlag
/// Output: result
/// others: w ##class(User.HomeworkYHT).UpdateCourseByOBJ("4","10100","算法设计","N")
ClassMethod UpdateCourseByOBJ(RowId As %String, Code As %String, Desc As %String, ActiveFlag As %String) As %String
{
	q:RowId="" "RowId为空"
	q:Code="" "课程编号为空"
	q:Desc="" "课程名称为空"
	q:ActiveFlag="" "课程是否有效标志为空"	
	s obj=##class(User.DHCCourseYHT).%OpenId(RowId)
	if (obj)
	{
		s obj.CrsCode=Code
		s obj.CrsDesc=Desc
		s obj.CrsActiveFlag=ActiveFlag	
	}
	else {q "需更新的数据不存在"}
	TSTART
	s sc=obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result="更新成功^"_RowId	
	}
	else 
	{
		TROLLBACK
		s result="更新失败,出错原因^"_$SYSTEM.Status.GetErrorText(sc)
	}
	d obj.%Close()
	q result
}

/// Function: 对象方式查询所有课程信息
/// Creator: 杨洪涛
/// Input: 
/// Output: 课程数据列表
/// others: d ##class(User.HomeworkYHT).SearchCourseByOBJ()
ClassMethod SearchCourseByOBJ() As %String
{
	s RowId=0
	for
	{
		s RowId=$o(^CourseSQLYHT(RowId))
		q:RowId=""
		s obj=##class(User.DHCCourseYHT).%OpenId(RowId)
		if (obj)
		{
			s Code=obj.CrsCode
			s Desc=obj.CrsDesc
			s ActiveFlag=obj.CrsActiveFlag
			w "课程编号:"_Code_",课程名称:"_Desc_",课程是否有效:"_ActiveFlag,!	
		}
		d obj.%Close()
		k obj
	}
}

/// Function: 对象方式查询一条课程信息
/// Creator: 杨洪涛
/// Input: RowId
/// Output: 课程数据列表
/// others: w ##class(User.HomeworkYHT).GetCourseByOBJ("5")
ClassMethod GetCourseByOBJ(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	s obj=##class(User.DHCCourseYHT).%OpenId(RowId)
	if (obj)
	{
		s Code=obj.CrsCode
		s Desc=obj.CrsDesc
		s ActiveFlag=obj.CrsActiveFlag
		s result="课程编号:"_Code_",课程名称:"_Desc_",课程是否有效:"_ActiveFlag
	}
	else 
	{
		s result="未查询到该条数据"	
	}
	d obj.%Close()
	k obj
	q result
}

/// Function: 父子表新增数据
/// Creator: 杨洪涛
/// Input: DataList
/// Output: result
/// others: w ##class(User.HomeworkYHT).AddStudentCourse("010^赵四^1^1997-05-01^5^60")
ClassMethod AddStudentCourse(DataList As %String) As %String
{
	q:DataList="" "新增数据为空"
	s StCode=$p(DataList,"^",1)
	q:StCode="" "学号为空"
	q:$d(^StudentInfoSQLYHT(0,"Code",StCode)) "该学生已存在"
	s StName=$p(DataList,"^",2)
	s StSexDR=$p(DataList,"^",3)
	s StDob=$p(DataList,"^",4)
	s:StDob'="" StDob=##Class(websys.Conversions).DateHtmlToLogical(StDob)
	s StScCourseDR=$p(DataList,"^",5)
	q:StScCourseDR="" "课程为空"
	s Score=$p(DataList,"^",6)
	s Stobj=##class(User.DHCStudentYHT).%New()
	if (Stobj)
	{
		s Stobj.StCode=StCode
		s Stobj.StName=StName
		d Stobj.StSexDRSetObjectId(StSexDR)
		s Stobj.StDob=StDob
		TSTART
		s Stsc=Stobj.%Save()
		if ($$$ISOK(Stsc))
		{
			s StRowId=Stobj.%Id()
			if (StRowId'="")
			{
				s Scobj=##class(User.DHCStudentCourseYHT).%New(StRowId)
				if (Scobj)
				{
					d Scobj.DHCScStudentParRefSetObjectId(StRowId)
					d Scobj.DHCScCourseDRSetObjectId(StScCourseDR)
					s Scobj.DHCScScore=Score
					s Scsc=Scobj.%Save()
					if ($$$ISOK(Scsc))
					{
						TCOMMIT
						s ScRowId=Scobj.%Id()
						s result="新增成功,学号为:"_StRowId_",选课编号为:"_ScRowId		
					}
					else 
					{
						TROLLBACK
						s result="选课表新增失败,原因为:"_$System.OBJ.DisplayError(Scsc)	
					}
					d Scobj.%Close()
					k Scobj
				}	
			}	
		}
		else 
		{
			TROLLBACK
			s StResult="学生表新增失败,原因为:"_$System.OBJ.DisplayError(Stsc)
		}
		d Stobj.%Close()
		k Stobj
	}
	q result
}

/// Creator: 杨洪涛
/// Function: 查找所有选课信息
/// d ##class(User.HomeworkYHT).GetStudentCourseInfo()
ClassMethod GetStudentCourseInfo() As %String
{
	s StRowId=0
	for
	{
		s StRowId=$o(^StudentInfoSQLYHT(StRowId))
		q:StRowId=""
		s ChildSub=0
		for
		{
			s ChildSub=$o(^StudentInfoSQLYHT(StRowId,"Course",ChildSub))
			q:ChildSub=""
			s CrsCourseStr=$g(^StudentInfoSQLYHT(StRowId,"Course",ChildSub))
			s CrsRowId=$p(CrsCourseStr,"^",1)
			s Score=$p(CrsCourseStr,"^",2)
			s Name=$p($g(^StudentInfoSQLYHT(StRowId)),"^",2)
			s Course=$p($g(^CourseSQLYHT(CrsRowId)),"^",2)
			w "学生姓名:"_Name_", 所选科目:"_Course_", 成绩:"_Score
			w !
		}
	}
}

/// Creator: 杨洪涛
/// Function: 查找所有选课信息
/// Others: d ##class(%ResultSet).RunQuery("User.HomeworkYHT","GetStudentCourse")
Query GetStudentCourse() As %Query(ROWSPEC = "Name:%String,Course:%String,Score:%String")
{
}

ClassMethod GetStudentCourseExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s StRowId=0
	for
	{
		s StRowId=$o(^StudentInfoSQLYHT(StRowId))
		q:StRowId=""
		s ChildSub=0
		for
		{
			s ChildSub=$o(^StudentInfoSQLYHT(StRowId,"Course",ChildSub))
			q:ChildSub=""
			s CrsCourseStr=$g(^StudentInfoSQLYHT(StRowId,"Course",ChildSub))
			s CrsRowId=$p(CrsCourseStr,"^",1)
			s Score=$p(CrsCourseStr,"^",2)
			s Name=$p($g(^StudentInfoSQLYHT(StRowId)),"^",2)
			s Course=$p($g(^CourseSQLYHT(CrsRowId)),"^",2)
			d OutputRow
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
 	Set Data=$lb(Name,Course,Score)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetStudentCourseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStudentCourseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStudentCourseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStudentCourseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
