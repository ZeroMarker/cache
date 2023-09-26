Import sqluser

/// Descript:	查询参数信息
/// Creator:	ljl
/// CreateDate:	2022-11-30
/// Table:		CSSD_Parameter
/// Input:		查询条件
/// Return：
/// d ##class(web.CSSDHUI.System.SystemParame).SelectAll(^tmpljl)
Class web.CSSDHUI.System.SystemParame Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

ClassMethod SelectAll(Params As %String)
{
	n (Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pParref=PJObj.%Get("Parref")
	q:pParref="" ""
	
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ID, CSSDP_ParaCode, CSSDP_ParaName, CSSDP_ParaValue,CSSDP_ParaExplain FROM CSSD_Parameter "
		_" where CSSDDP_BaseTypeDr="_pParref
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s json = ##class(web.CSSDHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s RowId = result.Data("ID")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Parameter",RowId,pHospId)
		continue:ret="N"
		s Code = result.Data("CSSDP_ParaCode")
		s Description = result.Data("CSSDP_ParaName")
		s ParaValue = result.Data("CSSDP_ParaValue")
		s ParaExplain= result.Data("CSSDP_ParaExplain")
		i Code="FtpPassword" s ParaValue="******"
		s DataStr=RowId_"^"_Code_"^"_Description_"^"_ParaValue_"^"_ParaExplain
		s count = count+1
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	s TitleStr="RowId^Code^Description^ParaValue^ParaExplain"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// Descript:	保存参数js调用
/// Creater:	litongxun
/// CreateDate:	2022-03-03
/// Table:		CSSD_Parameter
/// Input:		Params,Detail
/// Return：
/// w ##class(web.CSSDHUI.System.SystemParame).jsSave(6,"[{""RowId"":""748"",""Code"":""RequiredDelete"",""Description"":""子表删除是否提示"",""ParaValue"":""N"",""ParaExplain"":""明细删除是否需要提示,默认Y/是！""}]","{""BDPHospital"":""2"",""gUserId"":""6461"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2""}")
ClassMethod jsSave(Params As %String, Detail As %String) As %Library.String
{
	n (Params,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// w ##class(web.CSSDHUI.System.SystemParame).Save(6,"[{""RowId"":""748"",""Code"":""RequiredDelete"",""Description"":""子表删除是否提示"",""ParaValue"":""N"",""ParaExplain"":""明细删除是否需要提示,默认Y/是！""}]","{""BDPHospital"":""2"",""gUserId"":""6461"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2""}")
ClassMethod Save(Params As %String, Detail As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Detail)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Params)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")
	
	s pParref=OthersObj.%Get("Parref")
	i pParref="" q RtnObj.Err(-1,"","入参不能为空!")
	
	s pHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s gLocId=OthersObj.%Get("gLocId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		
		s RowId=RowObj.%Get("RowId")
		s Code=RowObj.%Get("Code")
		s Desc=RowObj.%Get("Description")
		s ParaValue=RowObj.%Get("ParaValue")
		s ParaExplain=RowObj.%Get("ParaExplain")
		i ((Code="")||(Desc="")) d RtnObj.Err(-2,RowId,"代码或名称不可为空!","",0) q
		
		s TmpId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_Parameter",pHospId,RowId,pParref)
		i TmpId'="" s Sc=RtnObj.Err(-3,"",Code_"代码重复！") q
		
		i ((Code="FtpPassword")&&(ParaValue'="******")) s ParaValue=##class(web.CSSDHUI.Common.UtilCommon).EncryptPW(ParaValue)
		
		i RowId="" d
		.s Obj=##class(User.CSSDParameter).%New()
		.d Obj.CSSDPCTypeSetObjectId(pParref)
		e  d
		.s Obj=##Class(User.CSSDParameter).%OpenId(RowId)
		.d Obj.%Reload()
		
		s Obj.CSSDPParaName=Desc
		s Obj.CSSDPParaCode=Code
		s Obj.CSSDPParaExplain =ParaExplain
		s:ParaValue'="******" Obj.CSSDPParaValue=ParaValue
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!") q
		
		s:RowId="" RowId=Obj.%Id()
		s Ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Parameter",RowId,pHospId)
		i Ret'=0 d RtnObj.Err(-11,"","关联院区失败!") q
	}
	q RtnObj
}

/// Descript:	删除参数js调用
/// Creater:	litongxun
/// CreateDate:	2022-03-03
/// Table:	CSSD_Parameter
ClassMethod jsDelete(Params) As %Library.String
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s $ZT=..sssError()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误")
	
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		&sql(Delete from CSSD_Parameter where %id=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-2,RowId,MethodName_":删除失败") q
		
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_Parameter",RowId)
		i ret'=0 d RtnObj.Err(-3,RowId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE) q 
	}
	q RtnObj
}

/// Descript:	查询应用系统参数值信息
/// Creator:	litongxun
/// CreateDate:	2022-03-02
/// Table:		CSSD_ParameterItm	
/// Return:		应用系统参数值信息
/// Others: w ##class(web.CSSDHUI.System.SystemParame).SelectProp("217")
ClassMethod SelectProp(Parref As %String)
{
	n (Parref)
	q:Parref="" ""
	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select PI_ParRef as ParRef,PI_RowId as RowId,PI_Type as Type,PI_Pointer as Pointer,PI_Value as PIValue,"
		_" PI_Hospital_DR as HospId, PI_StDate as StartDate "
		_" from CSSD_ParameterItm where PI_ParRef='"_Parref_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s json=##class(web.CSSDHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s ParRef=result.Data("ParRef")
		s RowId=result.Data("RowId")
		s Type=result.Data("Type")
		s Pointer=result.Data("Pointer")
		s Value=result.Data("PIValue")
		s HospId=result.Data("HospId")
		s StartDate=result.Data("StartDate")
		s ParaObj=##class(User.CSSDParameter).%OpenId(ParRef)
		s Code=ParaObj.CSSDPParaCode
		i Code="FtpPassword" s Value="******"
		
		s (TypeDesc,PointerDesc)=""
		i Type = "G" d
		.s TypeDesc="安全组"
		.&sql(select SSGRP_Desc into :PointerDesc from SS_Group where SSGRP_RowId=:Pointer)
		e  i Type = "L" d
		.s TypeDesc="科室"
		.&sql(select CTLOC_DESC into :PointerDesc from CT_Loc WHERE CTLOC_ROWID=:Pointer)
		e  i Type="U" d
		.s TypeDesc="用户"
		.&sql(select ssusr_name,SSUSR_Initials into :PointerDesc,:Initials from SS_user where ssusr_rowid=:Pointer)
		.q:SQLCODE'=0
		.
		.s PointerDesc=PointerDesc	//_"["_Initials_"]"
		
		s HospDesc=""
		i (HospId'="")&&$d(^CT("HOSP",HospId)) d
		.s HospDesc=$P($G(^CT("HOSP",HospId)),"^",2)
		s StartDate=..DL2H(StartDate)
		s DataStr=ParRef_"^"_RowId_"^"_Type_"^"_TypeDesc_"^"_Pointer
			_"^"_PointerDesc_"^"_Value_"^"_HospId_"^"_HospDesc_"^"_StartDate
		s count = count+1
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	s TitleStr="Parref^RowId^Type^TypeDesc^Pointer"
		_"^PointerDesc^Value^HospId^HospDesc^StartDate"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// Descript:	保存/更新参数明细信息(Js调用)
/// Creator:	litongxun
/// CreateDate:	2022-03-03
/// w ##class(web.CSSDHUI.System.SystemParame).jsSaveProp("","{""TypeField"":""G"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""PointerField"":""4"",""RowId"":""218||17"",""Value"":""12""}")
ClassMethod jsSaveProp(Parref As %String, Detail As %String) As %Library.String
{
	n (Parref,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveProp(Parref,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	保存/更新应用系统参数值信息
/// Creator:	litongxun
/// CreateDate:	2022-03-02
/// Table:		CSSD_ParameterItm
/// Input:		父表rowid, Json(rowid,父表id,类型,类型值,参数值,医院)
/// Output:		RtnObj
/// w ##class(web.CSSDHUI.System.SystemParame).SaveProp("68","{""Type"":""G"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2"",""Pointer"":""1"",""RowId"":"""",""Value"":""1""}")
ClassMethod SaveProp(Parref, Detail) As web.CSSDHUI.RtnObj
{
	n (Parref,Detail,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s RowId=PJObj.%Get("RowId")
	s Value=PJObj.%Get("Value")
	s HospId=PJObj.%Get("HospId")
	s Type=PJObj.%Get("TypeField")
	s Pointer=PJObj.%Get("PointerField")
	i ((Type="")||(Pointer="")) q RtnObj.Err(-1,"","类型或者类型值为空")
	
	i Parref'="" d
	.q:'$d(^User.CSSDParameterD(Parref))
	.s ParaObj=##class(User.CSSDParameter).%OpenId(Parref)
	.s Code=ParaObj.CSSDPParaCode
	.s:Code="FtpPassword" Value=##class(web.CSSDHUI.Common.UtilCommon).EncryptPW(Value)
	
	i RowId="" d
	.&sql(insert into CSSD_ParameterItm (PI_Type,PI_Pointer,PI_Value,PI_Hospital_DR,PI_ParRef) values (:Type,:Pointer,:Value,:HospId,:Parref))
	e  d
	.&sql(Update CSSD_ParameterItm set PI_Type=:Type,PI_Pointer=:Pointer,PI_Value=:Value,PI_Hospital_DR=:HospId where PI_RowId=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-10,"",$ClassName()_"SaveProp:保存参数明细数据失败!")
	
	q RtnObj
}

/// Descript:	获取参数值明显信息,填充表单
/// Creator:	litongxun
/// CreateDate:	2022-03-02
/// Table:		CSSD_ParameterItm
/// Input:		RowId
/// Output:		表单对象信息
/// w ##class(web.CSSDHUI.System.SystemParame).GetPropDetail("73||5")
ClassMethod GetPropDetail(RowId As %String)
{
	n (RowId)
	q:RowId="" ""
	
	s ParameterItmObj=##class(User.CSSDParameterItm).%OpenId(RowId)
	s Type=ParameterItmObj.PIType
	s Pointer=ParameterItmObj.PIPointer
	s Value=ParameterItmObj.PIValue
	s HospId=ParameterItmObj.PIHospitalDR
	s StartDate=ParameterItmObj.PIStDate
	s TypeDesc="",PointerDesc="",HospDesc=""
	i Type="G" d
	.s TypeDesc="安全组"
	.&sql(select SSGRP_Desc into :PointerDesc from SS_Group where SSGRP_RowId=:Pointer)
	e  i Type="L" d
	.s TypeDesc="科室"
	.&sql(select CTLOC_DESC into :PointerDesc from CT_Loc WHERE CTLOC_ROWID=:Pointer)
	e  i Type="U" d
	.s TypeDesc="用户"
	.&sql(select ssusr_name,SSUSR_Initials into :PointerDesc,:Initials from SS_user where ssusr_rowid=:Pointer)
	q:SQLCODE'=0
	
	i ((HospId'="")&&$d(^CT("HOSP",HospId))) d
	.s HospDesc=$P($G(^CT("HOSP",HospId)),"^",2)
	s TypeField=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(Type,TypeDesc)
	s PointerField=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(Pointer,PointerDesc)
	s HospField=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(HospId,HospDesc)
	s StartDate=..DL2H(StartDate)
	s ParaObj=##class(User.CSSDParameter).%OpenId(+RowId)
	s Code=ParaObj.CSSDPParaCode
	i Code="FtpPassword" s Value="******"
	s DataStr=RowId_"^"_TypeField_"^"_PointerField_"^"_Value_"^"_HospField_"^"_StartDate
	s TitleStr="RowId^TypeField^PointerField^Value^HospId^StartDate"
	s Str=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Str
	w ""
}

/// Descript: 提供js界面调用删除参数明细信息
/// Creator:	litongxun
/// CreateDate:	2022-03-02
/// w ##class(web.CSSDHUI.System.SystemParame).jsDeleteProp()
ClassMethod jsDeleteProp(Params As %String) As %Library.String
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s $ZT=..sssError()
	ts
	s RtnObj=..DeleteProp(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除应用系统参数值信息
/// Creator:	litongxun
/// CreateDate:	2022-03-02
/// Table:		CSSD_ParameterItm
/// Input:		Json({RowId:**})
/// Output:		RtnObj
ClassMethod DeleteProp(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s MethodName=$CLASSNAME()_".DeleteProp"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误")
	
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		&sql(Delete from CSSD_ParameterItm where %Id=:RowId)
		i SQLCODE'=0  d RtnObj.Err(-2,RowId,MethodName_":删除失败") q
		
	}
	q RtnObj
}

}
