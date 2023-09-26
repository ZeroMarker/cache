Class dhc.bonus.report.uBonusReportDefine Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:zhaoliguo
/// CreatDate:2014-02-13
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReport")
Query GetReport(UserCode, rptCode, rptType) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select reportCode,reportName from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusEmpReport b 
	where a.%ID=b.BonusReportID AND upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode)
	 and (reportCode=:rptCode or ""=:rptCode) and 	ReportType=:rptType 
	 order by reportCode
}

/// Creator:zhaoliguo
/// CreatDate:2016-07-01
/// Description:年度Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReport")
Query GetItems(rptCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
SELECT DISTINCT BonusSchemeItemID->SchemeItemCode,BonusSchemeItemID->SchemeItemName
 from dhc_bonus_data.BonusReportCell
WHERE BonusReportID->ReportCode=:rptCode
}

/// Creator:zhaoliguo
/// CreatDate:2014-02-13
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReport")
Query GetPersonReport() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select reportCode,reportName from dhc_bonus_data.BonusReport a
	where ReportType=1 and IsPub=1 order by reportCode
}

/// Creator:zhaoliguo
/// CreatDate:2014-02-13
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReport")
Query GetDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT BonusUnitID, BonusUnitCode , BonusUnitName  FROM dhc_bonus_data.BonusUnit
	WHERE BonusUnitTypeID=1 AND SuperiorUnitID>0
}

/// 主报表
ClassMethod GetReportDefineExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK
	q:rptCode="" $$$OK
	
	s unitflag=0
	&sql(select count(*) into :unitflag from dhc_bonus_data.BonusReportUnit where BonusReportID->ReportCode=:rptCode ) ;:rptCode

    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    i unitflag="" s unitflag=0
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"
	
	s strSql=strSql
	_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
	i unitflag>0 d
	.s strSql=strSql_" and c.BonusUnitID= d.BonusUnitID and a.%ID = d.BonusReportID "
	s strSql=strSql
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" _" and a.ReportCode= '"_rptCode_"'"

	 s strSql=strSql
	_" union all"
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,c.BonusSchemeItemID->SchemeItemName,sum(c.BonusValue) BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"
	s strSql=strSql	_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType=9"
	
	i unitflag>0 d
	.s strSql=strSql _" and c.BonusUnitID= d.BonusUnitID and a.%ID = d.BonusReportID  "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "_" and a.ReportCode= '"_rptCode_"'"

	s strSql=strSql	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemName "
	
	 s strSql=strSql
	_" union all"
	_"   select a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode"
	_" ,c.BonusUnitID->BonusUnitName ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c"
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"
	
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
	i unitflag>0 d
	.s strSql=strSql_" and c.BonusUnitID =d.BonusUnitID and a.%ID = d.BonusReportID  "
	
	s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"_" order by ReportIndex"

	    ;q strSql

  	;w strSql,!
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

ClassMethod GetReportDefineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportDefineExecute ]
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

