Class dhc.bonus.uextend.yjs.uEmpWorkDay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others: w ##class(dhc.bonus.uextend.yjs.uEmpWorkDay).CollectWorkDay("2014","09")
ClassMethod CollectWorkDay(year, month) As %String
{
	n (year,month)
	&SQL(delete from dhc_bonus_extend_yjs.EmpWorkDay where BonusYear=:year and BonusPeriod='M'_:month)
	s sqlStr=" select Year,right('00'||Month,2) as Month,DeptCode,EmpCardID,PSName,ApplealDays from HISHR.TimeLeaveInfo "
			_" where Year='"_year_"' and right('00'||Month,2)='"_month_"' "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rnt=""
	
	while(result.Next()){
		s Code="Null"
		s Year=result.Data("Year")
		s Month="M"_result.Data("Month")
		s DeptCode=result.Data("DeptCode")
		i DeptCode'="" d
		.&SQL(select FinanceStatName,FlexStrField2,FlexStrField4,DeptName into :Code,:FlexStrField2,:FlexStrField4,:DeptName from HISHR.DeptInfo where DeptCode=:DeptCode)
		
		s EmpCardID=result.Data("EmpCardID")
		i EmpCardID'="" d
		.&SQL(select case when FlexStrField6="" then 0 else FlexStrField6 end as FlexStrField6 into :SharyRate from HISHR.PersonInfo where EmpCardID=:EmpCardID)
		
		s PSName=result.Data("PSName")
		s ApplealDays=result.Data("ApplealDays")
		
		&SQL(insert into dhc_bonus_extend_yjs.EmpWorkDay(BonusYear,BonusPeriod,DeptCode,EmpCardID,EmpName,
		WorkDays,SharyRate,UpdateDate,FlexStrField2,FlexStrField4,DeptName) values(:Year,:Month,:Code,:EmpCardID,:PSName,:ApplealDays,:SharyRate,left(getdate(),10),:FlexStrField2,:FlexStrField4,:DeptName))
		s rnt=SQLCODE
	}
	
	q rnt
}

