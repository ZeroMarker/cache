Import sqluser

/// 查询接口日志
/// 2021-04-08
Class web.DHCSTMHUI.InsuDataUpLoadLog Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Query QueryLog(Params As %String) As Query(ROWSPEC = "LogId,LogType,LogClassName,LogMethodName,LogParams,LogResult,LogParamsDate,LogParamsTime,LogResultDate,LogResultTime,LogSuccess,LogParamsDateTime,LogResultDateTime,LogSendAgain")
{
}

ClassMethod QueryLogExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StartTime=PJObj.%Get("StartTime")
	s EndTime=PJObj.%Get("EndTime")
	s pType=PJObj.%Get("Type")
	s MethodName=PJObj.%Get("MethodName")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pParamValue=PJObj.%Get("ParamValue")
	s Status=PJObj.%Get("Status")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	q:StartDate="" $$$NullJson
	q:EndDate="" $$$NullJson
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:StartDate'="" EndDate=..DH2L(EndDate)
	s:StartTime'="" StartTime=..TH2L(StartTime)
	s:EndTime'="" EndTime=..TH2L(EndTime)
	s:StartTime="86399" StartTime=""
	s:EndTime="86399" EndTime=""
	q:(StartDate'="")&&(EndDate'="")&&(StartDate>EndDate) $$$NullJson	;开始日期不能晚于截止日期
	q:(StartTime'="")&&(EndTime'="")&&(StartTime>EndTime) $$$NullJson	;截止时间不能早于开始时间
	f Date=StartDate:1:EndDate d
	.s Type=""
	.f  s Type=$o(^User.DHCDataExchangeLogI("IndexLogTypeParamsDate",Date,Type)) q:Type=""  d
	..q:(pType'="")&&(pType'=Type)
	..s ShowDataFlag="Y",LogType=""
	..i (+Type=Type)&&($d(^User.DHCServiceConfigD(+Type))) d	//有配置表时
	...s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",Type,pHospId)
	...q:ShowDataFlag="N"
	...s SCInfo=^User.DHCServiceConfigD(Type)
	...s UseFlag=$list(SCInfo,6)
	...q:UseFlag'="Y"
	...s LogType=$list(SCInfo,2)
	..e  d	//没有配置表时
	...s LogType=Type
	..s LogId=""
	..f  s LogId=$o(^User.DHCDataExchangeLogI("IndexLogTypeParamsDate",Date,Type,LogId)) q:LogId=""  d
	...s LogObj=##class(User.DHCDataExchangeLog).%OpenId(LogId)
	...s LogClassName=LogObj.LogClassName
	...s LogMethodName=LogObj.LogMethodName
	...s Params=LogObj.LogParams
	...s Result=LogObj.LogResult
	...q:(Status="Y")&&(Result'="Y")
	...q:(Status="N")&&(Result="Y")
	...s LogParamsDate=LogObj.LogParamsDate
	...s LogParamsTime=LogObj.LogParamsTime
	...s LogResultDate=LogObj.LogResultDate
	...s LogResultTime=LogObj.LogResultTime
	...s LogSuccess=LogObj.LogSuccess
	...s LogSendAgain=LogObj.LogSendAgain
	...i LogSendAgain="" s LogSendAgain="N"
	...q:LogSendAgain="Y"	//重新发送后只展示新日志
	...
	...q:(MethodName'="")&&(MethodName'=LogMethodName)
	...q:(Date=StartDate)&&(StartTime'="")&&(LogParamsTime<StartTime)
	...q:(Date=EndDate)&&(EndTime'="")&&(LogParamsTime>EndTime)
	...s LogParams=Params.Read()
	...q:(pParamValue'="")&&(LogParams'[pParamValue)
	...s LogResult=Result.Read()
	...s LogParams=$tr(LogParams,"^"," ")
	...s LogResult=$tr(LogResult,"^"," ")
	...s:LogParamsDate'="" LogParamsDate=..DL2H(LogParamsDate)
	...s:LogResultDate'="" LogResultDate=..DL2H(LogResultDate)
	...s:LogParamsTime'="" LogParamsTime=..TL2H(LogParamsTime)
	...s:LogResultTime'="" LogResultTime=..TL2H(LogResultTime)
	...
	...s IsJsonParams=($e(LogParams,1)="{")||($e(LogParams,1)="[")
	...s IsJsonResult=($e(LogResult,1)="{")||($e(LogResult,1)="[")
	...i IsJsonParams s LogParams=" "_LogParams			;如果是json,加一个空格,避免后续组织json时按object返回
	...e  s LogParams=$replace(LogParams,"<","< ")		;处理<,后面添加空格,否则显示时html处理看不到xml标签
	...i IsJsonResult s LogResult=" "_LogResult
	...e  s LogResult=$replace(LogResult,"<","< ")
	...
	...s LogParamsDateTime=LogParamsDate_" "_LogParamsTime
	...s LogResultDateTime=LogResultDate_" "_LogResultTime
	...s Data=$lb(LogId,LogType,LogClassName,LogMethodName,LogParams,LogResult,LogParamsDate,LogParamsTime,LogResultDate,LogResultTime,LogSuccess,LogParamsDateTime,LogResultDateTime,LogSendAgain)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	...
	Quit $$$OK
}

/// Descript:	重新发送接口信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.InsuDataUpLoadLog).jsSend(124)
ClassMethod jsSend(LogId As %String) As %String
{
	n (LogId)
	s $ZT=..sssError()
	ts
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Send(LogId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 重新发送
/// w ##class(web.DHCSTMHUI.InsuDataUpLoadLog).Send(108)
ClassMethod Send(LogId As %String) As RtnObj
{
	n (LogId)
	s RtnObj=##class(RtnObj).%New()
	i LogId="" d RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s LogObj=##class(User.DHCDataExchangeLog).%OpenId(LogId)
	s LogType=LogObj.LogType
	s LogClassName=LogObj.LogClassName
	s LogMethodName=LogObj.LogMethodName
	s HospId=LogObj.HOSPID
	s LogParams=LogObj.LogParams
	try{
		s res=$CLASSMETHOD(LogClassName,LogMethodName,LogParams,HospId)
		d ##class(web.DHCSTMHUI.InsuMatCodeUpload).SaveLog(LogId,res,"","","","",HospId)
	}catch{
		d RtnObj.Err(-1,"","发送失败！")
	}
	q RtnObj
}

}
