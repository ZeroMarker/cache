Import sqluser

Class web.DHCSTMHUI.Common.HrpInterface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 依据医嘱明细RowId取出材料医嘱的相关信息
/// Author:zhwh
/// Date:2017-05-19
/// Arguments:
///    oeori - OE_OrdItem.OEORI_RowId
/// Return:
///    数据串 (收费项代码^收费项名称^规格^单位^数量^零售价^金额)
/// w ##Class(web.DHCSTMHUI.Common.HrpInterface).GetMatInfo()
ClassMethod GetMatInfo(oeori As %String) As %String
{
	n (oeori)
	s code="",desc="",uomDesc=""
	q:oeori="" ""
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" ""
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:inci="" ""
	s buomDr=$p($G(^INCI(inci,1)),"^",10)
	i buomDr>0 s uomDesc=$p($G(^CT("UOM",buomDr)),"^",2)
	&sql(SELECT olt_tariff_dr->tari_code,  olt_tariff_dr->tari_desc	into :code,:desc FROM dhc_orderlinktar WHERE OLT_ARCIM_DR=:arcim)

	s loc=$p(^OEORD(ord,"I",itm,3),"^",6)  ;接收科室
	i loc="" d  ;如果接收科室为空取就诊科室
	.s Adm=$P(^OEORD(ord),"^",1)
	.s admloc=$p(^PAADM(Adm),"^",4)
	.s loc=admloc
	s HospitalId=$p($G(^CTLOC(loc)),"^",22) 
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)					

	s confqty=+##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CalDispQty(oeori)	;取材料医嘱数量
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,sttdate,buomDr,HospitalId)				;单价
	s spAmt=confqty*sp

	;
	s STRTOLLMATERIALCODE=code ;STRTOLLMATERIALCODE	收费材料编码	VARCHAR2(40)	是		取值HIS方的收费材料编码
	s STRTOLLMATERIALNAME=desc ;STRTOLLMATERIALNAME	收费材料名称	VARCHAR2(106)	是		取值HIS方的收费材料名称
	s STRTOLLMATERIALSTYLE=spec ;STRTOLLMATERIALSTYLE	收费材料规格	VARCHAR2(200)	是		取值HIS方的收费材料规格
	s STRUNITNAME=uomDesc ;STRUNITNAME	计量单位	VARCHAR2(8)	是		取值HIS方的库存计量单位
	s DBLQUANTITY=confqty ;DBLQUANTITY	数量	NUMBER(6,2)	是		取值HIS方的数量（按库存计量单位）
	s DBLRETAILPRICE=sp ;DBLRETAILPRICE 零售价格	NUMBER(26,9)	是		取值HIS方的零售价格（按库存计量单位）
	s DBLRETAILAMOUNT=spAmt ;DBLRETAILAMOUNT 零售金额	NUMBER(26,9)	是		取值HIS方的零售金额

	q STRTOLLMATERIALCODE_"^"_STRTOLLMATERIALNAME_"^"_STRTOLLMATERIALSTYLE_"^"_STRUNITNAME_"^"_DBLQUANTITY_"^"_DBLRETAILPRICE_"^"_DBLRETAILAMOUNT
}

}
