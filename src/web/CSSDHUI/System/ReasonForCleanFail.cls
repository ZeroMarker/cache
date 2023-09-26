Import sqluser

Class web.CSSDHUI.System.ReasonForCleanFail Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 清洗不合格原因
/// 保存清洗不合格原因信息
/// w ##class(web.CSSDHUI.System.CleanType).jsSave()
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

/// 清洗不合格原因
/// 保存清洗不合格原因信息
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

		s CleanReasonId=Obj.%Get("RowId")
		s CleanReasonCode=Obj.%Get("CleanReasonCode")
		s CleanReasonDesc=Obj.%Get("CleanReasonDesc")
		s UseFlag=Obj.%Get("UseFlag")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",CleanReasonCode,"CSSD_CleanItmReason",PHospId,CleanReasonId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",CleanReasonDesc,"CSSD_CleanItmReason",PHospId,CleanReasonId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在!")
		continue:RtnObj.success'=0

		i CleanReasonId="" d
		.s CleanReasonObj=##class(User.CSSDCleanItmReason).%New()
		e  d
		.s CleanReasonObj=##class(User.CSSDCleanItmReason).%OpenId(CleanReasonId)
		.d CleanReasonObj.%Reload()
		s CleanReasonObj.CSSDRejectCode=CleanReasonCode
		s CleanReasonObj.CSSDRejectDesc=CleanReasonDesc
		s CleanReasonObj.CSSDCNotUseFlag=UseFlag
		s Sc=CleanReasonObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0
		s CleanReasonId=CleanReasonObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CleanItmReason",CleanReasonId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除清洗不合格原因
/// w ##class(web.CSSDHUI.System.ReasonForCleanFail).jsDelete()
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
/// Description:删除清洗不合格原因
/// Creator:	qiushengxin
/// Date:		2019-04-12
/// Table:		CSSD_CleanItmReason
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

		s CleanReasonId=Obj.%Get("RowId")
		continue:CleanReasonId=""

		&sql(delete from CSSD_CleanItmReason where %ID=:CleanReasonId)
		i SQLCODE'=0 d RtnObj.Err(-2,CleanReasonId,MethodName_":处理CSSD_CleanItmReason失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_CleanItmReason",CleanReasonId)
		i ret'=0 d RtnObj.Err(-3,CleanReasonId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// 清洗不合格原因
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.ReasonForCleanFail","SelectAllReasonForSteriFail")
Query SelectAllReasonForCleanFail(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanReasonCode,CleanReasonDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllReasonForCleanFailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT %ID As RowId, CSSD_RejectCode,CSSD_RejectDesc,CSSDC_NotUseFlag "
			_" FROM SQLUser.CSSD_CleanItmReason "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s CleanReasonCode = Result.Data("CSSD_RejectCode")
		s CleanReasonDesc = Result.Data("CSSD_RejectDesc")
		s UseFlag= Result.Data("CSSDC_NotUseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CleanItmReason",RowId,PHospId)
		continue:ret="N"
		d OutPutRowReasonForCleanFail
	}
	d Result.Close()
	Quit $$$OK
OutPutRowReasonForCleanFail
	s Data=$lb(RowId,CleanReasonCode,CleanReasonDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
