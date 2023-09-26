/// Creator: z;g
/// CreatDate: 2013-3-23
/// Description: 
Class dhc.bonus.report.uBonusReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod GetReportEmpExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
   ; k ^zlgtemp
	;s ^zlgtemp=rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	q:userCode="" $$$OK
	;s rptCode="0102"

    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    
    ;s userCode="D0036"
	s strSql=""
	_" select   a.ReportName,BonusUnitID->SuperiorUnitID->BonusUnitName supName,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetName,c.TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType=1"
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"' and c.BonusUnitID->BonusUnitCode='"_userCode_"'"
	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	
	 s strSql=strSql
	_" union all"
	_" select   a.ReportName,BonusUnitID->SuperiorUnitID->BonusUnitName supName,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemName,c.BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType=1"
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"' and c.BonusUnitID->BonusUnitCode='"_userCode_"'"
	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	
	 s strSql=strSql
	_" union all"
	_" select   a.ReportName,BonusUnitID->SuperiorUnitID->BonusUnitName supName,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c,dhc_bonus_data.BonusUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType=1"
	_" and c.BonusUnitID =d.SuperiorUnitID->SuperiorUnitID  and  d.BonusUnitCode='"_userCode_"'"
	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	 s strSql=strSql
	_" order by ReportIndex"


    ;w strSql,!
   	;k ^zlgtemp
    ;s ^zlgtemp= strSql	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s RowNo=0		
 While(result.Next()){
	  s RowNo=RowNo+1
	  
	  s ReportName=result.Data("ReportName")
      s supName=result.Data("supName")
      s UnitCode = result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
      s UnitName =UnitCode_"_"_UnitName
      
      s ItemName = result.Data("BonusTargetName")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")

	 d OutputRow1
	  
	} 
   	  
  	q $$$OK
OutputRow1
  	s Data=$lb(RowNo,ReportName,supName,UnitName,ItemName,TargetValue,syear)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportEmpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportEmpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReportEmpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportEmpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReport","GetReportEmp","0101","2013-01","D0120") 
Query GetReportEmp(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,supName:%String,UnitName:%String,ItemName:%String,TargetValue:%Float,syear:%String") [ SqlProc ]
{
}

/// 主报表
ClassMethod GetReportDeptExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	q:userCode="" $$$OK


    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    ;and  b.CellType=1
    ;s userCode="D0036"
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c,dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID  and b.BonusTargetID=c.BonusTargetID and a.ReportType=2"
	_" and c.BonusUnitID->SuperiorUnitID= d.BonusUnitID and UPPER(d.BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"')"
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" 

	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	
	 s strSql=strSql
	_" union all"
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,c.BonusSchemeItemID->SchemeItemName,sum(c.BonusValue) BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c,dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType=2"
	_" and c.BonusUnitID->SuperiorUnitID= d.BonusUnitID and UPPER(d.BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"')"
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "

	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	s strSql=strSql	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemName "
	
	 s strSql=strSql
	_" union all"
	_" select    a.ReportName,d.SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,d.SuperiorUnitID->BonusUnitName supName,d.BonusUnitCode,d.BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c,dhc_bonus_data.BonusUnit d,dhc_bonus_data.BonusEmployeeUnit e"
	_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType=2"
	_"    and d.SuperiorUnitID=e.BonusUnitID and  e.BonusEmployeeID->EmployeeCode='"_userCode_"'"
	_" and c.BonusUnitID =d.SuperiorUnitID->SuperiorUnitID "
	
	;_" and c.BonusUnitID =d.SuperiorUnitID->SuperiorUnitID  and  d.BonusUnitCode='"_userCode_"'"
	i rptCode'="" d
	.s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"
	 s strSql=strSql
	_" order by ReportIndex"


    ;q strSql
    ;k ^zlgtemp
    ;s ^zlgtemp= strSql	
  	w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s RowNo=0		
 While(result.Next()){
	  s RowNo=RowNo+1
	  
	  s ReportName=result.Data("ReportName")
      s supName=result.Data("supName")
      s UnitCode = result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
      s deptName = result.Data("deptName")
      ;s UnitName =UnitCode_"_"_UnitName
      s ItemCode= result.Data("ItemCode")
      s ItemName = result.Data("BonusTargetName")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")
	  s rptIndex=result.Data("ReportIndex")

	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,ItemName,TargetValue,syear,rptIndex)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportDeptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReportDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReport","GetReportDept","0201","2013-01","D0036") 
Query GetReportDept(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String") [ SqlProc ]
{
}

/// 主报表
ClassMethod GetNotUpDeptExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	;q:userCode="" $$$OK


    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
  
	s strSql=""
	_ " select SuperiorUnitID->SuperiorUnitID->BonusUnitName deptname,SuperiorUnitID->BonusUnitName groupName ,BonusUnitCode ,BonusUnitName from  dhc_bonus_data.BonusUnit where BonusUnitID NOT IN"
    _"  ( select  distinct  c.BonusUnitID  from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
    _"  where b.BonusReportID=a.%ID  and b.BonusTargetID=c.BonusTargetID and a.ReportType=2"
    _"  and BonusYear _ BonusPeriod ='"_yearMoth_"') and  UnitFlag=3  order by BonusUnitTypeID,BonusUnitCode "

	k ^zlgtemp
	s ^zlgtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	  s deptname=result.Data("deptname")
      s groupName=result.Data("groupName")
      s UnitCode =result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
     
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(deptname,groupName,UnitCode,UnitName,syear)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetNotUpDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotUpDeptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNotUpDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotUpDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReport","GetNotUpDept","0201","2013-01","D0036") 
Query GetNotUpDept(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "deptname:%String,groupName:%String,UnitCode:%String,BonusUnitName:%String,syear:%String ") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.report.uBonusReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
