Import sqluser

Class web.CSSDHUI.System.ReasonForSteriFail Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 灭菌不合格原因
/// 保存灭菌不合格原因信息
/// w ##class(web.CSSDHUI.System.ReasonForSteriFail).jsSave()
ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 灭菌不合格原因
/// 保存灭菌不合格原因信息
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params, Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s SteReasonId=Obj.%Get("RowId")
		s SteReasonCode=Obj.%Get("SteReasonCode")
		s SteReasonDesc=Obj.%Get("SteReasonDesc")
		s UseFlag=Obj.%Get("UseFlag")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",SteReasonCode,"CSSD_SteCheckReason",PHospId,SteReasonId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SteReasonDesc,"CSSD_SteCheckReason",PHospId,SteReasonId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在!")
		continue:RtnObj.success'=0

		i SteReasonId="" d
		.s SteReasonObj=##class(User.CSSDSteCheckReason).%New()
		e  d
		.s SteReasonObj=##class(User.CSSDSteCheckReason).%OpenId(SteReasonId)
		.d SteReasonObj.%Reload()
		s SteReasonObj.CSSDSteFailCode=SteReasonCode
		s SteReasonObj.CSSDSteFailDesc=SteReasonDesc
		s SteReasonObj.CSSDSNotUseFlag=UseFlag
		s Sc=SteReasonObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0
		s SteReasonId=SteReasonObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_SteCheckReason",SteReasonId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除清洗不合格原因
/// w ##class(web.CSSDHUI.System.ReasonForSteriFail).jsDelete()
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Return:		RtnObj
/// Description:删除灭菌不合格原因
/// Creator:	qiushengxin
/// Date:		2019-04-12
/// Input:		Params
/// Output:		RtnObj
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s SteReasonId=Obj.%Get("RowId")
		continue:SteReasonId=""
		&sql(delete from CSSD_SteCheckReason where %ID=:SteReasonId)
		i SQLCODE'=0 d RtnObj.Err(-2,SteReasonId,MethodName_":处理CSSD_SteCheckReason失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_SteCheckReason",SteReasonId)
		i ret'=0 d RtnObj.Err(-3,SteReasonId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// 灭菌不合格原因
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.ReasonForSteriFail","SelectAllReasonForSteriFail")
Query SelectAllReasonForSteriFail(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SteReasonCode,SteReasonDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllReasonForSteriFailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT %ID As RowId, CSSD_SteFailCode,CSSD_SteFailDesc,CSSDS_NotUseFlag "
			_" FROM CSSD_SteCheckReason "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s SteReasonCode = Result.Data("CSSD_SteFailCode")
		s SteReasonDesc = Result.Data("CSSD_SteFailDesc")
		s UseFlag = Result.Data("CSSDS_NotUseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SteCheckReason",RowId,PHospId)
		continue:ret="N"
		d OutPutRowReasonForSteriFail
	}
	d Result.Close()
	Quit $$$OK
OutPutRowReasonForSteriFail
	s Data=$lb(RowId,SteReasonCode,SteReasonDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
