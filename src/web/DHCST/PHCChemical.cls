Import sqluser

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:化学通用名相关
Class web.DHCST.PHCChemical Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAIN";

/// d ##class(%ResultSet).RunQuery("web.DHCST.PHCChemical","Query","^^amxl^")
Query Query(strParams As %String = "") As websys.Query(ROWSPEC = "chemicalId:%String,chemicalCode:%String,chemicalDesc:%String,phcCatId:%String,phcCatDesc:%String")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, strParams As %String = "") As %Status
{
	n (qHandle,strParams)
	//s ^hlh($this)=$lb(strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s inputPhcCat=$p(strParams,"^",1)
	s phcCatList=##class(web.DHCST.PHCCATMAINTAIN).GetChildrenNodes(inputPhcCat)
	i inputPhcCat'="" d
	.i phcCatList'="" s phcCatList=inputPhcCat_","_phcCatList
	.e  s phcCatList=inputPhcCat
	s phcCatList=$lfs(phcCatList,",")
	s inputCode=$zcvt($p(strParams,"^",2),"U")
	s inputDesc=$zcvt($p(strParams,"^",3),"U")
	s inputAlias=$p(strParams,"^",4)
	s chemicalId=""
	f  s chemicalId=$o(^DHCPHCM(chemicalId)) q:chemicalId=""  d
	.q:+chemicalId=0
	.s chemicalCode=$p(^DHCPHCM(chemicalId),"^",1)
	.q:(inputCode'="")&&($zcvt(chemicalCode,"U")'[inputCode)
	.s chemicalDesc=$p(^DHCPHCM(chemicalId),"^",2)
	.q:(inputDesc'="")&&($zcvt(chemicalDesc,"U")'[inputDesc)
	.s chemicalPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(chemicalDesc)
	.q:(inputAlias'="")&&($zcvt(chemicalPY,"U")'[$zcvt(inputAlias,"U"))
	.s phcCatId=$p(^DHCPHCM(chemicalId),"^",3)
	.q:(inputPhcCat'="")&&($lf(phcCatList,phcCatId)=0)
	.s phcCatDesc=$p($g(^DHCPHCC(+phcCatId)),"^",2)
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(chemicalId,chemicalCode,chemicalDesc,phcCatId,phcCatDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:保存化学通用名
/// input:      listData(药学分类ID^化学通用名代码^化学通用名描述)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.PHCChemical).Save("15^b111b^的d")
ClassMethod Save(chemicalId As %String, listData As %String) As %String
{
	n (chemicalId,listData)
	s phcCatId=$p(listData,"^",1)
	s phcCatObj=""
	//q:phcCatId="" -1_"^药学分类ID为空"
	i phcCatId'="" s phcCatObj=##class(User.DHCPHCCat).%OpenId(phcCatId,0)
	//q:phcCatObjId="" -1_"^药学分类不存在"
	s chemicalCode=$p(listData,"^",2)
	s chemicalDesc=$p(listData,"^",3)
	s chkRet=..CheckExist(chemicalCode,chemicalDesc,chemicalId)
	q:+chkRet<0 chkRet
	i chemicalId="" d
	.s chemicalObj=##class(User.DHCPHChemical).%New()
	e  d
	.s chemicalObj=##class(User.DHCPHChemical).%OpenId(chemicalId)
	.d chemicalObj.%Reload()
	s chemicalObj.PHCMCode=chemicalCode
	s chemicalObj.PHCMDesc=chemicalDesc
	s chemicalObj.PHCMPHCCDr=phcCatObj
	s sc=chemicalObj.%Save()
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.DHCPHChemical",errinfo)
	q chemicalObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:删除化学通用名
/// input:      chemicalId(化学通用名ID)
/// return:     +ret<0(重复)
/// w ##class(web.DHCST.PHCChemical).Delete("15552")
ClassMethod Delete(chemicalId As %String) As %String
{
	n (chemicalId)
	s chkLnk=##class(web.DHCST.DrugLink).CheckChemicalLink(chemicalId)
	q:chkLnk'="" chkLnk
	&SQL(delete FROM DHC_PHChemical WHERE PHCM_RowId=:chemicalId)
	q:SQLCODE'=0 -1_"^化学通用名删除失败,错误代码(SQL):"_SQLCODE
	q 0
}

/// creator:	yunhaibao
/// createdate: 2017-06-21
/// description:验证通用名重复
/// input:      code(代码),desc(描述)
/// return:     +ret<0(重复)
/// w ##class(web.DHCST.PHCChemical).CheckExist("ddd","dddd","")
ClassMethod CheckExist(code As %String, desc As %String, rowId As %String) As %String
{
	n (code,desc,rowId)
	s exitRet=0
	i rowId="" d
	.&SQL(SELECT * FROM DHC_PHChemical WHERE PHCM_Code=:code)
	.i SQLCODE=0 s exitRet=-1_"^化学通用名代码重复"
	.q:exitRet'=0
	.&SQL(SELECT * FROM DHC_PHChemical WHERE PHCM_Desc=:desc)
	.i SQLCODE=0 s exitRet=-1_"^化学通用名名称重复"
	e  d
	.&SQL(SELECT * FROM DHC_PHChemical WHERE PHCM_Code=:code and PHCM_RowId!=:rowId)
	.i SQLCODE=0 s exitRet=-1_"^化学通用名代码重复"
	.q:exitRet'=0
	.&SQL(SELECT * FROM DHC_PHChemical WHERE PHCM_Desc=:desc and PHCM_RowId!=:rowId)
	.i SQLCODE=0 s exitRet=-1_"^化学通用名名称重复"
	q exitRet
}

/// creator:	yunhaibao
/// createdate: 2017-06-28
/// description:根据Id获取化学通用名信息
/// input:      strParams(化学通用名ID)
/// return:     
/// w ##class(%ResultSet).RunQuery("web.DHCST.PHCChemical","QueryByRowId",3015)
Query QueryByRowId(strParams As %String) As websys.Query(ROWSPEC = "txtChemicalCode:%String,txtChemicalDesc:%String")
{
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, strParams As %String) As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s chemicalId=+$p(strParams,"^",1)
	q:chemicalId=0 $$$OK
	s chemicalCode=$p($g(^DHCPHCM(chemicalId)),"^",1)
	s chemicalDesc=$p($g(^DHCPHCM(chemicalId)),"^",2)	
	s Data=$lb(chemicalCode,chemicalDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

}