ClassMethod GetReportDefineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportDefineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReportDefine","0201","2013-11","D0036") 
Query GetReportDefine(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String") [ SqlProc ]
{
}

/// -------科室主任及护士长自定义报表------------------------------------------------------
/// 主报表
ClassMethod GetReportDefineDeptExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
  
	q:rptCode="" $$$OK
	
	s ReportType="11" ;横向扩展无图
	s unitflag=0
    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
            
    ;s userCode="D0036"
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,isnull(CellName,c.BonusTargetID->BonusTargetName) BonusTargetName,sum(c.TargetValue) as TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	_" ,dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType='"_ReportType_"'"
	_" and c.BonusUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" _" and a.ReportCode= '"_rptCode_"'"
	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusTargetID->BonusTargetCode"
	_" union all"
	_" select   a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,isnull(cellName,c.BonusSchemeItemID->SchemeItemName) sname,sum(c.BonusValue) BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	_ ",dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType='"_ReportType_"'"
	_" and c.BonusUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "_" and a.ReportCode= '"_rptCode_"'"
	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusSchemeItemID->SchemeItemName,cellName"
	_" union all"
	_" select a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode"
	_" ,c.BonusUnitID->BonusUnitName ,c.BonusTargetID->BonusTargetCode ItemCode,isnull(cellname,c.BonusTargetID->BonusTargetName) sname,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c"
	_ ",dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType='"_ReportType_"'"
	_" and c.BonusUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	_" and a.ReportCode= '"_rptCode_"'"_""
	_" union all"
	_" select a.ReportName, d.BonusUnitID->SuperiorUnitID->BonusUnitName supName,d.BonusUnitID->BonusUnitCode"
	_" ,d.BonusUnitID->BonusUnitName ,b.BonusTargetID->BonusTargetCode ItemCode,isnull(cellname,b.BonusTargetID->BonusTargetName) sname,b.BonusTargetID->InitValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusEmployeeUnit d"
	_" where b.BonusReportID=a.%ID and  b.CellType=1  and a.ReportType='"_ReportType_"'"
	_" and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	_" and a.ReportCode= '"_rptCode_"'"


	s strSql=strSql_" order by ReportIndex"
	
	i sDate="" d
    .s strSql="select   a.ReportName,d.BonusUnitID->SuperiorUnitID->BonusUnitName supName,d.BonusUnitID->BonusUnitCode,d.BonusUnitID->BonusUnitName "
	.s strSql=strSql_" ,c.BonusTargetCode ItemCode,isnull(CellName,c.BonusTargetName) BonusTargetName,0 as TargetValue,ReportIndex,'"_syear_"' syear "
	.s strSql=strSql_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTarget  c ,dhc_bonus_data.BonusEmployeeUnit d "
	.s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType='"_ReportType_"' "
    .s strSql=strSql_" and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"')  and a.ReportCode= '"_rptCode_"' "
    .s strSql=strSql_" group by a.ReportName,d.BonusUnitID->SuperiorUnitID->BonusUnitName ,d.BonusUnitID->BonusUnitCode,c.BonusTargetCode "
    .s strSql=strSql_" union all select   a.ReportName, d.BonusUnitID->SuperiorUnitID->BonusUnitName supName,d.BonusUnitID->BonusUnitCode,d.BonusUnitID->BonusUnitName"
    .s strSql=strSql_" ,c.SchemeItemCode ItemCode,isnull(cellName,c.SchemeItemName) sname,"
    .s strSql=strSql_" 0 BonusValue,ReportIndex,'"_syear_"' syear "
    .s strSql=strSql_"  from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusSchemeItem  c,dhc_bonus_data.BonusEmployeeUnit d "
    .s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID "
    .s strSql=strSql_" and a.ReportType='"_ReportType_"' and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') and a.ReportCode= '"_rptCode_"' "
    .s strSql=strSql_" group by a.ReportName,d.BonusUnitID->SuperiorUnitID->BonusUnitName ,d.BonusUnitID->BonusUnitCode ,c.SchemeItemName,cellName "

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
      s deptName ="" ; result.Data("deptName")
      ;s UnitName =UnitCode_"_"_UnitName
      s ItemCode= result.Data("ItemCode")
      s ItemName = result.Data("BonusTargetName")
      
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")
	  s rptIndex=result.Data("ReportIndex")

	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,ItemName,TargetValue,syear,rptIndex,UnitCode)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportDefineDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportDefineDeptExecute ]
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

