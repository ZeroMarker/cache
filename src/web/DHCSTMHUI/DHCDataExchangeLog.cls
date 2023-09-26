Import sqluser

/// 接口数据交互Log
/// 2018-12-28
Class web.DHCSTMHUI.DHCDataExchangeLog Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 记录日志
/// LogRowId	日志Id 引用类型
/// Result		Success_Result Success(0,Y)表示成功+接口返回值		
/// 	LogType		日志类型
/// 	ClassName	类名
/// MethodName	方法名
/// Params		接口参数
/// d hisOrderWebObj.XMLExportToString(.Xml)
/// d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"","SCI",$ZNAME,"SendOrderToSCM",Xml)
/// s operateResultObj=HisInfoServiceObj.getHopOrder(hisOrderWebObj)
/// d operateResultObj.XMLExportToString(.Xml)
/// d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log()
ClassMethod Log(ByRef LogRowId As %String, Result As %String = "", LogType As %String = "", ClassName As %String = "", MethodName As %String = "", Params As %String = "")
{
	n (LogRowId,Result,LogType,ClassName,MethodName,Params)
	
	i (LogType="")&&(LogRowId'="") d
	.s LogType=$list(^User.DHCDataExchangeLogD(LogRowId),2)
	s Success="N",LogTypeDesc=""
	i Result'="" d
	.i (+LogType=LogType)&&($d(^User.DHCServiceConfigD(+LogType))) d	//当传入LogType为配置表id且配置表存在当前配置时，取配置表里接口类型
	..s LogTypeDesc=$list(^User.DHCServiceConfigD(LogType),2)
	.e  d
	..s LogTypeDesc=LogType	//当没有配置表的时候，传入的为接口类型
	.i LogTypeDesc="ECS" d
	..s ResultCode={}.%FromJSON(Result).%Get("state")
	..i ResultCode=1 s Success="Y"
	.e  d
	..s ResultCode=$e(Result)
	..i (ResultCode=0)||(ResultCode="Y") s Success="Y"
	
	;Result,Params,按流处理
	s Result=$$GetStream(Result)
	s Params=$$GetStream(Params)
	s ServerIP=""	//##class(web.DHCSTMHUI.Common.UtilCommon).ServerIP()	//Linux环境下执行慢
	
	i $g(LogRowId)="" d
	.s obj=##class(User.DHCDataExchangeLog).%New()
	.s obj.LogClassName=ClassName
	.s obj.LogMethodName=MethodName
	.s obj.LogType=LogType
	.s obj.LogParams=Params
	.s obj.LogParamsDate=+$h
	.s obj.LogParamsTime=$P($h,",",2)
	.s obj.LogResult=Result
	.s obj.LogResultDate=+$h
	.s obj.LogResultTime=$P($h,",",2)
	.s obj.LogSuccess=Success
	.s obj.LogIP=ServerIP
	e  d
	.s obj=##class(User.DHCDataExchangeLog).%OpenId(LogRowId)
	.d obj.%Reload()
	.s obj.LogResult=Result
	.s obj.LogResultDate=+$h
	.s obj.LogResultTime=$P($h,",",2)
	.s obj.LogSuccess=Success
	s sc=obj.%Save()
	s LogRowId=obj.%Id()
	q sc
	
GetStream(Str)
	n (Str)
	s Stream=##class(%GlobalCharacterStream).%New()
	i $ISOBJECT(Str) d
	.d Stream.CopyFrom(Str)
	e  d
	.q:Str=""
	.d Stream.Write(Str)
	q Stream
}

/// 获取日志中记录的入参
/// w ##class(web.DHCSTMHUI.DHCDataExchangeLog).Get(3264)
ClassMethod Get(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	s StreamId=$lg(^User.DHCDataExchangeLogD(RowId),5)
	q:StreamId="" ""
	s Str=^User.DHCDataExchangeLogS(StreamId,1)
	q Str
}

/// 获取日志中记录的返回值
/// w ##class(web.DHCSTMHUI.DHCDataExchangeLog).GetResult(3264)
ClassMethod GetResult(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	s StreamId=$lg(^User.DHCDataExchangeLogD(RowId),6)
	q:StreamId="" ""
	s Str=^User.DHCDataExchangeLogS(StreamId,1)
	q Str
}

}
