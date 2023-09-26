Class User.kongjinchuanDay3 Extends %RegisteredObject
{

/// Function:使用SQL查询数据
/// CreaterDate:2023-09-13
/// Creater:孔晋川
/// InPut:
/// OutPut:StCode(学号),StName(姓名),StSexDR(性别),StDob(出生日期)
/// Others:d ##class(User.kongjinchuanDay3).SelectStudentData()
ClassMethod SelectStudentData() As %String
{
	s sqlStr="SELECT * FROM DHC_StudentKjc"
	s result=##class(%ResultSet).%New()
	if (result)
	{
		d result.Prepare(sqlStr)
		d result.Execute()
		while(result.Next()){
			s StCode=$g(result.Data("St_Code"))
			s StName=$g(result.Data("St_Name"))
			s StSexDR=$g(result.Data("St_Sex_DR"))
			s:StSexDR'="" StSexDR=$p($g(^CT("SEX",StSexDR)),"^",2)	
			s StDob=$g(result.Data("St_Dob"))
			s:StDob'="" StDob=$zd(StDob,3)
			w StCode_" "_StName_" "_StSexDR_" "_StDob
			w !
		}
	}
}

/// Function:使用SQL插入数据
/// CreaterDate:2023-09-13
/// Creater:孔晋川
/// InPut:StCode(学号),StName(姓名),StSexDR(性别),StDob(出生日期)
/// OutPut:1:成功, 0:失败
/// Others:w ##class(User.kongjinchuanDay3).InsertStudentData("","","","")
ClassMethod InsertStudentData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "请输入学号"
	q:StName="" "请输入姓名"
	q:$d(^User.DHCStudentKjcI("Code",StCode)) "学号重复"
	s:StDob'="" StDob=$zdh(StDob,3)
	&Sql(
		INSERT INTO DHC_StudentKjc (St_Code,St_Name,St_Sex_DR,St_Dob) 
		VALUES (:StCode,:StName,:StSexDR,:StDob)
	)
	if (SQLCODE=0){
		s result=1_":"_%ROWID
	}
	else{
		s result=0_":"_%msg
	}
	q result
}

/// Function:使用SQL更新数据
/// CreaterDate:2023-09-13
/// Creater:孔晋川
/// InPut:StRowId，StCode(学号),StName(姓名),StSexDR(性别),StDob(出生日期)
/// OutPut:1:成功, 0:失败
/// Others:w ##class(User.kongjinchuanDay3).UpdateStudentData("","","","","")
ClassMethod UpdateStudentData(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StRowId="" "请输入StRowId"
	q:StCode="" "请输入学号"
	q:StName="" "请输入姓名"
	q:'$d(^User.DHCStudentKjcD(StRowId)) "数据不存在"
	s:StDob'="" StDob=$zdh(StDob,3)
	&Sql(
		UPDATE DHC_StudentKjc 
		SET St_Code=:StCode, St_Name=:StName, St_Sex_DR=:StSexDR,St_Dob=:StDob 
		WHERE St_RowId=:StRowId
	)
	if (SQLCODE=0){
		s result=1_":"_%ROWID
	}
	else{
		s result=0_":"_%msg
	}
	q result
}

/// Function:使用SQL删除数据
/// CreaterDate:2023-09-13
/// Creater:孔晋川
/// InPut:StRowId
/// OutPut:1:成功, 0:失败
/// Others:w ##class(User.kongjinchuanDay3).DeleteStudentData()
ClassMethod DeleteStudentData(StRowId As %String) As %String
{
		q:StRowId="" "请输入StRowId"
		q:'$d(^User.DHCStudentKjcD(StRowId)) "数据不存在"
		&Sql(
			DELETE FROM DHC_StudentKjc WHERE St_RowId=:StRowId
		)
		if (SQLCODE=0){
			s result=1_":"_%ROWID
		}
		else{
			s result=0_":"_%msg
		}
		q result
}

