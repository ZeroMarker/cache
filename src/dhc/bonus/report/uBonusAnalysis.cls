Class dhc.bonus.report.uBonusAnalysis Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod GetBonusAnalysisExecute(ByRef qHandle As %Binary, sDate As %String) As %Status
{
	
	n (qHandle,sDate)
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
  
	s strSql=""
	_" select deptname,sum(value1) value1,sum(value2) value2,sum(value3) value3,sum(value4) value4, "
	_" sum(value5) value5 from ( "
	_" select BonusUnitID->BonusUnitName deptname,TargetValue value1,0 value2,0 value3,0 value4,0 value5 "
	_" from dhc_bonus_data.BonusTargetCollect "
	_" where BonusYear _ BonusPeriod ='"_yearMoth_"' and BonusTargetID->BonusTargetCode  = '011500' "
	
	_" union all "
	
    _" select BonusUnitID->BonusUnitName deptname,0 value1,BonusValue value2,0 value3,0 value4,0 value5 "
    _" from dhc_bonus_data.UnitBonusDetail "
    _" where BonusYear _ BonusPeriod ='"_yearMoth_"' and BonusSchemeItemID->SchemeItemCode = '10112' "
    
    _" union all "
    
    _" select BonusUnitID->BonusUnitName deptname,0 value1,0 value2,BonusValue value3,0 value4,0 value5 "
    _" from dhc_bonus_data.UnitBonusDetail "
    _" where BonusYear _ BonusPeriod ='"_yearMoth_"' and BonusSchemeItemID->SchemeItemCode = '10113' "
    
    _" union all "
    
    _" select SuperiorUnitID->BonusUnitName deptname,0 value1,0 value2,0 value3,sum(ROUND(ResultBonus,0,1)) value4,0 value5 "
    _" from dhc_bonus_data.BonusIssuedDetail "
    _" where BonusYear _ BonusPeriod ='"_yearMoth_"' and upper(BonusUnitCode) not like '%N%' "
    _" group by SuperiorUnitID "
    
    _" union all "
    
    _" select SuperiorUnitID->BonusUnitName deptname,0 value1,0 value2,0 value3,0 value4,sum(ROUND(ResultBonus,0,1)) value5 "
    _" from dhc_bonus_data.BonusIssuedDetail "
    _" where BonusYear _ BonusPeriod ='"_yearMoth_"' and upper(BonusUnitCode) like '%N%' "
    _" group by BonusUnitID->SuperiorUnitID "
    
    _" ) group by deptname "
    
	k ^zlgtemp
	s ^zlgtemp=strSql
	;w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	  s deptname=result.Data("deptname")
      s value1 = $fn(result.Data("value1"),"",2)
      s value2 = $fn(result.Data("value2"),"",2)
      s value3 = $fn(result.Data("value3"),"",2)
      s value4 = $fn(result.Data("value4"),"",2)
      s value5 = $fn(result.Data("value5"),"",2)
     
	 d OutputRow3
	  
	} 
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(deptname,value1,value2,value3,value4,value5)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
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

ClassMethod GetBonusAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusAnalysisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusAnalysis","GetBonusAnalysis","2013-10") 
Query GetBonusAnalysis(sDate As %String) As %Query(ROWSPEC = "deptname:%String,value1:%Float,value2:%Float,value3:%Float,value4:%Float,value5:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r7006.uBonusAnalysisS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
