Import sqluser

/// Descript:	字典对照公用方法
/// 			不同字典对照模式内容可能不一样(RowId/Code/Desc等),统一通过此类实现转换.
/// 			注意: 方法最前面的参数模式定义!!!
/// 			通过GetVendorId写法, 将第三方传入的"对照信息"转换为 我们的rowid;
/// 			通过GetVendor4Ser写法, 将我们的rowid转换为第三方需要的"对照信息".
/// CreateDate:	2021-11-04
Class web.DHCSTMService.HRPJson.CommonInfo Extends %RegisteredObject
{

/// 科室参数类型
Parameter LocParamMode [ Final ] = "RowId";

/// 供应商参数类型
Parameter VendorParamMode [ Final ] = "Code";

/// 生产厂家参数类型
Parameter ManfParamMode [ Final ] = "Code";

/// 库存项参数类型
Parameter InciParamMode [ Final ] = "Code";

/// 库存分类参数类型
Parameter IncscParamMode [ Final ] = "Desc";

/// Descript:	医院ID
/// Creator:	lihui
/// CreateDate:	20200414
/// Input:		医院编码  
/// Output:		医院ID
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).ComHosp()
ClassMethod ComHosp(Code As %String) As %String
{
	q:Code="" ""
	s Ret=""
	s RowId=""
	&sql(SELECT HOSP_RowId into:RowId FROM CT_Hospital WHERE HOSP_Code=:Code)
	i SQLCODE=0 s Ret=RowId
	q Ret
}

/// Description:Apc供应商对照
/// Input:		对照内容
/// Output:		供应商RowId
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId("AM00003")
ClassMethod GetVendorId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	
	;参数格式
	s ParamMode=..%GetParameter("VendorParamMode")
	
	i ParamMode="RowId" d
	.s RowId=Desc
	e  i ParamMode="Code" d
	.&sql(select APCVM_RowId into :RowId from APC_Vendor where APCVM_Code=:Desc and APCVM_Type='M')
	.i SQLCODE'=0 s RowId=""
	e  i ParamMode="Desc" d
	.&sql(select APCVM_RowId into :RowId from APC_Vendor where APCVM_Name=:Desc and APCVM_Type='M')
	.i SQLCODE'=0 s RowId=""
	
	i (RowId'="")&&'$d(^APC("APCVM",RowId)) q ""
	q RowId
}

/// Description:Apc供应商对照
/// Input:		供应商RowId
/// Output:		对照内容
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendor4Ser("1")
ClassMethod GetVendor4Ser(RowId As %String) As %String
{
	q:RowId="" ""
	s SerCode=""
	
	;参数格式
	s ParamMode=..%GetParameter("VendorParamMode")
	
	i ParamMode="RowId" d
	.s SerCode=RowId
	e  i ParamMode="Code" d
	.s SerCode=$p(^APC("APCVM",RowId),"^",2)
	e  i ParamMode="Desc" d
	.s SerCode=$p(^APC("APCVM",RowId),"^",3)
	
	q SerCode
}

/// Description:Manf生产商对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		Manf生产商描述
/// Output:		Manf生产商Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetManfId()
ClassMethod GetManfId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	
	;参数格式
	s ParamMode=..%GetParameter("ManfParamMode")
	
	i ParamMode="RowId" d
	.s RowId=Desc
	e  i ParamMode="Code" d
	.&sql(SELECT MANF_PhcManf_DR into :RowId FROM DHC_Manf_AddionInfo WHERE MANF_PhcManf_DR->PHMNF_Code=:Desc AND MANF_Type='M')
	.i SQLCODE'=0 s RowId=""
	e  i ParamMode="Desc" d
	.&sql(SELECT MANF_PhcManf_DR into :RowId FROM DHC_Manf_AddionInfo WHERE MANF_PhcManf_DR->PHMNF_Name=:Desc AND MANF_Type='M')
	.i SQLCODE'=0 s RowId=""
	
	i (RowId'="")&&'$d(^PHMNF(RowId)) q ""
	q RowId
}

