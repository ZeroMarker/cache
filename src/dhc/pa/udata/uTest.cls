/// Creator: wang ying
/// CreatDate: 2013-07-19
/// Description: 移动调查问卷
Class dhc.pa.udata.uTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(dhc.pa.udata.uTest).test()

ClassMethod test()
{
	 ;w {kpi
	 w "{"_"""kpi"""_":["
	    _"{KPIDr:1,KPIName:'工作态度',distScore:,levelScore:Y,Level:[{levelDr:1,levelName:'满意',score:5},{levelDr:2,levelName:'比较满意',score:4},{levelDr:3,levelName:'一般',score:3},{levelDr:4,levelName:'差',score:2},{levelDr:5,levelName:'很差',score:1}]},"
	    _"{KPIDr:2,KPIName:'问诊情况',levelDr:,levelName:,score: ,distScore:Y,levelScore:},"
	    _"{KPIDr:3,KPIName:'等待时间',distScore:,levelScore:Y,Level:[{levelDr:6,levelName:'长',score:1},{levelDr:7,levelName:'短',score:5}]}"
	    _"]}"
}

/// Creator: wang ying
/// CreatDate: 2013-06-18
/// Description: 查询符合条件的记录
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).ListRec("1||103","2014")
ClassMethod ListRec(SchemDr, period) As %String
{
		n (SchemDr,period)
		q:SchemDr="" "NoSchem"
		q:period="" "NoPeriod"
		s curr=$p(SchemDr,"||",1)
		s sqlStr="SELECT KpiScoreType_Rowid,KpiScoreType_KpiDr,KpiScoreType_DirectScore,KpiScoreType_LevelScore,KpiScoreType_Active FROM dhc_pa_data.KpiScoreType,dhc_pa_data.SchemDetail,dhc_pa_data.Stratagem,dhc_pa_data.Cycle where SchemDetail_KPIDr=KpiScoreType_KpiDr and SchemDetail_isTarget=2 and Stratagem_cycleDr=Cycle_rowid"
		i SchemDr'="" s sqlStr=sqlStr_" and SchemDetail_parRef='"_SchemDr_"' and Stratagem_rowid='"_curr_"'"		
		i period'=""  s sqlStr=sqlStr_" and Cycle_code='"_period_"'"
		s result=##class(%Library.ResultSet).%New()
        
		s resultString="{""kpi"""_":["
		s tmpString=""
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s KPIName="",directScore="",levelScore="",String="",levelString=""
			s rowid=result.Data("KpiScoreType_Rowid")
			s KpiDr = result.Data("KpiScoreType_KpiDr")
			i KpiDr'="" d
			i $d(^DHCCJXPAKPIINDEX1(KpiDr)) d
			.s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KpiDr)),"^",2)
			
			s directScore=result.Data("KpiScoreType_DirectScore")
			s levelScore=result.Data("KpiScoreType_LevelScore")
			s active=result.Data("KpiScoreType_Active")
			
			i tmpString="" d
			.s tmpString=resultString_"{""KPIDr"":"_KpiDr_","_"""KPIName"""_":"""_KPIName_""","_"""distScore"""_":"""_directScore_""","_"""levelScore"""_":"""_levelScore_""""
			e  d
			.s tmpString=tmpString_",{""KPIDr"":"_KpiDr_","_"""KPIName"""_":"""_KPIName_""","_"""distScore"""_":"""_directScore_""","_"""levelScore"""_":"""_levelScore_""""
			
			i levelScore="Y" d
			.i $d(^DHCCJXPAKPILEVEL(0,"KPILevel",rowid)) d
			..s levelRowid=0
			..s String=",""Level"":["
			..f  s levelRowid=$o(^DHCCJXPAKPILEVEL(0,"KPILevel",rowid,levelRowid)) q:levelRowid=""  d
			...i $d(^DHCCJXPASCORELEVEL(levelRowid)) d
			....s levelName=$p($g(^DHCCJXPASCORELEVEL(levelRowid)),"^",3)
			....s score=$p($g(^DHCCJXPASCORELEVEL(levelRowid)),"^",1)
			....i levelString="" s levelString=String_"{""levelDr"":"_levelRowid_","_"""levelName"":"_""""_levelName_""","_"""score"":"_score_"}"
			....e  s levelString=levelString_",{""levelDr"":"_levelRowid_","_"""levelName"":"_""""_levelName_""","_"""score"":"_score_"}"
			..s levelString=levelString_"]"
			i levelString="" s tmpString=tmpString_"}"
			e  s tmpString=tmpString_levelString_"}"
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2011-06-19
/// Description: 提交问卷调查信息
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).ListRec()
ClassMethod submit(data) As %String
{
	n (data)
}

