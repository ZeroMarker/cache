Class dhc.pa.uInter.uDirector Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  科室人均收支结余率 临床
///  方法描述：用sum（收支结余率求和*人数）/(sum(人数)，收支结余率来自于unitresultdetail表，
///  人数来自于jxbasedata
///  w ##class(dhc.pa.uInter.uDirector).incomeandpay("201401","201402","20141","H")
ClassMethod incomeandpay(startdate, enddate, yearmonth, type)
{
	    n (startdate, enddate,yearmonth, type)

		//109是临床科室的总称，72指标名称科室人均收支结余率
		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:yearmonth AND JXBaseData_periodType = :type AND JXBaseData_KPIDr=72
		and JXBaseData_parRef=109)
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT  109,:yearmonth,'H',72,
		sum(a.UnitResultDetail_actValue*b.JXBaseData_actualValue )/sum(b.JXBaseData_actualValue) value
		FROM 
		(

		SELECT urd.UnitResultDetail_rowid
		,s.Schem_rowid,s.Schem_name,j.JXUnit_rowid,j.JXUnit_name,ur.UnitResult_period,
		k.KPIIndex1_rowid,k.KPIIndex1_name,urd.UnitResultDetail_tValue,urd.UnitResultDetail_actValue,
		urd.UnitResultDetail_score,urd.UnitResultDetail_rate
		FROM dhc_pa_data.UnitResult ur, --
		dhc_pa_data.UnitResultDetail urd,
		dhc_pa_data.schem s,
		dhc_pa_data.jxunit j,
		dhc_pa_data.kpiindex1 k
		WHERE urd.UnitResultDetail_parRef=ur.UnitResult_rowid
		AND ur.UnitResult_schemDr=s.Schem_rowid
		AND ur.UnitResult_jxUnitDr=j.JXUnit_rowid
		AND urd.UnitResultDetail_KPIDr=k.KPIIndex1_rowid
		AND urd.UnitResultDetail_isTarget=2
		AND ur.UnitResult_schemDr IN ("1||1")
		AND urd.UnitResultDetail_KPIDr=2
		AND ur.UnitResult_period BETWEEN :startdate AND :enddate

		) a LEFT JOIN 
		(

		SELECT JXBaseData_parRef, JXBaseData_rowid, JXBaseData_childSub, JXBaseData_period, JXBaseData_periodType, JXBaseData_KPIDr, JXBaseData_actualValue, JXBaseData_auditDate, JXBaseData_auditUserDr, JXBaseData_dataState, JXBaseData_desc
		FROM dhc_pa_data.UnitSchem us,
		dhc_pa_data.JXBaseData j
		WHERE j.JXBaseData_parRef=us.UnitSchem_parRef
		AND us.UnitSchem_schemDr IN ("1||1")
		AND j.JXBaseData_KPIDr=56
		AND j.JXBaseData_period BETWEEN :startdate AND :enddate

		) b ON a.JXUnit_rowid=b.JXBaseData_parRef 
		AND a.UnitResult_period=b.JXBaseData_period
		GROUP BY a.Schem_rowid)


	q SQLCODE
}

