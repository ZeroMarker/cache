Class dhc.pa.udata.uSurveyScoreTotal Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate: 2011-04-28
/// Description: 查询调查总分记录
/// Table: dhc.pa.data.SurveyScoreTotal
/// Input: acceptUnitType-接受评分单元类别;acceptUnitDr-接受评分单元Dr;period-考核期间;periodType-期间类型;schemDr-绩效方案Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyScoreTotal).List("","","","","","","","","",0,25)
ClassMethod List(acceptUnitType, period, periodType, schemDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (acceptUnitType,period,periodType,schemDr,searchField,searchValue,sortField,sortDir,start,limit)
		
	s sqlStr="select SurveyScoreTotal_Rowid,SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_KpiDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_handFlag,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr from dhc_pa_data.SurveyScoreTotal"
	
	s Active="Y"
	s whereStr=" where %ID>0 and SurveyScoreTotal_Active='"_Active_"'"
	;i acceptUnitDr'="" s whereStr=whereStr_" and SurveyScoreTotal_AcceptUnitDr='"_acceptUnitDr_"'"
	i acceptUnitType'="" s whereStr=whereStr_" and SurveyScoreTotal_unitType='"_acceptUnitType_"'"
	i period'="" s whereStr=whereStr_" and SurveyScoreTotal_period='"_period_"'"
	i periodType'="" s whereStr=whereStr_" and SurveyScoreTotal_periodType='"_periodType_"'"
	i schemDr'="" s whereStr=whereStr_" and SurveyScoreTotal_SchemDr='"_schemDr_"'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="SurveyScoreTotal_Rowid"
	.i sortField="unitName" s sortField1="SurveyScoreTotal_AcceptUnitDr"
	.i sortField="unitTypeName" s sortField1="SurveyScoreTotal_unitType"
	.i sortField="kpiName" s sortField1="SurveyScoreTotal_KpiDr"
	.i sortField="TotalScore" s sortField1="SurveyScoreTotal_TotalScore"
	.i sortField="active" s sortField1="SurveyScoreTotal_Active"
	.i sortField="handFlag" s sortField1="SurveyScoreTotal_handFlag"
	.i sortField="period" s sortField1="SurveyScoreTotal_period"
	.i sortField="periodTypeName" s sortField1="SurveyScoreTotal_periodType"
	.i sortField="schemName" s sortField1="SurveyScoreTotal_SchemDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY InterKPI_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
	s count=0
	s resultString=""
	s end=start+limit
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^acceptUnitDr^unitName^unitType^unitTypeName^kpiDr^kpiName^totalScore^active^handFlag^period^periodType^periodTypeName^schemDr^schemName"
		
	While(result.Next())
	{
		s unitTypeName="",unitName="",kpiName="",periodTypeName="",schemName=""
		
		s rowid=result.Data("SurveyScoreTotal_Rowid")
		s acceptUnitDr=result.Data("SurveyScoreTotal_AcceptUnitDr")
		s unitType=result.Data("SurveyScoreTotal_unitType")
		i unitType="L" d
		.s unitTypeName="科室"
		.i acceptUnitDr'="" d
		..i $D(^DHCCJXPAJXUNIT(acceptUnitDr)) d
		...i $G(^DHCCJXPAJXUNIT(acceptUnitDr))'="" d
		....s unitName=$P(^DHCCJXPAJXUNIT(acceptUnitDr),"^",3)
		i unitType="P" s unitTypeName="个人"
		.i acceptUnitDr'="" d
		..i $D(^SSU("SSUSR",acceptUnitDr)) d
		...i $G(^SSU("SSUSR",acceptUnitDr))'="" d 
		....s unitName=$P(^SSU("SSUSR",acceptUnitDr),"^",2)
		s kpiDr=result.Data("SurveyScoreTotal_KpiDr")
		i kpiDr'="" d
		.i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
		..i $G(^DHCCJXPAKPIINDEX1(kpiDr))'="" d
		...s kpiName=$P(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
		s totalScore=$fn(result.Data("SurveyScoreTotal_TotalScore"),"",2)
		s active=result.Data("SurveyScoreTotal_Active")
		s handFlag=result.Data("SurveyScoreTotal_handFlag")
		s period=result.Data("SurveyScoreTotal_period")
		s periodType=result.Data("SurveyScoreTotal_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		s schemDr=result.Data("SurveyScoreTotal_SchemDr")
		i schemDr'="" d
		.s schemName=..GetSchemName(schemDr)
		s tmp=rowid_"^"_acceptUnitDr_"^"_unitName_"^"_unitType_"^"_unitTypeName_"^"_kpiDr_"^"_kpiName_"^"_totalScore_"^"_active_"^"_handFlag_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_schemDr_"^"_schemName
		s count=count+1
		i searchValue'="" d
		.q:(searchField="unitName")&(unitName'[searchValue)
		.q:(searchField="unitTypeName")&(unitTypeName'[searchValue)
		.q:(searchField="kpiName")&(kpiName'[searchValue)
		.q:(searchField="period")&(period'[searchValue)
		.q:(searchField="periodTypeName")&(periodTypeName'[searchValue)
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.e  d
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-04-29
/// Description: 获取方案名称
/// Table：dhc_pa_data.Schem
/// Input：schemDr-方案Dr
/// Output：
/// Return：有效方案名称字符串
/// Others：w ##class(dhc.pa.udata.uSurveyScoreTotal).GetSchemName("1||1")
ClassMethod GetSchemName(schemDr) As %String
{
	n (schemDr)
	
	s schemName=""
	q:schemDr="" schemName
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Schem_name from dhc_pa_data.Schem where Schem_rowid='"_schemDr_"'"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s schemName = result.Data("Schem_name")
	}
	d result.Close()
	
	q schemName
}

/// Creator：李明忠
/// CreatDate：2011-04-29
/// Description: 导入调查问卷明细表数据,并进行汇总
/// Table：dhc_pa_data.SurveyScore
/// Input：period-考核期间;periodType-期间类型
/// Output：
/// Return：成功标示
/// Others：w ##class(dhc.pa.udata.uSurveyScoreTotal).Import("201101","M")
ClassMethod Import(period, periodType) As %String
{
	n (period,periodType)
	
	k ^TMPDHCCJXPASCORE("dhc","pa","score")
	
	s flag="true"
	q:period="" flag
	q:periodType="" flag
	
	TSTART
	s rs=0
	
	i $D(^DHCCJXPASURVEYSCORE(0,"PPTU")) d
	.i $D(^DHCCJXPASURVEYSCORE(0,"PPTU",period,periodType)) d
	..s acceptUnitDr=0
	..f  s acceptUnitDr=$O(^DHCCJXPASURVEYSCORE(0,"PPTU",period,periodType,acceptUnitDr)) q:acceptUnitDr=""  d 
	...s acceptUnitType=""
	...f  s acceptUnitType=$O(^DHCCJXPASURVEYSCORE(0,"PPTU",period,periodType,acceptUnitDr,acceptUnitType)) q:acceptUnitType=""  d 
	....s rowid=0,count=0
	....f  s rowid=$O(^DHCCJXPASURVEYSCORE(0,"PPTU",period,periodType,acceptUnitDr,acceptUnitType,rowid)) q:rowid=""  d
	.....s curr=$G(^DHCCJXPASURVEYSCORE(rowid))
	.....i curr'="" d
	......s count=count+1
	......s kpiDr=$P(curr,"",6)
	......s schemDr=$P(curr,"",11)
	......s scoreLevelDr=$P(curr,"",7)
	......s score=0
	......i scoreLevelDr'="" d
	.......i $D(^DHCCJXPASCORELEVEL(scoreLevelDr)) d
	........s score=$P(^DHCCJXPASCORELEVEL(scoreLevelDr),"^",1)
	......e  d
	.......s score=$P(curr,"",8)
	......i $D(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)) d
	.......s ^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)=^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)+score
	......e  d
	.......s ^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)=score
	....s ^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)=$fn((^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)/count),"",2)
	
	//插入数据
	i $D(^TMPDHCCJXPASCORE("dhc","pa","score",$j)) d
	.s period="",active="Y",handFlag="N"
	.f  s period=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period)) q:period=""  d
	..s periodType="" 
	..f  s periodType=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType)) q:periodType=""  d
	...s schemDr=""
	...f  s schemDr=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr)) q:schemDr=""  d
	....s acceptUnitDr=0
	....f  s acceptUnitDr=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr)) q:acceptUnitDr=""  d
	.....s acceptUnitType="" 
	.....f  s acceptUnitType=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType)) q:acceptUnitType=""  d
	......s kpiDr=0
	......f  s kpiDr=$O(^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)) q:kpiDr=""  d
	.......s score=^TMPDHCCJXPASCORE("dhc","pa","score",$j,period,periodType,schemDr,acceptUnitDr,acceptUnitType,kpiDr)
	.......&SQL(insert into dhc_pa_data.SurveyScoreTotal(SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_KpiDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_handFlag,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr) values(:acceptUnitDr,:acceptUnitType,:kpiDr,:score,:active,:handFlag,:period,:periodType,:schemDr))
	.......i SQLCODE'=0 s rs=1
	
	k ^TMPDHCCJXPASCORE("dhc","pa","score",$j)
	
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	
	q flag
}

