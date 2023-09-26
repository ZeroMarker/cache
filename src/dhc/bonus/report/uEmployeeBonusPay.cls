Class dhc.bonus.report.uEmployeeBonusPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetEmployeeBonusPayExecute(ByRef qHandle As %Binary, userCode As %String, stdate As %String, endate As %String) As %Status
{
	
	n (qHandle,userCode,stdate,endate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	;w userCode,!
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:userCode="" $$$OK
   
    //s sqlStr="select b.BonusUnitName,c.EmployeeName,e.BonusValue from dhc_bonus_data.BonusEmployeeUnit a ,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployee c ,dhc_bonus_data.BonusEmployee qx,dhc_bonus_data.EmployeeBonusPay e where e.BonusEmployeeID = c.BonusEmployeeID and b.BonusUnitID = c.BonusUnitID and a.BonusUnitID = c.BonusUnitID and a.BonusUnitID = qx.BonusUnitID and qx.EmployeeCode = '"_userCode_"' and case when left(e.BonusPeriod,1)='M' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*1),2) when left(e.BonusPeriod,1)='Q' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*3),2) when left(e.BonusPeriod,1)='H' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*6),2) when left(e.BonusPeriod,1)='Y' then e.BonusYear _'-12' end >= '"_stdate_"' and case when left(e.BonusPeriod,1)='M' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*1),2) when left(e.BonusPeriod,1)='Q' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*3),2) when left(e.BonusPeriod,1)='H' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*6),2) when left(e.BonusPeriod,1)='Y' then e.BonusYear _'-12' end <= '"_endate_"'"
    s sqlStr="select b.BonusUnitName,e.BonusUnitID->BonusUnitName as empname,BonusValue"
	_" from dhc_bonus_data.EmployeeBonusPay e,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployeeUnit c"
	_" where e.BonusUnitID->SuperiorUnitID = b.BonusUnitID and e.BonusUnitID = c.BonusUnitID"
	_" and c.BonusEmployeeID->EmployeeCode = '"_userCode_"' and case when left(e.BonusPeriod,1)='M' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*1),2)"
	_" when left(e.BonusPeriod,1)='Q' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*3),2)"
	_" when left(e.BonusPeriod,1)='H' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*6),2)"
	_" when left(e.BonusPeriod,1)='Y' then e.BonusYear _'-12' end >= '"_stdate_"'"
	_" and case when left(e.BonusPeriod,1)='M' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*1),2)"
	_" when left(e.BonusPeriod,1)='Q' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*3),2)"
	_" when left(e.BonusPeriod,1)='H' then e.BonusYear _'-' _ right('0'_ (right(e.BonusPeriod,2)*6),2)"
	_" when left(e.BonusPeriod,1)='Y' then e.BonusYear _'-12' end <= '"_endate_"'"

	//w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      ;s YearMonthName="",kddept="",predept="",ChargeDictName=""
      s BonusUnitName=result.Data("BonusUnitName")
      s EmployeeName=result.Data("empname")
      s BonusValue=result.Data("BonusValue")
      
	  
	 d OutputRow28
	  
	}
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(BonusUnitName,EmployeeName,BonusValue)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetEmployeeBonusPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEmployeeBonusPayExecute ]
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

ClassMethod GetEmployeeBonusPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEmployeeBonusPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:王宏宇
/// CreatDate:2011-2-11
/// Description:查询报表数据记录
/// Table:dhc.chwk.data.STChargeIncome
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPay","GetEmployeeBonusPay","fhq","2011-01","2011-03")
Query GetEmployeeBonusPay(userCode As %String, stdate As %String, endate As %String) As %Query(ROWSPEC = "BonusUnitName:%String,EmployeeName:%String,BonusValue:%Float") [ SqlProc ]
{
}

/// -------获取人员奖金银行发放------------------
ClassMethod GetBonusBankPayExecute(ByRef qHandle As %Binary, sDate As %String, sUnitDr As %String) As %Status
{
	
	n (qHandle,sDate,sUnitDr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s ^zlg111=sDate_","_sUnitDr
 	q:sDate="" $$$OK
    s syear=$p(sDate,"-",1)
    s smonth="M" _ $p(sDate,"-",2)
    
    s sqlStr="SELECT a.SupUnitName,a.BonusUnitCode,a.BonusUnitName,b.CardNo ,b.BankNo ,sum(isnull(a.ResultBonus,0)+isnull(a.AdjustBonus2,0)) ResultBonus "
	_" FROM dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BankAccount b,dhc_bonus_data.BonusIssuedMain c"
	_" WHERE a.BonusUnitID =b.BonusUnitID AND a.ResultBonus<>0"
	_" AND a.BonusYear=c.BonusYear AND a.BonusPeriod=c.BonusPeriod  AND a.SchemeItemID=c.SchemeItemID AND a.SuperiorUnitID =c.BonusUnitID"
	_" AND c.DataStatus=3 AND a.BonusYear='"_syear_"' AND a.BonusPeriod='"_smonth_"' "
	
	i sUnitDr'="" d
	.s sqlStr=sqlStr_" AND a.SuperiorUnitID='"_sUnitDr_"'"
    s sqlStr=sqlStr _ " group by a.SupUnitName,a.BonusUnitCode,a.BonusUnitName,b.CardNo ,b.BankNo"
	//w sqlStr,!
	s ^zlg222=sqlStr
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){

      s SupUnitName=result.Data("SupUnitName")
      s EmpCode=result.Data("BonusUnitCode")
      s EmpName=result.Data("BonusUnitName")
      s CardNo=result.Data("CardNo")
      s BankNo=result.Data("BankNo")
      s ResultBonus=result.Data("ResultBonus")
       
	  
	 d OutputRow2
	  
	}
   	  
  	q $$$OK
OutputRow2
	
  
  	s Data=$lb(SupUnitName,EmpCode,EmpName,CardNo,BankNo,ResultBonus,sDate)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusBankPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusBankPayExecute ]
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

