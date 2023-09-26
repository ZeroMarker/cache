/// Function:面向对象数据操作
/// CreateDate:2023-09-14
/// Creator:yanghongrui
Class User.Study.NewDayFourY Extends %RegisteredObject
{

/// Function：数据新增
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsCode,CrsDesc,CrsActive
/// Output:
/// Others:w ##class(User.Study.NewDayFourY).AddData("3","模电","Y")
ClassMethod AddData(CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsCode="" "课程号为空"
	q:$d(^User.DHCCourseCI("Code",CrsCode)) "课程号重复"
	q:CrsDesc="" "课程名为空"
	s obj=##class(User.DHCCourseC).%New() //创建对象
	if (obj)
	{
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		//s obj.StSexDR=##class(User.CTSex).%OpenId(StSexDR)
		s obj.CrsActive=CrsActive
		TSTART
		s sc=obj.%Save() 
		if (sc=1)  //($$$ISOK(sc))  判断成功
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

/// Function：数据删除
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsRowId
/// Output: 0：失败 1：成功
/// Others:w ##class(User.Study.NewDayFourY).DeleteData("2")
ClassMethod DeleteData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	q:'$d(^User.DHCCourseCD(CrsRowId)) "数据不存在"
	s obj=##class(User.DHCCourseC).%OpenId(CrsRowId)  //打开对象
	if (obj)
	{
		TSTART
		s sc=##class(User.DHCCourseC).%DeleteId(CrsRowId) //删除对象
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

/// Function：数据更新
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsCode,CrsDesc,CrsActive
/// Output:
/// Others:w ##class(User.Study.NewDayFourY).UpdateData("3", "09","shudian","N")
ClassMethod UpdateData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s obj=##class(User.DHCCourseC).%OpenId(CrsRowId)  //打开对象
	if (obj)
	{
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActive=CrsActive
		TSTART
		s sc=obj.%Save()
		if ($$$ISOK(sc))
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

/// Function:数据保存 将新增和修改合并为一个方法
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsRowId 为空默认为新增 不为空 默认为更新数据
/// Output:
/// Others:w ##class(User.Study.NewDayFourY).SaveData("4","02","单片机","Y")
ClassMethod SaveData(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
		q:CrsCode="" "课程号为空"
		q:CrsDesc="" "课程名为空"
		if (CrsRowId="")  //新增
		{
			s obj=##class(User.DHCCourseC).%New() //创建对象
		}
		else //修改
		{
			s obj=##class(User.DHCCourseC).%OpenId(CrsRowId)  //打开对象
		}
		if (obj)
		{
			s obj.CrsCode=CrsCode
			s obj.CrsDesc=CrsDesc
			s obj.CrsActive=CrsActive
			s sc=obj.%Save()
			TSTART
			if (sc=1)  //($$$ISOK(sc))  判断成功
			{
				TCOMMIT
				s Id=obj.%Id()
				s result="数据保存成功^"_Id
			}
			else
			{
				TROLLBACK
				s result="数据保存失败^"_$SYSTEM.OBJ.DisplayError(sc)
			}
			d obj.%Close()	
		}
		else
		{
			s result="数据不存在"	
			
		}
			
		q result
}

/// Function:取数据
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_CourseC
/// Input:CrsRowId(不能为空)
/// Output:
/// Others:w ##class(User.Study.NewDayFourY).OpenData("4")
ClassMethod OpenData(CrsRowId As %String) As %String
{
	
	q:CrsRowId="" "CrsRowId为空"
	s obj=##class(User.DHCCourseC).%OpenId(CrsRowId)
	if ($ISOBJECT(obj))
	{
		s CrsCode=obj.CrsCode
		s CrsDesc=obj.CrsDesc
		s CrsActive=obj.CrsActive
		s json={}
		d json.%Set("CrsCode",CrsCode)
		d json.%Set("CrsDesc",CrsDesc)
		d json.%Set("CrsActive",CrsActive)
		s result=json.%ToJSON()
		//s result="课程号:"_CrsCode_",课程名"_CrsDesc_",有效性:"_CrsActive
		d obj.%Close()	
		}
	else
	{
		s result="数据不存在"
	}
	q result
}

/// Function:%Query的使用 子表的查询
/// CreateDate:2023-09-15
/// d ##class(%ResultSet).RunQuery("User.Study.NewDayFourY","GetDataList","3")
Query GetDataList(ParRef As %String) As %Query(ROWSPEC = "StScRowId:%String,StScCourseDR:%String,StScScore:%String")
{
}

ClassMethod GetDataListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (ParRef'="")
	{
		s DHCScChildSub=0
		for
		{
			s DHCScChildSub=$O(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub))
			q:DHCScChildSub=""
			s StScRowId=ParRef_"||"_DHCScChildSub
			s StScCourseDR=$p($g(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub)),"^",1)
			s:StScCourseDR'="" StScCourseDR=$p($g(^DHCCOURSE(StScCourseDR)),"^",2) //课程名称
			s StScScore=$p($g(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub)),"^",2)
			d OutputRow	
		}
	}
	else
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set ^CacheTemp(repid,ind)=$lb(StScRowId,StScCourseDR,StScScore)
	set ind=ind+1
	quit
}

ClassMethod GetDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		// if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	else
	{
		Set Row=^CacheTemp(repid,ind)
	
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:保存父表和子表数据(事务)
/// CreateDate:2023-09-15
/// Creator:yanghongrui
/// Table:DHC_StudentY、DHC_StudentCourseRR
/// Input:DataStr (StCode^StName^StSexDR^StDob^StScCourse^Score)
/// Others:w ##class(User.Study.NewDayFourY).AddStudentData("杨红蕊^小杨^2^2023-09-15^1^90")
ClassMethod AddStudentData(DataStr As %String) As %String
{
	q:DataStr="" "入参为空"
	s StCode=$p(DataStr,"^",1)
	q:StCode="" "学号不能为空"
	q:$d(^DHCSTUDENTY(0,"Code",StCode)) "学号已存在"
	s StName=$p(DataStr,"^",2)
	s StSexDR=$p(DataStr,"^",3)
	s StDob=$p(DataStr,"^",4)
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
	s StScCourseDR=$p(DataStr,"^",5)
	q:StScCourseDR="" "课程不能为空"
	s StScScore=$p(DataStr,"^",6)
	s Studentobj=##class(User.DHCStudentH).%New()
	if (Studentobj)
	{
		s Studentobj.StCode=StCode
		s Studentobj.StName=StName
		s Studentobj.StDob=StDob
		d Studentobj.StSexDRSetObjectId(StSexDR)
		TSTART
		s sc=Studentobj.%Save()    
		if ($$$ISOK(sc))
		{
			s id=Studentobj.%Id() //学生id
			if (id'="")
			{
				s courseobj=##class(User.DHCStudentCourseRR).%New(id)
				if (courseobj)
				{
					d courseobj.ParRefSetObjectId(id)
					d courseobj.DHCScCourseDRSetObjectId(StScCourseDR)
					s courseobj.DHCScScore=StScScore
					s coursesc=courseobj.%Save()  
					if (coursesc=1)
					{
						TCOMMIT
						s courseid=courseobj.%Id()
						s result="新增成功，学生id为"_id_",选课表id为"_courseid
					}
					else  //子表保存失败
					{
						TROLLBACK
						s result="选课表新增失败，原因为:"_$system.OBJ.DisplayError(coursesc)
					}
					d courseobj.%Close()
				}
			}
		}
		else  //学生表保存失败
		{
			TROLLBACK
			s result="学生表保存失败，原因为"_$system.OBJ.DisplayError(sc)
		}
		d Studentobj.%Close()
	}
	q result
}

}
