Import SQLUser

Class web.CSSDHUI.Clean.CleanTypeDetail Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Description:保存清洗详细信息
/// Creator:	wangjiabin
/// CreatDate:	2021-10-30
/// Table:		CSSD_CleanTypeDetail
/// Input:		
/// Return:		
/// w ##class(web.CSSDHUI.Clean.CleanTypeDetail).jsSave("{""CleanId"":69323,""Type"":""MachineClean""}","{""MachineCleanFlushTem"":""20"",""gUserId"":""1412"",""gLocId"":""14"",""gGroupId"":""103"",""gHospId"":""42"",""MachineCleanFlushTime"":""1"",""MachineCleanWashTem"":""20"",""MachineCleanWashTime"":""1"",""MachineCleanFlushMode"":""1"",""MachineCleanWashMode"":""1,2"",""MachineCleanProgram"":""1,2,8"",""MachineCleanSterMode"":""1"",""MachineCleanWashRatio"":""1;100""}")
ClassMethod jsSave(MainParams, Params) As %String
{
	n (%session,MainParams,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..Save(MainParams,Params)
	q RtnObj.Json()
}

/// Description:保存清洗详细信息
ClassMethod Save(MainParams, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainParams,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainParams)
	i Sc'=0 q RtnObj.Err(-1,"","参数错误!")
	
	s CleanId=PJObj.%Get("CleanId")
	s Type=PJObj.%Get("Type")
	s IsCmtEnter=$List(^User.CSSDCleanD(CleanId),18)	//清洗标记
	i IsCmtEnter="1" q RtnObj.Err(-1,"","该清洗单已提交,不可修改!","",0)
	
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","参数错误!")
	;冲洗
	s CleanFlushMode=PJObj.%Get("CleanFlushMode")
	s CleanFlushTem=PJObj.%Get("CleanFlushTem")
	s CleanFlushTime=PJObj.%Get("CleanFlushTime")
	;洗涤
	s CleanWashMode=PJObj.%Get("CleanWashMode")
	s CleanWashTem=PJObj.%Get("CleanWashTem")
	s CleanWashTime=PJObj.%Get("CleanWashTime")
	s CleanWashRatio=PJObj.%Get("CleanWashRatio")
	;消毒
	s CleanSterMode=PJObj.%Get("CleanSterMode")
	s CleanSterRatio=PJObj.%Get("CleanSterRatio")
	s CleanSterCheck=PJObj.%Get("CleanSterCheck")
	s CleanSterTime=PJObj.%Get("CleanSterTime")
	;漂洗/终末漂洗
	s CleanRinseMode=PJObj.%Get("CleanRinseMode")
	s CleanRinseTem=PJObj.%Get("CleanRinseTem")
	s CleanRinseTime=PJObj.%Get("CleanRinseTime")
	;润滑
	s CleanLubricateRatio=PJObj.%Get("CleanLubricateRatio")
	s CleanLubricateTime=PJObj.%Get("CleanLubricateTime")
	;干燥
	s CleanDryMode=PJObj.%Get("CleanDryMode")
	s CleanDryTime=PJObj.%Get("CleanDryTime")
	;终末漂洗
	s CleanFinalRinseMode=PJObj.%Get("CleanFinalRinseMode")
	s CleanFinalRinseTem=PJObj.%Get("CleanFinalRinseTem")
	s CleanFinalRinseTime=PJObj.%Get("CleanFinalRinseTime")
	;程序
	s MachineCleanProgram=PJObj.%Get("MachineCleanProgram")
	
	s TMP($name(CleanFlushMode))=$lb(CleanFlushMode)
	s TMP($name(CleanFlushTem))=$lb(CleanFlushTem)
	s TMP($name(CleanFlushTime))=$lb(CleanFlushTime)
	s TMP($name(CleanWashMode))=$lb(CleanWashMode)
	s TMP($name(CleanWashTem))=$lb(CleanWashTem)
	s TMP($name(CleanWashTime))=$lb(CleanWashTime)
	s TMP($name(CleanWashRatio))=$lb(CleanWashRatio)
	s TMP($name(CleanSterMode))=$lb(CleanSterMode)
	s TMP($name(CleanSterRatio))=$lb(CleanSterRatio)
	s TMP($name(CleanSterCheck))=$lb(CleanSterCheck)
	s TMP($name(CleanSterTime))=$lb(CleanSterTime)
	s TMP($name(CleanRinseMode))=$lb(CleanRinseMode)
	s TMP($name(CleanRinseTem))=$lb(CleanRinseTem)
	s TMP($name(CleanRinseTime))=$lb(CleanRinseTime)
	s TMP($name(CleanLubricateRatio))=$lb(CleanLubricateRatio)
	s TMP($name(CleanLubricateTime))=$lb(CleanLubricateTime)
	s TMP($name(CleanDryMode))=$lb(CleanDryMode)
	s TMP($name(CleanDryTime))=$lb(CleanDryTime)
	s TMP($name(CleanFinalRinseMode))=$lb(CleanFinalRinseMode)
	s TMP($name(CleanFinalRinseTem))=$lb(CleanFinalRinseTem)
	s TMP($name(CleanFinalRinseTime))=$lb(CleanFinalRinseTime)
	s TMP($name(MachineCleanProgram))=$lb(MachineCleanProgram)
	
	ts
	s Code=""
	f  s Code=$o(TMP(Code)) q:(Code="")||(RtnObj.success<0)  d
	.s Value=$lg(TMP(Code),1)
	.s RtnObj=..SaveCode(CleanId,Type,Code,Value)
	.q:RtnObj.success<0
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=CleanId
	q RtnObj
}

