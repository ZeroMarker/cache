/// Creator: 李明忠 
/// CreatDate: 2012-12-28
/// Description: 在执行原来的奖金核算算法前,将混合核算的方案先统一成独立核算
Class dhc.bonus.udata.uInsertBonusSchemCal Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：判断奖金方案是否是混合方案
/// Return: 返回值：1-独立核算,2-混合核算
/// Input：BonusSchemeCode-奖金方案Code
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).JudgeBonusScheme("0202")
ClassMethod JudgeBonusScheme(BonusSchemeCode) As %String
{
	n (BonusSchemeCode)
	
	s flag=1
	q:BonusSchemeCode="" flag
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select CalculateFlag from dhc_bonus_data.BonusScheme where BonusSchemeCode='"_BonusSchemeCode_"'")
	d result.Execute()
	
	While(result.Next()){
		s flag = result.Data("CalculateFlag")
	}
	d result.Close()
	
	q flag
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据方案Code获取方案的Id
/// Return: 方案的Id
/// Input：BonusSchemeCode-奖金方案Code
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetBonusSchemeId("0202")
ClassMethod GetBonusSchemeId(BonusSchemeCode) As %String
{
	n (BonusSchemeCode)
	
	s Id=0
	q:BonusSchemeCode="" Id
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusSchemeID from dhc_bonus_data.BonusScheme where BonusSchemeCode='"_BonusSchemeCode_"'")
	d result.Execute()
	
	While(result.Next()){
		s Id = result.Data("BonusSchemeID")
	}
	d result.Close()
	
	q Id
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据方案Id获取方案的科室
/// Return: 方案的科室字符串
/// Input：schemeId-方案Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetUnitOfSchem(5)
ClassMethod GetUnitOfSchem(schemeId) As %String
{
	n (schemeId)
	
	s unitId=""
	q:schemeId="" unitId
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusUnitID from dhc_bonus_data.BonusSchemeUnit where BonusSchemeID="_schemeId)
	d result.Execute()
	
	While(result.Next()){
		s uId = result.Data("BonusUnitID")
		i unitId="" s unitId=uId
		e  s unitId=unitId_"^"_uId
		
	}
	d result.Close()
	
	q unitId
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据部门Id获取部门的人员
/// Return: 人员的科室字符串
/// Input：unitId-部门Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetPersonOfUnit(487)
ClassMethod GetPersonOfUnit(unitId) As %String
{
	n (unitId)
	
	s personId=""
	q:unitId="" personId
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusUnitID from dhc_bonus_data.BonusUnit where LastStage=1 and IsValid=1 and SuperiorUnitID="_unitId)
	d result.Execute()
	
	While(result.Next()){
		s pId = result.Data("BonusUnitID")
		i personId="" s personId=pId
		e  s personId=personId_"^"_pId
	}
	d result.Close()
	
	q personId
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据方案Id获取方案下的数据级别为人员级别的指标
/// Return: 方案的指标字符串
/// Input：schemeId-方案Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetTargetOfSchem(5)
ClassMethod GetTargetOfSchem(schemeId) As %String
{
	n (schemeId)
	
	s targetId=""
	q:schemeId="" targetId
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusTargetID from dhc_bonus_data.BonusTargetMapping where BonusSchemID="_schemeId)
	d result.Execute()
	
	While(result.Next()){
		s tId = result.Data("BonusTargetID")
		i targetId="" s targetId=tId
		e  s targetId=targetId_"^"_tId
		
	}
	d result.Close()
	
	q targetId
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据提供的条件获取相应条件的值
/// Return: 返回值
/// Input：personId-人员核算单元Id;year-年度;period-核算期间;targetId-指标Id;schemeId-方案Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetValueOfTarget(6765,2011,"M11",5,75)
ClassMethod GetValueOfTarget(personId, year, period, schemId, targetId) As %String
{
	n (personId,year,period,schemId,targetId)
	
	s value=0
	q:personId="" value
	q:year="" value
	q:period="" value
	q:schemId="" value
	q:targetId="" value
	
	i $D(^dhc.bonus.d54C.BonusTargetM73AI("SchemTarget",schemId,targetId)) d
	.s rowid=0
	.s rowid=$O(^dhc.bonus.d54C.BonusTargetM73AI("SchemTarget",schemId,targetId,rowid))
	.q:rowid="" 
	.s isValid=$List(^dhc.bonus.d54C.BonusTargetM73AD(rowid),4)
	.i isValid=1 d
	..s mappedTargetId=$List(^dhc.bonus.d54C.BonusTargetM73AD(rowid),5)
	..s comeFlag=$List(^dhc.bonus.d54C.BonusTargetM73AD(rowid),6)
	..s value=..getValue(comeFlag,personId,year,period,mappedTargetId)
	
	q value
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：根据提供的条件获取相应条件的值
/// Return: 返回值
/// Input：comeFlag-奖金或者项目标示;personId-人员核算单元Id;year-年度;period-核算期间;Id-方案项目或者指标Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).getValue(1,6765,2011,"M11",5,75)
ClassMethod getValue(comeFlag, personId, year, period, Id) As %String
{
	n (comeFlag,personId,year,period,Id)
	
	s value=0
	q:comeFlag="" value
	q:personId="" value
	q:year="" value
	q:period="" value
	q:Id="" value
	
	//1-奖金指标,2-奖金项目
	s sqlStr=""
	i comeFlag=1 d
	.s sqlStr="select TargetValue from dhc_bonus_data.BonusTargetCollect where BonusYear="_year_" and BonusPeriod='"_period_"' and BonusTargetID="_Id_" and BonusUnitID="_personId
	e  d
	.s sqlStr="select BonusValue from dhc_bonus_data.UnitBonusDetail where BonusSchemeItemID="_Id_" and BonusUnitID="_personId_" and BonusYear="_year_" and BonusPeriod='"_period_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		i comeFlag=1 d
		.s value = result.Data("TargetValue")
		e  d
		.s value = result.Data("BonusValue")
	}
	
	q value
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：获取指标的单元
/// Return: 返回值
/// Input：targetId-指标Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetTargetType(75)
ClassMethod GetTargetType(targetId) As %String
{
	n (targetId)
	
	s calName=""
	q:targetId="" calName
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select CalUnitName from dhc_bonus_data.CalUnit where CalUnitID = (select CalUnitID from dhc_bonus_data.BonusTarget where BonusTargetID="_targetId_")")
	d result.Execute()
	
	While(result.Next()){
		s calName = result.Data("CalUnitName")
	}
	
	q calName
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：将混合核算的指标或者项目统一为可以进行独立核算的指标或者项目
/// Return: 返回值：1-独立核算,2-混合核算
/// Input：BonusSchemeCode-奖金方案Code;sBonusPeriod:格式:"BonusYear^BonusPeriod"
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).ChangeBonusScheme("0202","2011^M11")
ClassMethod ChangeBonusScheme(BonusSchemeCode, sBonusPeriod) As %String
{
	n (BonusSchemeCode,sBonusPeriod)
	
	k ^TMPHUAXIBonus("dhc","app","bonus",$j)
	
	q:BonusSchemeCode=""
	q:sBonusPeriod=""
	
	s year = $P(sBonusPeriod,"^",1)
	s period = $P(sBonusPeriod,"^",2)
	
	//根据方案code获取Id
	s schemId=..GetBonusSchemeId(BonusSchemeCode)
	q:schemId=""
	q:schemId=0
	//根据方案Id获取该方案的科室
	s unitStr=..GetUnitOfSchem(schemId)
	q:unitStr=""
	q:unitStr=0
	s unitCount=$L(unitStr,"^")
	//根据方案Id获取方案下的数据级别为人员级别的指标
	s targetStr=..GetTargetOfSchem(schemId)
	q:targetStr=""
	q:targetStr=0
	s targetCount=$L(targetStr,"^")
	
	s date=$ZD($h,3)_" "_$ZT($h,3)
	
	TSTART
	
	//统一核算,即:将人员指标统一到科室
	/*
	f unitIndex=1:1:unitCount d
	.s unitId=$P(unitStr,"^",unitIndex) //获取科室
	.s count=0 //定义该核算单元统计人数的变量
	.s personStr=..GetPersonOfUnit(unitId)
	.s personCount=$L(personStr,"^")
	.f personIndex=1:1:personCount d
	..s personId=$P(personStr,"^",personIndex) //获取人员
	..s count=count+1
	..f targetIndex=1:1:targetCount d
	...s targetId=$P(targetStr,"^",targetIndex) //获取指标
	...s calName=..GetTargetType(targetId) //获取指标的单位
	...s value=..GetValueOfTarget(personId,year,period,schemId,targetId)
	...i calName="百分比" d
	....i $D(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)) d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)=(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)*(count-1)+value)/count
	....e  d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)=value/count
	...e  d
	....i $D(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)) d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)=^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)+value
	....e  d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,unitId,targetId)=value
	*/
	
	//优化改写
	f targetIndex=1:1:targetCount d
	.s targetId=$P(targetStr,"^",targetIndex) //获取指标
	.s calName=..GetTargetType(targetId) //获取指标的单位
	.f unitIndex=1:1:unitCount d
	..s unitId=$P(unitStr,"^",unitIndex) //获取科室
	..s count=0 //定义该核算单元统计人数的变量
	..s personStr=..GetPersonOfUnit(unitId)
	..s personCount=$L(personStr,"^")
	..f personIndex=1:1:personCount d
	...s personId=$P(personStr,"^",personIndex) //获取人员
	...s count=count+1
	...s value=..GetValueOfTarget(personId,year,period,schemId,targetId)
	...i calName="百分比" d
	....i $D(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)) d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)=(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)*(count-1)+value)/count
	....e  d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)=value/count
	...e  d
	....i $D(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)) d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)=^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)+value
	....e  d
	.....s ^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)=value
	
	s rn=0
	
	//将统一到独立核算的指标数据插入到指标数据基础表
	i $D(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period)) d
	.s targetId=0
	.f  s targetId=$O(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId)) q:targetId=""  d
	..s dataSource=..GetDataSource(targetId) //获取指标数据源
	..s unitId=0
	..f  s unitId=$O(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId)) q:unitId=""  d
	...s value=$fn(^TMPHUAXIBonus("dhc","app","bonus",$j,year,period,targetId,unitId),"",4)
	...s res=..InsertData(year,period,unitId,targetId,value,date,dataSource)
	...i res'=0 d
	....s rn=res
	
	i rn'=0 d 
	.TROLLBACK
	E   d
	.TCOMMIT
	
	k ^TMPHUAXIBonus("dhc","app","bonus",$j)
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：获取指标的数据源
/// Return: 返回指标数据源
/// Input：targetId-指标Id
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).GetDataSource(75)
ClassMethod GetDataSource(targetId) As %String
{
	n (targetId)
	
	s dataSource=1
	q:targetId="" dataSource
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select DataSource from dhc_bonus_data.BonusTarget where BonusTargetID="_targetId)
	d result.Execute()
	
	While(result.Next()){
		s dataSource = result.Data("DataSource")
	}
	
	q dataSource
}

/// Creator: 李明忠
/// CreatDate: 2012-12-28
/// Description：向指标数据表插入数据
/// Return: 返回值
/// Input：year-年度;period-期间;unitId-核算单元Id;targetId-指标Id;value-指标值;date-数据插入日期;dataSource-数据源
/// Others：w ##class(dhc.bonus.udata.uInsertBonusSchemCal).InsertData(2011,"M11",475,76,163.0400)
ClassMethod InsertData(year, period, unitId, targetId, value, date, dataSource) As %String
{
	n (year,period,unitId,targetId,value,date,dataSource)
	
	q:year="" 0
	q:period="" 0
	q:unitId="" 0
	q:targetId="" 0
	q:value="" 0
	
	&SQL(Insert into dhc_bonus_data.BonusTargetCollect(BonusYear,BonusPeriod,BonusUnitID,BonusTargetID,TargetValue,UpdateDate,DataSource) values(:year,:period,:unitId,:targetId,:value,:date,:dataSource))

	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uInsertBonus7F1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
