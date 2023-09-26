/// Function:面向对象数据操作
/// CreateDate:2023-09-14
/// Creator:yanghongrui
Class User.Study.NewDayFour Extends %RegisteredObject
{

/// Function：数据新增
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_StudentY
/// Input:StCode,StName,StSexDR,StDob
/// Output:
/// Others:w ##class(User.Study.NewDayFour).AddData("1","杨红蕊01","1","2023-09-14")
ClassMethod AddData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "学号为空"
	q:$d(^User.DHCStudentYI("Code",StCode)) "学号重复"
	q:StName="" "姓名为空"
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob) //$zdh(StDob,3)
	s obj=##class(User.DHCStudentY).%New() //创建对象
	if (obj)
	{
		s obj.StCode=StCode
		s obj.StName=StName
		//s obj.StSexDR=##class(User.CTSex).%OpenId(StSexDR)
		d obj.StSexDRSetObjectId(StSexDR)
		s obj.StDob=StDob
		TSTART
		s sc=obj.%Save() 
		if (sc=1)  //($$$ISOK(sc))  判断成功
		{
			TCOMMIT
			s StRowId=obj.%Id()
			s result="成功^"_StRowId
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
/// Table:DHC_StudentY
/// Input:StRowId
/// Output: 0：失败 1：成功
/// Others:w ##class(User.Study.NewDayFour).DeleteData("23")
ClassMethod DeleteData(StRowId As %String) As %String
{
	q:StRowId="" "StRowId为空"
	q:'$d(^User.DHCStudentYD(StRowId)) "数据不存在"
	s obj=##class(User.DHCStudentY).%OpenId(StRowId)  //打开对象
	if (obj)
	{
		TSTART
		s sc=##class(User.DHCStudentY).%DeleteId(StRowId) //删除对象
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
/// Table:DHC_StudentY
/// Input:StCode,StName,StSexDR,StDob
/// Output:
/// Others:w ##class(User.Study.NewDayFour).UpdateData("12","B","小B",""1","2023-09-14")
ClassMethod UpdateData(CrsRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StRowId="" "StRowId为空"
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob) //$zdh(StDob,3)
	s obj=##class(User.DHCStudentY).%OpenId(StRowId)  //打开对象
	if (obj)
	{
		s obj.StCode=StCode
		s obj.StName=StName
		d obj.StSexDRSetObjectId(StSexDR) //指向型字段赋值方式
		s obj.StDob=StDob
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
/// Table:DHC_StudentY
/// Input:StRowId 为空默认为新增 不为空 默认为更新数据
/// Output:
/// Others:w ##class(User.Study.NewDayFour).UpdateData("12","B","小B",""1","2023-09-14")
ClassMethod SaveData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
		q:StCode="" "学号为空"
		q:StName="" "姓名为空"
		s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
		if (StRowId="")  //新增
		{
			s obj=##class(User.DHCStudentY).%New() //创建对象
		}
		else //修改
		{
			s obj=##class(User.DHCStudentY).%OpenId(StRowId)  //打开对象
		}
		if (obj)
		{
			s obj.StCode=StCode
			s obj.StName=StName
			d obj.StSexDRSetObjectId(StSexDR)
			s obj.StDob=StDob
			TSTART
			s sc=obj.%Save()
			if (sc=1)  //($$$ISOK(sc))  判断成功
			{
				TCOMMIT
				s id=obj.%Id()
				s result="数据保存成功^"_id
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
			s result="对象不存在"
			
			}	
		q result
}

/// Function:取数据
/// CreateDate:2023-09-14
/// Creator:yanghongrui
/// Table:DHC_StudentY
/// Input:StRowId(不能为空)
/// Output:
/// Others:w ##class(User.Study.NewDayFour).UpdateData("12","B","小B",""1","2023-09-14")
ClassMethod OpenData(StRowId As %String) As %String
{
	
	q:StRowId="" "StRowId为空"
	s obj=##class(User.DHCStudentY).%OpenId(StRowId)
	if ($ISOBJECT(obj))
	{
		s StCode=obj.StCode
		s StName=obj.StName
		s StDob=obj.StDob
		s:StDob'="" StDob=##class(websys.Conversions).DateLogicalToHtml(StDob)
		s StSexDR=obj.StSexDRGetObjectId() //指向型字段的取法
		s StSexDRDesc=""
		s:StSexDR'="" StSexDRDesc=obj.StSexDR.CTSEXDesc //性别描述
		s json={}
		d json.%Set("StCode",StCode)
		d json.%Set("StName",StName)
		d json.%Set("StSexDR",StSexDR)
		d json.%Set("StSexDRDesc",StSexDRDesc)
		d json.%Set("StDob",StDob)
		s result=json.%ToJSON()
		//s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDRDesc_",出生日期:"_StDob
		d obj.%Close()	
		}
		else
		{
			s result="数据不存在"
		}
		q result
}

/// Function:子表的数据新增
/// CreateDate:2023-09-16
/// Creator:yanghongrui
/// Table:DHC_StudentCourseRR
/// Input:ParRef:父表id, DHCScCourseDR:课程id,DHCScScore:成绩
/// Others:w ##class(User.Study.NewDayFour).AddStudentCourse("3","2","90")
ClassMethod AddStudentCourse(ParRef As %String, DHCScCourseDR As %String, DHCScScore As %String) As %String
{
	q:ParRef="" "ParRef不能为空"
	q:DHCScCourseDR="" "课程不能为空"
	s obj= ##class(User.DHCStudentCourseRR).%New(ParRef)
	if (obj)
	{
		d obj.ParRefSetObjectId(ParRef) ;父表id
		d obj.DHCScCourseDRSetObjectId(DHCScCourseDR) ; 指向型字段
		s obj.DHCScScore=DHCScScore
		TSTART
		s sc=obj.%Save() 
		if ($$$ISOK(sc))
		{
			s id=obj.%Id()
			TCOMMIT
			s result="新增成功"_id
		}
		else
		{
			TROLLBACK
			s result="新增失败，失败原因:"_$system.Status.GetErrorText(sc) ///$system.OBJ.DisplayError(sc)
			
		}
		d obj.%Close()
		
	}
	q result
}

/// Function:子表的数据修改
/// CreateDate:2023-09-15
/// Creator:yanghongrui
/// Table:DHC_StudentCourseG
/// Input:ParRef:父表id, DHCScCourseDR:课程id,DHCScScore:成绩
/// Others:w ##class(User.Study.NewDayFour).UpdateStudentCourse("1||1","1","100")
ClassMethod UpdateStudentCourse(RowId As %String, DHCScCourseDR As %String, DHCScScore As %String) As %String
{
	q:RowId="" "RowId为空"
	q:DHCScCourseDR="" "课程为空"
	s obj=##class(User.DHCStudentCourseRR).%OpenId(RowId)
	if (obj)
	{	
		d obj.DHCScCourseDRSetObjectId(DHCScCourseDR)
		s obj.DHCScScore=DHCScScore
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
			s result="修改失败"
		}
		d obj.%Close()
	}
	else
	{
		s result="数据不存在"	
			
	}
	q result
}

/// Function:子表的获取数据
/// CreateDate:2023-09-15
/// Creator:yanghongrui
/// Table:DHC_StudentCourseG
/// Input:ParRef:父表id, DHCScCourseDR:课程id,DHCScScore:成绩
/// Others:w ##class(User.Study.NewDayFour).SelectStudentCourse("3||4","4","100")
ClassMethod SelectStudentCourse(RowId As %String, DHCScCourseDR As %String, DHCScScore As %String) As %String
{
	q:RowId="" "RowId为空"
	q:DHCScCourseDR="" "课程为空"
	s obj=##class(User.DHCStudentCourseRR).%OpenId(RowId)
	if (obj)
	{	
		s DHCScCourseDR=obj.DHCScCourseDRGetObjectId()
		s DHCScCourseDesc=""
		s:obj.DHCScCourseDR'="" DHCScCourseDesc=obj.DHCScCourseDR.CrsDesc ;课程名称
		s result=DHCScCourseDR_" "_DHCScCourseDesc
		d obj.%Close()
	}
	else
	{
		s result="数据不存在"	
			
	}
	q result
}

/// Function:子表数据查询
/// CreateDate:2023-09-15
/// Creator:yanghongrui
/// Table:DHC_StudentCourseG
/// Input:ParRef:父表id
/// Others:d ##class(User.Study.NewDayFour).GetStudentCourse("")
ClassMethod GetStudentCourse(ParRef As %String) As %String
{
	if (ParRef'="")
	{
		s DHCScChildSub=0
		for
		{
			s DHCScChildSub=$O(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub))
			q:DHCScChildSub=""
			s StScRowId=ParRef_"||"_DHCScChildSub
			s StScCourseDR=$p($g(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub)),"^",1)
			s:StScCourseDR'="" StScCourseDR=$p($g(^DHCCOURSE(StScCourseDR)),"^",2) ;课程名称
			s StScScore=$p($g(^DHCSTUDENTY(ParRef,"Course",DHCScChildSub)),"^",2)
			w "课程:"_StScCourseDR_",成绩:"_StScScore ,!
			
		}
	}
	else
	{
		s ScParRef=0
		for
		{
			s ScParRef=$O(^DHCSTUDENTY(ScParRef))
			q:ScParRef=""
			s DHCScChildSub=0
			for
			{
			s DHCScChildSub=$O(^DHCSTUDENTY(ScParRef,"Course",DHCScChildSub))
			q:DHCScChildSub=""
			s StScRowId=ScParRef_"||"_DHCScChildSub
			s StScCourseDR=$p($g(^DHCSTUDENTY(ScParRef,"Course",DHCScChildSub)),"^",1)
			s:StScCourseDR'="" StScCourseDR=$p($g(^DHCCOURSE(StScCourseDR)),"^",2) //课程名称
			s StScScore=$p($g(^DHCSTUDENTY(ScParRef,"Course",DHCScChildSub)),"^",2)
			w StScRowId_"课程:"_StScCourseDR_",成绩:"_StScScore ,!		
			}	
		}
	}
}

/// Function:%Query的使用 子表的查询
/// CreateDate:2023-09-15
/// d ##class(%ResultSet).RunQuery("User.Study.NewDayFour","GetDataList","3")
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
/// Others:w ##class(User.Study.NewDayFour).AddStudentData("AA^小AA^1^2023-09-15^2^90")
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