/// Creator：李明忠
/// CreatDate：2011-05-03
/// Description: 计算调查问卷的指标值
/// Table：dhc_pa_data.SurveyScoreTotal
/// Input：period-考核期间;periodType-期间类型
/// Output：
/// Return：成功标示
/// Others：w ##class(dhc.pa.udata.uSurveyScoreTotal).Calculation("201101","M")
ClassMethod Calculation(period, periodType) As %String
{
	n (period,periodType)
	
	k ^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j)
	
	s KPIDr="?" //问卷调查指标ID
	i $D(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc")) d
	.i $D(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType)) d
	..s unitType=""
	..f  s unitType=$O(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType,unitType)) q:unitType=""  d
	...i unitType="L" d //先计算科室
	....s unitDr=0
	....f  s unitDr=$O(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType,unitType,unitDr)) q:unitDr=""  d
	.....s rowid=0
	.....f  s rowid=$O(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType,unitType,unitDr,rowid)) q:rowid=""  d
	......s curr=$G(^DHCCJXPASURVEYSCORETOTAL(rowid))
	......i curr'="" d
	.......s active=$P(curr,"^",5)
	.......i active="Y" d 
	........s kpiDr=$P(curr,"^",3)
	........s schemDr=$P(curr,"^",9)
	........s totalScore=$P(curr,"^",4)
	........;从方案明细表中获取指标权重
	........s rate=..getRate(schemDr,kpiDr)
	........s kpiValue=totalScore*rate
	........i $D(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)) d
	.........s ^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)=^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)+kpiValue
	........e  d
	.........s ^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)=kpiValue
	
	//取数插入表结构
	s dataState=-1
	i $D(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j)) d
	.s period=""
	.f  s period=$O(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period)) q:period=""  d
	..s periodType=""
	..f  s periodType=$O(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType)) q:periodType=""  d
	...s unitDr=0
	...f  s unitDr=$O(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr)) q:unitDr=""  d
	....s KPIDr=0
	....f  s KPIDr=$O(^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)) q:KPIDr=""  d
	.....s actValue=^TMPDHCCJXPATOTAL("dhc","pa","rate","survey",$j,period,periodType,unitDr,KPIDr)
	.....i $D(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",unitDr,period,periodType,KPIDr)) d
	......&SQL(update dhc_pa_data.jxbasedata set JXBaseData_actualValue=:actValue where JXBaseData_parRef=:unitDr and JXBaseData_period=:period and JXBaseData_periodType=:periodType and JXBaseData_KPIDr=:KPIDr)
	.....e  d
	......&SQL(insert into dhc_pa_data.jxbasedata(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState) values(:unitDr,:period,:periodType,:KPIDr,:actValue,:dataState))
	
	q "OK"
}

/// Creator：李明忠
/// CreatDate：2011-05-03
/// Description: 指标权重
/// Table：dhc_pa_data.SchemDetail
/// Input：schemDr-方案ID;kpiDr-指标ID
/// Output：
/// Return：指标权重
/// Others：w ##class(dhc.pa.udata.uSurveyScoreTotal).getRate("1||5",2)
ClassMethod getRate(schemDr, kpiDr) As %String
{
	n (schemDr,kpiDr)
	
	s rate=0
	q:schemDr="" rate
	q:kpiDr="" rate
	
	s sqlStr="select SchemDetail_rate from dhc_pa_data.schemDetail where SchemDetail_childSub>0 and SchemDetail_isTarget=2"
	
	s whereStr=""
	i schemDr'="" s whereStr=" and SchemDetail_parRef='"_schemDr_"'"
	i kpiDr'="" s whereStr=whereStr_" and SchemDetail_KPIDr='"_kpiDr_"'"
	
	s sqlStr=sqlStr_whereStr
		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
	While(result.Next())
	{
		s rate=result.Data("SchemDetail_rate")
	}

	d result.Close()
	q rate
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSurveyScore703S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
