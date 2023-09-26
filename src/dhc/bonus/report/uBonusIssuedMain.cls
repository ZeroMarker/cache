/// 标题：绩效奖金下发报表
/// 作者：Zhao LiGuo
/// 日期：2012-03-31
/// 需求：华西医院
Class dhc.bonus.report.uBonusIssuedMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 获取科室登陆人员有权限的科室
/// ------------得到核算单元信息--------------------------------------
/// Creator:赵立国
/// CreatDate:2012-3-31
/// Description:查询核算单元信息
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedMain","getUnit","fhq")
Query getUnit(sUserCode As %String) As %Query(ROWSPEC = "unitID:%String,unitName:%String") [ SqlProc ]
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
/// CreatDate:2012-3-31
/// Description:查询科室人员的奖金发放情况
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedMain","getUnitExecute","2011","M","M02","1")
ClassMethod getUnitExecute(ByRef qHandle As %Binary, sUserCode As %String) As %Status
{
	
	//n (bYear, bPeroidType, bPeroid, bUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s result = ##class(%Library.ResultSet).%New()

	s sqlStr = "select a.BonusUnitID,a.BonusUnitName"
	s sqlStr = sqlStr_" from dhc_bonus_data.BonusUnit a ,dhc_bonus_data.BonusEmployeeUnit b ,dhc_bonus_data.BonusEmployee c"
	s sqlStr = sqlStr_"  where a.BonusUnitID = b.BonusUnitID and b.BonusEmployeeID=c.BonusEmployeeID "
	s sqlStr = sqlStr_"  and c.EmployeeCode='"_sUserCode_"'"


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

/// 主报表
ClassMethod DeptIssuedMainExecute(ByRef qHandle As %Binary, sDate As %String, BonusUnitID As %String) As %Status
{
	
	n (qHandle,sDate,BonusUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
	
 	q:sDate="" $$$OK
	q:BonusUnitID="" $$$OK
  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	s strSql=strSql_" select BonusYear,BonusPeriod,SchemeItemID->SchemeItemName,ResultBonus,SupBonusUnitID->BonusUnitName"
		_" from dhc_bonus_data.BonusIssuedMain a"
		_" where a. BonusUnitID= '"_BonusUnitID_"'"
		_" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"'"

    //q strSql
    //w strSql,!	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s ItemName=result.Data("SchemeItemName")
      s BonusUnitName = result.Data("BonusUnitName")
    
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s TargetValue=$fn(result.Data("ResultBonus"),"",2)
	  s YearMonthName=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w ItemName_":"_BonusUnitName,!
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(ItemName,BonusUnitName,TargetValue,YearMonthName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIssuedMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIssuedMainExecute ]
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

ClassMethod DeptIssuedMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIssuedMainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIssuedMain","DeptIssuedMain","2011","M11","229")
Query DeptIssuedMain(sDate As %String, BonusUnitID As %String) As %Query(ROWSPEC = "ItemName:%String,BonusUnitName:%String,TargetValue:%Float,YearMonthName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusIssued66ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
