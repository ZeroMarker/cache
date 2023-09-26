Import sqluser

Class web.CSSDHUI.System.CleanType Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDHUISYSTEM";

/// 清洗方式
/// 保存清洗方式信息
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

/// 清洗方式
/// 保存清洗方式信息
/// w ##class(web.CSSDHUI.System.CleanType).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params, Others)
	s MethodName=$CLASSNAME()_".Save"
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

		s CleanTypeId=Obj.%Get("RowId")
		s CleanTypeCode=Obj.%Get("CleanTypeCode")
		s CleanTypeDesc=Obj.%Get("CleanTypeDesc")
		s UseFlag=Obj.%Get("UseFlag")
		s ManualFlag=Obj.%Get("ManualFlag")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",CleanTypeCode,"CSSD_CleanType",PHospId,CleanTypeId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",CleanTypeDesc,"CSSD_CleanType",PHospId,CleanTypeId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在！")
		continue:RtnObj.success'=0

		i CleanTypeId="" d
		.s CleanTypeObj=##class(User.CSSDCleanType).%New()
		e  d
		.s CleanTypeObj=##class(User.CSSDCleanType).%OpenId(CleanTypeId)
		.d CleanTypeObj.%Reload()
		s CleanTypeObj.CSSDCTCleanCode=CleanTypeCode
		s CleanTypeObj.CSSDCTCleanMode=CleanTypeDesc
		s CleanTypeObj.CSSDCTNotUseFlag=UseFlag
		s CleanTypeObj.CSSDCTIsManualTemp=ManualFlag
		s Sc=CleanTypeObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",MethodName_":保存失败!")
		continue:RtnObj.success'=0
		s CleanTypeId=CleanTypeObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CleanType",CleanTypeId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除清洗方式
/// w ##class(web.CSSDHUI.System.CleanType).jsDelete()
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
/// Description:删除清洗方式
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

		s CleanTypeId=Obj.%Get("RowId")
		continue:CleanTypeId=""
		&sql(delete from CSSD_CleanType where %ID=:CleanTypeId)
		i SQLCODE'=0 d RtnObj.Err(-2,CleanTypeId,MethodName_":删除失败,SQLOCDE:"_SQLCODE) 
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_CleanType",CleanTypeId)
		i ret'=0 d RtnObj.Err(-3,CleanTypeId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.CleanType","SelectAllCleanType",^tmpbin(119))
Query SelectAllCleanType(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanTypeCode,CleanTypeDesc,UseFlag,ManualFlag") [ SqlProc ]
{
}

ClassMethod SelectAllCleanTypeExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT %ID As RowId, CSSDCT_CleanCode,CSSDCT_CleanMode,CSSDCT_NotUseFlag,CSSDCT_IsManualTemp "
			_" FROM CSSD_CleanType "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s CleanTypeCode = Result.Data("CSSDCT_CleanCode")
		s CleanTypeDesc = Result.Data("CSSDCT_CleanMode")
		s UseFlag = Result.Data("CSSDCT_NotUseFlag")
		s ManualFlag=Result.Data("CSSDCT_IsManualTemp")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CleanType",RowId,PHospId)
		continue:ret="N"
		d OutPutRowCleanType
	}
	d Result.Close()
	Quit $$$OK
OutPutRowCleanType
	s Data=$lb(RowId,CleanTypeCode,CleanTypeDesc,UseFlag,ManualFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