/// Function:面向对象-新增数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:StCode(学号),StName(姓名),StSexDR(性别),StDob(出生日期)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).InsertStudentDataOOP("","","","")
ClassMethod InsertStudentDataOOP(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "请输入学号"
	q:$d(^User.DHCStudentKjcI("Code",StCode)) "学号重复"
	q:StName="" "请输入姓名"
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
	s obj=##class(User.DHCStudentKjc).%New()
	if (obj)
	{	
		//对象赋值
		s obj.StCode=StCode
		s obj.StName=StName
		d obj.StSexDRSetObjectId(StSexDR)
		s obj.StDob=StDob
		//插入事务
		TSTART
		s sc=obj.%Save()
		if (sc=1) //成功
		{	
			TCOMMIT
			s StRowId=obj.%Id()
			s result="新增成功:"_StRowId
		}
		else
		{
			TROLLBACK
			s result="新增失败:"_$SYSTEM.OBJ.DisplayError(sc)
		}
		do obj.%Close()
	}
	q result
}

/// Function:面向对象-删除数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:StRowId
/// OutPut:1:成功  0:失败
/// Others:w ##class(User.kongjinchuanDay3).DeleteStudentDataOOP("")
ClassMethod DeleteStudentDataOOP(StRowId As %String) As %String
{
	q:StRowId="" "请输入StRowId"
	q:$d(^User.DHCStudentKjcD(StRowId))=0 "数据不存在"
	s obj=##class(User.DHCStudentKjc).%OpenId(StRowId)
	if (obj)
	{	
		//插入事务
		TSTART
		s sc=##class(User.DHCStudentKjc).%DeleteId(StRowId)
		if ($$$ISOK(sc)) //成功
		{	
			TCOMMIT
			s result=1
		}
		else
		{
			TROLLBACK
			s result=0
		}
	}
	q result
}

/// Function:面向对象-查询单条数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:StRowId
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).selectStudentDataOOP("")
ClassMethod selectStudentDataOOP(StRowId As %String) As %String
{
	q:StRowId="" "请输入StRowId"
	s obj=##class(User.DHCStudentKjc).%OpenId(StRowId)
	if ($ISOBJECT(obj))
	{
		s StCode=obj.StCode
		s StName=obj.StName
		s StDob=obj.StDob
		s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
		s StSexDR=obj.StSexDRGetObjectId()
		s StSexDRDesc=""
		s:StSexDR'="" StSexDRDesc=obj.StSexDR.CTSexDesc	
		s result="学号:"_StCode_",姓名:"_StName_",性别:"_StSexDR_",出生日期:"_StDob
		
	}
	else
	{
		s result="数据不存在"
	}
	q result
}