ClassMethod GetBonusBankPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusBankPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:王宏宇
/// CreatDate:2011-2-11
/// Description:查询报表数据记录
/// Table:dhc.chwk.data.STChargeIncome
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPay","GetBonusBankPay","2016-05","") 
Query GetBonusBankPay(sDate As %String, sUnitDr As %String) As %Query(ROWSPEC = "SupUnitName:%String,EmpCode:%String,EmpName:%String,CardNo:%String,BankNo:%String,ResultBonus:%Float,sdate:%String") [ SqlProc ]
{
}

/// -------获取人员奖金科室发放汇总------------------
ClassMethod GetDeptEmpPayExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String, sUnitDr As %String, empCode As %String) As %Status
{
	
	n (qHandle,sDate,eDate,sUnitDr,empCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s ^zlg111=sDate_","_sUnitDr
 	q:sDate="" $$$OK
 	
    s sDate=$p(sDate,"-",1) _ $p(sDate,"-",2)
    s eDate=$p(eDate,"-",1) _ $p(eDate,"-",2)
   	 s sqlStr="SELECT  a.BonusYear _ RIGHT(a.BonusPeriod,2) as yearmonth,a.SupUnitName,a.BonusUnitCode,a.BonusUnitName,b.CardNo ,b.BankNo ,sum(isnull(a.ResultBonus,0)+isnull(a.AdjustBonus2,0)) ResultBonus "
	_" FROM dhc_bonus_data.BonusIssuedDetail a,dhc_bonus_data.BankAccount b,dhc_bonus_data.BonusIssuedMain c"
	_" WHERE a.BonusUnitID =b.BonusUnitID AND a.ResultBonus<>0"
	_" AND a.BonusYear=c.BonusYear AND a.BonusPeriod=c.BonusPeriod  AND a.SchemeItemID=c.SchemeItemID AND a.SuperiorUnitID =c.BonusUnitID"
	_" AND c.DataStatus=3  "
 	_" AND a.BonusYear _  RIGHT(a.BonusPeriod,2)>="_sDate_"  AND a.BonusYear _  RIGHT(a.BonusPeriod,2)<="_eDate

	i sUnitDr'="" d
	.s sqlStr=sqlStr_" AND a.SuperiorUnitID='"_sUnitDr_"'"
	i empCode '="" d 
	.s sqlStr=sqlStr_" AND (a.BonusUnitCode LIKE '%"_empCode_"%' OR a.BonusUnitName LIKE '%"_empCode_"%')"
    s sqlStr=sqlStr _ " group by a.SupUnitName,a.BonusUnitCode,a.BonusUnitName,b.CardNo ,b.BankNo,a.BonusYear _ RIGHT(a.BonusPeriod,2)"
	//w sqlStr,!
	s ^zlg222=sqlStr
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){

      s SupUnitName=result.Data("SupUnitName")
      s EmpCode=result.Data("BonusUnitCode")
      s EmpName=result.Data("BonusUnitName")
      s CardNo=result.Data("CardNo")
      s BankNo=result.Data("BankNo")
      s ResultBonus=result.Data("ResultBonus")
      s yearmonth =result.Data("yearmonth")
	  
	 d OutputRow3
	  
	}
   	  
  	q $$$OK
OutputRow3
	
  
  	s Data=$lb(SupUnitName,EmpCode,EmpName,CardNo,BankNo,ResultBonus,yearmonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetDeptEmpPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptEmpPayExecute ]
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

ClassMethod GetDeptEmpPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptEmpPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:王宏宇
/// CreatDate:2011-2-11
/// Description:查询报表数据记录
/// Table:dhc.chwk.data.STChargeIncome
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmployeeBonusPay","GetDeptEmpPay","2016-02","2016-05","","") 
Query GetDeptEmpPay(sDate As %String, eDate As %String, sUnitDr As %String, empCode As %String) As %Query(ROWSPEC = "SupUnitName:%String,EmpCode:%String,EmpName:%String,CardNo:%String,BankNo:%String,ResultBonus:%Float,sdate:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uEmployeeBon6E6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