ClassMethod GetReportDefineDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportDefineDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReportDefineDept","105","","demo") 
Query GetReportDefineDept(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String,UnitCode:%String") [ SqlProc ]
{
}

/// -------科室主任及护士长查询科室人员信息自定义报表------------------------------------------------------
/// 主报表
ClassMethod GetReportDefDeptPersonExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	q:rptCode="" $$$OK
	
	s unitflag=0
	;w "unitflag="_unitflag_":"_rptCode,!
	;&sql(select count(*) into :unitflag from dhc_bonus_data.BonusReportUnit where BonusReportID->ReportCode=:rptCode ) ;:rptCode

	;w "unitflag="_unitflag_":"_rptCode,!
    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    
    ;s userCode="D0036"
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,sum(c.TargetValue) as TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	s strSql=strSql_ ",dhc_bonus_data.BonusEmployeeUnit d"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
	s strSql=strSql_" and c.BonusUnitID->SuperiorUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" _" and a.ReportCode= '"_rptCode_"'"
	s strSql=strSql_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusTargetID->BonusTargetCode"
	 s strSql=strSql
	_" union all"
	_" select   a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,c.BonusSchemeItemID->SchemeItemName,sum(c.BonusValue) BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	s strSql=strSql_ ",dhc_bonus_data.BonusEmployeeUnit d"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType=9"
	s strSql=strSql_" and c.BonusUnitID->SuperiorUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "_" and a.ReportCode= '"_rptCode_"'"
	s strSql=strSql	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusSchemeItemID->SchemeItemName"
	s strSql=strSql
	_" union all"
	s strSql=strSql
	_"   select a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode"
	_" ,c.BonusUnitID->BonusUnitName ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c"
	s strSql=strSql_ ",dhc_bonus_data.BonusEmployeeUnit d"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
	s strSql=strSql_" and c.BonusUnitID->SuperiorUnitID= d.BonusUnitID and upper(d.BonusEmployeeID->EmployeeCode)=upper('"_userCode_"') "
	s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"_" order by ReportIndex"

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
      s deptName ="" ; result.Data("deptName")
      ;s UnitName =UnitCode_"_"_UnitName
      s ItemCode= result.Data("ItemCode")
      s ItemName = result.Data("BonusTargetName")
      
      i ItemName = "科室成本支出" s ItemName = "可控成本支出"
      e  i ItemName = "护士可控奖金" s ItemName = "可控结余考核"
      e  i ItemName = "医师可控奖金" s ItemName = "可控结余考核"
      e  i ItemName = "科室可控奖金" s ItemName = "可控结余考核"
      e  i ItemName = "绩效考核得分" s ItemName = "综合考核分值"
      e  i ItemName = "科室考核扣款" s ItemName = "考核奖罚"
      
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")
	  s rptIndex=result.Data("ReportIndex")

	 d OutputRow4
	  
	} 
   	  
  	q $$$OK
OutputRow4
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,ItemName,TargetValue,syear,rptIndex)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportDefDeptPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportDefDeptPersonExecute ]
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

ClassMethod GetReportDefDeptPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportDefDeptPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReportDefDeptPerson","0101","2013-07","D0101") 
Query GetReportDefDeptPerson(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String") [ SqlProc ]
{
}

/// -------科室主任及护士长查询科室信息自定义报表------------------------------------------------------
/// 主报表
ClassMethod GetReportDefPersonExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:sDate="" $$$OK
	q:rptCode="" $$$OK
	
	s unitflag=0
	;w "unitflag="_unitflag_":"_rptCode,!
	;&sql(select count(*) into :unitflag from dhc_bonus_data.BonusReportUnit where BonusReportID->ReportCode=:rptCode ) ;:rptCode

	;w "unitflag="_unitflag_":"_rptCode,!
    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    
    ;s userCode="D0036"
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,sum(c.TargetValue) as TargetValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	//s strSql=strSql_ ",dhc_bonus_data.BonusEmployeeUnit d"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
	s strSql=strSql_" and upper(c.BonusUnitID->BonusUnitCode)=upper('"_userCode_"') "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" _" and a.ReportCode= '"_rptCode_"'"
	s strSql=strSql_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusTargetID->BonusTargetCode"
	 s strSql=strSql
	_" union all"
	_" select   a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,c.BonusSchemeItemID->SchemeItemName,sum(c.BonusValue) BonusValue,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	//s strSql=strSql_ ",dhc_bonus_data.BonusEmployeeUnit d"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType=9"
		s strSql=strSql_" and upper(c.BonusUnitID->BonusUnitCode)=upper('"_userCode_"') "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "_" and a.ReportCode= '"_rptCode_"'"
	s strSql=strSql	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusSchemeItemID->SchemeItemName"
	s strSql=strSql
	_" union all"
	s strSql=strSql
	_"   select a.ReportName, c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode"
	_" ,c.BonusUnitID->BonusUnitName ,c.BonusTargetID->BonusTargetCode ItemCode,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c"
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType=9"
		s strSql=strSql_" and upper(c.BonusUnitID->BonusUnitCode)=upper('"_userCode_"') "
	s strSql=strSql_" and a.ReportCode= '"_rptCode_"'"_" order by ReportIndex"

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
      s deptName ="" ; result.Data("deptName")
      ;s UnitName =UnitCode_"_"_UnitName
      s ItemCode= result.Data("ItemCode")
      s ItemName = result.Data("BonusTargetName")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")
	  s rptIndex=result.Data("ReportIndex")

	 d OutputRow5
	  
	} 
   	  
  	q $$$OK
