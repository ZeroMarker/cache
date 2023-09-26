/// Creator: 杨旭
/// CreatDate: 2010-07-21
/// Description: 科室考核排名分析
Class dhc.pa.udata.uKPIReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 根据方案名找指标
/// Table: dhc.ca.cache.data.KPIIndex1
/// Input: d
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPIReport).FindKPIBySchem(1,0,25,2,"Y")
ClassMethod FindKPIBySchem(schemDr, start, limit, target, isEnd)
{
	n (schemDr, start, limit, target, isEnd)
	
	s sqlStr="SELECT * FROM dhc_pa_data.SchemDetail as s,dhc_pa_data.KPIIndex1 as k"
	
	s whereStr=" WHERE %ID>0 and s.SchemDetail_parRef='"_schemDr_"'"
	i target'="" s whereStr=whereStr_" AND s.SchemDetail_isTarget='"_target_"'"
	i isEnd'="" s whereStr=whereStr_" and k.KPIIndex1_isEnd='"_isEnd_"'"
	
	s sortStr=" ORDER BY s.%ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^shortcut^py"
	
	While(result.Next())
	{
		s rowid=result.Data("KPIIndex1_rowid")
		s code=result.Data("KPIIndex1_code")
		s name=result.Data("KPIIndex1_name")
		s shortcut=result.Data("KPIIndex1_shortcut")
		s py=result.Data("KPIIndex1_py")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_py
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 科室考核排名分析
/// Table: dhc.ca.cache.data.KPIIndex1
/// Input: d
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPIReport).createReport("1||3","1",3,5,0,25)
ClassMethod createReport(schemDr, cycleDr, period, kpiDr, start, limit)
{
	n (schemDr, cycleDr, period , kpiDr, start, limit)
	
	s sqlStr="SELECT * FROM dhc_pa_data.UnitSchem "
	
	s whereStr=" WHERE %ID>0 and UnitSchem_schemDr='"_schemDr_"'"
	
	s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s end=start+limit-1

	s resultString=""
	s cycle=..GetCycle(cycleDr, period)
	
	While(result.Next())
	{
		s unitDr=result.Data("UnitSchem_parRef")
		s flag="N"
		s appSysDr=0
		s aDeptName=""
		i unitDr'="" d
		.s flag=$P($g(^DHCCJXPAJXUNIT(unitDr)),"^",8)
		.s appSysDr=$P($g(^DHCCJXPAJXUNIT(unitDr)),"^",1)
		.i appSysDr=2 d
		..s unitResultDr= ..getUnitResult(schemDr, cycle, unitDr)
		..i unitResultDr'="" d
		...i resultString="" s resultString=..getUnitResultDetail(unitResultDr,kpiDr, start, limit)
		...e  s resultString=resultString_"!"_..getUnitResultDetail(unitResultDr,kpiDr, start, limit)
	}

	d result.Close()
	
	//对resultString进行处理
	s end=start+limit-1
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^KPIDr^KPIName^flag^flagName^estDesc^estUserDr^estUserName^score^estDate^estAUserDr^estAUserName^estADate^unitDr^unitName^tValue^actValue"
	s Len=$L(resultString,"!")
	s count=0
	f i=1:1:Len d
	.s tmp=$P(resultString,"!",i)
	.i (count>=start)&(count<=end) d
	..d json.InsertRowData(tmp)
	.s count=count+1
	
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 科室考核排名分析
/// Table: dhc.ca.cache.data.KPIIndex1
/// Input: d
/// Output: 
/// Return: 返回UnitResultDr^appSysDr
/// Others: w ##class(dhc.pa.udata.uKPIReport).getUnitResult("1||2",1,1)
ClassMethod getUnitResult(schemDr, cycle, unitDr)
{
	n (schemDr, cycle , unitDr)
	
	s sqlStr="SELECT * FROM dhc_pa_data.UnitResult "
	
	if schemDr'="" s whereStr=" WHERE %ID>0 and UnitResult_schemDr='"_schemDr_"'"
	if cycle'="" s whereStr=whereStr_" and UnitResult_period='"_cycle_"'"
	if unitDr'="" s whereStr=whereStr_" and UnitResult_jxUnitDr='"_unitDr_"'"
	s whereStr=whereStr_" and UnitResult_appSysDr=2"
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=""
	While(result.Next())
	{
		s rowid=result.Data("UnitResult_rowid")
		if rowid'="" s resultString=rowid
	}
	d result.Close()
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 科室考核排名分析
/// Table: dhc.ca.cache.data.KPIIndex1
/// Input: d
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPIReport).getUnitResultDetail("1||15",3,0,25)
ClassMethod getUnitResultDetail(unitResultDr, kpiDr, start, limit) As %String
{
	n (unitResultDr,kpiDr,start,limit)
	
	s sqlStr="SELECT * FROM dhc_pa_data.UnitResultDetail "
	
	s whereStr=" WHERE %ID>0 and UnitResultDetail_isTarget=2 and UnitResultDetail_parRef='"_unitResultDr_"'"
	s whereStr=whereStr_"and  UnitResultDetail_KPIDr='"_kpiDr_"'"
	
	s sortStr=" group by UnitResultDetail_KPIDr ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s tmpUnitResult=^DHCCJXPASTRATAGEM($p($g(unitResultDr),"||",1),"UnitResult",$p($g(unitResultDr),"||",2))
	s unitDr=$p(tmpUnitResult,"^",3)
	s unitName=""
	i unitDr'="" d
	.s unitName=$p(^DHCCJXPAJXUNIT(unitDr),"^",3)

	s tmp=""
	While(result.Next())
	{
		s flagName=""
		s rowid=result.Data("UnitResultDetail_rowid")
		s KPIDr=result.Data("UnitResultDetail_KPIDr")
		s KPIName=""
		i KPIDr'="" s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
		
		s flag=result.Data("UnitResultDetail_flag")
		i flag=0 s flagName="一般"
		i flag=1 s flagName="重点"
		s estDesc=result.Data("UnitResultDetail_estDesc")
		s estUserDr=result.Data("UnitResultDetail_estUserDr")
		s estUserName=""
		i estUserDr'="" s estUserName= $p($G(^SSU("SSUSR",estUserDr)),"^",2)
		s score=$fn(result.Data("UnitResultDetail_score"),"",2)
		s estDate=result.Data("UnitResultDetail_estDate")
		i estDate'="" s estDate=$zd(estDate,3) 
		
		s estAUserDr=result.Data("UnitResultDetail_estAUserDr")
		s estAUserName=""
		i estAUserDr'="" s estAUserName= $p($G(^SSU("SSUSR",estAUserDr)),"^",2)
		s estADate=result.Data("UnitResultDetail_estADate")
		i estADate'="" s estADate=$zd(estADate,3) 
		
		s tValue=$fn(result.Data("UnitResultDetail_tValue"),"",2) //目标值
		
		s actValue=$fn(result.Data("UnitResultDetail_actValue"),"",2) //实际值
		
		s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^"_flag_"^"_flagName_"^"_estDesc_"^"_estUserDr_"^"_estUserName_"^"_score_"^"_estDate_"^"_estAUserDr_"^"_estAUserName_"^"_estADate_"^"_unitDr_"^"_unitName_"^"_tValue_"^"_actValue
	}

	q tmp
}

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.udata.uKPIReport).GetCycle(1,1)
ClassMethod GetCycle(cycleDr, period) As %String
{
	n (cycleDr,period)

	q:cycleDr="" "UnCycle" //不计算
	q:period="" "UnPeriod" //不计算
	s newPeriod=""
	
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
		q:cycleCode="" "UnCycleCode" //不计算

	i period<10 d
	.s period="0"_period
	s newPeriod=cycleCode_period

	q newPeriod
}

/// Creator：李明忠
/// CreatDate：2010-11-22
/// Description: 点评
/// Table：dhc_pa_data.UnitResultDetail
/// Input：dataInfo-被点评的数据信息
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uKPIReport).Update("17^1||3^5^1^3^测试点评^demo^")
ClassMethod Update(dataInfo) As %String
{
	n (dataInfo)
	
	q:dataInfo="" "NoData"
	s dataLength=$L(dataInfo,"!")
	
	TSTART
	s rs=0
	s flag="true"
	
	f k=1:1:dataLength d
	.s data=$P(dataInfo,"!",k)
	.i data'="" d
	..s jxUnitDr=$P(data,"^",1)
	..s schemDr=$P(data,"^",2)
	..s kpiDr=$P(data,"^",3)
	..s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	..s stratagemDr=$P(schemDr,"||",1)
	..q:stratagemDr=""
	..s period=$P(data,"^",5)
	..s estDesc=$P(data,"^",6)
	..s userCode=$P(data,"^",7)
	..s Flag=$P(data,"^",8)
	..s cycleDr=$P(data,"^",4)
	..s newPeriod=..GetCycle(cycleDr,period)
	..s urRowid=..GetURRowid(stratagemDr,newPeriod,jxUnitDr,appSysDr,schemDr)
	..i urRowid'="" d
	...s flag=..SetThink(urRowid,kpiDr,estDesc,userCode,Flag)
	...;w urRowid_"^"_kpiDr_"^"_estDesc_"^"_userCode_"^"_Flag,!
	...;w jxUnitDr_"^"_flag,!
	...i flag="false" s rs=1
	
	i rs'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	
	q rs
}

