Class dhc.bonus.report.uBonusDeptReportDefine Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Description:报表Query
/// Table:dhc_bonus_data.BonusReport
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusDeptReportDefine","GetReport","demo")
Query GetReport1(UserCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select reportCode,reportName from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusEmpReport b 
	where a.%ID=b.BonusReportID AND upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode)
	and ReportType=9 order by reportCode
}

Query GetReport(UserCode, rptCode, rptType) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select reportCode,reportName from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusEmpReport b 
	where a.%ID=b.BonusReportID AND upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode)
	 and (reportCode=:rptCode or ""=:rptCode) and 	ReportType=:rptType 
	 order by reportCode
}

/// Description:报表Query
/// Table:dhc_bonus_data.UnitBonus
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusDeptReportDefine","GetDept","demo")
Query GetDept(UserCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select a.BonusUnitCode,a.BonusUnitName from dhc_bonus_data.BonusUnit a,dhc_bonus_data.BonusEmployeeUnit b
	where b.BonusUnitID=a.BonusUnitID and upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode)
}

/// 主报表
ClassMethod GetReportDefineExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String, deptCode As %String, ReportType As %String) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode,deptCode,ReportType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"

	;q:rptCode="" $$$OK
 	q:sDate="" $$$OK
	q:rptCode="" $$$OK
	;s ReportType="22" ;横向扩展无图
	s unitflag=0
	
	&sql(select count(*) into :unitflag from dhc_bonus_data.BonusReportUnit where BonusReportID->ReportCode=:rptCode ) 

	
    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    i unitflag="" s unitflag=0
    
	s strSql=""
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusTargetID->BonusTargetCode ItemCode,b.CellName,c.BonusTargetID->BonusTargetName,c.TargetValue,ReportIndex,'"_syear_"' syear"
	_" ,BackColor,FontBold"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.BonusTargetCollect  c"
	
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"

	s strSql=strSql
	_" where b.BonusReportID=a.%ID and  b.CellType=2 and b.BonusTargetID=c.BonusTargetID and a.ReportType='"_ReportType_"'"
	i unitflag>0 d
	.s strSql=strSql_" and c.BonusUnitID= d.BonusUnitID and a.%ID = d.BonusReportID "
	s strSql=strSql
	_" and BonusYear _ BonusPeriod ='"_yearMoth_"'" _" and a.ReportCode= '"_rptCode_"' and c.BonusUnitID->BonusUnitCode='"_deptCode_"'"

	 s strSql=strSql
	_" union all"
	_" select   a.ReportName,c.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemCode ItemCode,b.CellName,c.BonusSchemeItemID->SchemeItemName,c.BonusValue BonusValue,ReportIndex,'"_syear_"' syear"
	_" ,BackColor,FontBold"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"
	s strSql=strSql	_" where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType='"_ReportType_"'"
	
	i unitflag>0 d
	.s strSql=strSql _" and c.BonusUnitID= d.BonusUnitID and a.%ID = d.BonusReportID  "
	s strSql=strSql_" and BonusYear _ BonusPeriod ='"_yearMoth_"' "_" and a.ReportCode= '"_rptCode_"' and c.BonusUnitID->BonusUnitCode='"_deptCode_"' "

	s strSql=strSql	_" group by a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName ,c.BonusUnitID->BonusUnitCode,c.BonusUnitID->BonusUnitName"
	_" ,c.BonusSchemeItemID->SchemeItemName "
	
	 s strSql=strSql
	_" union all"
	_"   select a.ReportName,c.BonusUnitID->SuperiorUnitID->BonusUnitName deptName,c.BonusUnitID->SuperiorUnitID->BonusUnitName supName,c.BonusUnitID->BonusUnitCode"
	_" ,c.BonusUnitID->BonusUnitName ,c.BonusTargetID->BonusTargetCode ItemCode,b.CellName,c.BonusTargetID->BonusTargetName,c.TargetRate,ReportIndex,'"_syear_"' syear"
	_" ,BackColor,FontBold"
	_" from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.TargetCalculateRate  c"
	i unitflag>0 d
	.s strSql=strSql_ ",dhc_bonus_data.BonusReportUnit d"
	
	s strSql=strSql_" where b.BonusReportID=a.%ID and  b.CellType=1 and b.BonusTargetID=c.BonusTargetID and a.ReportType='"_ReportType_"'"
	i unitflag>0 d
	.s strSql=strSql_" and c.BonusUnitID =d.BonusUnitID and a.%ID = d.BonusReportID  "
	
	s strSql=strSql_" and a.ReportCode= '"_rptCode_"' and c.BonusUnitID->BonusUnitCode='"_deptCode_"'"_" order by ReportIndex"

	
    ;k ^zlgtemp
	;s ^zlgtemp(0625)=strSql
  	
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
      s CellName= result.Data("CellName")
 	  s FontBold= result.Data("FontBold")
      s BackColor= result.Data("BackColor")
      i FontBold="" s FontBold="false"
      i BackColor="" s BackColor="-1"
      
      i CellName '="" d
      .s ItemName = CellName
      e  d
      .s ItemName = result.Data("BonusTargetName")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s syear=result.Data("syear")
	  s rptIndex=result.Data("ReportIndex")

	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,ItemName,TargetValue,syear,rptIndex,FontBold,BackColor)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusDeptReportDefine","GetReportDefine","0203","2014-01","6666","D0101","22") 
Query GetReportDefine(rptCode As %String, sDate As %String, userCode As %String, deptCode As %String, ReportType As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String,FontBold:%String,BackColor:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusDeptRD6C1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
