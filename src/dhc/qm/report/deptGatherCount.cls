Class dhc.qm.report.deptGatherCount Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.qm.report.deptGatherCount","GetInfo","2015","Q","2","")

Query GetInfo(year As %String, type As %String, period As %String, dept As %String) As %Query(ROWSPEC = "deptdr:%String,dept:%String,period:%String,mysum:%Float,checkdr:%String,check:%String,checkCode:%String") [ SqlProc ]
{
}

ClassMethod GetInfoExecute(ByRef qHandle As %Binary, year As %String, type As %String, period As %String, dept As %String) As %Status
{
	
	n (qHandle,year,type,period,dept)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    i period>10   d
    .s period=year_period
	e  d
	.s period=year_0_period
	/*
	s sqlStr=" SELECT m.LocResultMain_departDr,LocResultMain_departDr,m.LocResultMain_departDr->DEP_Desc,m.LocResultMain_period,m.LocResultMain_schemDr,m.LocResultMain_schemDr->QMSchem_name,m.LocResultMain_schemDr->QMSchem_Code,sum(LocResultMain_failNum) AS failNumSum"
	_" FROM dhc_qm_data.LocResultMain m "
	_" WHERE  m.LocResultMain_period = '"_period_"'"
	i dept'=""  s sqlStr = sqlStr_" and LocResultMain_departDr = '"_dept_"' "
	 s sqlStr=sqlStr_" AND m.LocResultMain_schemDr->QMSchem_periodType = '"_type_"' "
	 s sqlStr=sqlStr_" and (m.LocResultMain_auditState=1 or LocResultdetail_saveStatus=1)"  //加入审核状态 2016-07-19 cyl
	_" GROUP BY m.LocResultMain_departDr,m.LocResultMain_period, m.LocResultMain_schemDr "
*/
	s sqlStr=" SELECT LocResultdetail_parRef->LocResultMain_departDr,LocResultdetail_parRef->LocResultMain_departDr->DEP_Desc,LocResultdetail_parRef->LocResultMain_period,LocResultdetail_parRef->LocResultMain_schemDr,LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_name,LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_Code,sum(LocResultdetail_parRef->LocResultMain_failNum) AS failNumSum"
		_" FROM dhc_qm_data.LocResultdetail "
		_" WHERE  LocResultdetail_parRef->LocResultMain_period = '"_period_"'"
	i dept'=""  s sqlStr = sqlStr_" and LocResultdetail_parRef->LocResultMain_departDr = '"_dept_"' "
	 s sqlStr=sqlStr_" AND LocResultdetail_parRef->LocResultMain_schemDr->QMSchem_periodType = '"_type_"' "
	 s sqlStr=sqlStr_" and (LocResultdetail_parRef->LocResultMain_auditState=1 or LocResultdetail_saveStatus=1) " //加入审核状态 2016-7-19 cyl  pad端保存状态为1 201682
	_" GROUP BY LocResultdetail_parRef->LocResultMain_departDr,LocResultdetail_parRef->LocResultMain_period, LocResultdetail_parRef->LocResultMain_schemDr "

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	
	d result.Execute()	
    While(result.Next()){
	    s deptdr=result.Data("LocResultMain_departDr")
	    ;s dept = result.Data("LocResultMain_departDr")
        s dept = result.Data("DEP_Desc")
		s period=result.Data("LocResultMain_period")
		s sum=$fn(result.Data("failNumSum"),"",2) //2016-6-27 cyl 保留两位小数
		s checkdr=result.Data("LocResultMain_schemDr")
		s check=result.Data("QMSchem_name")
		s checkCode=result.Data("QMSchem_Code")
		
		
	 d a    ;OutputRow28	  
	}
 
  	q $$$OK
a
    s Data=$lb(deptdr,dept,period,sum,checkdr,check,checkCode)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfoExecute ]
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

ClassMethod GetInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.qm.report.deptGatherCountS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