/// Creator：李明忠
/// CreatDate：2010-11-22
/// Description: 设置比例系数
/// Table：dhc_pa_data.UnitResultDetail
/// Input：period-考核周期,num-比例系数,deptDr-绩效单元Dr,schemDr-当前方案,kpiDr-指标,stratagemDr-当前战略,appSysDr-应用系统号
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uKPIReport).SetRate(1,1,"1||6",21)
ClassMethod GetURRowid(stratagemDr, newPeriod, jxUnitDr, appSysDr, schemDr) As %String
{
	n (stratagemDr,newPeriod,jxUnitDr,appSysDr,schemDr)
	
	s urRowid=""
	
	s sqlStr="select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	s whereStr=" and UnitResult_parRef='"_stratagemDr_"'"
	i newPeriod'="" s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	i schemDr'="" s whereStr=whereStr_" and UnitResult_schemDr='"_schemDr_"'"
	i appSysDr'="" s whereStr=whereStr_" and UnitResult_appSysDr='"_appSysDr_"'"
	i jxUnitDr'="" s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	
	s sqlStr=sqlStr_whereStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	While(result.Next())
	{
		s urRowid=result.Data("UnitResult_rowid")
	}

	d result.Close()
	
	q urRowid
}

/// Creator：李明忠
/// CreatDate：2010-11-22
/// Description: 设置点评数据
/// Table：dhc_pa_data.UnitResultDetail
/// Input：urRowid-单位考核ID,kpiDr-KPI指标Dr,estDesc-点评内容,userCode-系统用户代码,Flag-关注度
/// Output：
/// Return：返回rs
/// Others：w ##class(dhc.pa.udata.uKPIReport).SetThink("1||108",20,"","zhuangyan","www")
ClassMethod SetThink(urRowid, kpiDr, estDesc, userCode, Flag) As %String
{
	n (urRowid,kpiDr,estDesc,userCode,Flag)
	
	s userDr=""
	s flag="true"
	
	i userCode'="" d 
	.s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),userDr))
	
	s date=$P($h,",",1)
	
	;w urRowid_"^"_kpiDr_"^"_estDesc_"^"_userDr,!
	
	&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_flag=:Flag,UnitResultDetail_estDesc=:estDesc,UnitResultDetail_estUserDr=:userDr,UnitResultDetail_estDate=:date where UnitResultDetail_childSub>0 and UnitResultDetail_parRef=:urRowid and UnitResultDetail_KPIDr=:kpiDr and UnitResultDetail_isTarget=2)
	;w SQLCODE,!
	i SQLCODE'=0 d
	.s flag="false"
	
	q flag
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPIReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
