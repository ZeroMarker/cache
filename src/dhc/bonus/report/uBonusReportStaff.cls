/// 标题:财务绩效奖金统计表
/// 作者：侯勃
/// 日期：2013-12-10
Class dhc.bonus.report.uBonusReportStaff Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod StaffBonusExecute(ByRef qHandle As %Binary, sDate As %String, userCode As %String, flag As %String) As %Status
{
	
	n (qHandle,sDate,userCode,flag)
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
	
	i flag = "" d
	.s flag = "0"
  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
    
    s Code = $zcvt(userCode,"U")
    s mark = $e(Code)
    
	s strSql1=" select a.BonusYear,right(a.BonusPeriod,2) smonth, SupUnitName, "
		_" a.BonusUnitID->SuperiorUnitID->BonusUnitName supName,a.BonusUnitCode,a.BonusUnitName, "
		_" '03000' Code,'绩效奖金' Name,ROUND(a.ResultBonus,0,1) as Value1 "
		_" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BonusEmployeeUnit b,dhc_bonus_data.BonusIssuedMain c "
		_" where a.BonusUnitID->SuperiorUnitID = b.BonusUnitID and a.BonusUnitName is not null "
		_" and a.BonusYear = c.BonusYear and a.BonusPeriod = c.BonusPeriod "
		_" and a.SuperiorUnitID=c.BonusUnitID and a.SchemeItemID= c.SchemeItemID "
		_" and a.ResultBonus>0 and c.Remark = '1' "
		_" and a.BonusYear ='"_BonusYear_"' and a.BonusPeriod ='"_BonusPeriod_"' "
		_" and b.BonusEmployeeID->EmployeeCode = '"_userCode_"' "
    
    s strSQL1=" select BonusYear,right(BonusPeriod,2) smonth,a.BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName SupUnitName, "
        _" a.BonusUnitID->SuperiorUnitID->BonusUnitName supName,a.BonusUnitID->BonusUnitCode,a.BonusUnitID->BonusUnitName, "
        _" BonusTargetID->BonusTargetCode Code,BonusTargetID->BonusTargetName Name,TargetValue Value1 "
        _" from dhc_bonus_data.BonusTargetCollect a,dhc_bonus_data.BonusEmployeeUnit b "
        _" where a.BonusUnitID->SuperiorUnitID = b.BonusUnitID "
        _" and BonusTargetID->BonusTargetCode in ('03021','03031','03043','03081','03082','03083','03084') "
        _" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"' "
        _" and b.BonusEmployeeID->EmployeeCode = '"_userCode_"' "
        
    s strSql2=" select a.BonusYear,right(a.BonusPeriod,2) smonth, SupUnitName, "
        _" a.BonusUnitID->SuperiorUnitID->BonusUnitName supName,BonusUnitCode,BonusUnitName, " 
        _" '03000' Code,'绩效奖金' Name,ROUND(a.ResultBonus,0,1) as Value1 "
        _" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BonusIssuedMain b "	
        _" where BonusUnitName is not null and a.ResultBonus>0 "
        _" and a.BonusYear = b.BonusYear and a.BonusPeriod = b.BonusPeriod "
        _" and a.SuperiorUnitID=b.BonusUnitID and a.SchemeItemID= b.SchemeItemID "
        _" and b.Remark = '1' "
        _" and a.BonusYear ='"_BonusYear_"' and a.BonusPeriod ='"_BonusPeriod_"' "
        _" and BonusUnitCode = '"_userCode_"' "
    
    s strSQL2=" select BonusYear,right(BonusPeriod,2) smonth,BonusUnitID->SuperiorUnitID->SuperiorUnitID->BonusUnitName SupUnitName, "
        _" BonusUnitID->SuperiorUnitID->BonusUnitName supName,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName, "
        _" BonusTargetID->BonusTargetCode Code,BonusTargetID->BonusTargetName Name,TargetValue Value1 "
        _" from dhc_bonus_data.BonusTargetCollect "
        _" where BonusTargetID->BonusTargetCode in ('03021','03031','03043','03081','03082','03083','03084') "
        _" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"' "
        _" and BonusUnitID->BonusUnitCode = '"_userCode_"' "
	
	i flag = "1" d  //护士长/主任
	.s strSql = strSql1
	.i mark'="N" d
	..s strSql=strSql_" union all "_strSQL1
	e  d
	.s strSql = strSql2
	.i mark'="N" d
	..s strSql=strSql_" union all "_strSQL2
	
	s strSql=strSql_" order by SupUnitName,supName,Code ASC "
	
	;w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = result.Data("smonth")
      s suppName = result.Data("SupUnitName")
      s supName = result.Data("supName")
      s UnitCode = result.Data("BonusUnitCode")
      s UnitName = result.Data("BonusUnitName")
      s Code = result.Data("Code")
      s Name = result.Data("Name")
      s Value = result.Data("Value1")
      
      s YearMonth=sYear_"年"_$E(smonth,2,3)_"月"
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(sYear,smonth,suppName,supName,UnitCode,UnitName,Code,Name,Value,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod StaffBonusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaffBonusExecute ]
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

ClassMethod StaffBonusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaffBonusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:侯勃
/// CreatDate:2013-12-10
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusReportStaff","StaffBonus","2013-10","A0063","1")
Query StaffBonus(sDate As %String, userCode As %String, flag As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,suppname:%String,supname:%String,UnitCode:%String,UnitName:%String,Code:%String,Name:%String,Value:%Float,YearMonth:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusRepor7137S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