///  科室人均收支结余率 临床
///  w ##class(dhc.pa.uInter.uDirector).incomeandpay("201401","201402","20141","H")
ClassMethod incomeandpayf(startdate, enddate, yearmonth, type)
{
	    n (startdate, enddate,yearmonth, type)

		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:yearmonth AND JXBaseData_periodType = :type AND JXBaseData_KPIDr=72
		and JXBaseData_parRef=110)
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT  110,:yearmonth,'H',72,
		sum(a.UnitResultDetail_actValue*b.JXBaseData_actualValue )/sum(b.JXBaseData_actualValue) value
		FROM 
		(

		SELECT urd.UnitResultDetail_rowid
		,s.Schem_rowid,s.Schem_name,j.JXUnit_rowid,j.JXUnit_name,ur.UnitResult_period,
		k.KPIIndex1_rowid,k.KPIIndex1_name,urd.UnitResultDetail_tValue,urd.UnitResultDetail_actValue,
		urd.UnitResultDetail_score,urd.UnitResultDetail_rate
		FROM dhc_pa_data.UnitResult ur, --
		dhc_pa_data.UnitResultDetail urd,
		dhc_pa_data.schem s,
		dhc_pa_data.jxunit j,
		dhc_pa_data.kpiindex1 k
		WHERE urd.UnitResultDetail_parRef=ur.UnitResult_rowid
		AND ur.UnitResult_schemDr=s.Schem_rowid
		AND ur.UnitResult_jxUnitDr=j.JXUnit_rowid
		AND urd.UnitResultDetail_KPIDr=k.KPIIndex1_rowid
		AND urd.UnitResultDetail_isTarget=2
		AND ur.UnitResult_schemDr IN ("1||4","1||10")
		AND urd.UnitResultDetail_KPIDr=2
		AND ur.UnitResult_period BETWEEN  :startdate AND :enddate

		) a LEFT JOIN 
		(

		SELECT JXBaseData_parRef, JXBaseData_rowid, JXBaseData_childSub, JXBaseData_period, JXBaseData_periodType, JXBaseData_KPIDr, JXBaseData_actualValue, JXBaseData_auditDate, JXBaseData_auditUserDr, JXBaseData_dataState, JXBaseData_desc
		FROM dhc_pa_data.UnitSchem us,
		dhc_pa_data.JXBaseData j
		WHERE j.JXBaseData_parRef=us.UnitSchem_parRef
		AND us.UnitSchem_schemDr in ("1||4","1||10")
		AND j.JXBaseData_KPIDr=56
		AND j.JXBaseData_period BETWEEN  :startdate AND :enddate

		) b ON a.JXUnit_rowid=b.JXBaseData_parRef 
		AND a.UnitResult_period=b.JXBaseData_period
		)


	q SQLCODE
}

///  全年门诊人次
///  w ##class(dhc.pa.uInter.uDirector).clinicPatients("1","201401","201406","20141","H","1","22","1||1")
ClassMethod clinicPatients(deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
{
	    n (deptdr, startdate, enddate,period, type, kpidr, sourcekpidr, scheme)
		i deptdr="" s deptdr=109
		i kpidr="" s kpidr=73
		i sourcekpidr="" s sourcekpidr=3
		i scheme="" s scheme="1||1"
			
		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:period AND JXBaseData_periodType = :type AND JXBaseData_KPIDr=73)	
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT :deptdr,:period,:type,:kpidr,sum(JXBaseData_actualValue) FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_KPIDr=:sourcekpidr
		AND JXBaseData_period between :startdate AND :enddate
		AND JXBaseData_parRef IN (SELECT UnitSchem_parRef
		FROM dhc_pa_data.UnitSchem
		WHERE UnitSchem_schemDr IN (:scheme)
		))


	q SQLCODE
}

//deptdr 数据存放的科室，type，数据是按照月份，还是年份统计，kpidr，指标id，scheme，方案id

///  全年出院人次
///  w ##class(dhc.pa.uInter.uDirector).discharged("1","201401","201406","20141","H","1","22","1||1")
ClassMethod discharged(deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
{
	    n (deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
	    
	    i deptdr="" s deptdr=109
		i kpidr="" s kpidr=74
		i sourcekpidr="" s sourcekpidr=20
		i scheme="" s scheme="1||1"
	    /*
	    s beginyearmonth=year_"01"
		s yearmonthtype="%"_year_"-"_$E(month,2,3)_"%"
		s yearmonth=year_$E(month,2,3)
		s startyearmonth=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
		s month=$E(yearmonth,5,6)+1
		i month <=9 s month="0"_month
		i month=13 s yearmonth=($E(yearmonth,1,4)+1)_"01",month="01"
		s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
		s endyearmonth=$zdateh(endyearmonth,3)-1
		s endyearmonth=$zdate(endyearmonth,3)
		w beginyearmonth_"<-"_yearmonth,!		
		*/	
		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:period AND JXBaseData_periodType = :type AND JXBaseData_KPIDr=74)	
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT :deptdr,:period,:type,:kpidr,sum(JXBaseData_actualValue) FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_KPIDr=:sourcekpidr
		AND JXBaseData_period between :startdate AND :enddate
		AND JXBaseData_parRef IN (SELECT UnitSchem_parRef
		FROM dhc_pa_data.UnitSchem
		WHERE UnitSchem_schemDr IN (:scheme)
		))


	q SQLCODE
}

