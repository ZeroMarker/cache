/// Creator: wang ying
/// CreatDate: 2010-11-9
/// Description: 个人基本数据维护
Class dhc.pa.udata.uPJXBaseData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-09
/// Description: 查询符合条件的记录
/// Table: dhc.pa.udata.PJXBaseData
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uPJXBaseData).ListRec("","outKpiCode",01,"","",0,25,"1","1","M")
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency)
		
		s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
		;w newPeriod,!
		s sqlStr="SELECT PJXBaseData_rowid,PJXBaseData_ssUserDr,PJXBaseData_period,PJXBaseData_periodType,PJXBaseData_KPIDr,PJXBaseData_actualValue,PJXBaseData_auditDate,PJXBaseData_auditUserDr FROM dhc_pa_inter.PJXBaseData WHERE %ID>0 and PJXBaseData_period="_newPeriod_" and PJXBaseData_periodType="_"'"_frequency_"'"
		
		
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="PJXBaseData_rowid"
		.i sortField="ssUserDr" s sortField1="PJXBaseData_ssUserDr"
		.i sortField="period" s sortField1="PJXBaseData_period"
		.i sortField="periodType" s sortField1="PJXBaseData_periodType"
		.i sortField="KPIDr" s sortField1="PJXBaseData_KPIDr"
		.i sortField="actualValue" s sortField1="PJXBaseData_actualValue"
		.i sortField="auditDate" s sortField1="PJXBaseData_auditDate"
		.i sortField="auditUserDr" s sortField1="PJXBaseData_auditUserDr"
		
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr=" ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		;w sqlStr,!
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^userName^period^periodType^KPIDr^KPICode^KPIName^actualValue^auditDate^auditUserName"
		s KPIName = "",userName="",auditUserName="",KPICode="",auditDate=""
		While(result.Next())
		{
			s rowid=result.Data("PJXBaseData_rowid")
			s ssUserDr=result.Data("PJXBaseData_ssUserDr")
			i ssUserDr'=""  d
			.i $d(^SSU("SSUSR",ssUserDr)) d
			..s userName = $p($g(^SSU("SSUSR",ssUserDr)),"^",2)
			s period=result.Data("PJXBaseData_period")
			s ptype=result.Data("PJXBaseData_periodType")
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s KPIDr=result.Data("PJXBaseData_KPIDr")
			i KPIDr'="" d
			.i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
			..s KPICode = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",1)
			..s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s actualValue=result.Data("PJXBaseData_actualValue")
			s date=result.Data("PJXBaseData_auditDate")
			;w "date="_date,!
			i date'="" s auditDate = $zd(date,3)
			s auditUserDr=result.Data("PJXBaseData_auditUserDr")
			i auditUserDr'=""  d
			.i $d(^SSU("SSUSR",auditUserDr)) d
			..s auditUserName = $p($g(^SSU("SSUSR",auditUserDr)),"^",2)
			
			s tmp=rowid_"^"_userName_"^"_period_"^"_periodType_"^"_KPIDr_"^"_KPICode_"^"_KPIName_"^"_actualValue_"^"_auditDate_"^"_auditUserName
			s count=count+1
			i searchValue'="" d
			.q:(searchField="userName")&(userName'[searchValue)
			.q:(searchField="period")&(period'[searchValue)
			.q:(searchField="periodType")&(periodType'[searchValue)
			.q:(searchField="KPIName")&(KPIName'[searchValue)
			.q:(searchField="actualValue")&(actualValue'[searchValue)
			.q:(searchField="auditDate")&(auditDate'[searchValue)
			.q:(searchField="auditUserName")&(auditUserName'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-11-8
/// Description: 删除期间类型对应的期间的数据
/// Table：dhc.pa.inter.OutKPIData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uOutKPIData).Delete(4)
ClassMethod Delete(CycleDr, period, frequency) As %String
{
	n (CycleDr, period, frequency)
	
	s newPeriod = ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(CycleDr,period)
	
	&SQL(DELETE FROM dhc_pa_inter.PJXBaseData WHERE PJXBaseData_period=:newPeriod and PJXBaseData_periodType=:frequency)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uPJXBaseDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
