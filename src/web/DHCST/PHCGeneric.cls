Import sqluser

/// creator:	yunhaibao
/// createdate: 2017-06-22
/// description:处方通用名相关
Class web.DHCST.PHCGeneric Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAIN";

/// w ##class(%ResultSet).RunQuery("web.DHCST.PHCGeneric","Query","^^^amxl^")
Query Query(strParams As %String = "") As websys.Query(ROWSPEC = "genericId:%String,genericCode:%String,genericDesc:%String,genericStDate:%String,genericEdDate:%String,chemicalId:%String,chemicalDesc:%String,formDesc:%String,stkCatDesc:%String")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, strParams As %String = "") As %Status
{
	n (qHandle,strParams)
	//s ^yunhaibao($this)=strParams
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s inputChemiId=$p(strParams,"^",1)
	s inputCode=$zcvt($p(strParams,"^",2),"U")
	s inputDesc=$zcvt($p(strParams,"^",3),"U")
	s inputAlias=$p(strParams,"^",4)
	S inputPhcCat=$p(strParams,"^",5)
	s phcCatList=##class(web.DHCST.PHCCATMAINTAIN).GetChildrenNodes(inputPhcCat)
	i inputPhcCat'="" d
	.i phcCatList'="" s phcCatList=inputPhcCat_","_phcCatList
	.e  s phcCatList=inputPhcCat
	s phcCatList=$lfs(phcCatList,",")
	s genericId=""
	f  s genericId=$o(^PHCGE("GE",genericId)) q:genericId=""  d
	.q:+genericId=0  
	.s geneData=^PHCGE("GE",genericId)
	.s genericCode=$p(geneData,"^",1)
	.q:(inputCode'="")&&($zcvt(genericCode,"U")'[inputCode)
	.s genericDesc=$p(geneData,"^",2)
	.q:(inputDesc'="")&&($zcvt(genericDesc,"U")'[inputDesc)
	.s genericStDate=$p(geneData,"^",5)
	.s genericPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(genericDesc)
	.q:(inputAlias'="")&&($zcvt(genericPY,"U")'[$zcvt(inputAlias,"U"))
	.s genericStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(genericStDate,"ST")
	.s genericEdDate=$p(geneData,"^",6)
	.s genericEdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(genericEdDate,"ST")
	.s dhcGenericId=genericId
	.s chemicalId=$p($g(^PHCGE("GE",dhcGenericId,"DHC")),"^",3)
	.s stkCatId=$p($g(^PHCGE("GE",dhcGenericId,"DHC")),"^",4)
	.s formId=$p($g(^PHCGE("GE",dhcGenericId,"DHC")),"^",5)
	.s chemicalDesc=$s(chemicalId'="":$p($g(^DHCPHCM(+chemicalId)),"^",2),1:"")
	.s formDesc=$s(formId'="":$p($g(^PHCF(+formId)),"^",2),1:"")
	.s stkCatDesc=$s(stkCatId'="":$p($g(^INC("SC",+stkCatId)),"^",2),1:"")
	.q:(inputChemiId'="")&&(inputChemiId'=chemicalId)
	.s quitFlag=""
	.q:(inputPhcCat'="")&&(chemicalId="")
	.i chemicalId'="" d
	..s phcCatId=$p(^DHCPHCM(chemicalId),"^",3)
	..i (inputPhcCat'="")&&($lf(phcCatList,phcCatId)=0) s quitFlag=1
	.q:quitFlag'=""
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(genericId,genericCode,genericDesc,genericStDate,genericEdDate,chemicalId,chemicalDesc,formDesc,stkCatDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:保存处方通用名
/// input:      genericId(处方通用名ID),listData(化学通用名ID^处方通用名代码^处方通用名描述^开始日期^截止日期)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.PHCGeneric).Save("","^666^666")
ClassMethod Save(genericId As %String, listData As %String) As %String
{
	n (genericId,listData)
	s chemicalId=$p(listData,"^",1)
	s genericCode=$p(listData,"^",2)
	s genericDesc=$p(listData,"^",3)
	s genericStDate=$p(listData,"^",4)
	s genericStDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(genericStDate)
	s genericEdDate=$p(listData,"^",5)
	s genericEdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(genericEdDate)
	s stkCatId=$p(listData,"^",6)
	s formId=$p(listData,"^",7)
	s phcCatId=$p(listData,"^",8)
	s chkRet=..CheckExist(genericCode,genericDesc,genericId)
	q:+chkRet<0 chkRet
	ts
	i genericId="" d
	.s genericObj=##class(User.PHCGeneric).%New()
	e  d
	.s genericObj=##class(User.PHCGeneric).%OpenId(genericId)
	.d genericObj.%Reload()
	s genericObj.PHCGECode=genericCode
	s genericObj.PHCGEName=genericDesc
	s genericObj.PHCGEDateFrom=genericStDate
	s genericObj.PHCGEDateTo=genericEdDate
	s sc=genericObj.%Save()
	s errinfo=""
	i $$$ISERR(sc) d
	.tro
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.PHCGeneric",errinfo)
	q:errinfo'="" -1_"^"_errinfo
	s genericId=genericObj.%Id()
	s saveRet=..SaveDHCPhcGeneric(genericId,chemicalId,stkCatId,formId,phcCatId)
	i +saveRet<0 tro  q saveRet
	tc
	q genericObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-06-22
/// description:保存处方通用名扩展表
/// input:      genericId(处方通用名ID),chemicalId(化学通用名ID)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.PHCGeneric).SaveDHCPhcGeneric(1416,15)
ClassMethod SaveDHCPhcGeneric(genericId As %String, chemicalId As %String, stkCatId As %String, formId As %String, phcCatId = "") As %String
{
	n (chemicalId,genericId,stkCatId,formId,phcCatId)
	s genericId=+genericId
	q:+genericId=0 "-1^处方通用名ID为空"
	s dhcGeneObj=##class(User.DHCPhcGeneric).%OpenId(genericId)
	d dhcGeneObj.%Reload()
	//s dhcGeneObj.PHCGEDR=##class(User.PHCGeneric).%OpenId(genericId)
	i chemicalId'="" d
	.d dhcGeneObj.PHCGEPHCMDrSetObjectId(chemicalId)
	i stkCatId'="" d
	.d dhcGeneObj.PHCGEINCSCDRSetObjectId(stkCatId)
	i formId'="" d
	.d dhcGeneObj.PHCGEPHCFDrSetObjectId(formId)
	i phcCatId'="" d
	.d dhcGeneObj.PHCGEPHCCDRSetObjectId(phcCatId)
	s sc=dhcGeneObj.%Save()
	s errinfo=""
	i $$$ISERR(sc) d
	.tro
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.DHCPhcGeneric",errinfo)
	q:errinfo'="" -1_"^"_errinfo
	i stkCatId'="" d ..UpdateIncStkCat(genericId)
	d ..UpdatePhcForm(genericId)
	q dhcGeneObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:删除处方通用名
/// input:      genericId(处方通用名ID)
/// return:     +ret<0(重复)
/// w ##class(web.DHCST.PHCGeneric).Delete("2244")
ClassMethod Delete(genericId As %String) As %String
{
	n (genericId)
	s chkRet=##class(web.DHCST.DrugLink).CheckGenericLink(genericId)
	q:+chkRet<0 chkRet
	ts
	&SQL(delete FROM PHC_Generic WHERE PHCGE_RowId=:genericId)
	i SQLCODE'=0 tro  q -1_"^处方通用名删除失败,错误代码(SQL):"_SQLCODE
	&SQL(delete FROM DHC_PHCGeneric WHERE PHCGE_RowId=:genericId)
	tc
	q 0
}

/// creator:	yunhaibao
/// createdate: 2017-06-22
/// description:验证处方通用名重复
/// input:      code(代码),desc(描述)
/// return:     +ret<0(重复)
/// w ##class(web.DHCST.PHCGeneric).CheckExist("hxjcs0825","hxjcs0825")
ClassMethod CheckExist(code As %String, desc As %String, rowId As %String) As %String
{
	n (code,desc,rowId)
	s exitRet=0
	i rowId="" d
	.&SQL(SELECT * FROM PHC_Generic WHERE PHCGE_Code=:code)
	.i SQLCODE=0 s exitRet=-1_"^处方通用名代码重复"
	.q:exitRet'=0
	.&SQL(SELECT * FROM PHC_Generic WHERE PHCGE_Name=:desc)
	.i SQLCODE=0 s exitRet=-1_"^处方通用名名称重复"
	e  d
	.&SQL(SELECT * FROM PHC_Generic WHERE PHCGE_Code=:code and PHCGE_RowId!=:rowId)
	.i SQLCODE=0 s exitRet=-1_"^处方通用名代码重复"
	.q:exitRet'=0
	.&SQL(SELECT * FROM PHC_Generic WHERE PHCGE_Name=:desc and PHCGE_RowId!=:rowId)
	.i SQLCODE=0 s exitRet=-1_"^处方通用名名称重复"
	q exitRet
}

/// creator:	yunhaibao
/// createdate: 2017-06-28
/// description:根据Id获取处方通用名信息
/// input:      strParams(处方通用名ID)
/// return:     代码^描述
/// w ##class(%ResultSet).RunQuery("web.DHCST.PHCGeneric","QueryByRowId",1424)
Query QueryByRowId(strParams As %String) As websys.Query(ROWSPEC = "txtGenericCode,txtGenericDesc,dtStartDate,dtEndDate,cmbStkCat,cmbForm")
{
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, strParams As %String) As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s genericId=+$p(strParams,"^",1)
	q:genericId=0 $$$OK
	s geneData=$g(^PHCGE("GE",genericId))
	s genericCode=$p(geneData,"^",1)
	s genericDesc=$p(geneData,"^",2)
	s genericStDate=$p(geneData,"^",5)
	s genericStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(genericStDate,"ST")
	s genericEdDate=$p(geneData,"^",6)
	s genericEdDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(genericEdDate,"ST")
	s stkCatId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",4)
	s formId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",5)
	s Data=$lb(genericCode,genericDesc,genericStDate,genericEdDate,stkCatId,formId)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

/// creator:yunhaibao
/// createdate:2017-09-15
/// description:修改处方通用名库存分类时,同步更新库存项库存分类
ClassMethod UpdateIncStkCat(genericId)
{
	n (genericId)
	q:genericId="" ""
	s geneStkCatDr=$p($g(^PHCGE("GE",genericId,"DHC")),"^",4)
	s arcItmVer=""
	f  s arcItmVer=$o(^ARCIM(0,"Gener",genericId,arcItmVer)) q:arcItmVer=""  d
	.q:+arcItmVer=0
	.s incItmId=""
	.f  s incItmId=$o(^INCI(0,"ARCIM_DR",arcItmVer,incItmId)) q:incItmId=""  d
	..q:+incItmId=0
	..&SQL(UPDATE INC_Itm SET INCI_INCSC_DR=:geneStkCatDr WHERE INCI_RowId=:incItmId)
	q 0
}

/// creator:  	 yunhaibao
/// createdate:  2018-10-26
/// description: 修改处方通用名剂型时,同步更新药学项剂型
ClassMethod UpdatePhcForm(genericId)
{
	n (genericId)
	q:genericId="" ""
	s geneFormDr=$p($g(^PHCGE("GE",genericId,"DHC")),"^",5)
	s phcdId=0
	f  s phcdId=$o(^PHCD(0,"Gener",genericId,phcdId)) q:phcdId=""  d
	.&SQL(UPDATE PHC_DrgForm SET PHCDF_PHCF_DR=:geneFormDr WHERE PHCDF_PHCD_ParRef=:phcdId)
	q 0
}

}
