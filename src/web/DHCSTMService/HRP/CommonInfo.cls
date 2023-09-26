Import sqluser

/// Descript:	SPD 相关对照方法
/// Creator:	XuChao
/// CreateDate:	2018-01-26
Class web.DHCSTMService.HRP.CommonInfo Extends %RegisteredObject
{

/// Descript:	医院ID
/// Creator:	lihui
/// CreateDate:	20200414
/// Input:		医院编码  
/// Output:     医院ID
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComHosp()
ClassMethod ComHosp(Code As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT HOSP_RowId into:RowId FROM CT_Hospital WHERE HOSP_Code=:Code)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	Apc供应商对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		Apc供应商描述  
/// Output:     Apc供应商Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComApc()
ClassMethod ComApc(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(select APCVM_RowId into :RowId from APC_Vendor where APCVM_Name=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	Manf生产商对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		Manf生产商描述  
/// Output:     Manf生产商Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComManf()
ClassMethod ComManf(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT PHMNF_RowId into :RowId FROM PH_Manufacturer WHERE PHMNF_Name=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	配送商对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		配送商描述  
/// Output:     配送商Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComCarrie()
ClassMethod ComCarrie(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT CA_Rowid into :RowId FROM DHC_Carrier WHERE CA_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	Loc科室对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		Loc科室描述  
/// Output:     Loc科室Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComLoc()
ClassMethod ComLoc(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT CTLOC_RowID into :RowId FROM CT_Loc WHERE CTLOC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	User用户对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		用户名 
/// Output:     用户Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComUser()
ClassMethod ComUser(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	s:Desc="" Desc="demo"
	&sql(SELECT SSUSR_RowId into :RowId FROM SS_User WHERE SSUSR_Initials=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	类组对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		类组描述,类组Code  
/// Output:     类组Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComScgDesc()
ClassMethod ComScg(Desc As %String = "", Code As %String = "") As %String
{
	s Ret=""
	s RowId=""
	i Desc'="" &sql(SELECT SCG_Rowid into :RowId FROM DHC_StkCatGroup WHERE SCG_Desc=:Desc)
	i Code'="" &sql(SELECT SCG_Rowid into :RowId FROM DHC_StkCatGroup WHERE SCG_Desc=:Code)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	Inci物资品种对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		物资Code  
/// Output:     物资Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComInci()
ClassMethod ComInci(Code As %String) As %String
{
	s Ret=""
	s Ret=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))     
	q Ret
}

/// Descript:	单位对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		单位描述  
/// Output:     单位Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComUom()
ClassMethod ComUom(Desc As %String) As %String
{
	s Ret=""
	i Desc'="" s Ret=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),""))
	q Ret
}

/// Descript:	库存分类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		库存分类描述 
/// Output:     库存分类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComStkCat()
ClassMethod ComStkCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT INCSC_RowId into :RowId FROM INC_StkCat WHERE INCSC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	医嘱子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		医嘱子类描述  
/// Output:     医嘱子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComOrdSubCat()
ClassMethod ComOrdSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT ARCIC_RowId into :RowId FROM ARC_ItemCat WHERE ARCIC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	账单子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		账单子类描述  
/// Output:     账单子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComBillSubCat()
ClassMethod ComBillSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT ARCSG_RowId into :RowId FROM ARC_BillSub WHERE ARCSG_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	账单大类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		账单大类描述  
/// Output:     账单大类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComBillCat()
ClassMethod ComBillCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT ARCBG_RowId into :RowId FROM ARC_BillGrp WHERE ARCBG_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	收费大类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		收费大类描述  
/// Output:     收费大类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComTarCat()
ClassMethod ComTarCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TARC_RowId into RowId FROM DHC_TarCate WHERE  TARC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	收费子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		收费子类描述  
/// Output:     收费子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComTarSubCat()
ClassMethod ComTarSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TARSC_RowId into :RowId FROM DHC_TarSubCate WHERE TARSC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	住院子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		住院子类描述  
/// Output:     住院子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComInpaSubCat()
ClassMethod ComInpaSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TARIC_RowId into :RowId FROM DHC_TarInpatCate WHERE TARIC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	门诊子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		门诊子类描述  
/// Output:     门诊子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComOutpaSubCat()
ClassMethod ComOutpaSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TAROC_RowId into :RowId FROM DHC_TarOutpatCate WHERE TAROC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	核算子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		核算子类描述  
/// Output:     核算子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComTarEMSubCat()
ClassMethod ComTarEmSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TAREC_RowId into :RowId FROM DHC_TarEMCCate WHERE TAREC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	会计子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		会计子类描述  
/// Output:     会计子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComAcctSubCat()
ClassMethod ComAcctSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TARAC_RowId  into :RowId FROM  DHC_TarAcctCate WHERE TARAC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	病案子类对照
/// Creator:	XuChao
/// CreateDate:	2018-01-26
/// Input:		病案子类描述  
/// Output:     病案子类Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComMrSubCat()
ClassMethod ComMrSubCat(Desc As %String) As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT TARMC_RowId into :RowId FROM DHC_TarMRCate WHERE TARMC_Desc=:Desc)
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	获取Demo RowId
/// Creator:	XuChao
/// CreateDate:	2018-03-2
/// Input:		  
/// Output:     RowId
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).GetDemoId()
ClassMethod GetDemoId() As %String
{
	s Ret=""
	s RowId=""
	&sql(SELECT %id into :RowId FROM ss_user WHERE SSUSR_Initials='demo')
	i SQLCODE=0  s Ret=RowId
	q Ret
}

/// Descript:	处理条码相关
/// Creator:	XuChao
/// CreateDate:	2018-04-17
/// Descript:	调整原因
/// Creator:	lihui
/// CreateDate:	20191225
/// Input:		调整原因描述  
/// Output:     调整原因Id
/// Return：
/// w ##class(web.DHCSTMService.HRP.CommonInfo).ComApc()
ClassMethod GetAdjReason(AdjReason As %String) As %String
{
	s ReasonId="",StkType="M"
	&sql(SELECT ADJ_RowId INTO:ReasonId FROM INC_ReasonForAdjustment WHERE ADJ_Desc=:AdjReason AND ADJ_StkType=:StkType)
	s Ret=ReasonId	
	q Ret
}

Storage Default
{
<Data name="CommonInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTMServi2D1F.CommonInfoD</DataLocation>
<DefaultData>CommonInfoDefaultData</DefaultData>
<IdLocation>^web.DHCSTMServi2D1F.CommonInfoD</IdLocation>
<IndexLocation>^web.DHCSTMServi2D1F.CommonInfoI</IndexLocation>
<StreamLocation>^web.DHCSTMServi2D1F.CommonInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