/// Function:面向对象-更新数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:StRowId,StCode(学号),StName(姓名),StSexDR(性别),StDob(出生日期)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).UpdateStudentDataOOP("","","","","")
ClassMethod UpdateStudentDataOOP(StRowId As %String, StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StRowId="" "请输入StRowId"
	q:StCode="" "请输入学号"
	q:StName="" "请输入姓名"
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
	s obj=##class(User.DHCStudentKjc).%OpenId(StRowId)
	if (obj)
	{	
		//对象赋值
		s obj.StCode=StCode
		s obj.StName=StName
		d obj.StSexDRSetObjectId(StSexDR)
		s obj.StDob=StDob
		//插入事务
		TSTART
		s sc=obj.%Save()
		if (sc=1) //成功
		{	
			TCOMMIT
			s StRowId=obj.%Id()
			s result="更新成功:"_StRowId
		}
		else
		{
			TROLLBACK
			s result="更新失败"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	else
	{
		s result="对象不存在"
	}
	q result
}

/// Function:面向对象-新增课程表数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:CrsCode(课程号),CrsDesc(课程名),CrsActiveFlag(有效标志)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).InsertCourseDataOOP("","","")
ClassMethod InsertCourseDataOOP(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "请输入课程号"
	q:CrsDesc="" "请输入课程名"
	q:((CrsActiveFlag="") || ((CrsActiveFlag'="Y") & (CrsActiveFlag'="N"))) "请输入有效标志Y或N"
	s obj=##class(User.DHCCourseKjc).%New()
	if (obj)
	{	
		//对象赋值
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag

		//插入事务
		TSTART
		s sc=obj.%Save()
		if (sc=1) //成功
		{	
			TCOMMIT
			s StRowId=obj.%Id()
			s result="新增成功:"_CrsRowId
		}
		else
		{
			TROLLBACK
			s result="新增失败:"_$SYSTEM.OBJ.DisplayError(sc)
		}
		do obj.%Close()
	}
	q result
}

/// Function:面向对象-删除课程表数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:CrsRowId
/// OutPut:1:成功  0:失败
/// Others:w ##class(User.kongjinchuanDay3).DeleteCourseDataOOP("")
ClassMethod DeleteCourseDataOOP(CrsRowId As %String) As %String
{
	q:CrsRowId="" "请输入CrsRowId"
	q:$d(^User.DHCCourseKjcD(CrsRowId))=0 "数据不存在"
	s obj=##class(User.DHCCourseKjc).%OpenId(CrsRowId)
	if (obj)
	{	
		//插入事务
		TSTART
		s sc=##class(User.DHCCourseKjc).%DeleteId(CrsRowId)
		if ($$$ISOK(sc)) //成功
		{	
			TCOMMIT
			s result=1
		}
		else
		{
			TROLLBACK
			s result=0
		}
	}
	q result
}

/// Function:面向对象-查询课程单条数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:CrsRowId
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).selectCourseDataOOP("")
ClassMethod selectCourseDataOOP(CrsRowId As %String) As %String
{
	q:CrsRowId="" "请输入CrsRowId"
	s obj=##class(User.DHCCourseKjc).%OpenId(CrsRowId)
	if ($ISOBJECT(obj))
	{
		s CrsCode=obj.CrsCode
		s CrsDesc=obj.CrsDesc
		s CrsActiveFlag=obj.CrsActiveFlag
		s result="课程号:"_CrsCode_",课程名:"_CrsDesc_",课程是否有效:"_CrsActiveFlag
		
	}
	else
	{
		s result="数据不存在"
	}
	q result
}

/// Function:面向对象-更新课程表数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:CrsRowId,CrsCode(课程号),CrsDesc(课程名),CrsActiveFlag(有效标志)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).UpdateCourseDataOOP("","","","")
ClassMethod UpdateCourseDataOOP(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsRowId="" "请输入CrsRowId"
	q:CrsCode="" "请输入课程号"
	q:CrsDesc="" "请输入课程名"
	q:((CrsActiveFlag="") || ((CrsActiveFlag'="Y") & (CrsActiveFlag'="N"))) "请输入有效标志Y或N"
	s obj=##class(User.DHCCourseKjc).%OpenId(CrsRowId)
	if (obj)
	{	
		//对象赋值
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag
		//插入事务
		TSTART
		s sc=obj.%Save()
		if (sc=1) //成功
		{	
			TCOMMIT
			s StRowId=obj.%Id()
			s result="更新成功:"_CrsRowId
		}
		else
		{
			TROLLBACK
			s result="更新失败"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	else
	{
		s result="对象不存在"
	}
	q result
}

/// Function:面向对象-更新/新增课程表数据
/// CreaterDate:2023-09-14
/// Creater:孔晋川
/// InPut:CrsRowId,CrsCode(课程号),CrsDesc(课程名),CrsActiveFlag(有效标志)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).SaveCourseDataOOP("","","","")
ClassMethod SaveCourseDataOOP(CrsRowId As %String, CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "请输入课程号"
	q:CrsDesc="" "请输入课程名"
	q:((CrsActiveFlag="") || ((CrsActiveFlag'="Y") & (CrsActiveFlag'="N"))) "请输入有效标志Y或N"
	if (CrsRowId="") //新增
	{
		s obj=##class(User.DHCCourseKjc).%New()
	}
	else //更新
	{
		s obj=##class(User.DHCCourseKjc).%OpenId(CrsRowId)
	}
	if (obj)
	{	
		//对象赋值
		s obj.CrsCode=CrsCode
		s obj.CrsDesc=CrsDesc
		s obj.CrsActiveFlag=CrsActiveFlag
		//插入事务
		TSTART
		s sc=obj.%Save()
		if (sc=1) //成功
		{	
			TCOMMIT
			s StRowId=obj.%Id()
			s result="保存成功:"_CrsRowId
		}
		else
		{
			TROLLBACK
			s result="保存失败"_$SYSTEM.OBJ.DisplayError(sc)
		}
		d obj.%Close()
	}
	else
	{
		s result="对象不存在"
	}
	q result
}

/// Function:子表查询数据
/// CreaterDate:2023-09-15
/// Creater:孔晋川
/// InPut:ParRef(学生表id)
/// OutPut:
/// Others:d ##class(User.kongjinchuanDay3).SelectScData("")
ClassMethod SelectScData(ParRef As %String) As %String
{
	d ##class(%ResultSet).RunQuery("User.kongjinchuanDay3","GetScDataKjc",ParRef)
}

/// Function:父表子表数据新增(事务+面向对象)
/// CreaterDate:2023-09-15
/// Creater:孔晋川
/// InPut: DataStr(StCode^StName^StSexDR^StDob^ScCourseDR^ScScore)
/// OutPut:
/// Others:w ##class(User.kongjinchuanDay3).insertScAndStudentData("05^小李^1^2000-01-01^1^98")
ClassMethod insertScAndStudentData(DataStr As %String) As %String
{
	q:DataStr="" "入参为空"
	s StCode=$p(DataStr,"^",1)
	q:StCode="" "学号不能为空"
	q:$d(^DHCSTUDENTKJC(0,"Code",StCode)) "学号重复"
	s StName=$p(DataStr,"^",2)
	s StSexDR=$p(DataStr,"^",3)
	s StDob=$p(DataStr,"^",4) //出生日期
	s:StDob'="" StDob=##class(websys.Conversions).DateHtmlToLogical(StDob)
	s ScCourseDR=$p(DataStr,"^",5)
	q:ScCourseDR="" "课程名不能为空"
	s ScScore=$p(DataStr,"^",6)
	
	s studentObj=##class(User.DHCStudentKjcS).%New()
	if (studentObj)
	{
		s studentObj.StCode=StCode
		s studentObj.StName=StName
		d studentObj.StSexDRSetObjectId(StSexDR)
		s studentObj.StDob=StDob
		TSTART //开启事务
		s sc=studentObj.%Save()
		if ($$$ISOK(sc))
		{
			s id=studentObj.%Id()
			if (id'="")
			{
				s scObj=##class(User.DHCStudentCourseKjc).%New(id)
				if (scObj) //子表新增
				{
					d scObj.StudentParRefSetObjectId(id)
					d scObj.DHCScCourseDRSetObjectId(ScCourseDR)
					s scObj.DHCScScore=ScScore
					s stuCorSc=scObj.%Save()
					if (stuCorSc=1)
					{	
						TCOMMIT //事务提交
						s scId=scObj.%Id()
						s result="学生课程表新增成功"_scId
					}
					else
					{
						TROLLBACK //失败回滚
						s result="子表新增失败"_$system.OBJ.DisplayError(stuCorSc)
					}
					d scObj.%Close()
				}
			}
		
		}
		else //学生表新增失败
		{	
			TROLLBACK //失败回滚
			s result="学生表新增失败"_$system.OBJ.DisplayError(sc)
		}
		d studentObj.%Close()
	}
	q result
}

/// Function:%Query的使用---学生表查询DHC_StudentKjcS
/// d ##class(%ResultSet).RunQuery("User.kongjinchuanDay3","GetStudentDataKjc","","","")
Query GetStudentDataKjc(RowId As %String, Code As %String, Name As %String) As %Query(ROWSPEC = "StRowId:%String,StCode:%String:学号,StName:%String:姓名,StSexDR:%String:性别,StDob:%String:出生日期")
{
}

ClassMethod GetStudentDataKjcExecute(ByRef qHandle As %Binary, RowId As %String, Code As %String, Name As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    //If $g(ind)="" Set ind=0
    
    //代码段
    if (RowId'="") //单条查询
	{
		s StRowId=RowId
		s StCode=$P($g(^DHCSTUDENTKJC(StRowId)),"^",1)
		s StName=$P($g(^DHCSTUDENTKJC(StRowId)),"^",2)
		s StSexDR=$P($g(^DHCSTUDENTKJC(StRowId)),"^",3)
		s StDob=$P($g(^DHCSTUDENTKJC(StRowId)),"^",4)
		s:StDob'="" StDob=$zd(StDob,3)
		d OutputRow
	}
	else //全查询
	{
		s StRowId=0
		for
		{
			s StRowId=$O(^DHCSTUDENTKJC(StRowId)) q:StRowId=""
			s StCode=$P($g(^DHCSTUDENTKJC(StRowId)),"^",1)
			s StName=$P($g(^DHCSTUDENTKJC(StRowId)),"^",2)
			s StSexDR=$P($g(^DHCSTUDENTKJC(StRowId)),"^",3)
			s StDob=$P($g(^DHCSTUDENTKJC(StRowId)),"^",4)
			s:StDob'="" StDob=$zd(StDob,3)
			if (StCode[Code)&(StName[Name)
			{
				d OutputRow
			}
		}	
	}
	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK    
OutputRow
	set Data=$lb(StRowId,StCode,StName,StSexDR,StDob)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetStudentDataKjcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStudentDataKjcExecute ]
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

ClassMethod GetStudentDataKjcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStudentDataKjcExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Function:%Query的使用---学生课程表查询
/// d ##class(%ResultSet).RunQuery("User.kongjinchuanDay3","GetScDataKjc","")
Query GetScDataKjc(ParRef As %String) As %Query(ROWSPEC = "ScParRef:%String:学号,ScCourseDR:%String:课程名,ScScore:%String:课程分数")
{
}

ClassMethod GetScDataKjcExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    //If $g(ind)="" Set ind=0
    
    //代码段
    if (ParRef'="") //输入了学生表id(父表id)
	{
		s DHCScChildSub=0
		for
		{	
			s DHCScChildSub=$O(^DHCSTUDENTKJC(ParRef,"StudentSub",DHCScChildSub))
			q:DHCScChildSub=""
			s ScParRef=ParRef
			s ScCourseDR=$p($g(^DHCSTUDENTKJC(ParRef,"StudentSub",DHCScChildSub)),"^",1)
			s:ScCourseDR'="" ScCourseDR=$listget($g(^User.DHCCourseKjcD(ScCourseDR)),3)
			s ScScore=$p($g(^DHCSTUDENTKJC(ParRef,"StudentSub",DHCScChildSub)),"^",2)
			d OutputRow
		}
	}
	else //全查
	{
		s ScParRef=0
		for
		{
			s ScParRef=$o(^DHCSTUDENTKJC(ScParRef))
			q:ScParRef=""
			s DHCScChildSub=0
			for
			{	
				s DHCScChildSub=$O(^DHCSTUDENTKJC(ScParRef,"StudentSub",DHCScChildSub))
				q:DHCScChildSub=""
				s ScCourseDR=$p($g(^DHCSTUDENTKJC(ScParRef,"StudentSub",DHCScChildSub)),"^",1)
				s:ScCourseDR'="" ScCourseDR=$listget($g(^User.DHCCourseKjcD(ScCourseDR)),3)
				s ScScore=$p($g(^DHCSTUDENTKJC(ScParRef,"StudentSub",DHCScChildSub)),"^",2)
				s ScParRef=ScParRef
				d OutputRow
			} 
		}
	}
    
    
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK    
OutputRow
	set Data=$lb(ScParRef,ScCourseDR,ScScore)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetScDataKjcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScDataKjcExecute ]
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

ClassMethod GetScDataKjcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScDataKjcExecute ]
{
	Quit $$$OK
}

}