/// Description:配送商对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		配送商描述  
/// Output:		配送商Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).ComCarrie()
ClassMethod ComCarrier(Desc As %String) As %String
{
	q:Desc="" ""
	s Ret=""
	s RowId=""
	&sql(SELECT CA_Rowid into :RowId FROM DHC_Carrier WHERE CA_Desc=:Desc)
	i SQLCODE=0 s Ret=RowId
	q Ret
}

/// Description:Loc科室对照(入参根据对接规则可能有变化,可能是RowId,也可能是Code或者Desc)
/// CreateDate:	2021-11-05
/// Input:		Desc- 
/// Output:		Loc科室Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId("保健科")
ClassMethod GetLocId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	
	;参数模式
	s ParamMode=..%GetParameter("LocParamMode")
	
	i ParamMode="RowId" d
	.s RowId=Desc
	e  i ParamMode="Code" d
	.&sql(SELECT CTLOC_RowID into :RowId FROM CT_Loc WHERE CTLOC_Code=:Desc)
	.i SQLCODE'=0 s RowId=""
	e  i ParamMode="Code" d
	.&sql(SELECT CTLOC_RowID into :RowId FROM CT_Loc WHERE CTLOC_Desc=:Desc)
	.i SQLCODE'=0 s RowId=""
	
	i (RowId'="")&&'$d(^CTLOC(RowId)) q ""
	q RowId
}

ClassMethod GetLoc4Ser(RowId) As %String
{
	q:RowId="" ""
	s SerCode=""
	
	;参数格式
	s ParamMode=..%GetParameter("LocParamMode")
	
	i ParamMode="RowId" d
	.s SerCode=RowId
	e  i ParamMode="Code" d
	.s SerCode=$p(^CTLOC(RowId),"^",1)
	e  i ParamMode="Desc" d
	.s SerCode=$p(^CTLOC(RowId),"^",2)
	
	q SerCode
}

/// Description:User用户对照
/// Input:		用户名 
/// Output:		用户Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId()
ClassMethod GetUserId(Desc As %String) As %String
{
	q:Desc="" ""
	s Ret=""
	s RowId=""
	s:Desc="" Desc="demo"
	&sql(SELECT SSUSR_RowId into :RowId FROM SS_User WHERE SSUSR_Initials=:Desc)
	i SQLCODE=0 s Ret=RowId
	q Ret
}

/// Description:类组对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		类组描述,类组Code  
/// Output:		类组Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).ComScgDesc()
ClassMethod ComScg(Desc As %String) As %String
{
	q:Desc="" ""
	s Ret=""
	s RowId=""
	&sql(SELECT SCG_Rowid into :RowId FROM DHC_StkCatGroup WHERE SCG_Desc=:Desc)
	i SQLCODE=0 s Ret=RowId
	q Ret
}

/// Description:物资品种对照
/// Input:		物资Code  
/// Output:		物资Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId()
ClassMethod GetInciId(Code As %String) As %String
{
	q:Code="" ""
	s RowId=""
	
	;参数格式
	s ParamMode=..%GetParameter("InciParamMode")
	
	i ParamMode="RowId" d
	.s RowId=Code
	e  i ParamMode="Code" d
	.s RowId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))
	
	i (RowId'="")&&'$d(^INCI(RowId,1)) q ""
	q RowId
}

ClassMethod GetInci4Ser(RowId As %String) As %String
{
	q:RowId="" ""
	s SerCode=""
	
	;参数格式
	s ParamMode=..%GetParameter("InciParamMode")
	
	i ParamMode="RowId" d
	.s SerCode=RowId
	e  i ParamMode="Code" d
	.s SerCode=$p(^INCI(RowId,1),"^",1)
	e  i ParamMode="Desc" d
	.s SerCode=$p(^INCI(RowId,1),"^",2)
	
	q SerCode
}

/// Description:单位对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		单位描述  
/// Output:		单位Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId("包(4000)")
ClassMethod GetUomId(Desc As %String) As %String
{
	s Desc=$$UPPER^SSUTIL4(Desc)
	q:Desc="" ""
	s RowId=$o(^CT("UOM",0,"Desc",Desc,""))
	i RowId="" d
	.&sql(Insert into CT_UOM
		(CTUOM_Code,CTUOM_Desc)
		values
		(:Desc,:Desc))
	.q:SQLCODE'=0
	.s RowId=%ROWID
	q RowId
}

