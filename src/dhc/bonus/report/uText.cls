Class dhc.bonus.report.uText Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod GetDeptExecute(ByRef qHandle As %Binary, bonusunitCode As %String) As %Status
{
	
	n (qHandle,bonusunitCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    k ^zlgtemp
	s ^zlgtemp="zlg1="_bonusunitCode
	;q:rptCode="" $$$OK
 	;q:sDate="" $$$OK
	;q:userCode="" $$$OK


    ;s yearMoth= $p(sDate,"-",1) _"M"_$p(sDate,"-",2)
    ;s syear=$p(sDate,"-",1) _"年"_$p(sDate,"-",2)_"月"
    
	s strSql=""
	_" select BonusUnitCode,BonusUnitName,BonusUnitTypeID,BonusUnitTypeID->UnitTypeName"
	_" from  dhc_bonus_data.BonusUnit"
	
	i bonusunitCode'="" d
	.s strSql=strSql_" where BonusUnitCode = '"_bonusunitCode_"'"

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
	  
	  s BonusUnitCode=result.Data("BonusUnitCode")
      s BonusUnitName=result.Data("BonusUnitName")
      s BonusUnitTypeID = result.Data("BonusUnitTypeID")
      s UnitTypeName = result.Data("UnitTypeName")
    

	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(RowNo,BonusUnitCode,BonusUnitName,BonusUnitTypeID,UnitTypeName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptExecute ]
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

ClassMethod GetDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uText","GetReportDept","0202","2013-01","1186") 
Query GetDept(bonusunitCode As %String) As %Query(ROWSPEC = "RowNo:%Integer,BonusUnitCode:%String,BonusUnitName:%String,UnitTypeCode:%String,UnitTypeName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.report.uTextS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
