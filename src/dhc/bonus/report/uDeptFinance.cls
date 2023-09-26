/// 标题:财务绩效奖金统计表
/// 作者：Zhao LiGuo
/// 日期：2013-01-22
/// 需求：华西医院
Class dhc.bonus.report.uDeptFinance Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod DeptFinanceExecute(ByRef qHandle As %Binary, sDate As %String, flag As %String) As %Status
{
	
	n (qHandle,sDate,flag)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	/*s strSql=strSql_" select BonusYear,right(BonusPeriod,2) smonth, SuperiorUnitID->SuperiorUnitID->BonusUnitName supname,"
		_" SuperiorUnitID->BonusUnitCode,supUnitName UnitName,sum(ROUND(ResultBonus,0,1)) as zje"
		_" from dhc_bonus_data.BonusIssuedDetail where %id>0  and ResultBonus>0 and supUnitName is not null  "
		_" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"'"
		_" group by BonusYear,BonusPeriod,SuperiorUnitID->SuperiorUnitID->BonusUnitName,supUnitName, SuperiorUnitID"
		_"  order by SuperiorUnitID->SuperiorUnitID->BonusUnitCode,SuperiorUnitID->BonusUnitCode"
    */
    
    s strSql=strSql_" select BonusYear,right(BonusPeriod,2) smonth, SuperiorUnitID->SuperiorUnitID->BonusUnitName supname,"
		_" BonusUnitID->SumUnitID->BonusUnitCode,BonusUnitID->SumUnitID->BonusUnitName UnitName,sum(ROUND(ResultBonus,0,1)) as zje"
		_" from dhc_bonus_data.BonusIssuedDetail where %id>0  and ResultBonus>0 and supUnitName is not null  "
		_" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"'"
	
	s strSql=strSql_" group by BonusYear,BonusPeriod,SuperiorUnitID->SuperiorUnitID,BonusUnitID->SumUnitID "
	          _" order by SuperiorUnitID->SuperiorUnitID,BonusUnitID->SumUnitID "
	
	w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = result.Data("smonth")
      s UnitName = result.Data("UnitName")
      s UnitCode = result.Data("BonusUnitCode")
      
      s supname =  result.Data("supname")
      s zje = result.Data("zje")
      s YearMonth=BonusYear_"年"_$E(smonth,2,3)_"月"
	  ;w supname_":"_zje,!
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(sYear,smonth,supname,UnitCode,UnitName,zje,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptFinanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptFinanceExecute ]
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

ClassMethod DeptFinanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptFinanceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptFinance","DeptFinance","2013-01")
Query DeptFinance(sDate As %String, flag As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,supname:%String,UnitCode:%String,UnitName:%String,zje:%Float,YearMonth:%String") [ SqlProc ]
{
}

/// 主报表
ClassMethod EmpFinanceExecute(ByRef qHandle As %Binary, sDate As %String, flag As %String) As %Status
{
	
	n (qHandle,sDate,flag)
	

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	/*
	s strSql=" select BonusYear,right(BonusPeriod,2) smonth, supUnitName,BonusUnitCode, BonusUnitName ,a.BonusUnitID->BonusUnitTypeID->UnitTypeName"
		_" ,IssuedBonus,AdjustBonus,ResultBonus,BankNo"
		 _" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BankAccount b"
 		 _" where  a.BonusUnitID =*b.BonusUnitID  and BonusUnitName is not null and ResultBonus>0"
 		 _" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"'"
 		 _"  order by SuperiorUnitID->SuperiorUnitID->BonusUnitCode,SuperiorUnitID->BonusUnitCode"
    */
 	;BonusIssuedMainID->DataStatus=2 AND
 	
 	s strSql=" select BonusYear,right(BonusPeriod,2) smonth, supUnitName,BonusUnitCode, BonusUnitName ,c.FlexStrField4 UnitTypeName"
		_" ,ROUND(IssuedBonus,0,1) as IssuedBonus,AdjustBonus,ROUND(ResultBonus,0,1) as ResultBonus,BankNo"
		_",SchemeItemID->SchemeItemCode,SchemeItemID->SchemeItemName "
		 _" from dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BankAccount b,HISHR.PersonInfo c"
 		 _" where  a.BonusUnitCode =b.EmpCode  and BonusUnitName is not null and ResultBonus>0"
 		 _" and b.EmpCode=c.empCardID  and b.IsValid = '1'"
 		 _" and BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"'"
 	i flag'="" d
 	
	.s strSql=strSql_" and SuperiorUnitID->BonusUnitID = '"_flag_"'"
	
	s strSql=strSql_" order by SuperiorUnitID->SuperiorUnitID->BonusUnitCode,SuperiorUnitID->BonusUnitCode "
	
	k ^zmbSql
    s ^zmbSql=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = result.Data("smonth")
      
      s UnitTypeName = result.Data("UnitTypeName")
 
      i UnitTypeName="MEDICALCARE" d 
      .s UnitTypeName="临床医生" 
      e  d
      .i UnitTypeName="NURSE" d 
      ..s UnitTypeName="临床护士"       
      .e  d
      ..s UnitTypeName="其他人员"  
      
      s UnitName = result.Data("BonusUnitName")
      
      s UnitCode = result.Data("BonusUnitCode")
      s supname =  result.Data("SupUnitName")
      s BankNo =  result.Data("BankNo")
      
      s ItemName=  result.Data("SchemeItemName")
      s ItemCode=  result.Data("SchemeItemCode")
      i ItemCode="0101095" d
      .s ItemName="劳务津贴"
      
      s IssuedBonus=$fn(result.Data("IssuedBonus"),"",0)
      
      s AdjustBonus = $fn(result.Data("AdjustBonus"),"",0)
      s ResultBonus = $fn(result.Data("ResultBonus"),"",0)
     
      s YearMonth=BonusYear_"年"_$E(smonth,2,3)_"月"

	 d OutputRow2

	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(sYear,smonth,UnitTypeName,supname,UnitCode,UnitName,IssuedBonus,AdjustBonus,ResultBonus,YearMonth,BankNo,ItemName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod EmpFinanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmpFinanceExecute ]
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

ClassMethod EmpFinanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmpFinanceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptFinance","EmpFinance","2015-08","")
Query EmpFinance(sDate As %String, flag As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,UnitTypeName:%String,supname:%String,UnitCode:%String,UnitName:%String,IssuedBonus:%Float,AdjustBonus:%Float,ResultBonus:%Float,YearMonth:%String,BankNo:%String,ItemName:%String") [ SqlProc ]
{
}

//----------------------------------

/// 主报表
ClassMethod empWorkDayExecute(ByRef qHandle As %Binary, sDate As %String, UnitID As %String, sUserCode As %String) As %Status
{
	
	n (qHandle,sDate,UnitID,sUserCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK

  	s ^zlg12=sDate_"^"_UnitID_"^"_sUserCode
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
    s strSql=""
    
	
	s strSql="select b.Code1,b.Name, BonusYear,BonusPeriod,a.EmpCardID,EmpName,WorkDays,SharyRate,d.FlexStrField4"
	_" from dhc_bonus_extend_yjs.EmpWorkDay a,dhc_sync_data.sync_loc b,dhc_bonus_data.BonusEmployeeUnit c,HISHR.PersonInfo d"
	_" WHERE a.DeptCode =b.Code0 and a.DeptCode=c.BonusUnitID->BonusUnitCode AND a.EmpCardID =d.empCardID"
	_" AND upper(c.BonusEmployeeID->EmployeeCode)=upper('"_sUserCode_"')"
	_" and a.BonusYear ='"_BonusYear_"' and a.BonusPeriod ='"_BonusPeriod_"'"
	i UnitID'=""  s strSql =strSql_" AND c.BonusUnitID= "_UnitID
	
	s strSql =strSql_"  UNION"
	_" select b.Code1,b.Name, BonusYear,BonusPeriod,a.EmpCardID,EmpName,WorkDays,SharyRate,d.FlexStrField4"
	_" from dhc_bonus_extend_yjs.EmpWorkDay a,dhc_sync_data.sync_loc b,dhc_bonus_data.BonusEmployeeUnit c,HISHR.PersonInfo d"
	_" WHERE a.DeptCode =b.Code0 and a.DeptCode=c.BonusUnitID->SuperiorUnitID->BonusUnitCode"
	_" AND a.EmpCardID =d.empCardID AND upper(c.BonusEmployeeID->EmployeeCode)=upper('"_sUserCode_"')"
	_" and a.BonusYear ='"_BonusYear_"' and a.BonusPeriod ='"_BonusPeriod_"'"
	i UnitID'=""  s strSql =strSql_" AND c.BonusUnitID ="_UnitID
	k ^zlg15
	s ^zlg15= strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = result.Data("BonusPeriod")
      s UnitName = result.Data("Name")
      s UnitCode = result.Data("Code1")
      s EmpCardID = result.Data("EmpCardID")
      s EmpName = result.Data("EmpName")
      s WorkDays = result.Data("WorkDays")
      s SharyRate = result.Data("SharyRate")
      s empType =  result.Data("FlexStrField4")
     	; MEDICALCARE	医疗
		; NURSE	护理
	  i empType="MEDICALCARE" d
	  .s empTypeName="临床医生" 
	  e  d
	  .i empType="NURSE" d
	  ..s empTypeName="临床护士" 
	  .e  d
	  ..s empTypeName="其他人员" 
	  
	  s YearMonth=BonusYear_"年"_$E(smonth,2,3)_"月"
	 
	 d OutputRow21
	  
	} 
   	  
  	q $$$OK
OutputRow21
  	s Data=$lb(sYear,smonth,UnitCode,UnitName,EmpCardID,EmpName,WorkDays,SharyRate,empTypeName,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod empWorkDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = empWorkDayExecute ]
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

ClassMethod empWorkDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = empWorkDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//                                                                              sYear,smonth,UnitCode,UnitName,EmpCardID,EmpName,WorkDays,SharyRate,empTypeName,YearMonth

/// Creator:Zhao Liguo
/// CreatDate:2015-12-2 sYear,smonth,UnitCode,UnitName,EmpCardID,EmpName,zje,WorkDays,SharyRate,empType,YearMonth
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others: sYear,smonth,UnitCode,UnitName,EmpCardID,EmpName,WorkDays,SharyRate,empTypeName,YearMonth
///        d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptFinance","EmpFinance","2015-08","")
Query empWorkDay(sDate As %String, UnitID As %String, sUserCode As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,UnitCode:%String,UnitName:%String,EmpCardID:%String,EmpName:%String,WorkDays:%Float,SharyRate:%Float,empTypeName:%String,YearMonth:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.report.uDeptFinanceS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
