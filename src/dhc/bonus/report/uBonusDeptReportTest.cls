Class dhc.bonus.report.uBonusDeptReportTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
ClassMethod GetReportDefineExecute(ByRef qHandle As %Binary, rptCode As %String, sDate As %String, userCode As %String, deptCode As %String, ReportType As %String, ItemRate As %Float) As %Status
{
	
	n (qHandle,rptCode,sDate,userCode,deptCode,ReportType,ItemRate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    ;k ^zlgtemp8
	;s ^zlgtemp8=rptCode_"^"_sDate_"^"_userCode_"^"_deptCode_"^"_ReportType_"^"_ItemRate
	
 	q:sDate="" $$$OK
	q:rptCode="" $$$OK
	;s ReportType="22" ;横向扩展无图
	s unitflag=0
	s initRate=1
	;i ItemRate="" s ItemRate=1
	
	&sql(select count(*) into :unitflag from dhc_bonus_data.BonusReportUnit where BonusReportID->ReportCode=:rptCode ) 
	
	&sql(select InitValue into :initRate from dhc_bonus_data.bonusTarget where BonusTargetCode='01020' ) 
	i initRate="" s initRate=1
	i ItemRate="" s ItemRate=initRate
	
    s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    i unitflag="" s unitflag=0
    
	s strSql=""
	_"  select isnull(b.CellName,c.BonusSchemeItemID->SchemeItemName) CellName,sum(c.BonusValue) BonusValue "
    _"  from dhc_bonus_data.BonusReport a,dhc_bonus_data.BonusReportCell b,dhc_bonus_data.UnitBonusDetail  c"
    _"  where b.BonusReportID=a.%ID and  b.CellType=3 and b.BonusSchemeItemID=c.BonusSchemeItemID and a.ReportType='22'"
    _"  and BonusYear _ BonusPeriod ='"_yearMoth_"' and a.ReportCode= '0201'"
    _"  group by b.CellName "
	
	w strSql,!
  	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s RowNo=0		
 While(result.Next()){
	  s RowNo=RowNo+1
	  
	  s ReportName=""
      s supName=""
      s UnitCode = ""
      s UnitName = ""
      s deptName = ""
      s ItemCode= ""
      s CellName= result.Data("CellName")
 	  s FontBold= ""
      s BackColor= ""
      i FontBold="" s FontBold="false"
      i BackColor="" s BackColor="-1"
      
      i CellName="工作量提成奖" d
      .s TargetValue=$fn(result.Data("BonusValue")/ initRate*ItemRate,"",2)
      e  d
      .s TargetValue=$fn(result.Data("BonusValue"),"",2)
     
      s initRates="原 "_ initRate _"/新 "_ItemRate
      
	  s syear=syear
	  s rptIndex=1

	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(RowNo,ReportName,deptName,supName,UnitName,ItemCode,CellName,TargetValue,syear,rptIndex,FontBold,BackColor,initRates)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusDeptReportTest","GetReportDefine","0100","2014-01","6666","D0101","22","1") 
Query GetReportDefine(rptCode As %String, sDate As %String, userCode As %String, deptCode As %String, ReportType As %String, ItemRate As %Float) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,deptName:%String ,supName:%String,UnitName:%String,ItemCode:%String,ItemName:%String,TargetValue:%Float,syear:%String,rptIndex:%String,FontBold:%String,BackColor:%String,ItemRate:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusDeptR8A5AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
