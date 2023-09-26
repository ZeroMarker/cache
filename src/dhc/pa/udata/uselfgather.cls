/// 绩效考核---自查汇总统计
/// Creator: 何佳兵
/// CreatDate: 2015-05-19
/// Description: 
Class dhc.pa.udata.uselfgather Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Description: 获取科室类别
/// Table：  dhc.pa.data.JXGroup
/// Others： w ##class(dhc.pa.udata.uselfgather).GetDept("0","10")
ClassMethod GetDept(start, limit) As %String
{
	n (start, limit)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXGroup_IDSet,JXGroup_name from dhc_pa_data.JXGroup "
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXGroup_IDSet")
		s name = result.Data("JXGroup_name")
		s tmp=rowid_"^"_name
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator:何佳兵
/// CreatDate:2015-05-21
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.pa.udata.uselfgather","GetReportSlefGather","Q","1","2","4-5-6-7-8-9-10-11") 
Query GetReportSlefGather(year As %String, period As %String, starttime As %String, endtime As %String, zxc As %String) As %Query(ROWSPEC = "rowid:%Integer,zccode:%String,zcname:%String,deptname:%String,period:%String,auditDr:%String,auditDate:%String,auditState:%String,submitUser:%String,submitDate:%String,submitState:%String,updateDr:%String,updateDate:%String,updateState:%String,totalScore:%String") [ SqlProc ]
{
}

/// Description: 查询
/// Table：  dhc.pa.data.UnitDeptResult
/// others:others:d ##class(%ResultSet).RunQuery("dhc.pa.udata.uselfgather","GetReportSlefGather","2015","Q","1","3","4-5-6-7-8-9-10-11") 
ClassMethod GetReportSlefGatherExecute(ByRef qHandle As %Binary, year As %String, period As %String, starttime As %String, endtime As %String, zxc As %String) As %Status
{
	
	n (qHandle,year,period,starttime,endtime,zxc)	
	s ^hjb=year_","_period_","_starttime_","_endtime_","_zxc
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	s dept =$tr(zxc,"-",",")
 	s tmp= "("_dept_")"
 	s year=year
 	//s year=$e($ZDATE($H),7,10)
 	
	s sqlStr="SELECT a.UDR_rowid,a.UDR_DschemDr->DSC_code as ZCcode,a.UDR_DschemDr->DSC_name as ZCname,a.UDR_jxUnitDr->JXUnit_name,a.UDR_period,a.UDR_auditDr,a.UDR_auditDate,a.UDR_auditState,a.UDR_submiDr,a.UDR_submiDate,a.UDR_submitState,"
	_"a.UDR_updateDr,a.UDR_updateDate,a.UDR_updateState,a.UDR_totalScore FROM dhc_pa_data.UnitDeptResult a,dhc_pa_data.DeptSchem b where  a.UDR_DschemDr=b.DSC_rowid"
	
	i zxc'="" s sqlStr=sqlStr_" and a.UDR_jxUnitDr in "_tmp_""
	i period'="" s sqlStr=sqlStr_" and b.DSC_frequency='"_period_"'"
	i starttime'=""  d
	.i starttime<10 s starttime=0_starttime
	.s starttime=year_starttime
	.s sqlStr=sqlStr_"and UDR_period>='"_starttime_"'"
	i endtime'="" d 
	.i endtime<10 s endtime=0_endtime
	.s endtime=year_endtime
	.s sqlStr=sqlStr_"and UDR_period<='"_endtime_"'"
	//s ^hjb=starttime_","_endtime
	//w starttime_","_endtime
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	//s ^hjb=sqlStr
	
	While(result.Next())
		{   
			s rowid= result.Data("UDR_rowid")
			s zccode= result.Data("ZCcode")
			s zcname= result.Data("ZCname")
			s deptname= result.Data("JXUnit_name")
			s period= result.Data("UDR_period")
			s auditDr= result.Data("UDR_auditDr")
			s auditDate= result.Data("UDR_auditDate") 
			//s auditDate=$ZDATETIME(auditDate) 
			s auditState= result.Data("UDR_auditState") 
			i auditState=1 s auditState="已评审"
			i auditState=0 s auditState="未评审"	
			
			s submitUser= result.Data("UDR_submiDr")
			s submitDate= result.Data("UDR_submiDate")
			s submitState= result.Data("UDR_submitState")
			i submitState=1 s submitState="已提交"
			i submitState=0 s submitState="未提交"
			s updateDr= result.Data("UDR_updateDr")
			s updateDate= result.Data("UDR_updateDate")
			s updateState= result.Data("UDR_updateState")
			s totalScore= result.Data("UDR_totalScore")
	
			d OutputRow1
			
		}
			
		q $$$OK
OutputRow1
  	s Data=$lb(rowid,zccode,zcname,deptname,period,auditDr,auditDate,auditState,submitUser,submitDate,submitState,updateDr,updateDate,updateState,totalScore)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportSlefGatherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportSlefGatherExecute ]
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

ClassMethod GetReportSlefGatherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportSlefGatherExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 链接页面query
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.udata.uselfgather","GetResultDetail","1")
Query GetResultDetail(UDRrowid As %String) As %Query(ROWSPEC = "rowid:%String,kpiname:%String,score:%String,estDesc:%String,load:%String") [ SqlProc ]
{
}

ClassMethod GetResultDetailExecute(ByRef qHandle As %Binary, UDRrowid As %String) As %Status
{
	n (qHandle,UDRrowid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s sqlStr = "SELECT UDRD_rowid,UDRD_DKPIDr->DKX_name AS KPI_NAME ,UDRD_score, UDRD_estDesc, UDRD_load FROM dhc_pa_data.UnitDeptResultDetail "
    i sqlStr '="" s sqlStr = sqlStr_" where UDRD_UDResult = '"_UDRrowid_"'"
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    ;w sqlStr
    d result.Execute()
    While(result.Next()){ 
	    s rowid = result.Data("UDRD_rowid")
	    s kpiname = result.Data("KPI_NAME")
	    s score = result.Data("UDRD_score")
	    s estDesc = result.Data("UDRD_estDesc")
	    s load = result.Data("UDRD_load")
	    d OutputRow21
    }
		q $$$OK
OutputRow21
		s Data = $lb(rowid,kpiname,score,estDesc,load)
 	 	s ^CacheTemp(repid,ind)=Data	
		s ind = ind + 1
		q
}

ClassMethod GetResultDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultDetailExecute ]
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

ClassMethod GetResultDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询科室类型
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.udata.uselfgather","GetDept")
Query GetDept() As %Query(ROWSPEC = "JXGroupIDSet:%String,JXGroupname:%String") [ SqlProc ]
{
}

ClassMethod GetDeptExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s sqlStr = "select 	JXGroup_IDSet,JXGroup_name from dhc_pa_data.JXGroup "
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    ;w sqlStr
    d result.Execute()
    While(result.Next()){ 
	    s JXGroupIDSet = result.Data("JXGroup_IDSet")
	    s JXGroupname = result.Data("JXGroup_name")
	    d OutputRow
    }
		q $$$OK
OutputRow
		s Data = $lb(JXGroupIDSet,JXGroupname)
 	 	s ^CacheTemp(repid,ind)=Data	
		s ind = ind + 1
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

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.pa.udata.uselfgatherS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
