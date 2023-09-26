Class dhc.pa.udata.uDeptKPIReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uDeptKPIReport).List(0,25,"")
ClassMethod List(start, limit, unitDr) As %String
{
	n (start, limit,  unitDr)
	
	s sqlStr="select *,DKR_DeptDr->JXUnit_name as unitName,DKR_KPIDr->KPIIndex1_name as KPIName from dhc_pa_data.DeptKPIReport "
	s whereStr=" where %ID >0 "
	i unitDr'="" s whereStr=whereStr_" and DKR_DeptDr ='"_unitDr_"' "
	s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^unitDr^unitName^KPIDr^KPIName^flag"
	
	While(result.Next()){
		
		s rowid=result.Data("DeptKPIReport_rowid")
		s unitDr=result.Data("DKR_DeptDr")
		s unitName=result.Data("unitName")
		s KPIDr=result.Data("DKR_KPIDr")
		s KPIName=result.Data("KPIName")
		s flag=result.Data("DKR_Active")
		
		s tmp=rowid_"^"_unitDr_"^"_unitName_"^"_KPIDr_"^"_KPIName_"^"_flag
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.report.uYantaiReport).isInUse(81,89)
ClassMethod isInUse(unit, kpi) As %String
{
	n (unit,kpi)
	
	s score=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DKR_Active from dhc_pa_data.DeptKPIReport where %ID>0"
	s whereStr=" and DKR_DeptDr ='"_unit_"' and DKR_KPIDr ='"_kpi_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s score = result.Data("DKR_Active")
	}
	
	q score
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).Aduit("2")
ClassMethod Change(unit, kpi) As %String
{
	n (unit,kpi)
	i ..isInUse(unit,kpi)="Y" d
	.&SQL(UPDATE dhc_pa_data.DeptKPIReport set DKR_Active="N"  where DKR_DeptDr=:unit and DKR_KPIDr=:kpi)
	e  d
	.&SQL(UPDATE dhc_pa_data.DeptKPIReport set DKR_Active="Y"  where DKR_DeptDr=:unit and DKR_KPIDr=:kpi)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDeptKPIReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
