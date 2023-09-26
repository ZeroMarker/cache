/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-28
/// Description: 科室人员奖金发放报表
Class dhc.bonus.report.uEmployeeBonusPayReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:赵立国
/// CreatDate:2011-1-28
/// Description:查询科室人员奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getReport","2010","M","M02","1")
Query getReport(bYear, bPeroidType, bPeroid, bUnitID As %String) As %Query(ROWSPEC = "unitName:%String,bonusValue:%Integer") [ SqlProc ]
{
}

ClassMethod getReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getReportExecute ]
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

/// Creator:zhao liguo
/// CreatDate:2011-1-28
/// Description:查询科室人员的奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getReport","2011","M","01","371")
ClassMethod getReportExecute(ByRef qHandle As %Binary, bYear, bPeroidType, bPeroid, bUnitID As %String) As %Status
{
	
	//n (bYear, bPeroidType, bPeroid, bUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s sPeroid = bPeroidType _ bPeroid
	
	q:bYear="" $$$OK
	q:bPeroidType="" $$$OK
	q:bPeroid="" $$$OK
	q:bUnitID="" $$$OK
	
	s result = ##class(%Library.ResultSet).%New()
	
	s sqlStr = "select BonusUnitID->BonusUnitName AS EmployeeName,BonusValue from dhc_bonus_data.EmployeeBonusPay"

	s sqlStr = sqlStr_"   where  BonusYear='"_bYear_"' and BonusPeriod='"_sPeroid_"' and BonusUnitID->SuperiorUnitID ="_bUnitID
	
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s empName = result.Data("EmployeeName")
		s bonusValue = result.Data("BonusValue")
			
		d OutputDeptSorce
	}

    q $$$OK
OutputDeptSorce
    s Data=$lb(empName,bonusValue)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	d result.Close()
}

/// ------------得到核算单元信息--------------------------------------
/// Creator:赵立国
/// CreatDate:2011-1-28
/// Description:查询核算单元信息
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getUnit","fhq")
Query getUnit(bUnitCode As %String) As %Query(ROWSPEC = "unitID:%String,unitName:%String") [ SqlProc ]
{
}

ClassMethod getUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getUnitExecute ]
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

/// Creator:zhao liguo
/// CreatDate:2011-1-28
/// Description:查询科室人员的奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getUnitExecute","2011","M","M02","1")
ClassMethod getUnitExecute(ByRef qHandle As %Binary, bUnitCode As %String) As %Status
{
	
	//n (bYear, bPeroidType, bPeroid, bUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	

	//q:bUnitCode="" $$$OK
	
	//s bUnitCode=$$ALPHAUP^SSUTIL4(bUnitCode)
	//w bUnitCode,!
	s result = ##class(%Library.ResultSet).%New()
	/*
	s sqlStr = "select a.BonusUnitID,a.BonusUnitName"
	s sqlStr = sqlStr_" from dhc_bonus_data.BonusUnit a ,dhc_bonus_data.BonusEmployeeUnit b ,dhc_bonus_data.BonusEmployee c"
	s sqlStr = sqlStr_"  where a.BonusUnitID = b.BonusUnitID and b.BonusEmployeeID=c.BonusEmployeeID "
	s sqlStr = sqlStr_"  and c.EmployeeCode='"_bUnitCode_"'"
	*/
	s sqlStr = " select a.BonusUnitID,a.BonusUnitName      from dhc_bonus_data.BonusUnit a WHERE  UnitFlag=1 and a.LastStage=0"

	 //and a.BonusUnitTypeID= "_bUnitType
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s bonusUnitID = result.Data("BonusUnitID")
		s bonusUnitName = result.Data("BonusUnitName")
		d OutputUnits
	}

    q $$$OK
OutputUnits
    s Data=$lb(bonusUnitID,bonusUnitName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	d result.Close()
}

/// ------------得到报表头信息--------------------------------
/// Creator:赵立国
/// CreatDate:2011-1-28
/// Description:查询核算单元信息
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getReportTitle","2010","M","02","1")
Query getReportTitle(bYear, bPeroidType, bPeroid, bUnitID As %String) As %Query(ROWSPEC = "BonusPeriod:%String,BonusUnitName:%String,RealBonus:%String") [ SqlProc ]
{
}

ClassMethod getReportTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getReportTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getReportTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getReportTitleExecute ]
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

/// Creator:zhao liguo
/// CreatDate:2011-1-28
/// Description:查询科室人员的奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPayReport","getUnitExecute","2011","M","M02","1")
ClassMethod getReportTitleExecute(ByRef qHandle As %Binary, bYear As %String, bPeroidType As %String, bPeroid As %String, bUnitID As %String) As %Status
{
	
	//n (bYear, bPeroidType, bPeroid, bUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	//unitName:%String,currPeroid:%String,bonusValue:%String
	q:bYear="" $$$OK
	q:bPeroidType="" $$$OK	
	q:bPeroid="" $$$OK
	q:bUnitID="" $$$OK	
	
	s sPeroid = bPeroidType _ bPeroid
		
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "select case  when left(BonusPeriod,1)='M' THEN BonusYear _ '年' _ right(BonusPeriod,2) _ '月'"
	s sqlStr = sqlStr_" when left(BonusPeriod,1)='Q' THEN BonusYear _ '年' _ right(BonusPeriod,2) _ '季度'"
	s sqlStr = sqlStr_"  when BonusPeriod='H01' THEN BonusYear _ '年上半年'  when BonusPeriod='H02' THEN BonusYear _ '年下半年' "
	
	s sqlStr = sqlStr_" when left(BonusPeriod,1)='Y' THEN BonusYear _ '年' end as BonusPeriod,BonusUnitName,RealBonus"
	s sqlStr = sqlStr_"  from dhc_bonus_data.UnitBonusPay a, dhc_bonus_data.BonusUnit b"
	s sqlStr = sqlStr_" where a.BonusUnitID = b.BonusUnitID"
	s sqlStr = sqlStr_" and a.BonusYear='"_ bYear _"' and a.BonusPeriod = '" _ sPeroid _"'"
	s sqlStr = sqlStr_" and a.BonusUnitID=" _ bUnitID
	
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s BonusPeriod = result.Data("BonusPeriod")
		s BonusUnitName = result.Data("BonusUnitName")
		s RealBonus = result.Data("RealBonus")
		d OutputTite
	}

    q $$$OK
OutputTite
    s Data=$lb(BonusPeriod,BonusUnitName,RealBonus)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	d result.Close()
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uEmployeeBon962S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
