/// Creator: wang ying
/// CreatDate: 2011-1-4
/// Description: 基本数据功能扩展
Class dhc.pa.udata.uJXBaseDataBusiness Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2011-1-4
/// Description: 根据绩效单元与KPI指标进行笛卡尔积初始化
/// Table：dhc_pa_data.JXBaseData
/// Input：unitStr-绩效单元串,KPIStr-指标串
/// Output：
/// Return：
/// Others：w ##class(dhc.pa.udata.uJXBaseDataBusiness).init("10,12,13^201101^M^1,2,3")
ClassMethod init(data) As %String
{
	n (data)
	;w $zt($p($h,",",2)),!
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	s unitStr=$p(data,"^",1)
	s period=$p(data,"^",2)	
	s periodType=$p(data,"^",3)
	s KPIStr=$p(data,"^",4)
	
	s $ZT="initERRO"
	s SQLCODE=0
	TSTART
	s unitLen=$l(unitStr,",")
	s KPILen=$l(KPIStr,",")
	f i=1:1:unitLen d
	.f j=1:1:KPILen d
	..s jxUnitDr=$p(unitStr,",",i)
	..s kpidr=$p(KPIStr,",",j)
	..s actualValue=0
	..s state=-1
	..i jxUnitDr'="" s PLIST(0)=jxUnitDr 
	..i period'="" s PLIST(3)=period
	..i periodType'="" s PLIST(4)=periodType
	..i kpidr'="" s PLIST(5)=kpidr
	..i ##class(dhc.pa.udata.uJXBaseData).IfRepRecode(jxUnitDr,period,kpidr,periodType)'="" q:"RepRecode"  
	..i actualValue'="" s PLIST(6)=actualValue
	..i state'="" s PLIST(9)=state
	..&SQL(insert into dhc_pa_data.JXBaseData VALUES PLIST())
	..i SQLCODE TROLLBACK
    TCOMMIT
    ;w $zt($p($h,",",2)),!
    q SQLCODE
initERRO
    Set ErrorMsg=$ZE	//得到系统返回的错误消息
 	TROLLBACK		    //回滚事务
 	Quit SQLCODE       //返回错误消息 ;
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXBaseDataB758S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
