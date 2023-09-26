Import sqluser

Class web.CSSDHUI.System.PackageSpec Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 消毒包规格
/// 保存消毒包规格
/// w ##class(web.CSSDHUI.System.PackageSpec).jsSave()
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
/// Description:保存消毒包规格
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.PackageSpec).Save()
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

		s SpecId=Obj.%Get("RowId")
		s SpecCode=Obj.%Get("SpecCode")
		s SpecDesc=Obj.%Get("SpecDesc")
		s UseFlag=Obj.%Get("UseFlag")

		i ((SpecCode="")||(SpecDesc="")) d RtnObj.Err(-2,"","规格代码、名称不能为空!")
		continue:RtnObj.success'=0
		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",SpecCode,"CT_STER_CSSD.PackageSpec",PHospId,SpecId)
		i CodeId'="" d RtnObj.Err(-3,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SpecDesc,"CT_STER_CSSD.PackageSpec",PHospId,SpecId)
		i DescId'="" d RtnObj.Err(-4,"","描述已存在!")
		continue:RtnObj.success'=0

		i SpecId="" d
		.s SpecObj=##class(CT.STER.CSSD.PackageSpec).%New()
		e  d
		.s SpecObj=##class(CT.STER.CSSD.PackageSpec).%OpenId(SpecId)
		.d SpecObj.%Reload()
		s SpecObj.PSSpecCode=SpecCode
		s SpecObj.PSSpecDesc=SpecDesc
		s SpecObj.PSSpecUseFlag=UseFlag
		s Sc=SpecObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!")
		continue:RtnObj.success'=0
		s SpecId=SpecObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CT_STER_CSSD.PackageSpec",SpecId,PHospId)
		i ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:删除消毒包规格
/// Creator:ban
/// Date:2020-07-07
/// Table:PackageSpec
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.System.PackageSpec).jsDelete("")
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
/// Description:删除召回原因
/// Creator:ban
/// Date:2020-07-07
/// Table:CSSD_RecallReason
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

		s SpecId=Obj.%Get("RowId")
		continue:SpecId=""

		&sql(delete from CT_STER_CSSD.PackageSpec where ID=:SpecId)
		i SQLCODE'=0 d RtnObj.Err(-2,SpecId,MethodName_":处理PackageSpec失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CT_STER_CSSD.PackageSpec",SpecId)
		i ret'=0 d RtnObj.Err(-3,SpecId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
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
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.PackageSpec","SelectAllPackageSpec","RowId","Desc")
Query SelectAllPackageSpec(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SpecCode,SpecDesc,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllPackageSpecExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT ID,PS_SpecCode,PS_SpecDesc,PS_SpecUseFlag FROM CT_STER_CSSD.PackageSpec"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s SpecCode = Result.Data("PS_SpecCode")
		s SpecDesc = Result.Data("PS_SpecDesc")
		s UseFlag = Result.Data("PS_SpecUseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_STER_CSSD.PackageSpec",RowId,PHospId)
		continue:ret="N"
		d OutPutRowPackageSpec
	}
	d Result.Close()
	Quit $$$OK
OutPutRowPackageSpec
	s Data=$lb(RowId,SpecCode,SpecDesc,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
