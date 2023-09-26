Import SQLUser

Class web.CSSDHUI.System.Satisfaction Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ljl
/// CreatDate:2022-3-21
/// Description:查询满意度调查信息-码表维护   
/// Table:CSSD_Satisfaction
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.Satisfaction","SelectAllSatisfaction","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectAllSatisfaction(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SatisfactionCode,SatisfactionDesc,SatisfactionType,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllSatisfactionExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT ID,S_Code,S_Desc,S_Type,S_UseFlag FROM CT_STER_CSSD.Satisfaction"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s SatisfactionCode = Result.Data("S_Code")
		s SatisfactionDesc = Result.Data("S_Desc")
		s SatisfactionType = Result.Data("S_Type")
		s UseFlag = Result.Data("S_UseFlag")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_STER_CSSD.Satisfaction",RowId,PHospId)
		continue:ret="N"
		d OutPutRowSatisfaction
	}
	d Result.Close()
	Quit $$$OK
OutPutRowSatisfaction
	s Data=$lb(RowId,SatisfactionCode,SatisfactionDesc,SatisfactionType,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ljl
/// CreatDate:2022-3-21
/// Description:保存满意度调查信息-码表维护   
/// Table:CSSD_Satisfaction
/// d ##class(web.CSSDHUI.System.Satisfaction).jsSave()
ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()	// 事务
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

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

		s SatisfactionId=Obj.%Get("RowId") 
		s SatisfactionCode=Obj.%Get("SatisfactionCode")
		s SatisfactionDesc=Obj.%Get("SatisfactionDesc")
		s UseFlag=Obj.%Get("UseFlag")
		s SatisfactionType=Obj.%Get("SatisfactionType")

		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",SatisfactionCode,"CT_STER_CSSD.Satisfaction",PHospId,SatisfactionId)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在!")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SatisfactionDesc,"CT_STER_CSSD.Satisfaction",PHospId,SatisfactionId)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在!")
		continue:RtnObj.success'=0

		i SatisfactionId="" d
		.s SatisfactionObj=##class(CT.STER.CSSD.Satisfaction).%New()
		e  d
		.s SatisfactionObj=##class(CT.STER.CSSD.Satisfaction).%OpenId(SatisfactionId)
		.d SatisfactionObj.%Reload()
		s SatisfactionObj.SCode=SatisfactionCode
		s SatisfactionObj.SDesc=SatisfactionDesc
		s SatisfactionObj.SType=SatisfactionType
		s SatisfactionObj.SUseFlag=UseFlag
		s Sc=SatisfactionObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0
		s SatisfactionId=SatisfactionObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CT_STER_CSSD.Satisfaction",SatisfactionId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:ljl
/// CreatDate:2022-3-21
/// Description:删除满意度调查信息-码表维护   
/// Table:CSSD_Satisfaction
/// d ##class(web.CSSDHUI.System.Satisfaction).jsDelete()
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

ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s SatisfactionId=Obj.%Get("RowId")
		continue:SatisfactionId=""

		&sql(Delete From CT_STER_CSSD.Satisfaction where ID=:SatisfactionId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CT_STER_CSSD.Satisfaction",SatisfactionId)
		i ret'=0 d RtnObj.Err(-3,SatisfactionId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

}
