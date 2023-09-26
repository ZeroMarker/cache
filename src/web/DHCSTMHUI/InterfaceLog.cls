Import sqluser

Class web.DHCSTMHUI.InterfaceLog Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:记录医嘱相关接口日志信息
/// Creator：lxt
/// CreateDate：2023-2-1
/// Input：
/// 		LogRowId：日志id，
/// 		TypeInfo：Type^ClassMame^MethodName（记录返回值时，此参数传空）,
/// 		Params：入参（记录返回值时，此参数传空）
/// 		Result：返回值
/// OutPut：LogRowId（日志id），0成功，非0失败
/// ##class(web.DHCSTMHUI.InterfaceLog).Log()
ClassMethod Log(ByRef LogRowId As %String, TypeInfo As %String = "", Params As %String = "", Result As %String = "")
{
	n (LogRowId,TypeInfo,Params,Result)
	s ^templxt("Log")=$lb(LogRowId,TypeInfo,Params,Result)
	
	s (LogType,ClassName,MethodName)=""
	i TypeInfo'="" d
	.s LogType=$p(TypeInfo,"^",1)
	.s ClassName=$p(TypeInfo,"^",2)
	.s MethodName=$p(TypeInfo,"^",3)
	
	s Success="N"
	i (Result'="") d
	.i ((Result>=0)||(Result="Y")) d
	..s Success="Y"
	.e  d
	..s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	..d PJobj.%FromJSON(Result)
	..s Success=PJobj.%Get("success")
	..i Success=0 s Success="Y"
	
	i $g(LogRowId)="" d
	.s obj=##class(HRP.MAT.InterfaceLog).%New()
	.s obj.LogType=LogType
	.s obj.LogClass=ClassName
	.s obj.LogMethod=MethodName
	.s obj.LogParams=Params
	.s obj.LogDate=+$h
	.s obj.LogTime=$P($h,",",2)
	.s obj.LogSuccess=Success
	e  d
	.s obj=##class(HRP.MAT.InterfaceLog).%OpenId(LogRowId)
	.d obj.%Reload()
	.s obj.LogRet=Result
	.s obj.LogRetDate=+$h
	.s obj.LogRetTime=$P($h,",",2)
	.s obj.LogSuccess=Success
	s sc=obj.%Save()
	q:$$$ISERR(sc) -1
	s LogRowId=obj.%Id()
	q 0
}

}
