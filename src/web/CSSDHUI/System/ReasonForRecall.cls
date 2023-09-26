Import sqluser

Class web.CSSDHUI.System.ReasonForRecall Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 召回原因
/// 保存召回原因
/// w ##class(web.CSSDHUI.System.ReasonForRecall).jsSave()
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

/// Return:RtnObj
/// Description:保存召回原因
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.ReasonForRecall).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
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

		s RecallReasonId=Obj.%Get("RowId")
		s RecallReasonCode=Obj.%Get("RecallReasonCode")
		s RecallReasonDesc=Obj.%Get("RecallReasonDesc")
		s UseFlag=Obj.%Get("UseFlag")

		i ((RecallReasonCode="")||(RecallReasonDesc="")) d RtnObj.Err(-2,"","召回原因代码、名称不能为空!")
		continue:RtnObj.success'=0
		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",RecallReasonCode,"CSSD_RecallReason",PHospId,RecallReasonId)
		i CodeId'="" d RtnObj.Err(-3,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",RecallReasonDesc,"CSSD_RecallReason",PHospId,RecallReasonId)
		i DescId'="" d RtnObj.Err(-4,"","描述已存在!")
		continue:RtnObj.success'=0

		i RecallReasonId="" d
		.s RecallReasonObj=##class(User.CSSDRecallReason).%New()
		e  d
		.s RecallReasonObj=##class(User.CSSDRecallReason).%OpenId(RecallReasonId)
		.d RecallReasonObj.%Reload()
		s RecallReasonObj.CSSDRecallCode=RecallReasonCode
		s RecallReasonObj.CSSDRecallDesc=RecallReasonDesc
		s RecallReasonObj.CSSDRecallUseFlag=UseFlag
		s Sc=RecallReasonObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!")
		continue:RtnObj.success'=0
		s RecallReasonId=RecallReasonObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_RecallReason",RecallReasonId,PHospId)
		i ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:删除召回原因
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.ReasonForRecall).jsDelete("")
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

/// Return:RtnObj
/// Description:删除召回原因
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
/// Input:ID
/// Output:RtnObj
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

		s RecallReasonId=Obj.%Get("RowId")
		continue:RecallReasonId=""
		&sql(delete from CSSD_RecallReason where CSSDRR_RecallRowid=:RecallReasonId)
		i SQLCODE'=0 d RtnObj.Err(-2,RecallReasonId,MethodName_":处理CSSD_RecallReason失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_RecallReason",RecallReasonId)
		i ret'=0 d RtnObj.Err(-3,RecallReasonId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:获取召回原因
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
/// Input:ID
/// Output:RtnObj
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.ReasonForRecall","SelectAllReasonForRecall","RowId","Desc")
Query SelectAllReasonForRecall(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,RecallReasonCode,RecallReasonDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllReasonForRecallExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT CSSDRR_RecallRowid, CSSD_RecallCode, CSSD_RecallDesc, CSSD_RecallUseFlag "
			_" FROM CSSD_RecallReason"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDRR_RecallRowid")
		s RecallReasonCode = Result.Data("CSSD_RecallCode")
		s RecallReasonDesc = Result.Data("CSSD_RecallDesc")
		s UseFlag = Result.Data("CSSD_RecallUseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_RecallReason",RowId,PHospId)
		continue:ret="N"
		d OutPutRowReasonForConsume
	}
	d Result.Close()
	Quit $$$OK
OutPutRowReasonForConsume
	s Data=$lb(RowId,RecallReasonCode,RecallReasonDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
