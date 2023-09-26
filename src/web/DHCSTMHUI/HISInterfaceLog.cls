Import sqluser

/// 查询HIS接口日志(与医生站、计费、基础数据平台等产品组交互接口)
/// 2023-03-06
Class web.DHCSTMHUI.HISInterfaceLog Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   查询接口日志
/// Creator:	wxj
/// Date: 		2023-03-06
/// Table:	DHC_DataExchangeLog
/// w ##class(web.DHCSTMHUI.HISInterfaceLog).QueryLog("1","15","{""StartDate"":""2022-10-13"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""59996"",""EndDate"":""2022-10-14"",""Type"":"""",""MethodName"":"""",""ParamValue"":"""",""StartTime"":"""",""EndTime"":"""",""BDPHospital"":""2""}")
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
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PType=PJObj.%Get("Type")
	s PMethodName=PJObj.%Get("MethodName")
	s PParamValue=PJObj.%Get("ParamValue")
	
	q:PStartDate="" $$$NullJson
	q:PEndDate="" $$$NullJson
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	q:(PStartDate'="")&&(PEndDate'="")&&(PStartDate>PEndDate) $$$NullJson	;开始日期不能晚于截止日期
	q:(PStartDate=PEndDate)&&(PStartTime'="")&&(PEndTime'="")&&(PStartTime>PEndTime) $$$NullJson	;截止时间不能早于开始时间
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count=0
	f Date=PStartDate:1:PEndDate d
	.s LogId=""
	.f  s LogId=$o(^HRP.MAT.InterfaceLogI("DateType",Date,"HIS",LogId)) q:LogId=""  d
	..s LogObj=##class(HRP.MAT.InterfaceLog).%OpenId(LogId)
	..s Type=LogObj.LogType
	..s ClassName=LogObj.LogClass
	..s MethodName=LogObj.LogMethod
	..s Params=LogObj.LogParams
	..s Result=LogObj.LogRet
	..s ParamsDate=LogObj.LogDate
	..s ParamsTime=LogObj.LogTime
	..s ResultDate=LogObj.LogRetDate
	..s ResultTime=LogObj.LogRetTime
	..s Success=LogObj.LogSuccess
	..
	..q:(PMethodName'="")&&(PMethodName'=MethodName)
	..q:(Date=PStartDate)&&(PStartTime'="")&&(ParamsTime<PStartTime)
	..q:(Date=PEndDate)&&(PEndTime'="")&&(ParamsTime>PEndTime)
	..q:(PParamValue'="")&&(Params'[PParamValue)
	..s count = count+1
	..q:count<=Start
	..q:count>End
	..s:ParamsDate'="" ParamsDate=..DL2H(ParamsDate)
	..s:ResultDate'="" ResultDate=..DL2H(ResultDate)
	..s:ParamsTime'="" ParamsTime=..TL2H(ParamsTime)
	..s:ResultTime'="" ResultTime=..TL2H(ResultTime)
	..s ParamsDateTime=ParamsDate_" "_ParamsTime
	..s ResultDateTime=ResultDate_" "_ResultTime
	..s Data1=LogId_"^"_Type_"^"_ClassName_"^"_MethodName_"^"_Params_"^"_Result
	..s Data2=ParamsDate_"^"_ParamsTime_"^"_ResultDate_"^"_ResultTime_"^"_Success
	..s Data3=ParamsDateTime_"^"_ResultDateTime
	..s Data=Data1_"^"_Data2_"^"_Data3
	..
	..d json.InsertRowData(Data)
	s Title="LogId^Type^ClassName^MethodName^Params^Result"
		_"^ParamsDate^ParamsTime^ResultDate^ResultTime^Success"
		_"^ParamsDateTime^ResultDateTime"
	d json.getJsonData(Title,count)
	k json
	q ""
}

/// Descript:  获取接口方法名
/// Creator:	wxj
/// Date: 		2023-03-06
/// Table:	DHC_DataExchangeLog
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HISInterfaceLog","GetLogMethodName")
Query GetLogMethodName() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLogMethodNameExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s MethodName=""
	f  s MethodName=$o(^HRP.MAT.InterfaceLogI("Method",MethodName)) q:MethodName=""  d
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

}
