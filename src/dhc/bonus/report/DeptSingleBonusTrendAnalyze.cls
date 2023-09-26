Class dhc.bonus.report.DeptSingleBonusTrendAnalyze Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.bonus.report.DeptSingleBonusTrendAnalyze","GetBonusTrend","1")

Query GetBonusTrend(deptdr As %String) As %Query(ROWSPEC = "rowid:%String,deptname:%String,username:%String,IsDirectorlist:%String") [ SqlProc ]
{
}

ClassMethod GetBonusTrendExecute(ByRef qHandle As %Binary, deptdr As %String) As %Status
{
	
	n (qHandle,deptdr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

    s sqlStr="select SRMDU_Rowid,SRMDU_DeptDR->SRMD_Name as DeptName,SRMDU_UserDR->SRMU_Name as UserName,SRMDU_IsDirector" 
	_" from herp_srm_data.SRMDeptUser "
	
    i deptdr'=""   s sqlStr=sqlStr_" where   SRMDU_DeptDR = '"_deptdr_"'"
	   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
        s rowid = result.Data("SRMDU_Rowid")
		s deptname=result.Data("DeptName")
		s username=result.Data("UserName")
		s IsDirectorlist=result.Data("SRMDU_IsDirector")
		i IsDirectorlist'="" d
		.i IsDirectorlist="Y" s IsDirectorlist="是"
		.i IsDirectorlist="N" s IsDirectorlist="否"	
	 d OutputRow28	  
	}
 
  	q $$$OK
OutputRow28
    s Data=$lb(rowid,deptname,username,IsDirectorlist)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetBonusTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusTrendExecute ]
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

ClassMethod GetBonusTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusTrendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.DeptSingleB4303S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