/// Description:保存一条信息
ClassMethod SaveCode(CleanId, Type, DetailCode, DetailValue) As web.CSSDHUI.RtnObj
{
	n (%session,CleanId,Type,DetailCode,DetailValue)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RowId=$o(^User.CSSDCleanTypeDetailI("IndexClean",CleanId,DetailCode,""))
	
	i RowId="" d
	.s Obj=##class(User.CSSDCleanTypeDetail).%New()
	.d Obj.CSSDCTDCleanDRSetObjectId(CleanId)
	.s Obj.CSSDCTDType=Type
	e  d
	.s Obj=##class(User.CSSDCleanTypeDetail).%OpenId(RowId)
	
	s Obj.CSSDCTDCode=DetailCode
	s Obj.CSSDCTDValue=DetailValue
	
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","清洗信息保存失败")
	s RowId=Obj.%Id()
	
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Description:删除清洗详细信息
/// Creator:	wangjiabin
/// CreatDate:	2021-11-02
/// Table:		CSSD_CleanTypeDetail
/// Input:		CleanId: 清洗单rowid
/// Return:	
/// w ##class(web.CSSDHUI.Clean.CleanTypeDetail).jsDelete()
ClassMethod jsDelete(CleanId) As %String
{
	n (%session,CleanId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..Delete(CleanId)
	q RtnObj.Json()
}

ClassMethod Delete(CleanId) As web.CSSDHUI.RtnObj
{
	n (%session,CleanId)
	i CleanId="" q RtnObj.Err(-1,"","清洗主单不存在","",0)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Ret=..GetCleanTypeDetail(CleanId)
	i Ret="{}" q RtnObj.Err(-2,"","该清洗信息已删除!","",0)
	
	s IsCmtEnter=$List(^User.CSSDCleanD(CleanId),18)	//清洗标记
	i IsCmtEnter="1" q RtnObj.Err(-1,"","该清洗单已提交,不可删除!","",0)
	
	&sql(delete from CSSD_CleanTypeDetail where CSSDCTD_Clean_DR=:CleanId)
	i SQLCODE<0 q RtnObj.Err(-3,"","删除失败!")
	
	q RtnObj
}

/// Description:获取清洗详细信息,用于界面表单显示
/// w ##class(web.CSSDHUI.Clean.CleanTypeDetail).GetCleanTypeDetail("58")
ClassMethod GetCleanTypeDetail(CleanId) As %String
{
	n (%session,CleanId)
	
	s Title="",Data="",Type=""
	s Code=""
	f  s Code=$o(^User.CSSDCleanTypeDetailI("IndexClean",CleanId,Code)) q:Code=""  d
	.s RowId=$o(^User.CSSDCleanTypeDetailI("IndexClean",CleanId,Code,""))
	.q:RowId=""
	.
	.s Type=$lg(^User.CSSDCleanTypeDetailD(RowId),3)
	.s Value=$lg(^User.CSSDCleanTypeDetailD(RowId),5)
	.i Title="" d
	..s Title=Code
	..s Data=Value
	.e  d
	..s Title=Title_"^"_Code
	..s Data=Data_"^"_Value
	
	q:Title="" "{}"
	s Title=Title_"^Type",Data=Data_"^"_Type
	
	s Str=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Str
}

}