OutputRow5
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,ItemName,TargetValue,syear,rptIndex)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportDefPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportDefPersonExecute ]
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

ClassMethod GetReportDefPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportDefPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetReportDefPerson","0101","2013-07","D0101") 
Query GetReportDefPerson(rptCode As %String, sDate As %String, userCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String") [ SqlProc ]
{
}

/// -------奖金方案项目报表-----------------------------------------------------
/// 主报表
ClassMethod GetSchemItemExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, eDate As %String, sUnitDr As %String, sItemCode As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,eDate,sUnitDr,sItemCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
 	q:sDate="" $$$OK
 	q:eDate="" $$$OK
	q:rptCode="" $$$OK
	
	s unitflag=0

    s sDate= $p(sDate,"-",1) _$p(sDate,"-",2)
    s eDate= $p(eDate,"-",1) _$p(eDate,"-",2)
    
    s strSql=""
	_" select BonusYear _'-'_ RIGHT(BonusPeriod,2) AS sYearMonth,BonusUnitID,BonusUnitID->BonusUnitName,b.ReportName"
	_" ,a.BonusSchemeItemID->SchemeItemCode,a.BonusSchemeItemID->SchemeItemName,sum(BonusValue) BonusValue,ReportIndex"
	_" from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusReport b,dhc_bonus_data.BonusReportCell c"
    _" where b.BonusReportID =c.BonusReportID AND a.BonusSchemeItemID =c.BonusSchemeItemID  "
    _" AND BonusYear _ RIGHT(BonusPeriod,2)>='"_sDate_"' and BonusYear _ RIGHT(BonusPeriod,2)<='"_eDate_"' "
    _" and b.ReportCode='"_rptCode_"'"
    i sItemCode'="" d 
    .s strSql=strSql _" and a.BonusSchemeItemID->SchemeItemCode ='"_sItemCode_"'"
    i sUnitDr'="" d 
    .s strSql=strSql _" and BonusUnitID='"_sUnitDr_"'"
    s strSql=strSql _" GROUP BY BonusYear _'-'_ RIGHT(BonusPeriod,2) ,BonusUnitID,BonusUnitID->BonusUnitCode,a.BonusSchemeItemID->SchemeItemCode,ReportIndex"
    s strSql=strSql _" ORDER BY BonusUnitID->BonusUnitCode,a.BonusSchemeItemID->SchemeItemCode"

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s RowNo=0		
    While(result.Next()){
	  s RowNo=RowNo+1
	  
	  s sYearMonth=result.Data("sYearMonth")
      s UnitName = result.Data("BonusUnitName")
      s UnitID = result.Data("BonusUnitID")

      s ItemCode= result.Data("SchemeItemCode")
      s ItemName = result.Data("SchemeItemName")
      s TargetValue=$fn(result.Data("BonusValue"),"",2)
	  s sYFDate=sDate _"至"_ eDate
	  s rptIndex=result.Data("ReportIndex")
      s ReportName=result.Data("ReportName")
	 d OutputRow6
	  
	} 
   	  
  	q $$$OK
OutputRow6
  	s Data=$lb(sYearMonth,UnitName,UnitID,ItemCode,ItemName,TargetValue,sYFDate,rptIndex,ReportName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetSchemItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemItemExecute ]
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

ClassMethod GetSchemItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportDefine","GetSchemItem","F001","2016-02","2016-05","","") 
Query GetSchemItem(rptCode As %String, sDate As %String, eDate As %String, sUnitDr As %String, sItemCode As %String) As %Query(ROWSPEC = "YearMonth:%String,UnitName:%String ,UnitID:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,YFDate:%String,rptIndex:%String,ReportName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusReport743S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