//工作量

///  w ##class(dhc.pa.uInter.uDirector).workload("1","201401","201406","20141","H","1","22","1||1")
ClassMethod workload(deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
{
	    n (deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
	    i deptdr="" s deptdr=110
		i kpidr="" s kpidr=75
		i sourcekpidr="" s sourcekpidr=38
		//i scheme="" s scheme="1||4","1||10"
	    /*
	    i scheme="" s scheme="1||1"
	    i kpidr="" s kpidr=19
	    s beginyearmonth=year_"01"
		s yearmonthtype="%"_year_"-"_$E(month,2,3)_"%"
		s yearmonth=year_$E(month,2,3)
		s startyearmonth=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
		s month=$E(yearmonth,5,6)+1
		i month <=9 s month="0"_month
		i month=13 s yearmonth=($E(yearmonth,1,4)+1)_"01",month="01"
		s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
		s endyearmonth=$zdateh(endyearmonth,3)-1
		s endyearmonth=$zdate(endyearmonth,3)
		w beginyearmonth_"<-"_yearmonth,!		
		*/	
		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:period AND JXBaseData_periodType = :type AND JXBaseData_KPIDr=75)	
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT :deptdr,:period,:type,:kpidr,sum(JXBaseData_actualValue) FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_KPIDr=:sourcekpidr
		AND JXBaseData_period between :startdate AND :enddate
		AND JXBaseData_parRef IN (SELECT UnitSchem_parRef
		FROM dhc_pa_data.UnitSchem
		WHERE UnitSchem_schemDr IN ("1||4","1||10")
		))


	q SQLCODE
}

/// 总平均住院日
///  w ##class(dhc.pa.uInter.uDirector).workload("1","201401","201406","20141","H","1","22","1||1")
ClassMethod liveInHospital(deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
{
	    n (deptdr, startdate, enddate, period, type, kpidr, sourcekpidr, scheme)
	    i deptdr="" s deptdr=110
		i kpidr="" s kpidr=78
		i sourcekpidr="" s sourcekpidr=38
		i scheme="" s scheme="1||1"
	
		//删除操作
		&sql(DELETE 
		FROM dhc_pa_data.JXBaseData
		WHERE JXBaseData_period =:period AND JXBaseData_periodType ='H' AND JXBaseData_KPIDr=78)	
		//插入操作
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		
		SELECT  109,:period,'H',78,
		sum(a.JXBaseData_actualValue )/sum(b.JXBaseData_actualValue) value
		FROM 
		(

   		SELECT JXBaseData_parRef, JXBaseData_rowid, JXBaseData_childSub, JXBaseData_period, JXBaseData_periodType, JXBaseData_KPIDr, JXBaseData_actualValue, JXBaseData_auditDate, JXBaseData_auditUserDr, JXBaseData_dataState, JXBaseData_desc
		FROM dhc_pa_data.UnitSchem us,
		dhc_pa_data.JXBaseData j
		WHERE j.JXBaseData_parRef=us.UnitSchem_parRef
		AND us.UnitSchem_schemDr in ("1||1")
		AND j.JXBaseData_KPIDr=19
		AND j.JXBaseData_period between :startdate AND :enddate

		) a LEFT JOIN 
		(

		SELECT JXBaseData_parRef, JXBaseData_rowid, JXBaseData_childSub, JXBaseData_period, JXBaseData_periodType, JXBaseData_KPIDr, JXBaseData_actualValue, JXBaseData_auditDate, JXBaseData_auditUserDr, JXBaseData_dataState, JXBaseData_desc
		FROM dhc_pa_data.UnitSchem us,
		dhc_pa_data.JXBaseData j
		WHERE j.JXBaseData_parRef=us.UnitSchem_parRef
		AND us.UnitSchem_schemDr in ("1||1")
		AND j.JXBaseData_KPIDr=20
		AND j.JXBaseData_period between :startdate AND :enddate

		) b ON a.JXBaseData_parRef=b.JXBaseData_parRef 
		AND a.JXBaseData_period=b.JXBaseData_period)


	q SQLCODE
}

///  w ##class(dhc.pa.uInter.uDirector).test()
ClassMethod test()
{
	w "hello",!
	q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.uDirectorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
