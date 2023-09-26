/// Creator: wang ying
/// CreatDate: 2015-5-6
/// Description: 自动从jxbasedata表采集数据设置目标值
Class dhc.pa.udata.uSetKPITarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2015-5-6
/// Description: 导入同期类型的目标值
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uSetKPITarget).samePerion("201501",5,"M",2,2,"1||7||27","001^床均出院病人数^001-床均出院病人数^^1^≥三年同期均值 8.88 2.5；＜三年同期均值 8.88 1.5；＜三年同期最低值 8.66 0^^7^H^""<35>/<83>""^^2^I^^2^N^Y^N^N^N^0^1^N^Y^1^Y^^",3)
ClassMethod samePerion(period, jxUnitDr, periodType, KPIDr, colTypeDr, URDetailRowid, KPIStr) As %String
{
	n (period,jxUnitDr,periodType,KPIDr,colTypeDr, URDetailRowid,KPIStr)
	
	s actValue=0,maxVaule=0,SQLCODE=0,sumValue=0
	s extremum=$p(KPIStr,"^",9)
	q:'$d(^DHCCJXPAKPITargetI("IndexTarget",1,KPIDr))
	s KPITargetDr=$o(^DHCCJXPAKPITargetI("IndexTarget",1,KPIDr,0))
	i KPITargetDr'="" d
	.s Coefficient=$LIST($G(^DHCCJXPAKPITargetD(KPITargetDr)),5)
	s year=$e(period,1,4)
	s endYear=year-Coefficient-1
	s fristPerion=endYear+1_$e(period,5,6)
	i colTypeDr'=2 s minVaule=..firstValue(fristPerion,jxUnitDr, periodType,KPIDr)
	e  s minVaule=..firstExpValue(fristPerion,jxUnitDr, periodType, KPIDr, KPIStr)
	s perPerion=endYear
	f  s endYear=endYear+1  q:endYear>=year  d
	.s samePeriod=endYear_$e(period,5,6)
	.i colTypeDr'=2 d
	..i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr)) d
	...s dataRowid=0
	...f  s dataRowid=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr,dataRowid)) q:dataRowid=""  d
	....q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid))
	....s currValue=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid)),"^",4)
	....i currValue>maxVaule s maxVaule=currValue
	....i currValue<minVaule s minVaule=currValue
	....i currValue=0 
	....s actValue=currValue+actValue
	.e  d
	..s calUnitName="",actValue=0
	..s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	..s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	..;i KPIDr=2 b 
	..i expression'="" d
	...s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,samePeriod,periodType)) //调用公式转换方法
	...s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	...;i KPIDr=2 b
	...i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	....s actValue=100
	...i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	....s actValue=0
	....i $fn(mark,"",2)="" d
	.....s actValue=0
	....e  s actValue=mark
	....i calUnitName="百分比" s actValue=actValue*100
	....i actValue>maxVaule s maxVaule=actValue
	....i actValue<minVaule s minVaule=actValue
	....s sumValue=actValue+sumValue
	i colTypeDr=2 s actValue=sumValue
	s actValue=actValue/Coefficient
	i extremum="H" s bValue=maxVaule,baseValue=actValue
	i extremum="L" s bValue=minVaule,baseValue=actValue
	;w actValue," minVaule="_minVaule," maxVaule="_maxVaule,!
	;w actValue," bValue="_bValue," baseValue="_baseValue,!
	&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:actValue,UnitResultDetail_baseValue=:baseValue,UnitResultDetail_bValue=:bValue where UnitResultDetail_rowid=:URDetailRowid)
	i SQLCODE'=0 d //2014-12-09 update
	.d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailSamePeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_actValue,SQLCODE,"")
    q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2015-5-6
