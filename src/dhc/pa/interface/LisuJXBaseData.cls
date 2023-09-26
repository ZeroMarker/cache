Class dhc.pa.interface.LisuJXBaseData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// description:将医技预约等待时间的数据插入Jxbasedata中
///  w ##class(dhc.pa.interface.LisuJXBaseData).insertWaitTime("2014","M03")
ClassMethod insertWaitTime(year, month, KPIdr)
{
	n (year, month,KPIdr)
	s yearmonth=year_$E(month,2,3)
	&sql(delete from dhc_pa_data.JXBaseData where JXBaseData_period=:yearmonth and JXBaseData_KPIDr='37')
	s yearmonth=year_"-"_$E(month,2,3)
	s sqlString="INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue) "
	s sqlString=sqlString_"SELECT b.JXUnit_rowid,subString(a.ApplyTime,1,4)||subString(a.ApplyTime,6,2) AS yearmonth,'M' AS type,37 AS 预约kpi,a.waittime FROM "
	_" ("
	_"		SELECT 'H'||DeptID AS deptid,ApplyTime, DeptName,sum(DateWaitTime)/count(%id) AS waittime,sum(ReportTime)/count(%id) AS reporttime"
	_"		FROM dhc_pa_data.DHCCJXPALisPacsDataA"
	_"		WHERE DateWaitTime IS NOT NULL "
	_"		AND ApplyTime LIKE '"_yearmonth_"%'"
	_"		GROUP BY deptid"
	_" ) a,"
	_" ("
	_"		SELECT jx.JXUnit_rowid,jx.JXUnit_name,son.BonusUnitID,son.BonusUnitCode AS soncode,son.BonusUnitName AS sonname,son.SuperiorUnitID,father.BonusUnitCode AS code,father.BonusUnitName" 
	_"		FROM dhc_bonus_data.BonusUnit son,"
	_"		dhc_bonus_data.BonusUnit father,dhc_pa_data.JXUnit jx"
	_"		WHERE son.SuperiorUnitID=father.BonusUnitID AND father.BonusUnitCode=jx.JXUnit_code"
	_" ) b"
	_" WHERE a.deptid=b.soncode"
				
	
	;w !,sqlString,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlString)
	d result.Execute()
	d result.Close()
	q 0
}

/// description:将医技出报告时间的数据插入Jxbasedata中
///  w ##class(dhc.pa.interface.LisuJXBaseData).insertReportTime("2014","M03")
ClassMethod insertReportTime(year, month)
{
	
	s yearmonth=year_$E(month,2,3)
	&sql(delete from dhc_pa_data.JXBaseData where JXBaseData_period=:yearmonth and JXBaseData_KPIDr='39')
	s yearmonth=year_"-"_$E(month,2,3)
	s sqlString="INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue) "
	s sqlString=""
	s sqlString=sqlString_"SELECT b.JXUnit_rowid,subString(a.ApplyTime,1,4)||subString(a.ApplyTime,6,2) AS yearmonth,'M' AS type,39 AS kpidr,a.reporttime FROM "
	_" ("
	_"		SELECT 'H'||DeptID AS deptid,ApplyTime, DeptName,sum(DateWaitTime)/count(%id) AS waittime,sum(ReportTime)/count(%id) AS reporttime"
	_"		FROM dhc_pa_data.DHCCJXPALisPacsDataA"
	_"		WHERE DateWaitTime IS NOT NULL "
	_"		AND ApplyTime LIKE '"_yearmonth_"%'"
	_"		GROUP BY deptid"
	_" ) a,"
	_" ("
	_"		SELECT jx.JXUnit_rowid,jx.JXUnit_name,son.BonusUnitID,son.BonusUnitCode AS soncode,son.BonusUnitName AS sonname,son.SuperiorUnitID,father.BonusUnitCode AS code,father.BonusUnitName" 
	_"		FROM dhc_bonus_data.BonusUnit son,"
	_"		dhc_bonus_data.BonusUnit father,dhc_pa_data.JXUnit jx"
	_"		WHERE son.SuperiorUnitID=father.BonusUnitID AND father.BonusUnitCode=jx.JXUnit_code"
	_" ) b"
	_" WHERE a.deptid=b.soncode"
				
	
	w !,sqlString,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlString)
	d result.Execute()
	d result.Close()
	q 0
}