/// Description:库存分类对照
/// Input:		对照内容
/// Output:		库存分类Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetIncscId()
ClassMethod GetIncscId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	
	;参数格式
	s ParamMode=..%GetParameter("IncscParamMode")
	
	i ParamMode="RowId" d
	.s RowId=Desc
	e  i ParamMode="Desc" d
	.&sql(SELECT INCSC_RowId into :RowId FROM INC_StkCat WHERE INCSC_Desc=:Desc)
	.i SQLCODE'=0 s RowId=""
	
	i (RowId'="")&&'$d(^INC("SC",RowId)) q ""
	q RowId
}

/// Description:医嘱子类对照
/// Input:		医嘱子类描述  
/// Output:		医嘱子类Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetOrdSubCatId()
ClassMethod GetOrdSubCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT ARCIC_RowId into :RowId FROM ARC_ItemCat WHERE ARCIC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Description:账单子类对照
/// Input:		账单子类描述  
/// Output:		账单子类Id
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetBillSubCatId()
ClassMethod GetBillSubCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT ARCSG_RowId into :RowId FROM ARC_BillSub WHERE ARCSG_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

ClassMethod GetPriorityId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT OECPR_RowId into :RowId FROM OEC_Priority WHERE OECPR_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	收费子类对照
/// Input:		收费子类描述
/// Output:		收费子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarSubCatId()
ClassMethod GetTarSubCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TARSC_RowId into :RowId FROM DHC_TarSubCate WHERE TARSC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	住院子类对照
/// Input:		住院子类描述  
/// Output:		住院子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarInpatCatId()
ClassMethod GetTarInpatCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TARIC_RowId into :RowId FROM DHC_TarInpatCate WHERE TARIC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	门诊子类对照
/// Input:		门诊子类描述  
/// Output:		门诊子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarOutpatCatId()
ClassMethod GetTarOutpatCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TAROC_RowId into :RowId FROM DHC_TarOutpatCate WHERE TAROC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	核算子类对照
/// Input:		核算子类描述  
/// Output:		核算子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarEMCCatId()
ClassMethod GetTarEMCCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TAREC_RowId into :RowId FROM DHC_TarEMCCate WHERE TAREC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	会计子类对照
/// Input:		会计子类描述  
/// Output:		会计子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarAcctCatId()
ClassMethod GetTarAcctCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TARAC_RowId  into :RowId FROM  DHC_TarAcctCate WHERE TARAC_Desc=:Desc)
	i SQLCODE'=0  s RowId=""
	q RowId
}

/// Descript:	病案子类对照
/// Input:		病案子类描述  
/// Output:		病案子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarMRCatId()
ClassMethod GetTarMRCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TARMC_RowId into :RowId FROM DHC_TarMRCate WHERE TARMC_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	新病案首页子类对照
/// Input:		新病案首页子类描述  
/// Output:     新病案首页子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarNewMRSubCatId()
ClassMethod GetTarNewMRSubCatId(Desc As %String) As %String
{
	q:Desc="" ""
	s RowId=""
	&sql(SELECT TARMCCNew_RowId into :RowId FROM DHC_TarMCCateNew WHERE TARMCCNew_Desc=:Desc)
	i SQLCODE'=0 s RowId=""
	q RowId
}

/// Descript:	获取Demo RowId
/// Input:		
/// Output:		RowId
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetDemoId()
ClassMethod GetDemoId() As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT %id into :RowId FROM ss_user WHERE SSUSR_Initials='demo')
	i SQLCODE=0 s Ret=RowId
	q Ret
}

/// Descript:	调整原因
/// Creator:	lihui
/// CreateDate:	20191225
/// Input:		调整原因描述  
/// Output:		调整原因Id
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.CommonInfo).GetAdjReason()
ClassMethod GetAdjReason(AdjReason As %String) As %String
{
	q:AdjReason="" ""
	s ReasonId="",StkType="M"
	&sql(SELECT ADJ_RowId INTO :ReasonId FROM INC_ReasonForAdjustment
		WHERE ADJ_Desc=:AdjReason AND ADJ_StkType=:StkType)
	i SQLCODE'=0 s ReasonId=""
	q ReasonId
}

}
