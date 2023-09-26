Class web.DHCEkg.Base Extends %RegisteredObject
{

/// Creator：		yangyali
/// CreatDate：		2020-07-16
/// Description:	记录global日志，并清理一周以前的global
/// Input：			日志类型(Log/Error)，类名，方法名，日期，时间，日志内容，可变参数1，可变参数2
/// Return：       
/// Others：		规定临时global格式：^tmpDHCEKG(类型,类名,方法名,日期,时间...)=日志内容
/// w ##class(web.DHCEkg.Base).Log(日志类型(Log/Error)，类名，方法名，日期，时间，日志内容，可变参数1，可变参数2)
ClassMethod Log(logType As %String, ClassName As %String, MethodName As %String, logDate As %String, logTime As %String, logdata As %String(MAXLEN=32767), param1 = "", param2 = "")
{
	S logType=$G(logType),ClassName=$G(ClassName),MethodName=$G(MethodName),logDate=$G(logDate),logTime=$G(logTime),param1=$G(param1),param2=$G(param2),logdata=$G(logdata)
	Q:'$L(logType) 0 ;日志类型不能为空
	Q:'$L(ClassName) 0 ;类名不能为空
	Q:'$L(MethodName) 0 ;方法名不能为空
	Q:'$L(logDate) 0 ;日期不能为空
	Q:'$L(logTime) 0 ;时间不能为空
	;b ; w 
	if ($L(param1)>0)&&($L(param2)>0) ;参数1和参数2都有值
	{
		S ^tmpDHCEKG(logType,ClassName,MethodName,logDate,logTime,param1,param2)=logdata
	}
	elseif ($L(param1)>0) ;参数1有值
	{
		S ^tmpDHCEKG(logType,ClassName,MethodName,logDate,logTime,param1)=logdata
	}
	else ;没有参数1和参数2
	{
		S ^tmpDHCEKG(logType,ClassName,MethodName,logDate,logTime)=logdata
	}
	s curDate=$P($H,",",1)
	S CurLogDate=""
	F 
	{
		S CurLogDate=$O(^tmpDHCEKG(logType,ClassName,MethodName,CurLogDate))
		Q:'$l(CurLogDate)
		S LogicData=$ZDH(CurLogDate,3)
		K:LogicData<(curDate-7) ^tmpDHCEKG(logType,ClassName,MethodName,CurLogDate)	
	}
	
	Q $$$OK
}

}
