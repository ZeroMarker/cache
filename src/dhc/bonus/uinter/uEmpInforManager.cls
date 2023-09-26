/// 调取人事系统中享奖系数的维护
Class dhc.bonus.uinter.uEmpInforManager Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Description: 获取人事系统学历
/// Table: 
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(herp.acct.hishr.uEmpInforManager).GetHighStudy(0,25)
ClassMethod GetHighStudy(start, limit) As %String
{
	n (start,limit)
	s sqlStr=" SELECT LiteracyType,CONTEXT FROM HISHR.LiteracyTypeInfo "
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="code^name"
	While(result.Next())
	{   
		s code = result.Data("LiteracyType")
		s name=result.Data("CONTEXT")
		
		
		s tmp=code_"^"_name
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Description: 获取人事系统人员类别
/// Table: 
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(herp.acct.hishr.uEmpInforManager).GetHighStudy(0,25)
ClassMethod GetEmpType(start, limit) As %String
{
	n (start,limit)
	s sqlStr="   SELECT StationTypeCode, StationTypeName FROM HIShr.StationTypeInfo  "
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="code^name"
	While(result.Next())
	{   
		s code = result.Data("StationTypeCode")
		s name=result.Data("StationTypeName")
		
		
		s tmp=code_"^"_name
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Description: 更新记录
/// Table：herp_budg_data.BudgYearMonthDict
/// Input：rowId-所在行号;code-参数代码, name-参数名称,visvalid-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(herp.acct.hishr.uEmpInforManager).UpdateRec("4","3","发放")
ClassMethod UpdateRec(rowId, sDate, sRate, PeriodDate, EmpTypeName) As %String
{
	n (rowId, sDate, sRate,PeriodDate,EmpTypeName)
	k PLIST
	
	;i yearmonth="" s yearmonth=$list(^herpbgBudgYearMonthDictD(rowId),2)
	;i startdate="" s startdate=$list(^herpbgBudgYearMonthDictD(rowId),3)
	;i enddate=""   s enddate=$list(^herpbgBudgYearMonthDictD(rowId),4)
	
	s tmpRowid=0
	;s tmpRowid=..IfRepNameD(yearmonth)
	;q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"	
	
	
	;i yearmonth      '="" s Plist(2)= yearmonth       
	;i startdate      '="" s Plist(3)= startdate    
	;i enddate        '="" s Plist(4)= enddate
	i sRate'="" d
	.&SQL(UPDATE  HISHR.PersonInfo set FlexStrField6=:sRate  where %ID=:rowId) 
	
	i sDate'="" d
	.s sDate=$zdh(sDate,3)
	.&SQL(UPDATE  HISHR.PersonInfo set TryOutDay=:sDate  where %ID=:rowId) 
	
	i PeriodDate'="" d
	.s PeriodDate=$zdh(PeriodDate,3)
	.&SQL(UPDATE  HISHR.PersonInfo set RegaleExtrudeSubsidyTM=:PeriodDate where %ID=:rowId) 
	
	i EmpTypeName'="" d
	.&SQL(UPDATE  HISHR.PersonInfo set IatricalPositionCode=:EmpTypeName where %ID=:rowId) 
	
	q SQLCODE
}

/// Description: 查询符合条件的记录
/// Table:  herp_budg_data.BudgYearMonthDict
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.bonus.uinter.uEmpInforManager).List("2402^^^^^^^","","",0,15)
ClassMethod List(sData, sortField, sortDir, start, limit) As %String
{
	n (sData,sortField,sortDir,start,limit)
	;s ^zlg211=sData
	s empName=$p(sData,"^",1)
	s empDept=$p(sData,"^",2)
	s empStudy=$p(sData,"^",3)
	s empType=$p(sData,"^",4)
	s joinDate=$p(sData,"^",5)
	s workDate=$p(sData,"^",6)
	s sRate=$p(sData,"^",7)
	s PeriodDate=$p(sData,"^",8)
	
	s sqlStr="select  a.%ID rowid, a.IatricalPositionCode as empType,a.EmpCardID,a.Name,dept.FlexStrField4 DeptCode,dept.DeptName,c.CONTEXT as SkillDuty,a.StartWorkDay,p.CONTEXT as HighStudy,b.CONTEXT as Sex,d.StationTypeName EmpTypeName,a.TryOutDay,a.FlexStrField6  BonusRate,a.RegaleExtrudeSubsidyTM as PeriodDate"
	_" from HISHR.PersonInfo as a left join hishr.SexTypeInfo as b on a.sex=b.sextype left join HISHR.SkillDutyTypeInfo as c on a.SkillDuty=c.SkillDutyType"
	_"  left join HISHR.LiteracyTypeInfo as p on a.HighStudy=p.LiteracyType left join HISHR.DeptInfo as dept on a.DeptCode=dept.DeptCode"
 	_" LEFT JOIN HIShr.StationTypeInfo AS d ON d.StationTypeCode =a.FlexStrField4"
 	_" where 1=1 and a.PersonStatus in ('01','32') " 
 	
 	s sortField1=""
 	i empName'="" s sqlStr=sqlStr_" and (a.EmpCardID like '%"_empName_"%' or a.Name like '%"_empName_"%' ) "
 	i empDept'="" s sqlStr=sqlStr_" and (dept.FlexStrField4 like '%"_empDept_"%' or dept.DeptName like '%"_empDept_"%' ) "
    i empStudy'="" s sqlStr=sqlStr_" and a.HighStudy = '"_empStudy_"' "
 	i empType'="" s sqlStr=sqlStr_" and a.IatricalPositionCode = '"_empType_"' "
 	i sRate'="" s sqlStr=sqlStr_" and a.FlexStrField6 = '"_sRate_"' "
 	
 	i joinDate'="" d
 	.s joinDate=$zdh(joinDate,3)
 	.s sqlStr=sqlStr_" and  a.StartWorkDay >="_ joinDate_"" 
 	
 	i workDate'="" d
 	.s workDate=$zdh(workDate,3)
 	.s sqlStr=sqlStr_" and  a.TryOutDay <="_ workDate _" " //or a.TryOutDay is null)
 	
 	i PeriodDate'="" d
 	.s PeriodDate=$zdh(PeriodDate,3)
 	.s sqlStr=sqlStr_" and  a.RegaleExtrudeSubsidyTM <="_ PeriodDate _" and a.FlexStrField6<1" 
 	//order by dept.FlexStrField4
 	
 	i sortField'="" d
	.i sortField="DeptCode" s sortField1="dept.FlexStrField4" 
	.i sortField="DeptName" s sortField1="dept.DeptName"
	.i sortField="EmpCardID" s sortField1="a.EmpCardID"
	.i sortField="Name" s sortField1="a.Name"
	.i sortField="Sex" s sortField1="b.CONTEXT"
	.i sortField="HighStudy" s sortField1="p.CONTEXT"
	.i sortField="SkillDuty" s sortField1="c.CONTEXT"
	.i sortField="EmpTypeName" s sortField1="d.StationTypeName"
	.i sortField="StartWorkDay" s sortField1="a.StartWorkDay"
	.i sortField="TryOutDay" s sortField1="a.TryOutDay"
	.i sortField="BonusRate" s sortField1="a.FlexStrField6"
	.i sortField="PeriodDate" s sortField1="a.RegaleExtrudeSubsidyTM"
	i (sortDir="DESC")||(sortDir="ASC") s sqlStr=sqlStr_" order by  "_sortField1_" "_sortDir
	i (sortDir="")||(sortField="") s sqlStr=sqlStr_" order by  a.%ID"	
	;k ^zlgtemp
	;s ^zlgtemp=sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^EmpCardID^Name^DeptCode^DeptName^SkillDuty^StartWorkDay^HighStudy^Sex^EmpTypeName^TryOutDay^BonusRate^PeriodDate"
	While(result.Next())
	{   
		s rowid = result.Data("rowid")
		s EmpCardID=result.Data("EmpCardID")
		s Name=result.Data("Name")
		s DeptCode=result.Data("DeptCode")		
		s DeptName = result.Data("DeptName")		
		s SkillDuty=result.Data("SkillDuty")
		s StartWorkDay=result.Data("StartWorkDay")
		i StartWorkDay'="" d
		.s StartWorkDay=$zd(StartWorkDay,3)
		s HighStudy=result.Data("HighStudy")		
		s Sex = result.Data("Sex")
		;s EmpTypeName=result.Data("EmpTypeName") ; 
		s EmpTypeName=result.Data("empType")
		
		i EmpTypeName="YS" S EmpTypeName="医生"
		i EmpTypeName="HS" S EmpTypeName="护士"
		i EmpTypeName="QT" S EmpTypeName="其他"
		
		s TryOutDay=result.Data("TryOutDay")
		i TryOutDay'="" d
		.s TryOutDay=$zd(TryOutDay,3)
		s BonusRate=$tr(result.Data("BonusRate"),$c(13,10,0),"") ;2015-7-7
		s PeriodDate=result.Data("PeriodDate")
		i PeriodDate'="" d
		.s PeriodDate=$zd(PeriodDate,3)
		
		s tmp=rowid_"^"_EmpCardID_"^"_Name_"^"_DeptCode_"^"_DeptName_"^"_SkillDuty_"^"_StartWorkDay_"^"_HighStudy_"^"_Sex_"^"_EmpTypeName_"^"_TryOutDay_"^"_BonusRate_"^"_PeriodDate
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus1BEE.uEmpInforMa9792S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