/// Description: 导入平均值类型的目标值
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uSetKPITarget).AvgValuePerion("M")
ClassMethod AvgValuePerion(period, jxUnitDr, periodType, KPIDr, colTypeDr, URDetailRowid) As %String
{
	n (period,jxUnitDr,periodType,KPIDr)
	
	...s i=-1,n=0
	...s sumValue=0,avgValue=0,len=0,calUnitName=""
	...i periodType="M"  s len=12
	...i periodType="Q"  s len=4
	...i periodType="H"  s len=2
	...i periodType="Y"  s len=0
	...f  s i=i+1  q:i>len  d
	....s avgPeriod=0
	....i i<10 d
	.....s avgPeriod=$e(period,1,4)-1_"0"_i
	....e  s avgPeriod=$e(period,1,4)-1_i
	....i colTypeDr'=2 d
	.....i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr)) d
	......s dataAvg=0
	......f  s dataAvg=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,avgPeriod,periodType,KPIDr,dataAvg)) q:dataAvg=""  d
	.......q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg))
	.......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1
	.......s Value=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataAvg)),"^",4)
	.......s sumValue=sumValue+Value
	....e  d
	.....s calUnitName="",actValue=0
	.....s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	.....s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	.....i expression'="" d
	......s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,avgPeriod,periodType)) //调用公式转换方法
	......s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	......i (periodType'="Y")&&($e(avgPeriod,5,6)="00") s mark=0 //2015-01-20 add
	......;i KPIDr=7 b
	......i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	.......s actValue=1
	......i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	.......s actValue=0
	.......i $fn(mark,"",2)="" d
	........s actValue=0
	.......e  s actValue=mark
	......i '((periodType'="Y")&&($e(avgPeriod,5,6)="00")) s n=n+1  //2015-01-20 add
	......s sumValue=sumValue+actValue
	...i n=0 s avgValue=sumValue
	...e  s avgValue=sumValue/n
	...;i KPIDr=7 b
	...i calUnitName="百分比" s avgValue=avgValue*100
	...&SQL(Update dhc_pa_data.UnitResultDetail set UnitResultDetail_tValue=:avgValue where UnitResultDetail_rowid=:URDetailRowid)
	...i SQLCODE'=0 d //2014-12-09 update
	....d ##class(dhc.pa.udata.uPALogger).Insert("updateURDetailAvgPeriod",period_"^"_periodType_"^"_URDetailRowid_"^"_avgValue,SQLCODE,"")
}

/// Creator：wang ying
/// CreatDate：2015-5-24
/// Description: 导入平均值类型的目标值
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uSetKPITarget).firstValue("201201",5,"M",35)
ClassMethod firstValue(samePeriod, jxUnitDr, periodType, KPIDr) As %String
{
	n (samePeriod,jxUnitDr,periodType,KPIDr)
	s currValue=0
	i $d(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr)) d
	.s dataRowid=0
	.f  s dataRowid=$o(^DHCCJXPAJXUNIT(0,"JXBDPeriodKPI",jxUnitDr,samePeriod,periodType,KPIDr,dataRowid)) q:dataRowid=""  d
	..q:'$d(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid))
	..s currValue=$p($g(^DHCCJXPAJXUNIT(jxUnitDr,"JXBaseData",dataRowid)),"^",4)+currValue
	q currValue
}

/// Creator：wang ying
/// CreatDate：2015-5-24
/// Description: 导入平均值类型的目标值
/// Table：
/// Input：
/// Output：
/// Return：成功或失败标志
/// Others：w ##class(dhc.pa.udata.uSetKPITarget).firstExpValue("201201",5,"M",2,"001^床均出院病人数^001-床均出院病人数^^1^≥三年同期均值 8.88 2.5；＜三年同期均值 8.88 1.5；＜三年同期最低值 8.66 0^^7^H^""<35>/<83>""^^2^I^^2^N^Y^N^N^N^0^1^N^Y^1^Y^^")
ClassMethod firstExpValue(samePeriod, jxUnitDr, periodType, KPIDr, KPIStr) As %String
{
	n (samePeriod,jxUnitDr,periodType,KPIDr,KPIStr)
	s actValue=0
	s extremum=$p(KPIStr,"^",9)	
	s calUnitName="",actValue=0,sumValue=0
	s calUnitName=$P(^DHCCJXPACALUNIT($p(KPIStr,"^",8)),"^",2)
	s expression= ##class(dhc.pa.udata.uCalculator).GetKPIExpression(KPIDr) //获取该指标的计算公式
	i expression'="" d
	.s expression=##class(dhc.pa.udata.uCalculator).TransStr2(##class(dhc.pa.udata.uCalculator).TransStr(expression,jxUnitDr,samePeriod,periodType)) //调用公式转换方法
	.s mark= $$Express^Calculator(expression) //需要对expression进行验证并求职
	.i (mark="<DIVIDE>")&&(extremum="H")&&(calUnitName="百分比") d //分母为0  实际值默认值为100
	..s actValue=100
	.i (mark'="<SYNTAX>")&&(mark'="<DIVIDE>") d //mark可能是最终值、也可能是错误信息
	..s actValue=0
	..i $fn(mark,"",2)="" d
	...s actValue=0
	..e  s actValue=mark
	..i calUnitName="百分比" s actValue=actValue*100
	q actValue
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSetKPITargetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
