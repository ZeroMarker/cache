Import sqluser

/// 查询接口日志
/// 2021-04-08
Class web.DHCSTMHUI.GetDataExchangeLog Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   查询接口日志
/// Creator:	wxj
/// Date: 		20210407
/// Table:	DHC_DataExchangeLog
/// w ##class(web.DHCSTMHUI.GetDataExchangeLog).QueryLog("1","15","{""StartDate"":""2022-10-13"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""59996"",""EndDate"":""2022-10-14"",""Type"":"""",""MethodName"":"""",""ParamValue"":"""",""StartTime"":"""",""EndTime"":"""",""BDPHospital"":""2""}")
ClassMethod QueryLog(page As %String, rows As %String, Params As %String) As %String
{
	n (page,rows,Params,%session)
	s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	
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
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count=0
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
	...s count = count+1
	...q:count<=Start
	...q:count>End
	...
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
	...s Data1=LogId_"^"_LogType_"^"_LogClassName_"^"_LogMethodName_"^"_LogParams_"^"_LogResult
	...s Data2=LogParamsDate_"^"_LogParamsTime_"^"_LogResultDate_"^"_LogResultTime_"^"_LogSuccess
	...s Data3=LogParamsDateTime_"^"_LogResultDateTime_"^"_LogSendAgain
	...s Data=Data1_"^"_Data2_"^"_Data3
	...
	...d json.InsertRowData(Data)
	s Title="LogId^LogType^LogClassName^LogMethodName^LogParams^LogResult"
		_"^LogParamsDate^LogParamsTime^LogResultDate^LogResultTime^LogSuccess"
		_"^LogParamsDateTime^LogResultDateTime^LogSendAgain"
	d json.getJsonData(Title,count)
	k json
	q ""
}

/// Descript:  获取接口类型
/// Creator:	wxj
/// Date: 		20210407
/// Table:	DHC_DataExchangeLog
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.GetDataExchangeLog","GetLogType")
Query GetLogType(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLogTypeExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s LogType=""
	f  s LogType=$o(^User.DHCDataExchangeLogI("IndexLogType",LogType)) q:LogType=""  d
	.s (RowId,Description)=""
	.i (+LogType=LogType)&&($d(^User.DHCServiceConfigD(+LogType))) d //有配置表时
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",LogType,pHospId)
	..q:ShowDataFlag="N"
	..s SCInfo=^User.DHCServiceConfigD(LogType)
	..s UseFlag=$list(SCInfo,6)
	..q:UseFlag'="Y"
	..s RowId=LogType
	..s Description=$list(SCInfo,2)
	.e  d			//没有配置表时
	..s RowId=LogType
	..s Description=LogType
	.q:RowId=""
	.d OutPutLogType
	Quit $$$OK
	
OutPutLogType
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:  获取接口方法名
/// Creator:	wxj
/// Date: 		20210407
/// Table:	DHC_DataExchangeLog
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.GetDataExchangeLog","GetLogMethodName","ECS")
Query GetLogMethodName(LogType) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLogMethodNameExecute(ByRef qHandle As %Binary, LogType) As %Status
{
	n (qHandle,LogType,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s MethodName=""
	f  s MethodName=$o(^User.DHCDataExchangeLogI("IndexLogTypeMethodName",LogType,MethodName)) q:MethodName=""  d
	.s RowId=MethodName
	.s Description=MethodName
	.d OutPutMethodName
	Quit $$$OK
OutPutMethodName
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	重新发送接口信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.GetDataExchangeLog).jsSend(124)
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
	s LogParams=LogObj.LogParams.Read()
	s LogObj.LogSendAgain="Y"	//更新重新发送标志
	s sc=LogObj.%Save()
	q:$$$ISERR(sc) RtnObj.Err(-7,"","更新重新发送标志失败")
	
	try{
		s ExecuteStr="Set Ret=$CLASSMETHOD("_$c(34)_LogClassName_$c(34)_","_$c(34)_LogMethodName_$c(34)
		s ParamLen=$l(LogParams,";")
		f i=1:1:ParamLen d
		.s ExecuteStr=ExecuteStr_","_$c(34)_$p(LogParams,";",i)_$c(34)
		s ExecuteStr=ExecuteStr_")"
		x ExecuteStr
	}catch{
		d RtnObj.Err(-1,"","发送失败！")
	}
	q RtnObj
}

}