/// description:将医技工作量的数据插入Jxbasedata中
///  w ##class(dhc.pa.interface.LisuJXBaseData).insertWaitTime("2014","M03")
ClassMethod insertWorkLoad(year, month)
{
	
	s yearmonth=year_$E(month,2,3)
	&sql(delete from dhc_pa_data.JXBaseData where JXBaseData_period=:yearmonth and JXBaseData_KPIDr='38')
	s yearmonth=year_"-"_$E(month,2,3)
	s sqlString="INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue) "
	s sqlString=sqlString_"SELECT b.JXUnit_rowid,subString(a.ApplyTime,1,4)||subString(a.ApplyTime,6,2) AS yearmonth,'M' AS type,38 AS kpidr,a.workload FROM "
	_" ("
	_"		SELECT 'H'||DeptID AS deptid,ApplyTime, DeptName,count(%id) AS workload"
	_"		FROM dhc_pa_data.DHCCJXPALisPacsDataA"
	_"		WHERE DateWaitTime IS NOT NULL "
	_"		AND ApplyTime LIKE '"_yearmonth_"%'"
	_"		GROUP BY deptid"
	_" ) a,"
	_" ("
	_"		SELECT jx.JXUnit_rowid,jx.JXUnit_name,son.BonusUnitID,son.BonusUnitCode AS soncode,son.BonusUnitName AS sonname,son.SuperiorUnitID,father.BonusUnitCode AS code,father.BonusUnitName" 
	_"		FROM dhc_bonus_data.BonusUnit son,"
	_"		dhc_bonus_data.BonusUnit father,dhc_pa_data.JXUnit jx"
	_"		WHERE son.SuperiorUnitID=father.BonusUnitID AND father.BonusUnitCode=jx.JXUnit_code"
	_" ) b"
	_" WHERE a.deptid=b.soncode"
				
	
	;w !,sqlString,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlString)
	d result.Execute()
	d result.Close()
	q 0
}

/// description:将医技工作量详细到人的数据插入Medincome中
///  w ##class(dhc.pa.interface.LisuJXBaseData).insertWorkLoadDetailPerson("2014","M03")
ClassMethod insertWorkLoadDetailPerson(year, month)
{
	
	s yearmonth=year_$E(month,2,3)
	&sql(delete from dhc_pa_data.MedIncome where YearMonth=:yearmonth and KpiDr='38')
	s yearmonth=year_"-"_$E(month,2,3)
	s sqlString="INSERT INTO dhc_pa_data.MedIncome (YearMonth, DeptDr, MedName, Income, KpiDr) "
	s sqlString=""
	s sqlString=sqlString_"SELECT subString(a.ApplyTime,1,4)||subString(a.ApplyTime,6,2) AS yearmonth,b.JXUnit_rowid,a.Reportor,a.workload,38 AS kpidr FROM "
	_" ("
	_"		SELECT 'H'||DeptID AS deptid,Reportor, DeptName,count(%id) AS workload,ApplyTime"
	_"		FROM dhc_pa_data.DHCCJXPALisPacsDataA"
	_"		WHERE DateWaitTime IS NOT NULL "
	_"		AND ApplyTime LIKE '"_yearmonth_"%'"
	_"		GROUP BY deptid,Reportor"
	_" ) a,"
	_" ("
	_"		SELECT jx.JXUnit_rowid,jx.JXUnit_name,son.BonusUnitID,son.BonusUnitCode AS soncode,son.BonusUnitName AS sonname,son.SuperiorUnitID,father.BonusUnitCode AS code,father.BonusUnitName" 
	_"		FROM dhc_bonus_data.BonusUnit son,"
	_"		dhc_bonus_data.BonusUnit father,dhc_pa_data.JXUnit jx"
	_"		WHERE son.SuperiorUnitID=father.BonusUnitID AND father.BonusUnitCode=jx.JXUnit_code"
	_" ) b"
	_" WHERE a.deptid=b.soncode"
				
	
	w !,sqlString,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlString)
	d result.Execute()
	d result.Close()
	q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.inteD774.LisuJXBaseDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
