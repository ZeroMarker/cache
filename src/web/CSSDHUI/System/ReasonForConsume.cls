Import sqluser

Class web.CSSDHUI.System.ReasonForConsume Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 器械报损原因
/// 保存器械报损原因信息
/// w ##class(web.CSSDHUI.System.ReasonForConsume).jsSave()
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

/// 器械报损原因
/// 保存器械报损原因信息
/// w ##class(web.CSSDHUI.System.ReasonForConsume).Save()
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

		s ConsumeReasonId=Obj.%Get("RowId")
		s ConsumeReasonCode=Obj.%Get("ConsumeReasonCode")
		s ConsumeReasonDesc=Obj.%Get("ConsumeReasonDesc")
		s UseFlag=Obj.%Get("UseFlag")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",ConsumeReasonCode,"CSSD_MachineConsumeReason",PHospId,ConsumeReasonId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",ConsumeReasonDesc,"CSSD_MachineConsumeReason",PHospId,ConsumeReasonId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在!")
		continue:RtnObj.success'=0

		i ConsumeReasonId="" d
		.s ConsumeReasonObj=##class(User.CSSDMachineConsumeReason).%New()
		e  d
		.s ConsumeReasonObj=##class(User.CSSDMachineConsumeReason).%OpenId(ConsumeReasonId)
		.d ConsumeReasonObj.%Reload()
		s ConsumeReasonObj.CSSDMConsumeCode=ConsumeReasonCode
		s ConsumeReasonObj.CSSDMConsumeDesc=ConsumeReasonDesc
		s ConsumeReasonObj.CSSDCNotUseFlag=UseFlag
		s Sc=ConsumeReasonObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0
		s ConsumeReasonId=ConsumeReasonObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_MachineConsumeReason",ConsumeReasonId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Return:RtnObj
/// Description:删除报损原因
/// Creator:wb
/// Date:2019-12-06
/// Table:CSSD_MachineConsumeReason
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.ReasonForConsume).jsDelete()
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

/// Return:	RtnObj
/// Description:删除器械报损原因
/// Creator:wb
/// Date:2019-12-06
/// Table:CSSD_MachineConsumeReason
/// Input:Params
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

		s ConsumeReasonId=Obj.%Get("RowId")
		continue:ConsumeReasonId=""

		&sql(delete from CSSD_MachineConsumeReason where CSSDMConsume_Rowid=:ConsumeReasonId)
		i SQLCODE'=0 d RtnObj.Err(-6,ConsumeReasonId,MethodName_":处理CSSD_MachineConsumeReason失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_MachineConsumeReason",ConsumeReasonId)
		i ret'=0 d RtnObj.Err(-2,ConsumeReasonId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:获取器械报损原因
/// Creator:wb
/// Date:2019-12-06
/// Table:CSSD_MachineConsumeReason
/// Input:ID
/// Output:RtnObj
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.ReasonForConsume","SelectAllReasonForConsume","RowId","Desc")
Query SelectAllReasonForConsume(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ConsumeReasonCode,ConsumeReasonDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllReasonForConsumeExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT CSSDMConsume_Rowid As RowId, CSSD_MConsumeCode,CSSD_MConsumeDesc, CSSDC_NotUseFlag "
			_" FROM CSSD_MachineConsumeReason "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ConsumeReasonCode = Result.Data("CSSD_MConsumeCode")
		s ConsumeReasonDesc = Result.Data("CSSD_MConsumeDesc")
		s UseFlag = Result.Data("CSSDC_NotUseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConsumeReason",RowId,PHospId)
		continue:ret="N"
		d OutPutRowReasonForConsume
	}
	d Result.Close()
	Quit $$$OK
OutPutRowReasonForConsume
	s Data=$lb(RowId,ConsumeReasonCode,ConsumeReasonDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
