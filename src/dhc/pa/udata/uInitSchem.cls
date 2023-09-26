/// Creator: wang ying
/// CreatDate: 2014-12-10
/// Description: 初始化绩效单元、绩效单元明显、绩效单元算法制度明显
Class dhc.pa.udata.uInitSchem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 导入接口指标任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).importOutKPIDataByTask("M")
ClassMethod importOutKPIDataByTask(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	s cycleCode=$p(cycle,"^",1)+1
	q:cycleCode="" "cycleCodeNull"
	s monthCode=$p(cycle,"^",2)
	q:monthCode="" "monthCodeNull"
	i monthCode=12 s cycleCode=cycleCode-1
	
	s CycleDr=0
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"

	;w CycleDr_"^"_monthCode_"^"_frequency,!
	s intLocSetDr=0
	f  s intLocSetDr=$o(^DHCCJXPAINTERLOCSET(intLocSetDr)) q:intLocSetDr=""  d
	.s sqlcode=0
	.s sqlcode=##class(dhc.pa.udata.uOutKPIData).import(CycleDr,monthCode,frequency,intLocSetDr,"")
	.i sqlcode'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("setAllActValueByTask",CycleDr_"^"_frequency_"^"_monthCode,sqlcode,"")
	
	q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 基础数据导入任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).importJXBaseData("M")