/// Creator: wang ying
/// CreatDate: 2013-07-17
/// Description: 查询调查问卷的方案
/// Table: dhc_pa_data.Schem
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).schem()
ClassMethod schem() As %String
{
	    s currStragem=##class(dhc.pa.udata.uKpiScoreType).currStragem()
	    i currStragem="ERROR" q "ERROR"
	    i currStragem="NO"  q "NO"
	    
	    s sqlStr="select Schem_rowid,Schem_name from dhc_pa_data.Schem where Schem_flag='Y' and Schem_parRef='"_currStragem_"'"
				
		s result=##class(%Library.ResultSet).%New()
		
		s resultString="{""schem"""_":["
		s tmpString=""
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s KPIName="",directScore="",levelScore="",String="",levelString=""
			s rowid=result.Data("Schem_rowid")
			s desc = result.Data("Schem_name")
			
			i tmpString="" d
			.s tmpString=resultString_"{""rowid"":"_""""_rowid_""","_"""desc"""_":"""_desc_"""}"
			e  d
			.s tmpString=tmpString_",{""rowid"":"_""""_rowid_""","_"""desc"""_":"""_desc_"""}"
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2013-07-17
/// Description: 查询调查问卷的方案
/// Table: dhc_pa_data.UnitResult
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).period("3||16")
ClassMethod period(schemDr) As %String
{
	    n (schemDr)
	   
	    q:schemDr="" "NoSchem"
	    
	    s sqlStr="SELECT distinct UnitResult_period from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail where UnitResult_rowid=UnitResultDetail_parRef"
	    i schemDr'="" s sqlStr=sqlStr_" and UnitResult_schemDr='"_schemDr_"'"
				
		s result=##class(%Library.ResultSet).%New()
		
		s resultString="{""month"""_":["
		s tmpString=""
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s period=result.Data("UnitResult_period")
			
			i tmpString="" d
			.s tmpString=resultString_"{""period"":"_""""_period_"""}"
			e  d
			.s tmpString=tmpString_",{""period"":"_""""_period_"""}"
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2013-07-17
/// Description: 查询调查问卷的方案
/// Table: dhc_pa_data.UnitResult
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).cycle()
ClassMethod cycle() As %String
{
	  
	   	    
	    s sqlStr="SELECT Cycle_code,Cycle_name from dhc_pa_data.Cycle where %ID>0 order by Cycle_code desc"
	  
				
		s result=##class(%Library.ResultSet).%New()
		
		s resultString="{""month"""_":["
		s tmpString=""
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		While(result.Next())
		{
			s code=result.Data("Cycle_code")
			s desc=result.Data("Cycle_name")
			
			i tmpString="" d
			.s tmpString=resultString_"{""code"":"_""""_code_""","_"""desc"""_":"""_desc_"""}"
			e  d
			.s tmpString=tmpString_",{""code"":"_""""_code_""","_"""desc"""_":"""_desc_"""}"
			
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2013-07-17
/// Description: 查询调查问卷的方案
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).jxUnit("","demo")
ClassMethod jxUnit(schemDr, userCode) As %String
{
	    n (schemDr,userCode)
	    
	    q:userCode="" "NoData"
	
		s userCode=$$ALPHAUP^SSUTIL4(userCode)
		//根据用户Code查找用户ID
		s userId=0
		s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
		q:userId="" "NoData"
	   
	    s sqlStr="select distinct  UnitSchem_parRef,JXUnit_shortcut from dhc_pa_data.UnitSchem,dhc_pa_data.JXUnit,dhc_pa_data.JXUnitAudit,dhc_pa_data.schem  where UnitSchem_parRef=JXUnit_rowid and UnitSchem_parRef=JXUnitAudit_jxUnitDr and Schem_rowid=UnitSchem_schemDr and Schem_flag='Y' and  JXUnitAudit_userDr='"_userId_"'"
	    s whereStr=""
	    i schemDr'="" s whereStr=" and UnitSchem_schemDr="_schemDr
		s result=##class(%Library.ResultSet).%New()
	   
		s resultString="{""jxunit"""_":["
		s tmpString=""
		s sqlStr=sqlStr_whereStr
		;w sqlStr,!
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			s KPIName="",directScore="",levelScore="",String="",levelString=""
			s rowid=result.Data("UnitSchem_parRef")
			s desc = result.Data("JXUnit_shortcut")
			
			i tmpString="" d
			.s tmpString=resultString_"{""rowid"":"_""""_rowid_""","_"""desc"""_":"""_desc_"""}"
			e  d
			.s tmpString=tmpString_",{""rowid"":"_""""_rowid_""","_"""desc"""_":"""_desc_"""}"
			
		}
	    s tmpString=tmpString_"]}"
		d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2013-07-23
/// Description: 查询调查问卷的方案的个数
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).surveyNum("^201304^M^1^3")
ClassMethod surveyNum(data) As %String
{
	    n (data)
	    //2013-07-31 修改
	    ;s currStragem=##class(dhc.pa.udata.uKpiScoreType).currStragem()
	    ;i currStragem="ERROR" q "ERROR"
	    ;i currStragem="NO"  q "NO"
	    
	    q:data="" "NoData"
	    ;s schemDr=$p(data,"^",1)
	    s period=$p(data,"^",2)
	    s periodType=$p(data,"^",3)
	    s userId=$p(data,"^",4)
	    s unitDr=$p(data,"^",5)
	    q:userId="" "NouserId"
	    q:period="" "Noperiod"
	    q:periodType="" "NoperiodType"
	    
		s userName="",unitName="",periodName="",cycle="",schemName=""
		//根据用户ID查找用户名称
		i userId'="" d
		.i $d(^SSU("SSUSR",userId)) d
		..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
		
		i unitDr'="" d
		.i $d(^DHCCJXPAJXUNIT(unitDr)) d
		..s unitName=$p($g(^DHCCJXPAJXUNIT(unitDr)),"^",3)
		
		
		i (periodType'="")&&(period'="") d
		.s cycle=$e(period,1,4)_"年"
		.i periodType="M" d
		..s periodName=$e(period,5,6)_"月"
		.i periodType="Q" d
		..s periodName=$e(period,5,6)_"季度"
		.i periodType="HY" d
		..s periodName=$e(period,5,6)_"半年"
		.i periodType="Y" d
		..s periodName="全年"
	   
	    s flag="N"
	    s resultString="{""SurveyScore"""_":["
	    s tmpString="",schemNum=0
	    s schemDr=0
	    f  s schemDr=$o(^DHCCJXPAJXUNIT(0,"UnitSchemSchem",unitDr,schemDr)) q:schemDr=""  d
        .s schemName=""
        .s currStragem=$p(schemDr,"||",1)
        .s schem=$p(schemDr,"||",2)
        .i $d(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)) d
        ..s flag=$p($g(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)),"^",12)
        ..s schemName=$p($g(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)),"^",2)
        .i flag="Y" d
        ..s schemNum=0
	    ..s patDr=0
	    ..f  s patDr=$o(^DHCCJXPASURVEYSCORE(0,"SchemPat",period,periodType,unitDr,userId,schemDr,patDr)) q:patDr=""  d
	    ...s schemNum=schemNum+1
		..i tmpString="" d
		...s tmpString=resultString_"{""schemName"":"_""""_schemName_""","_"""schemNum"""_":"""_schemNum_""","_"""userName"""_":"""_userName_""","_"""unitName"""_":"""_unitName_""","_"""cycle"""_":"""_cycle_""","_"""periodName"""_":"""_periodName_""","_"""schemDr"""_":"""_schemDr_"""}"
		..e  d
		...s tmpString=tmpString_",{""schemName"":"_""""_schemName_""","_"""schemNum"""_":"""_schemNum_""","_"""userName"""_":"""_userName_""","_"""unitName"""_":"""_unitName_""","_"""cycle"""_":"""_cycle_""","_"""periodName"""_":"""_periodName_""","_"""schemDr"""_":"""_schemDr_"""}"
	    s tmpString=tmpString_"]}"
		//d result.Close()
		q tmpString
}

/// Creator: wang ying
/// CreatDate: 2013-08-22
/// Description: 查询调查问卷的方案的受访人
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uTest).surveyPat("3||16^201301^M^1^3")
ClassMethod surveyPat(data) As %String
{
	    n (data)
	    //2013-07-31 修改
	    ;s currStragem=##class(dhc.pa.udata.uKpiScoreType).currStragem()
	    ;i currStragem="ERROR" q "ERROR"
	    ;i currStragem="NO"  q "NO"
	    
	    q:data="" "NoData"
	    s schemDr=$p(data,"^",1)
	    s period=$p(data,"^",2)
	    s periodType=$p(data,"^",3)
	    s userId=$p(data,"^",4)
	    s unitDr=$p(data,"^",5)
	    q:userId="" "NouserId"
	    q:period="" "Noperiod"
	    q:periodType="" "NoperiodType"
	    
		s userName="",unitName="",periodName="",cycle="",schemName=""
		//根据用户ID查找用户名称
		i userId'="" d
		.i $d(^SSU("SSUSR",userId)) d
		..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
		
		i unitDr'="" d
		.i $d(^DHCCJXPAJXUNIT(unitDr)) d
		..s unitName=$p($g(^DHCCJXPAJXUNIT(unitDr)),"^",3)
		
		
		i (periodType'="")&&(period'="") d
		.s cycle=$e(period,1,4)_"年"
		.i periodType="M" d
		..s periodName=$e(period,5,6)_"月"
		.i periodType="Q" d
		..s periodName=$e(period,5,6)_"季度"
		.i periodType="HY" d
		..s periodName=$e(period,5,6)_"半年"
		.i periodType="Y" d
		..s periodName="全年"
	   
	    s flag="N"
	    s resultString="{""SurveyScore"""_":["
	    s tmpString="",schemNum=0
        s schemName=""
        s currStragem=$p(schemDr,"||",1)
        s schem=$p(schemDr,"||",2)
        i $d(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)) d
        .s flag=$p($g(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)),"^",12)
        .s schemName=$p($g(^DHCCJXPASTRATAGEM(currStragem,"Schem",schem)),"^",2)
        
        i flag="Y" d
	    .s patDr=0
	    .f  s patDr=$o(^DHCCJXPASURVEYSCORE(0,"SchemPat",period,periodType,unitDr,userId,schemDr,patDr)) q:patDr=""  d
	    ..s rowid=0,patName=""
	    ..f  s rowid=$o(^DHCCJXPASURVEYSCORE(0,"SchemPat",period,periodType,unitDr,userId,schemDr,patDr,rowid)) q:rowid=""  d
	    ...i $d(^DHCCJXPASURVEYSCORE(rowid)) d
	    ....s patName=$p($g(^DHCCJXPASURVEYSCORE(rowid)),"^",16)
		..i tmpString="" d
		...s tmpString=resultString_"{""schemName"":"_""""_schemName_""","_"""schemNum"""_":"""_schemNum_""","_"""userName"""_":"""_userName_""","_"""unitName"""_":"""_unitName_""","_"""pat"""_":"""_patDr_""","_"""patName"""_":"""_patName_""","_"""schemDr"""_":"""_schemDr_"""}"
		..e  d
		...s tmpString=tmpString_",{""schemName"":"_""""_schemName_""","_"""schemNum"""_":"""_schemNum_""","_"""userName"""_":"""_userName_""","_"""unitName"""_":"""_unitName_""","_"""pat"""_":"""_patDr_""","_"""patName"""_":"""_patName_""","_"""schemDr"""_":"""_schemDr_"""}"
	    s tmpString=tmpString_"]}"
		//d result.Close()
		q tmpString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
