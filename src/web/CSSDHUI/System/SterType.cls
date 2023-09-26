Import sqluser

Class web.CSSDHUI.System.SterType Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDHUISYSTEM";

/// 灭菌方式
/// 保存灭菌方式信息
/// w ##class(web.CSSDHUI.System.SterType).jsSave()
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

/// 灭菌方式
/// 保存灭菌方式信息
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

		s SterTypeId=Obj.%Get("RowId")
		s SterTypeCode=Obj.%Get("SterTypeCode")
		s SterTypeDesc=Obj.%Get("SterTypeDesc")
		s DisplayColor=Obj.%Get("DisplayColor")
		s SterFlag=Obj.%Get("SterFlag")
		s LowerTempFlag=Obj.%Get("LowerTempFlag")
		s UseFlag=Obj.%Get("UseFlag")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",SterTypeCode,"CSSD_SterType",PHospId,SterTypeId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SterTypeDesc,"CSSD_SterType",PHospId,SterTypeId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在！")
		continue:RtnObj.success'=0
		i SterTypeId="" d
		.s CSSDSterTypeObj=##class(User.CSSDSterType).%New()
		e  d
		.s CSSDSterTypeObj=##class(User.CSSDSterType).%OpenId(SterTypeId)
		.d CSSDSterTypeObj.%Reload()
		s CSSDSterTypeObj.CSSDSTSterCode=SterTypeCode
		s CSSDSterTypeObj.CSSDSTSterName=SterTypeDesc
		s CSSDSterTypeObj.CSSDSTNotUseFlag=UseFlag
		s CSSDSterTypeObj.CSSDSTIsSter=SterFlag
		s CSSDSterTypeObj.CSSDSTIsLowerTemp=LowerTempFlag
		s CSSDSterTypeObj.CSSDSTDisplayColor=DisplayColor
		s Sc=CSSDSterTypeObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0
		s SterTypeId=CSSDSterTypeObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_SterType",SterTypeId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SterType","SelectAllSterType","{""BDPHospital"":""3"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectAllSterType(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SterTypeCode,SterTypeDesc,UseFlag,SterFlag,LowerTempFlag,DisplayColor") [ SqlProc ]
{
}

ClassMethod SelectAllSterTypeExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT %ID As RowId, CSSDST_SterCode,CSSDST_SterName,CSSDST_NotUseFlag,CSSDST_IsSter,CSSDST_IsLowerTemp,CSSDST_DisplayColor "
			_" FROM CSSD_SterType"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s SterTypeCode = Result.Data("CSSDST_SterCode")
		s SterTypeDesc = Result.Data("CSSDST_SterName")
		s UseFlag = Result.Data("CSSDST_NotUseFlag")
		s SterFlag = Result.Data("CSSDST_IsSter")
		s LowerTempFlag = Result.Data("CSSDST_IsLowerTemp")
		s DisplayColor=Result.Data("CSSDST_DisplayColor")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_SterType",RowId,PHospId)
		continue:ret="N"
		d OutPutRowSterType
	}
	d Result.Close()
	Quit $$$OK
OutPutRowSterType
	s Data=$lb(RowId,SterTypeCode,SterTypeDesc,UseFlag,SterFlag,LowerTempFlag,DisplayColor)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