ClassMethod GetDept(start, limit, str) As %String
{
	n (start,limit,str)
	
	s sqlStr="select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where BonusUnitTypeID=2 and IsValid=1"
	i str'="" s sqlStr=sqlStr_" and (BonusUnitCode like '%"_str_"%' or BonusUnitName like '%"_str_"%')"
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
		s code=result.Data("BonusUnitCode")
		s name=result.Data("BonusUnitName")
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

ClassMethod ListWorkDay(sortField, sortDir, start, limit, year, month, Dept, person, bonusRate) As %String
{
	n (sortField,sortDir,start,limit,year,month,Dept,person,bonusRate)
	s sqlStr=" select EmpWorkDayID as rowid,BonusYear,BonusPeriod,DeptCode,EmpCardID,EmpName,WorkDays,SharyRate,UpdateDate,IsCheck"
			_" from dhc_bonus_extend_yjs.EmpWorkDay where %ID>0"
	s sortField1=""
	s sqlStr=sqlStr_" and BonusYear='"_year_"'"
	s sqlStr=sqlStr_" and BonusPeriod='M"_month_"'"	
	i Dept'="" s sqlStr=sqlStr_" and DeptCode='"_Dept_"'"
	i person'="" s sqlStr=sqlStr_" and (EmpCardID='"_person_"' or EmpName like '%"_person_"%')"
	i bonusRate'="" s sqlStr=sqlStr_" and SharyRate='"_bonusRate_"'"
	
	i sortField'="" d
	.i sortField="BonusYear" s sortField1="BonusYear"
	.i sortField="BonusPeriod" s sortField1="BonusPeriod"
	.i sortField="DeptName" s sortField1="DeptCode"
	.i sortField="EmpCardID" s sortField1="EmpCardID"
	.i sortField="EmpName" s sortField1="EmpName"
	.i sortField="WorkDays" s sortField1="WorkDays"
	.i sortField="SharyRate" s sortField1="SharyRate"
	.i sortField="UpdateDate" s sortField1="UpdateDate"
	i (sortDir="DESC")||(sortDir="ASC") s sqlStr=sqlStr_" order by  "_sortField1_" "_sortDir
	i (sortDir="")||(sortField="") s sqlStr=sqlStr_" order by BonusYear,DeptCode,BonusPeriod Desc"		
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusYear^BonusPeriod^DeptCode^DeptName^EmpCardID^EmpName^WorkDays^SharyRate^UpdateDate^IsCheck"
	While(result.Next())
	{    
		s rowid = result.Data("rowid")
		s BonusYear=result.Data("BonusYear")
		s BonusPeriod=result.Data("BonusPeriod")
		s DeptCode=result.Data("DeptCode")
		i DeptCode'="" d
		.s id1=""
		.s id1=$O(^dhcsyncLocI("syncLocCode0Idx",DeptCode,id1))
		.i id1'="" d
		..s DeptName=$List(^dhcsyncLocD(id1),3)
		
		i DeptCode="" d
		.s DeptName=""	
		s EmpCardID=result.Data("EmpCardID")
		s EmpName=result.Data("EmpName")
		s WorkDays=result.Data("WorkDays")
		s SharyRate=result.Data("SharyRate")
		s UpdateDate=result.Data("UpdateDate")
		s IsCheck=result.Data("IsCheck")
		i IsCheck="" s IsCheck="未审核"
		e  i IsCheck=1 s IsCheck="审核"
		s tmp=rowid_"^"_BonusYear_"^"_BonusPeriod_"^"_DeptCode_"^"_DeptName_"^"_EmpCardID_"^"_EmpName_"^"_WorkDays_"^"_SharyRate_"^"_UpdateDate_"^"_IsCheck
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

ClassMethod UpdateRec(rowid, DeptName) As %String
{
	n (rowid,DeptName)
	&SQL(update dhc_bonus_extend_yjs.EmpWorkDay set DeptCode=:DeptName where EmpWorkDayID=:rowid)
	q SQLCODE
}

/// others: w ##class(dhc.bonus.uextend.yjs.uEmpWorkDay).Submmit("2015","M08")
ClassMethod Submmit(year, month) As %String
{
   
    n (year,month)
    
    s sYM=year_"-"_$E(month,2,3)
    s cont=0
    &sql(select count(*) into :cont from dhc_bonus_extend_yjs.EmpWorkDay  where  BonusYear =:year AND BonusPeriod =:month )
    
    q:cont=0 1 
    &sql( update dhc_bonus_extend_yjs.EmpWorkDay set IsCheck=1 where  BonusYear =:year AND BonusPeriod =:month)
    &sql(delete from dhc_bonus_data.BonusTargetCollect where BonusYear=:year and BonusPeriod=:month and BonusTargetID in ('25','26','66','67') )
    
    s date=$ZDate($P($H,",",1),3)_" "_$ZTime($P($H,",",2))
    s days=##class(dhc.bonus.comm.Tools).GetMonthDays(sYM)
    
    s sqlStr="SELECT BonusUnitID,BonusYear, BonusPeriod,  BonusUnitCode, BonusUnitName, sum(workSum) workSum, sum(sharySum) sharySum, empType FROM ( "
    _" select a.BonusYear ,a.BonusPeriod ,c.BonusUnitID,c.BonusUnitCode,c.BonusUnitName ,sum(a.WorkDays/"_days_") workSum,sum(a.WorkDays/"_days_"*a.SharyRate) sharySum "
    _" ,CASE  WHEN b.IatricalPositionCode = 'HS' THEN '护士'   ELSE '医生' END empType "
    _" from dhc_bonus_extend_yjs.EmpWorkDay a,HISHR.PersonInfo b,dhc_bonus_data.bonusunit c "
    _" where  BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' "
    _" AND a.EmpCardID=b.empCardID AND a.DeptCode=c.BonusUnitCode "
    _" AND c.LastStage=0"
    _"  GROUP BY c.BonusUnitCode,c.BonusUnitName,b.FlexStrField4"
    _" UNION ALL   "
    _" select a.BonusYear ,a.BonusPeriod ,c.SuperiorUnitID,c.SuperiorUnitID->BonusUnitCode,c.SuperiorUnitID->BonusUnitName ,sum(a.WorkDays/"_days_"),sum(a.WorkDays/"_days_"*a.SharyRate) sharySum"
    _" ,CASE  WHEN b.IatricalPositionCode ='HS' THEN '护士'   ELSE '医生' END empType"
    _" from dhc_bonus_extend_yjs.EmpWorkDay a,HISHR.PersonInfo b,dhc_bonus_data.bonusunit c"
    _" where  BonusYear ='"_year_"' AND BonusPeriod ='"_month_"'"
    _" AND a.EmpCardID=b.empCardID AND a.DeptCode=c.BonusUnitCode "  
    _" AND c.LastStage=1"
    _" GROUP BY c.SuperiorUnitID->BonusUnitCode,c.SuperiorUnitID->BonusUnitName ,b.FlexStrField4"
    _" ) AS jj "
    _" GROUP BY BonusUnitID,BonusYear, BonusPeriod,  BonusUnitCode, BonusUnitName,empType"
    
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
    //插入付款明细表
	While(result.Next())
	{   
	
	    s BonusUnitID=result.Data("BonusUnitID")
	    s BonusYear=result.Data("BonusYear")
	    s BonusPeriod=result.Data("BonusPeriod")
	    s workSum=result.Data("workSum")
	    s sharySum=result.Data("sharySum")
	    
	    s empType=result.Data("empType")
	    i empType="护士" d
	    .s BonusTargetIDForwork= 66
	    .s BonusTargetIDForshary=67
	    e  i empType="医生" d
	    .s BonusTargetIDForwork= 25
	    .s BonusTargetIDForshary=26
	    
		s date=$ZDate($P($H,",",1),3)_" "_$ZTime($P($H,",",2))
	&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,BonusYear,BonusPeriod,DataSource, TargetValue, UpdateDate, Remark)
	values(:BonusTargetIDForwork,:BonusUnitID,:BonusYear,:BonusPeriod,
	1,:workSum,:date,"人员在班考核"))
		&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,BonusYear,BonusPeriod,DataSource, TargetValue, UpdateDate, Remark)
	values(:BonusTargetIDForshary,:BonusUnitID,:BonusYear,:BonusPeriod,
	1,:sharySum,:date,"人员在班考核"))

	}
	q 0
}

/// others: w ##class(dhc.bonus.uextend.yjs.uEmpWorkDay).Submmit("2015","M08")
ClassMethod GetMonthDay(year, month) As %String
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.uext8C0C.uEmpWorkDayS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