ClassMethod importJXBaseData(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	
	s cycleCode=$p(cycle,"^",1)+1
	q:cycleCode="" "cycleCodeNull"
	s monthCode=$p(cycle,"^",2)
	q:monthCode="" "monthCodeNull"
	i monthCode=12 s cycleCode=cycleCode-1
	
	s CycleDr=0
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"
	
	i $e(monthCode,2,2)="" s monthCode="0"_monthCode
	s newPeriod=cycleCode_monthCode
	

	;w CycleDr_"^"_newPeriod_"^"_frequency,!
	s sqlcode=0
	s sqlcode=##class(dhc.pa.udata.uJXBaseData).Import(newPeriod,frequency)
	i sqlcode'=0 d
	.d ##class(dhc.pa.udata.uPALogger).Insert("ImportJXBaseDataByTask",newPeriod_"^"_frequency,sqlcode,"")
    q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-11
/// Description: 数据初始化
/// Table：
/// Input：CycleDr-战略年度Dr,SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).InitAll("demo","2012","1||1")
ClassMethod InitAll(userCode, cycleCode, SchemID) As %String
{
	n (userCode,cycleCode,SchemID)
	;w $zt($p($h,",",2)),!
		
	s rs=0,flag="true" //定义返回值标志,SQL执行标志,年度代码
	
	s currStratagemDr=##class(dhc.pa.udata.uComm).GetCurrStratagemDr()
	q:currStratagemDr="NoCurrRecord" currStratagemDr //表示没有当前战略记录
	q:currStratagemDr="RepCurrRecord" currStratagemDr //表示有多条当前战略记录

	
	i cycleCode="" s cycleCode=$p(..getYearCode(),"^",3)
	q:cycleCode="" "ErrCycle" //没有年度将不复制记录
	
	s Schem=""
	f  s Schem=$o(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",Schem)) q:Schem=""  d
	.s flag="true"
	.s SchemDr=currStratagemDr_"||"_Schem
	.q:((SchemDr'=SchemID)&&(SchemID'=""))
	.s aduit=""
	.s aduit= ##class(dhc.pa.udata.uComm).SchemByAduit(SchemDr,userCode)
	.i '(aduit>0)  s flag="NoAduit" 
	.q:flag="NoAduit"
	.s flag=..Init(cycleCode,SchemDr) //按方案初始化
	.i flag'="true" d
	..d ##class(dhc.pa.udata.uPALogger).Insert("InitAll",cycleCode_"^"_SchemDr,flag,"")
	
	;w $zt($p($h,",",2)),!
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 基础数据导入任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).importTvalueByTask("Q")
ClassMethod importTvalueByTask(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	s currStratagemDr=##class(dhc.pa.udata.uComm).GetCurrStratagemDr()
	q:currStratagemDr="NoCurrRecord" currStratagemDr //表示没有当前战略记录
	q:currStratagemDr="RepCurrRecord" currStratagemDr //表示有多条当前战略记录

	
	s cycleCode=$p(cycle,"^",3)
	q:cycleCode="" "cycleCodeNull"
	s monthCode=$p(cycle,"^",2)
	q:monthCode="" "monthCodeNull"
	i monthCode=12 s cycleCode=cycleCode-1
	
	s CycleDr=0
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"
	
	i $e(monthCode,2,2)="" s monthCode="0"_monthCode
	s newPeriod=cycleCode_monthCode
	

	;w CycleDr_"^"_cycleCode_"^"_frequency,!
	
	s sqlcode=0
	s sqlcode=##class(dhc.pa.udata.uKPITargetSet).ImportTValueInfo(cycleCode,frequency)
	s Schem=0
	f  s Schem=$o(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",Schem)) q:Schem=""  d
	.s SchemDr=currStratagemDr_"||"_Schem
	.s sqlcode=##class(dhc.pa.udata.uKPITargetSet).ImportTValue(CycleDr,SchemDr,"")
	.i sqlcode'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("importTvalueByTask",CycleDr_"^"_SchemDr,sqlcode,"")
    q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 指标值计算任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).setAllActValueByTask("M")
ClassMethod setAllActValueByTask(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	s cycleCode=$p(cycle,"^",1)+1
	q:cycleCode="" "cycleCodeNull"
	s monthCode=$p(cycle,"^",2)
	q:monthCode="" "monthCodeNull"
	i monthCode=12 s cycleCode=cycleCode-1
	
	s CycleDr=0
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"

	;w CycleDr_"^"_monthCode_"^"_frequency,!
	s sqlcode=0
	s sqlcode=##class(dhc.pa.udata.uCalculator).setAllActValue(CycleDr,frequency,monthCode,"")
	i sqlcode'="%true" d
	.d ##class(dhc.pa.udata.uPALogger).Insert("setAllActValueByTask",CycleDr_"^"_frequency_"^"_monthCode,sqlcode,"")
	
	q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 指标分计算任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).AssScoreCalAllByTask("M")
ClassMethod AssScoreCalAllByTask(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	s cycleCode=$p(cycle,"^",1)+1
	q:cycleCode="" "cycleCodeNull"
	s monthCode=$p(cycle,"^",2)
	q:monthCode="" "monthCodeNull"
	i monthCode=12 s cycleCode=cycleCode-1
	
	s CycleDr=0
	s CycleDr=$o(^DHCCJXPACYCLE(0,"Code",cycleCode,CycleDr))	
	q:CycleDr="" "CycleDrNull"

	;w CycleDr_"^"_monthCode_"^"_frequency,!
	s sqlcode=0
	s sqlcode=##class(dhc.pa.udata.uCalculator).AssScoreCalAll(CycleDr,frequency,monthCode,"")
	i sqlcode'="true" d
	.d ##class(dhc.pa.udata.uPALogger).Insert("AssScoreCalAllByTask",CycleDr_"^"_frequency_"^"_monthCode,sqlcode,"")
	
	q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-11
/// Description: 数据初始化
/// Table：
/// Input：CycleDr-战略年度Dr,SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).Init("2016","1||5")
ClassMethod Init(cycleCode, SchemDr) As %String
{
	
	n (cycleCode,SchemDr)
	
	s currStratagemDr=$p(SchemDr,"||",1)
	q:currStratagemDr="" "nullcurrStratagemDr"
	s flag="true"
	s flag=..CopySchems(cycleCode,SchemDr) //复制绩效方案
	i flag'="true" s rs=1
	q:flag="nullUnit" "nullUnit" //该方案下没有科室
	q:flag="false" "false1"
	
	;w "1",!
	s flag=..CopySchemDetailData(currStratagemDr,SchemDr,cycleCode)
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem2" //没有方案
	q:flag="false" "false2"
	;w "Detail",!
	s flag=..CopySchemDetailAddData(SchemDr,cycleCode)
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem3" //没有方案
	q:flag="false" "false3"
	;w "add",!
	s flag=..CopySchemDetailDistData(SchemDr,cycleCode)
	;w SchemDr,!
	i flag'="true" s rs=1
	q:flag="NoSchem" "NoSchem4" //没有方案
	q:flag="false" "false4"
	
    ;w $zt($p($h,",",2)),!
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 获得要初始化的年度代码
/// Table：
/// Input：CycleDr-战略年度Dr,SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).getYearCode()
ClassMethod getYearCode() As %String
{
	s date=$p($h,",",1)
	;s date=63249
	s date=$zd(date,3)
	
	s yearCode=""
	s currYear=$p(date,"-",1)
	s currMonth=$p(date,"-",2)
	s yearCode=currYear-1
	s monthCode=currMonth-1
	i monthCode=0 s monthCode=12
	q yearCode_"^"_monthCode_"^"_currYear
	;q "2014"_"^"_"2"_"^"_"2015"
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 复制方案
/// Table：dhc_pa_data.Schem
/// Input：cycleCode-年度代码;schemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchems("2010",1)
ClassMethod CopySchems(cycleCode, schemDr) As %String
{
	n (cycleCode,schemDr)
	
	q:cycleCode="" "false" 
	q:schemDr="" "false" 
	
	s flag="true"
	
	;查询方案的绩效单元
	s jxUnitStr=##class(dhc.pa.udata.uDistTarget).GetJXUnitOfSchem(schemDr)
	q:jxUnitStr="" "nullUnit"
	
	s childSub=$P(schemDr,"||",2)
	s currStratagemDr=$P(schemDr,"||",1)
	i $G(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",childSub))'="" d
	.s frequency=$P($G(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",childSub)),"^",5)
	.i frequency'="" d
	..s flag=..CopySchemData(cycleCode,frequency,currStratagemDr,schemDr,jxUnitStr)
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 按照报告复制绩效方案
/// Table：dhc_pa_data.UnitResult
/// Input：cycleCode-年度;frequency-报告频率;currStratagemDr-当前战略;schemDr-方案;jxUnitStr-绩效单元
/// Output：
/// Return：成功标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).CopySchemData(2015,"M",1,"1||26","4")
ClassMethod CopySchemData(cycleCode, frequency, currStratagemDr, schemDr, jxUnitStr) As %String
{
	n (cycleCode,frequency,currStratagemDr,schemDr,jxUnitStr)
	
	
	s rs=0,flag="true",SQLCODE=0
	
	i frequency="M" d //按月复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=1
	..i currMonth'="" d
	...;生成当前月份至12月数据数量Count
	...s Count=13-currMonth
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	......i SQLCODE'=0 d
	.......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataM00",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	.....f i=1:1:Count d
	......s month=currMonth+i-1
	......i month<10 d
	.......s month="0"_month
	......s period=cycleCode_month
	......s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.......i SQLCODE'=0 d
	........d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataM",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	
	i frequency="Q" d //按季度复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=1
	..i currMonth'="" d
	...;生成当前季度至第四季度数据数量Count
	...s Count=##class(dhc.pa.udata.uDistTarget).GetCount(currMonth)
	...;根据当前月份获取起始季度
	...s startQuarter=##class(dhc.pa.udata.uDistTarget).GetStartQuarter(currMonth)
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	......i SQLCODE'=0 d
	.......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataQ00",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	.....f i=1:1:Count d
	......s Quarter="0"_(startQuarter+i-1)
	......s period=cycleCode_Quarter
	......s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.......i SQLCODE'=0 d
	........d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataQ",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	
	i frequency="H" d //按半年复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s auditState=-1
	..;获取当前月份
	..s currMonth=1
	..i currMonth'="" d
	...;生成当前所属半年至下半年数据数量Count
	...i currMonth<7 s Count=2
	...e  s Count=1
	...;根据当前月份获取起始半年期间
	...s startHalfYear=##class(dhc.pa.udata.uDistTarget).GetStartHalfYear(currMonth)
	...s Length=$L(jxUnitStr,"^")
	...f k=1:1:Length d
	....s jxUnitDr=$P(jxUnitStr,"^",k)
	....i jxUnitDr'="" d
	.....;首先添加一条年度00记录
	.....s period=cycleCode_"00"
	.....s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	.....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	.....e  d
	......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	......i SQLCODE'=0 d
	.......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataH00",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	.....f i=1:1:Count d
	......s HalfYear="0"_(startHalfYear+i-1)
	......s period=cycleCode_HalfYear
	......s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	......i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	......e  d
	.......&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.......i SQLCODE'=0 d
	........d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataH",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")
	
	i frequency="Y" d //按年复制数据
	.;获取应用系统号
	.s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	.i appSysDr'="" d
	..s Length=$L(jxUnitStr,"^")
	..f k=1:1:Length d
	...s jxUnitDr=$P(jxUnitStr,"^",k)
	...i jxUnitDr'="" d
	....s period=cycleCode_"00"
	....s auditState=-1
	....s SQLCODE=##class(dhc.pa.udata.uDistTarget).CopySchemToPeridRec(currStratagemDr,appSysDr,schemDr,period)
	....i $D(^DHCCJXPASTRATAGEM(0,"PUSA",currStratagemDr,period,jxUnitDr,schemDr,appSysDr)) d //什么也不做
	....e  d
	.....&SQL(Insert into dhc_pa_data.UnitResult(UnitResult_parRef,UnitResult_schemDr,UnitResult_appSysDr,UnitResult_jxUnitDr,UnitResult_period,UnitResult_auditState) values(:currStratagemDr,:schemDr,:appSysDr,:jxUnitDr,:period,:auditState))
	.....i SQLCODE'=0 d
	......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDataY",period_"^"_frequency_"^"_schemDr_"^"_jxUnitDr,SQLCODE,"")

	i SQLCODE'=0 d
	.s flag="false"
	
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 复制单元方案明细
/// Table：dhc_pa_data.UnitResultDetail
/// Input：currStratagemDr-当前战略Dr;schemDr-方案
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailData(1,"1||1")
ClassMethod CopySchemDetailData(currStratagemDr, schemDr, cycleCode) As %String
{
	n (currStratagemDr,schemDr,cycleCode)
	
	
	s rs=0,flag="true"
	s SQLCODE=0
	//根据方案查询绩效单元考核方案
	s unitResultChildSub=0,count=0,jxUnitDr=0,yearCode=""
	f  s jxUnitDr=$O(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStratagemDr,schemDr,jxUnitDr)) q:jxUnitDr=""  d
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(0,"UnitResultSchem",currStratagemDr,schemDr,jxUnitDr,unitResultChildSub)) q:unitResultChildSub=""  d
	..i $d(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)) d
	...s yearCode=$p($g(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)),"^",4)
	...s yearCode=$e(yearCode,1,4) 
	..q:yearCode'=cycleCode //与当前年度不符的绩效单元不复制
	..s unitResultRowid=currStratagemDr_"||"_unitResultChildSub
	..;按照绩效单元方案逐个复制绩效单元方案明细
	..i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2))) d
	...s schemDetailChildSub=0
	...f  s schemDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2),schemDetailChildSub)) q:schemDetailChildSub=""  d
	....s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"SchemDetail",$P(schemDr,"||",2),schemDetailChildSub))
	....s schemDetailRowid=currStratagemDr_"||"_$P(schemDr,"||",2)_"||"_schemDetailChildSub
	....i Curr'="" d
	.....s count=count+1
	.....s Order=$P(Curr,"^",1)
	.....s KPIDr=$P(Curr,"^",2)
	.....s IsTarget=$P(Curr,"^",3)
	.....s Rate=$P(Curr,"^",4)
	.....s Parent=$P(Curr,"^",5)
	.....i $D(^DHCCJXPASTRATAGEM(0,"URDetailRecord",currStratagemDr,unitResultChildSub,schemDetailRowid,KPIDr)) d 
	......;w count_"^"_unitResultRowid_"^"_schemDetailRowid_"^"_KPIDr_"^"_Order_"^"_IsTarget_"^"_Rate_"^"_Parent,! 
	......&SQL(update dhc_pa_data.UnitResultDetail set UnitResultDetail_rate=:Rate,UnitResultDetail_parent=:Parent where UnitResultDetail_parRef=:unitResultRowid and UnitResultDetail_sDetailDr=:schemDetailRowid and UnitResultDetail_KPIDr=:KPIDr and UnitResultDetail_isTarget=:IsTarget ) 
	......i SQLCODE'=0 d
	.......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailDataUpdate",unitResultRowid_"^"_schemDetailRowid_"^"_KPIDr_"^"_IsTarget,SQLCODE,"")
	.....e  d 
	......&SQL(Insert into dhc_pa_data.UnitResultDetail(UnitResultDetail_parRef,UnitResultDetail_sDetailDr,UnitResultDetail_KPIDr,UnitResultDetail_order,UnitResultDetail_isTarget,UnitResultDetail_rate,UnitResultDetail_parent) values(:unitResultRowid,:schemDetailRowid,:KPIDr,:Order,:IsTarget,:Rate,:Parent)) 
	......i SQLCODE'=0 d
	.......d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailData",unitResultRowid_"^"_schemDetailRowid_"^"_KPIDr_"^"_IsTarget,SQLCODE,"")
	
	i SQLCODE'=0 d
	.s flag="false"
	
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2010-8-12
/// Description: 复制绩效方案加减法评分标准
/// Table：dhc_pa_data.URDetailAdd
/// Input：SchemDr-方案Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailAddData("1||1")
ClassMethod CopySchemDetailAddData(SchemDr, cycleCode) As %String
{
	n (SchemDr,cycleCode)
	;w $zt($p($h,",",2)),!
	q:SchemDr="" "true"
	q:cycleCode="" "true"
	
	s currStratagemDr=$P(SchemDr,"||",1)
	
	
	s rs=0,flag="true",count=0
	
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail")) d
	.s unitResultChildSub=0
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub)) q:unitResultChildSub=""  d
	..s yearCode=""
	..i $d(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub))  d
	...s yearCode=$p($g(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)),"^",4)
	...s yearCode=$e(yearCode,1,4)
	..q:yearCode'=cycleCode //与当前年度不符的绩效单元不复制
	..s unitResultDetailChildSub=0
	..f  s unitResultDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub)) q:unitResultDetailChildSub=""  d
	...s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub))
	...i Curr'="" d
	....s sDetailDr=$P(Curr,"^",1)
	....s schem=$P(sDetailDr,"||",1)_"||"_$P(sDetailDr,"||",2)
	....i schem=SchemDr d
	.....s isTarget = $P(Curr,"^",4)
	.....i isTarget'="1" d
	......s KPIDr = $P(Curr,"^",2) 
	......s KPIMethod = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
	......;w KPIMethod,!
	......i (KPIMethod="A")||(KPIMethod="D") d
	.......;w count_"^"_currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub_"^"_KPIMethod,!
	.......s unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub
	.......s SchemDetailRowid=$P(Curr,"^",1)
	.......;根据方案明细Rowid查询SchemDetailAdd
	.......i SchemDetailRowid'="" d
	........s Length=$L(SchemDetailRowid,"||")
	........s schemDetailAddChildSub=0
	........f  s schemDetailAddChildSub=$O(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailAdd",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailAddChildSub)) q:schemDetailAddChildSub=""  d
	.........s AddCurr=$G(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailAdd",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailAddChildSub))
	.........;w SchemDetailRowid_"!!!"_AddCurr,!
	.........i AddCurr'="" d
	..........s count=count+1
	..........s Flag=$P(AddCurr,"^",1)
	..........s changeValue=$P(AddCurr,"^",2)
	..........s score=$P(AddCurr,"^",3)
	..........s baseValue=$P(AddCurr,"^",4)
	..........s baseScore=$P(AddCurr,"^",5)
	..........;w count_"^"_unitResultDetailRowid_"^"_Flag_"^"_changeValue_"^"_score,!
	..........i $D(^DHCCJXPASTRATAGEM(0,"URDA",currStratagemDr,unitResultChildSub,unitResultDetailChildSub,KPIMethod)) d
	...........&SQL(update dhc_pa_data.URDetailAdd set URDetailAdd_changeValue=:changeValue,URDetailAdd_score=:score,URDetailAdd_baseValue=:baseValue,URDetailAdd_base=:baseScore where URDetailAdd_parRef=:unitResultDetailRowid and URDetailAdd_flag=:KPIMethod)
	...........i SQLCODE'=0 d
	............d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailAddDataUpdate",unitResultDetailRowid_"^"_KPIMethod_"^"_changeValue_"^"_score,SQLCODE,"")
	..........e  d
	...........&SQL(Insert into dhc_pa_data.URDetailAdd(URDetailAdd_parRef,URDetailAdd_flag,URDetailAdd_changeValue,URDetailAdd_score,URDetailAdd_baseValue,URDetailAdd_base) values(:unitResultDetailRowid,:Flag,:changeValue,:score,:baseValue,:baseScore))
	...........i SQLCODE'=0 d
	............d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailAddData",unitResultDetailRowid_"^"_Flag_"^"_changeValue_"^"_score,SQLCODE,"")
	..........i SQLCODE'=0   d
    ...........;s ^TMPDHCCJXPA($J,0,"pa","uradd")=unitResultDetailRowid_"^"_KPIDr  
    ...........s flag="false"

    /*
	i rs'=0 d
	.TRollBack
	.s flag="false"
	e  d
	.TCOMMIT
	*/
	;w $zt($p($h,",",2)),!
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-10
/// Description: 复制绩效方案区间法评分标准
/// Table：dhc_pa_data.URDetailDist
/// Input：currStratagemDr-当前战略Dr
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uDistTarget).CopySchemDetailDistData("1||1")
ClassMethod CopySchemDetailDistData(SchemDr, cycleCode) As %String
{
	n (SchemDr,cycleCode)
	
	q:SchemDr="" "true"
	q:cycleCode="" "true"
	s currStratagemDr=$P(SchemDr,"||",1)
	
	
	s rs=0,flag="true",count=0
	
	i $D(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail")) d
	.s unitResultChildSub=0
	.f  s unitResultChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub)) q:unitResultChildSub=""  d
	..s yearCode=""
	..i $d(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub))  d
	...s yearCode=$p($g(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",unitResultChildSub)),"^",4)
	...s yearCode=$e(yearCode,1,4)
	..q:yearCode'=cycleCode //与当前年度不符的绩效单元不复制
	..s unitResultDetailChildSub=0
	..f  s unitResultDetailChildSub=$O(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub)) q:unitResultDetailChildSub=""  d
	...s Curr=$G(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",unitResultChildSub,unitResultDetailChildSub))
	...i Curr'="" d
	....s sDetailDr=$P(Curr,"^",1)
	....s schem=$P(sDetailDr,"||",1)_"||"_$P(sDetailDr,"||",2)
	....i schem=SchemDr d
	.....s isTarget = $P(Curr,"^",4)
	.....i isTarget'=1 d
	......s KPIDr = $P(Curr,"^",2) 
	......s KPIMethod = $P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",13)  //考核方法
	......i KPIMethod="I" d
	.......s unitResultDetailRowid=currStratagemDr_"||"_unitResultChildSub_"||"_unitResultDetailChildSub
	.......s SchemDetailRowid=$P(Curr,"^",1)
	.......;根据方案明细Rowid查询SchemDetailDist
	.......i SchemDetailRowid'="" d
	........s Length=$L(SchemDetailRowid,"||")
	........s schemDetailDistChildSub=0
	........f  s schemDetailDistChildSub=$O(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailDist",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailDistChildSub)) q:schemDetailDistChildSub=""  d
	.........s DistCurr=$G(^DHCCJXPASTRATAGEM($P(SchemDetailRowid,"||",1),"SchemDetailDist",$P(SchemDetailRowid,"||",2),$P(SchemDetailRowid,"||",3),schemDetailDistChildSub))
	.........i DistCurr'="" d
	..........;s count=count+1
	..........s Order=$P(DistCurr,"^",1)
	..........;w Order,!
	..........s ValueLower=$P(DistCurr,"^",2)
	..........s ValueUp=$P(DistCurr,"^",3)
	..........s ScoreLower=$P(DistCurr,"^",4)
	..........s ScoreUp=$P(DistCurr,"^",5)
	..........s RangeDr=$P(DistCurr,"^",6)
	..........;w unitResultDetailRowid_"^"_Order_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,!
	..........i $D(^DHCCJXPASTRATAGEM(0,"URDD",currStratagemDr,unitResultChildSub,unitResultDetailChildSub,RangeDr)) d
	...........&SQL(update dhc_pa_data.URDetailDist set URDetailDist_valueLower=:ValueLower,URDetailDist_valueUp=:ValueUp,URDetailDist_scoreLower=:ScoreLower,URDetailDist_scoreUp=:ScoreUp where URDetailDist_rangeDr=:RangeDr and URDetailDist_parRef=:unitResultDetailRowid)
	...........;w SQLCODE,!
	...........i SQLCODE'=0 d
	............d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailDistDataUpdate",unitResultDetailRowid_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,SQLCODE,"")
	..........e  d
	...........;w unitResultDetailRowid_"^"_Order_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,!
	...........&SQL(Insert into dhc_pa_data.URDetailDist(URDetailDist_parRef,URDetailDist_order,URDetailDist_valueLower,URDetailDist_valueUp,URDetailDist_scoreLower,URDetailDist_scoreUp,URDetailDist_rangeDr) values(:unitResultDetailRowid,:Order,:ValueLower,:ValueUp,:ScoreLower,:ScoreUp,:RangeDr))
	...........i SQLCODE'=0 d
	............d ##class(dhc.pa.udata.uPALogger).Insert("CopySchemDetailDistData",unitResultDetailRowid_"^"_ValueLower_"^"_ValueUp_"^"_ScoreLower_"^"_ScoreUp_"^"_RangeDr,SQLCODE,"")
	..........i SQLCODE'=0   s flag="false"
	
	q flag
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 导入接口指标任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).BatchimportOutKPIDataByTask("M")
ClassMethod BatchimportOutKPIDataByTask(frequency) As %String
{
	n (frequency)
	s CycleDr=3 
	

	;w CycleDr_"^"_monthCode_"^"_frequency,!
	;s month=1
	f monthCode=1:1:12 d
	.s intLocSetDr=0
	.f  s intLocSetDr=$o(^DHCCJXPAINTERLOCSET(intLocSetDr)) q:intLocSetDr=""  d
	..s sqlcode=0
	..s sqlcode=##class(dhc.pa.udata.uOutKPIData).import(CycleDr,monthCode,frequency,intLocSetDr,"")
	..i sqlcode'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("setAllActValueByTask",CycleDr_"^"_frequency_"^"_monthCode,sqlcode,"")
	
	q sqlcode
}

/// Creator：wang ying
/// CreatDate：2014-12-18
/// Description: 基础数据导入任务
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).BatchimportJXBaseData("M")
ClassMethod BatchimportJXBaseData(frequency) As %String
{
	n (frequency)
	s CycleDr=1
	s cycleCode=2014
	
	;w CycleDr_"^"_newPeriod_"^"_frequency,!
    f monthCode=1:1:12 d
    .i $l(monthCode)=1 s newPeriod=cycleCode_"0"_monthCode
    .e  s newPeriod=cycleCode_monthCode
	.s sqlcode=0
	.s sqlcode=##class(dhc.pa.udata.uJXBaseData).Import(newPeriod,frequency)
	.i sqlcode'=0 d
	..d ##class(dhc.pa.udata.uPALogger).Insert("ImportJXBaseDataByTask",newPeriod_"^"_frequency,sqlcode,"")
    q sqlcode
}

/// Creator：wang ying
/// CreatDate：2016-2-17
/// Description: 从明细表取去年同期目标值
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uInitSchem).importTvalue("Q")
ClassMethod importTvalue(frequency) As %String
{
	n (frequency)
	s cycle=..getYearCode()
	q:cycle="" "ErrCycle" 
	
	s currStratagemDr=##class(dhc.pa.udata.uComm).GetCurrStratagemDr()
	q:currStratagemDr="NoCurrRecord" currStratagemDr //表示没有当前战略记录
	q:currStratagemDr="RepCurrRecord" currStratagemDr //表示有多条当前战略记录

	
	s cycleCode=$p(cycle,"^",3)
	q:cycleCode="" "cycleCodeNull"
	
	
	;w CycleDr_"^"_newPeriod_"^"_frequency,!
	s URMain=0,sqlcode=0
	f  s URMain=$o(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",URMain)) q:URMain=""  d
	.s URDetail=0
	.f  s URDetail=$o(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",URMain,URDetail)) q:URDetail=""  d
	..s URDetailInfo=$g(^DHCCJXPASTRATAGEM(currStratagemDr,"URDetail",URMain,URDetail))
	..q:URDetailInfo=""
	..s tValue=$p(URDetailInfo,"^",6)
	..s kpiDr=$p(URDetailInfo,"^",2)
	..q:$g(^DHCCJXPAKPIINDEX1(kpiDr))=""
	..s kpiType=$p(^DHCCJXPAKPIINDEX1(kpiDr),"^",15)
	..q:kpiType'=3
	..q:'$d(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",URMain)) 
	..s URMainInfo=$g(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",URMain))
	..q:URMainInfo=""
	..s URMainInfo=$g(^DHCCJXPASTRATAGEM(currStratagemDr,"UnitResult",URMain))
	..s periode=$p(URMainInfo,"^",4)
	..q:$e(periode,1,4)'=cycleCode
	..q:$e(periode,5,6)="00"
	..s samePeriod=cycleCode-1_$e(periode,5,6)
	..s schemDr=$p(URMainInfo,"^",1)
	..s periodType=""
	..q:schemDr=""
	..q:$g(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)))=""
	..s periodType=$p(^DHCCJXPASTRATAGEM(currStratagemDr,"Schem",$p(schemDr,"||",2)),"^",5)
	..q:periodType'=frequency
	..s appsys=$p(URMainInfo,"^",2)
	..s jxUnitDr=$p(URMainInfo,"^",3)
	..s URDetailRowid=currStratagemDr_"||"_URMain_"||"_URDetail
	..s TValue=0
	..&sql(SELECT UnitResultDetail_tValue INTO :TValue FROM dhc_pa_data.UnitResultDetail 
	   WHERE UnitResultDetail_parRef->UnitResult_jxUnitDr=:jxUnitDr 
	    AND UnitResultDetail_parRef->UnitResult_schemDr=:schemDr 
	    AND UnitResultDetail_parRef->UnitResult_period=:samePeriod
	    AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency=:frequency
	    AND UnitResultDetail_parRef->UnitResult_appSysDr=:appsys
	    AND UnitResultDetail_isTarget=2 AND UnitResultDetail_KPIDr=:kpiDr)
    ..&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:TValue where %ID=:URDetailRowid)
	..i sqlcode'=0 d
	...d ##class(dhc.pa.udata.uPALogger).Insert("importTvalue",TValue_"^"_URDetailRowid,sqlcode,"")
    q sqlcode
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInitSchemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
