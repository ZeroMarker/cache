Import sqluser

/// Descript:药品基本信息相关的公共方法
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-03
/// Others:
Class web.DHCST.Common.DrugInfoCommon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 根据库存项代码或RowID取得规格
ClassMethod GetSpec(incicode, inci) As %Library.String
{
	i inci="" d
	.s inci=..ItemCodeToID(incicode)
	q:inci="" ""
	s spec=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
}

/// Descript:根据药品id和参数配置取供应商
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:
/// Input:库存项id,应用程序代码
/// Output:		
/// Return：供应商id^供应商名称
ClassMethod GetConfigVendor(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	s VendorProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppCode,"DefaItmVendor",Params)
	i VendorProp=1  d   ;取最后一次入库供应商
	.s VenInfo=##class(web.DHCST.Common.DrugStkCommon).GetLastVen(IncId)     
	e  d   ;取招标供应商
	.s VenInfo=..GetPbVendor(IncId)
	s VenId=$p(VenInfo,"^",1)
	s VenDesc=$p(VenInfo,"^",2)
	q VenId_"^"_VenDesc
}

/// Descript:根据药品id和参数配置取厂商
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:
/// Input:库存项id,应用程序代码,安全组id^科室id^用户id^医院id
/// Output:		
/// Return：厂商id^厂商名称
ClassMethod GetConfigManf(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	s ManfProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppCode,"DefaManf",Params)
	i ManfProp=1  d   ;取最后一次入库厂商
	.s ManfInfo=##class(web.DHCST.Common.DrugStkCommon).GetLastManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",2)
	e  i ManfProp=3  d   ;招标厂商
	.s ManfInfo=..GetPbManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",2)
	e  d   ;初始厂商
	.s ManfInfo=..GetManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	q ManfId_"^"_ManfDesc
}

/// Descript:根据药品id和参数配置取配送商
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-27
/// Table:
/// Input:库存项id,应用程序代码
/// Output:		
/// Return：配送商id^配送商名称
ClassMethod GetConfigCarrier(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	s DefaItmCarrier=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppCode,"DefaItmCarrier",Params)
	i DefaItmCarrier=1  d   ;上次采购配送商
	.s CarrierInfo=..GetLastPbCarrier(IncId)
	.s CarrierId=$p(CarrierInfo,"^",1)
	.s CarrierDesc=$p(CarrierInfo,"^",2)
	e  d   ;招标配送商
	.s CarrierInfo=..GetPbCarrier(IncId)
	.s CarrierId=$p(CarrierInfo,"^",1)
	.s CarrierDesc=$p(CarrierInfo,"^",2)
	q CarrierId_"^"_CarrierDesc
}

/// Descript:取某药品招标供应商
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return供应商ID^供应商名称
ClassMethod GetPbVendor(Inci) As %Library.String
{
	q:Inci="" ""
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" ""
	s VendorId=$p($G(^DHCITMINFO(Add)),"^",24)
	s:VendorId'="" VenDesc=$p(^APC("APCVM",VendorId),"^",3)
	q VendorId_"^"_$g(VenDesc)
}

/// Descript:取某药品招标生产商
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return厂商ID^厂商名称
ClassMethod GetPbManf(Inci) As %Library.String
{
	q:Inci="" ""
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" ""
	s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
	s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
	q ManfId_"^"_$g(ManfDesc)
}

/// Descript:取某药品上次采购配送商
/// Creater:zhangdongmei
/// CreateDate:2012-09-27
/// Input:库存项id
/// Output:	
/// Return:配送商ID^配送商名称
ClassMethod GetLastPbCarrier(Inci) As %Library.String
{
	q:Inci="" ""
	s CarrierId=""
	s Inpp=""
	f  s Inpp=$o(^INPP(0,"INCI",Inci,Inpp),-1) q:(Inpp="")!(CarrierId'="")  d
	.s Chl=""
	.f  s Chl=$o(^INPP(0,"INCI",Inci,Inpp,Chl),-1)  q:(Chl="")!(CarrierId'="")  d
	..s CarrierId=$p(^INPP(Inpp,"PPI",Chl),"^",8)
	.
	s:CarrierId'=""&&$d(^DHCCARR(CarrierId)) CarrierDesc=$p(^DHCCARR(CarrierId),"^",2)
	q CarrierId_"^"_$g(CarrierDesc)
}

/// Descript:取某药品招标配送商
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return配送商ID^配送商名称
ClassMethod GetPbCarrier(Inci) As %Library.String
{
	q:Inci="" ""
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" ""
	s CarrierId=$p($G(^DHCITMINFO(Add)),"^",26)
	s:CarrierId'="" CarrierDesc=$P(^DHCCARR(CarrierId),"^",2)
	q CarrierId_"^"_$g(CarrierDesc)
}

/// Description: 慎用
ClassMethod ItemCodeToID(incicode)
{
	&sql(SELECT INCI_ROWID INTO :QQ FROM INC_ITM WHERE INCI_CODE=:incicode)
	q QQ
}

/// Descript:	根据库存项的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
ClassMethod GetManf(InciDr)
{
 Q:+InciDr=0 ""
 s scgType=$P(..GetIncStkCatGrp(InciDr),"^",3)
 if scgType="M"   //物资用的取厂家的方法
 {
	s Add=$o(^DHCITMINFO(0,"INCI",InciDr,"")) 
	q:Add="" ""
	s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
	s:ManfId'="" ManfCode=$P(^PHMNF(ManfId),"^",1)
	s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
	q ManfId_"^"_$G(ManfCode)_"^"_$g(ManfDesc)
 }
 else
 {
	s Add=$o(^DHCITMINFO(0,"INCI",InciDr,"")) 
	q:Add="" ""
	s ManfId=$p($G(^DHCITMINFO(Add)),"^",48)
	s:ManfId'="" ManfCode=$P(^PHMNF(ManfId),"^",1)
	s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
	q ManfId_"^"_$G(ManfCode)_"^"_$g(ManfDesc)
 }
}

/// Descript:	根据PHC_DrgMast的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
/// V8.3 停用
ClassMethod GetManfByPhcd(PhcdDr)
{
	Q:PhcdDr="" ""
	Q:'$D(^PHCD(PhcdDr)) ""
	S ManfDr=$P(^PHCD(PhcdDr,2),"^",4)
	Q:ManfDr="" ""
	Q:'$D(^PHMNF(ManfDr)) ""
	S ManfCode=$P(^PHMNF(ManfDr),"^",1)
	S ManfName=$P(^PHMNF(ManfDr),"^",2)
	Q ManfDr_"^"_ManfCode_"^"_ManfName
}

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr)
{
	S ArcimDr=..GetArcim(InciDr)
	Q:ArcimDr="" ""
	S Phcdf=..GetPhcdfByArcim(ArcimDr)
	Q Phcdf
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S buomdr=$P(^INCI(InciDr,1),"^",10)
	Q:buomdr="" ""
	Q:'$D(^CT("UOM",buomdr)) ""
	S buomdesc=$P(^CT("UOM",buomdr),"^",2)
	Q buomdr_"^"_buomdesc
}

/// Descript:	根据库存项ID取入库单位
/// Creater:	yangsj
/// CreateDate:	2021-04-07
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	入库单位ID^入库单位描述
ClassMethod GetIncPuom(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S puomdr=$P(^INCI(InciDr,3),"^",6)
	Q:puomdr="" ""
	Q:'$D(^CT("UOM",puomdr)) ""
	S puomdesc=$P(^CT("UOM",puomdr),"^",2)
	Q puomdr_"^"_puomdesc
}

/// Descript:	根据库存项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
/// Note :		MaYuqiang 20220517 将计价单位修改为门诊发药单位
ClassMethod GetArcBuomByInc(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	//S ArcimDr=..GetArcim(InciDr)
	//Q ..GetArcBuom(ArcimDr)
	s opUomId = $p($g(^INCI(InciDr, 1)), "^", 12)
	s opUomDesc = $p($g(^CT("UOM", +opUomId)), "^", 2)
	q opUomId _"^"_ opUomDesc
}

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid 
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S ArcimDr=$P(^INCI(InciDr,1),"^",3)
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取计价单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	计价单位ID^计价单位描述
ClassMethod GetArcBuom(ArcimDr)
{
	Q:ArcimDr="" ""
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	S BillUomDr=$P(^ARCIM(Arcsub,Arcver,8),"^",14)
	Q:BillUomDr="" ""
	Q:'$D(^CT("UOM",BillUomDr)) ""
	S BillUomDesc=$P(^CT("UOM",BillUomDr),"^",2)
	Q BillUomDr_"^"_BillUomDesc
}

/// Descript:	根据库存项ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项ID
/// Output:		Return
/// Return：	剂型代码^描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetForm(1)
ClassMethod GetForm(InciDr)
{
	Q:InciDr="" ""
	S Phcdf=..GetPhcdf(InciDr)
	Q:Phcdf="" ""
	s GeneId=..GetGeneIdByPhcd(Phcdf)
	q:GeneId="" ""
	S FormStr=..GetFormByGene(GeneId)
	Q FormStr
}

/// Descript:	根据PHC_DrgForm的ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Output:		Return
/// Return：	剂型代码^描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf("1||1")
ClassMethod GetFormByPhcdf(PhcdfDr)
{
	Q:PhcdfDr="" ""
	s GeneId=..GetGeneIdByPhcd(PhcdfDr)
	q:GeneId="" ""
	S FormStr=..GetFormByGene(GeneId)
	Q FormStr
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr)
{
	Q:ArcimDr="" ""
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
	Q Phcdf
}

/// Descript:	根据库存项的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodName(InciDr)
{
	Q:InciDr="" ""
	S Phcdf=..GetPhcdf(InciDr)
	Q:Phcdf="" ""
	S Phcd=$P(Phcdf,"||",1)
	Q:Phcd="" ""
	S GoodName=..GetGoodNameByPhcd(Phcd)
	Q GoodName
}

/// Descript:	根据PHC_DrgMast的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodNameByPhcd(PhcdDr)
{
	Q:PhcdDr="" ""
	Q:'$D(^PHCD(PhcdDr)) ""
	S GoodName=$P(^PHCD(PhcdDr,2),"^",7)
	Q GoodName
}

/// Descript:	根据库存项的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	通用名代码^通用名描述
ClassMethod GetGene(InciDr)
{
	Q:InciDr="" ""
	S Phcdf=..GetPhcdf(InciDr)
	Q:Phcdf="" ""
	S Phcd=$P(Phcdf,"||",1)
	Q:Phcd="" ""
	S GeneStr=..GetGeneByPhcd(Phcd)
	Q GeneStr
}

/// Descript:	根据PHC_DrgMast的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	通用名
ClassMethod GetGeneByPhcd(PhcdDr)
{
	Q:PhcdDr="" ""
	Q:'$D(^PHCD(PhcdDr,4)) ""
	S GeneDr=$P(^PHCD(PhcdDr,4),"^",1)
	Q:GeneDr="" ""
	Q:'$D(^PHCGE("GE",GeneDr)) ""
	S GeneCode=$P(^PHCGE("GE",GeneDr),"^",1)
	S GeneName=$P(^PHCGE("GE",GeneDr),"^",2)
	Q GeneCode_"^"_GeneName
}

/// 三级分类
/// V7.1之后不再使用
ClassMethod GetPhcCat(inci) As %Library.String
{
	q ""
	q:inci="" ""
	s arcim=$p(^INCI(inci,1),"^",3) q:arcim="" ""
	s sub=$p(arcim,"||",1) q:sub="" ""
	s ver=$p(arcim,"||",2)  q:ver="" ""
	Q:'$D(^ARCIM(sub,ver,1)) ""
	s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
	s drg=+drgfrm q:drg="" ""
	s subcat=$p(^PHCD(drg,1),"^",3) q:subcat="" ""
	s cat=+subcat,sub=$p(subcat,"||",2)
	s catdesc=$p($g(^PHCC(cat)),"^",2)
	q $g(catdesc)_"^"_cat
}

/// 三级分类
/// V7.1之后不再使用
ClassMethod GetPhcSubCat(inci) As %Library.String
{
	q ""
	;药学子类名称
	s subcatdesc=""
	q:inci="" subcatdesc
	s arcim=$p(^INCI(inci,1),"^",3) q:arcim="" ""
	s sub=$p(arcim,"||",1) q:sub="" ""
	s ver=$p(arcim,"||",2)  q:ver="" ""
	s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
	s drg=+drgfrm q:drg="" ""
	s subcat=$p(^PHCD(drg,1),"^",3) q:subcat="" ""
	s cat=+subcat,sub=$p(subcat,"||",2)
	q:(cat="")!(sub="") subcatdesc
	i $d(^PHCC(cat,"SC",sub)) d
	.s subcatdesc=$p(^PHCC(cat,"SC",sub),"^",2)
	e  d
	.s subcatdesc=""
	q $g(subcatdesc)_"^"_cat_"||"_sub
}

/// 三级分类
/// V7.1之后不再使用
ClassMethod GetPhcMinCat(inci) As %Library.String
{
	q ""
	;药学最小类名称
	s subcatdesc=""
	q:inci="" subcatdesc
	s arcim=$p(^INCI(inci,1),"^",3) q:arcim="" ""
	s sub=$p(arcim,"||",1) q:sub="" ""
	s ver=$p(arcim,"||",2)  q:ver="" ""
	s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
	s drg=+drgfrm q:drg="" ""
	s subcat=$p(^PHCD(drg,1),"^",6) q:subcat="" ""
	s cat=+subcat,sub=$p(subcat,"||",2),msub=$p(subcat,"||",3)
	q:(cat="")!(sub="")!(msub="") subcatdesc
	i $d(^PHCC(cat,"SC",sub,"MIN",msub)) d
	.s subcatdesc=$p(^PHCC(cat,"SC",sub,"MIN",msub),"^",2)
	e  d
	.s subcatdesc=""
	q $g(subcatdesc)_"^"_cat_"||"_sub_"||"_msub
}

/// 医保类别,8.3开始不再维护,通过接口获取
ClassMethod GetOfficialCode(inciid) As %Library.String
{
	s arcim=..GetArcim(inciid)
	q:arcim="" ""
	q ##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"")
	;根据库存项rowid找到医保代码
	q:inciid="" -1
	s arcim=$p(^INCI(inciid,1),"^",3) q:arcim="" -1
	s sub=$p(arcim,"||",1) q:sub="" -1
	s ver=$p(arcim,"||",2)  q:ver="" -1
	Q:'$D(^ARCIM(sub,ver,1)) -1
	s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" -1
	s drgmst=+drgfrm q:drgmst="" -1
	i $d(^PHCD(drgmst,4)) d
	.s offcodedr=$p(^PHCD(drgmst,4),"^",2)  //保持直接取该字段的值，因为项目上一直是存的描述
	.i offcodedr'="" s offcode=$p($g(^DHCITMIC(offcodedr)),"^",2)
	q $g(offcode)
}

/// Description:取管制分类
ClassMethod GetMangerDrug(inci) As %Library.String
{
	s phcpodesc=""
	q:'$d(^INCI(inci)) phcpodesc
	q:'$d(^INCI(inci,1)) phcpodesc 
	s OriginalARCIM=$p(^INCI(inci,1),"^",3)
	s Arc=+OriginalARCIM
	s ArcSub=$p(OriginalARCIM,"||",2)
	q:Arc="" phcpodesc
	q:ArcSub="" phcpodesc
	q:'$d(^ARCIM(Arc,ArcSub,1)) phcpodesc
	s PHCDFDR=$p(^ARCIM(Arc,ArcSub,1),"^",12)
	q:PHCDFDR="" phcpodesc
	s DrugMast=+PHCDFDR
	q:'$d(^PHCD(DrugMast,1)) phcpodesc
	s PHCPO=$p(^PHCD(DrugMast,1),"^",4)
	q:PHCPO="" phcpodesc
	q:'$d(^PHCPO(PHCPO)) phcpodesc
	s phcpodesc=$p(^PHCPO(PHCPO),"^",2)
	s phcpodesc=$tr(phcpodesc,$c(13,10),"")
	q phcpodesc_"^"_PHCPO
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci) As %Library.String
{
	Q:inci="" ""
	Q:'$d(^INCI(inci,2)) ""
	s inccat=$p(^INCI(inci,2),"^",2)
	q:inccat="" ""
	s scg=$o(^DHCSCG("STKCAT",inccat,""))
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=""
	S scgtypeDesc=..stktypeDesc(scgtype)
	s scgset=$p(^DHCSCG(scg),"^",5)
	s scgstrumodeflag=$p(^DHCSCG(scg),"^",7)
	q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc_"^"_scg_"^"_scgset_"^"_$g(scgstrumodeflag)
}

/// 根据分类取类组信息
/// Author:	zhwh
/// Date	2011-11-02
/// Argu:		
/// 	cat - 库存分类ID
/// Return:		
/// 	字符串: 类组代码^类组描述^类组类型^类组类型名称^类组Rowid
/// Tables: 
/// 	INC_Itm，DHC_StkCatGrpRelations
ClassMethod StkCatGrpStr(cat As %String) As %String
{
	q:cat="" ""
	s scg=$o(^DHCSCG("STKCAT",cat,""))
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=..stktypeDesc(scgtype)
	q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc_"^"_scg
}

/// 判断是否是制剂，1：是；0：不是
ClassMethod ChkRIngr(inci)
{
	q:inci="" 0
	s recsub=""
	s recsub=$o(^INCI(inci,"REC","0"))
	q:(recsub=0)!(recsub="") 0
	q 1
}

/// 取大包装描述
/// Author:zhwh
/// Date:2012-07-20
/// Argu:
///  inci  -库存项rowid
/// Return:
///  大包装描述串
ClassMethod GetPackUom(inci As %String) As %String
{
	&sql(select INFO_PackUom,INFO_PackUomFactor into :uom,:fac from DHC_ItmAddionInfo where INFO_INCI_DR=:inci)
	q:SQLCODE ""
	q uom_" x "_fac
}

/// 取库存项的药学分类,三级分类
/// V7.1后不再使用
ClassMethod GetDrugPhcCat(inci)
{
	q ""
	q:inci="" ""
	s phccatstring=""
	s arcim=$p($G(^INCI(inci,1)),"^",3)  q:arcim="" phccatstring
	s asub=$p(arcim,"||",1)  q:asub="" phccatstring
	s ver=$p(arcim,"||",2) q:ver="" phccatstring
	s drgfrm=$p($G(^ARCIM(asub,ver,1)),"^",12) q:drgfrm="" phccatstring
	s drg=+drgfrm
	s psubcat=$p($G(^PHCD(drg,1)),"^",3)  q:psubcat="" phccatstring
	s pmincat=$p($G(^PHCD(drg,1)),"^",6)
	s pcat=+psubcat,psub=$p(psubcat,"||",2) q:'$d(^PHCC(pcat)) phccatstring
	s pcatdesc=$p(^PHCC(pcat),"^",2) 
	i psub'="" d
	. s psubcatdesc=$p($G(^PHCC(pcat,"SC",psub)),"^",2)
	i pmincat'="" d
	. s pmin=$p(pmincat,"||",3)
	. s pmincatdesc=$p($G(^PHCC(pcat,"SC",psub,"MIN",pmin)),"^",2)
	s phccatstring=$g(pcat)_"^"_$g(pcatdesc)_"^"_$G(psubcat)_"^"_$g(psubcatdesc)_"^"_$G(pmincat)_"^"_$g(pmincatdesc)
	q $g(phccatstring)
}

/// Creator:	zhangdongmei
/// CreatDate:	2012-08-06
/// Description:获得库存项的医嘱子类信息
/// Table:	 	ARC_ItmMast，ARC_ItemCat
/// Input:		库存项ID
/// Return:		id^医嘱子类描述
ClassMethod GetArcItemCat(inci) As %Library.String
{
 	q:inci="" ""
 	s ARCIM=$p(^INCI(inci,1),"^",3) 
 	q:ARCIM="" ""
 	s sub=+ARCIM,ver=$p(ARCIM,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ""
 	s itemcat=$p(^ARCIM(sub,ver,1),"^",10)  
 	s:itemcat'="" catdesc=$p(^ARC("IC",itemcat),"^",2) 
 	q itemcat_"^"_$g(catdesc)
}

/// Creator:	zhangdongmei
/// CreatDate:	2012-08-06
/// Description:获得库存项的进口标志（进口,国产,合资）
/// Table:		DHC_ItmAddionInfo
/// Input:		库存项ID
/// Return:		进口标志
ClassMethod GetItmImpFlag(inciid) As %Library.String
{
	 q:inciid="" ""
	 s infoid=""
	 s infoid=$o(^DHCITMINFO(0,"INCI",inciid,infoid))
	 q:infoid="" ""
	 q:'$d(^DHCITMINFO(infoid))
	 s flag=$p(^DHCITMINFO(infoid),"^",2)
	 q flag
}

/// Description:取得某库存项的定价类型
/// Input:inci_itmRowid
/// Output:定价类型
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
ClassMethod GetItmAddtionSpType(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s spTypedr=""
	s spTypedr=$p(^DHCITMINFO(infoid),"^",15)
	i spTypedr'="" d
	.s spType=$p(^DHCINMT(spTypedr),"^",2)
	q $g(spType)
}

/// Description:取得某库存项的定价类型信息
/// Input:		inci_itmRowid
/// Output:		定价类型
/// Creator:	wangjiabin
/// CreateDate:	2013-11-21
ClassMethod GetMarkType(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s spTypedr=""
	s spTypedr=$p(^DHCITMINFO(infoid),"^",15)
	i spTypedr'="" d
	.s spType=$p(^DHCINMT(spTypedr),"^",2)
	q spTypedr_"^"_$g(spType)
}

/// Description:取得某库存项的招标标志
/// Input:inci_itmRowid
/// Output:0-非招标,1-招标
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(1273)
/// 该字段一直在借用库存项位置
ClassMethod GetItmPbFlag(inci)
{
	//modify by wyx 2014-01-16
	q:inci="" ""
	s tmpPbFlag=$p(^INCI(inci,2),"^",7)
	i tmpPbFlag="Y" q 1
	q 0

	s Info=""
	s Info=$o(^DHCITMINFO(0,"INCI",inci,Info))
	q:Info="" ""
	//s PbFlag=$p(^DHCITMINFO(infoid),"^",30)
	s PbRp=$p(^DHCITMINFO(Info),"^",22)
	s PbLevelId=$p(^DHCITMINFO(Info),"^",30)
	s:PbLevelId'="" PbLevel=$p($g(^DHCITMPBL(PbLevelId)),"^",2)
	s PbVendorId=$p(^DHCITMINFO(Info),"^",24)
	s PbManfId=$p(^DHCITMINFO(Info),"^",25)
	s PbCarrierId=$p(^DHCITMINFO(Info),"^",26)
	s PbLDr=$p(^DHCITMINFO(Info),"^",23)        ;招标名称
	i (+PbRp'=0)!(PbLevelId'="")!(PbVendorId'="")!(PbManfId'="")!(PbCarrierId'="")!(PbLDr'="") d
	.s PbFlag="1"
	e  d
	.s PbFlag="0"
	q PbFlag
}

/// Description:取得某库存项的招标级别
/// Input:inci_itmRowid
/// Output:招标级别
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(1273)
ClassMethod GetItmAddtionPbLevel(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s PbLevel=$p(^DHCITMINFO(infoid),"^",30)
	q PbLevel
}

/// Description:取得某库存项的备案标志
/// Input:inci_itmRowid
/// Output:0-否 , 1-备案
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
ClassMethod GetItmAddtionBAFlag(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s BAflag=$p(^DHCITMINFO(infoid),"^",29)
	q BAflag
}

/// Description:取得某库存项的进口标志
/// Input:DHC_ItmAddionInfo
/// Output:Y,N
/// Creator:zdm
/// CreateDate:2012-01-16
ClassMethod GetItmImportFlag(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s Impflag=$p(^DHCITMINFO(infoid),"^",2)
	q Impflag
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String
{
	I scgtype="G" q "Drug"
	I scgtype="M" q "Material"
	q "Other"
}

/// CreatDate:2013-05-15
/// Description:取库存项高值标志
/// Table:DHC_ItmAddionInfo
/// Input:库存项代码
/// Return:高值标志：Y/N
ClassMethod GetIncHighValueFlag(inci) As %String
{
	q:inci="" ""
	s flag="N"
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:info="" flag
	s flag=$p(^DHCITMINFO(info),"^",12)
	s:flag="" flag="N"
	q flag
}

/// 根据库存项RowID取得品牌
ClassMethod GetBrand(inci) As %Library.String
{
	q:inci="" ""
	s brand=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s brand=$p($G(^DHCITMINFO(add)),"^",58)
	q brand
}

/// 根据库存项RowID取得型号
ClassMethod GetModel(inci) As %Library.String
{
	q:inci="" ""
	s model=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s model=$p($G(^DHCITMINFO(add)),"^",59)
	q model
}

/// /// 根据库存项RowID取得简称
ClassMethod GetAbbrev(inci) As %Library.String
{
	q:inci="" ""
	s abbrev=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s abbrev=$p($G(^DHCITMINFO(add)),"^",60)
	q abbrev
}

/// /// 根据库存项RowID取得监管级别
ClassMethod GetSupervision(inci) As %Library.String
{
	q:inci="" ""
	s Supervision=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s Supervision=$p($G(^DHCITMINFO(add)),"^",61)
	q Supervision
}

/// Descript:取科室药品所维护的货位
/// Creater:	LiangQaing
/// CreateDate:	2013-11-19
/// Table:
/// Input:科室库存项ID,分隔符,货位ID,货位描述
/// Output:		
/// Return:是否有相关货位:货位串
ClassMethod GetInciBinStr(incil, del = "", sbrowid = "", desc = "")
{
    if ($d(^oddCOM("PHA.IN.StkBin.Face", "m", "GetStkBinByInicl"))){
        #; 2023-02-22, 调用hisui新药库货位
        q ":" _ ##class(PHA.IN.StkBin.Face).GetStkBinByInicl(incil)
    }
	s chkflag=0
	s ret=""
	s incilb=""
	f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
	.s stkbindr=$p(^DHCINCILB(incilb),"^",2)
	.s stkbin=$p(^INC("SB",stkbindr),"^",2)
	.i ret="" d
	..s ret=stkbin
	.e  d
	..s ret=ret_del_stkbin
	.q:(stkbin'[desc)&(desc'="")
	.q:(stkbindr'=sbrowid)&(stkbindr'="")
	.s chkflag=1
	q chkflag_":"_ret
}

/// Descript:	根据药学项ID取药学多级分类的值
/// Creater:	hulihua
/// CreateDate:	2017-11-02
/// Input:		PHC_DrgForm的ID
/// Output:		Return
/// Return：	药学多级分类值
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhcdf("112||1")
ClassMethod GetPhaCatAllByPhcdf(Phcdf)
{
	Q:Phcdf="" ""
	Q:'$D(^PHCD(+Phcdf,4)) ""
	S GeneDr=$P(^PHCD(+Phcdf,4),"^",1)
	Q:GeneDr="" ""
	Q:'$D(^PHCGE("GE",GeneDr)) ""
	s dhcGenericId=GeneDr
	s NewCatId=$p($g(^PHCGE("GE",dhcGenericId,"DHC")),"^",6)
	s PhaCatAllDesc=""
	i NewCatId'="" d
	.s PhaCatAllDesc=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCat(NewCatId,"")
	Q NewCatId_"^"_PhaCatAllDesc
}

/// Descript:	根据库存项ID取药学多级分类的值
/// Creater:	wyx
/// CreateDate:	2014-12-08
/// Input:		InciDr-库存项ID
/// Output:		Return
/// Return：	药学多级分类值
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(1)
ClassMethod GetPhaCatAll(InciDr)
{
	Q:InciDr="" ""
	S Phcdf=..GetPhcdf(InciDr)
	Q:Phcdf="" ""
	s NewCatId=""
	s PhaCatAllDesc=""
	s phcgeDr=$p($g(^PHCD(+Phcdf,4)),"^",1)
	q:phcgeDr="" ""
	s NewCatId=$p($g(^PHCGE("GE",phcgeDr,"DHC")),"^",6)
	i NewCatId'="" d
	.s PhaCatAllDesc=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCat(NewCatId,"")
	Q NewCatId_"^"_PhaCatAllDesc
}

/// Descript:	查看分类id是否存在父子关系
/// Creater:	wyx
/// CreateDate:	2015-01-05
/// Input:		CatIdA是不是包含CatIdB
/// Output:		Return
/// Return：	1 存在，0 不存在
ClassMethod CheckNewCatId(CatIdA, CatIdB)
{
	s ret=0
	q:+CatIdA="0" ret
	q:+CatIdB="0" ret
	q:'$d(^DHCPHCC(CatIdA)) ret
	q:'$d(^DHCPHCC(CatIdB)) ret
	q:CatIdA=CatIdB 1
	s parcatdr=$p(^DHCPHCC(CatIdB),"^",3)
	//s catdesc=$p(^DHCPHCC(catdr),"^",2)
	q:parcatdr=0 0
	i parcatdr=CatIdA s ret=1
	e  s ret=..CheckNewCatId(CatIdA,parcatdr)
	q ret
}

/// Descript:	根据库存项ID取药学多级分类的值
/// Creater:	wyx
/// CreateDate:	2015-01-06
/// Input:		InciDr-库存项ID
/// Output:		Return
/// Return：	药学多级分类值 格式："catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3"
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByInci(524)
ClassMethod GetPhaCatAllByInci(InciDr)
{
	Q:InciDr="" ""
	S Phcdf=..GetPhcdf(InciDr)
	Q:Phcdf="" ""
	s PhaCatAllStr=..GetPhaCatAllByPhc(Phcdf)
	Q PhaCatAllStr
}

/// Descript:	根据药学项ID取药学多级分类的值
/// Creater:	wyx
/// CreateDate:	2015-01-06
/// Input:		InciDr-药学项ID
/// Output:		Return
/// Return：	药学多级分类值 格式："catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3"
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhc("112||1")
ClassMethod GetPhaCatAllByPhc(Phcdf)
{
	Q:Phcdf="" ""
	s phcgeDr=$p($g(^PHCD(+Phcdf,4)),"^",1)
	q:phcgeDr="" ""
	s NewCatId=$p($g(^PHCGE("GE",phcgeDr,"DHC")),"^",6)
	s PhaCatAllStr=""
	i NewCatId'="" d           ;多级药学分类
	.s PhaCatAllStr=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCatById(NewCatId,"","","")
	Q PhaCatAllStr
}

/// description: 根据库存项rowid找到医保代码
/// 8.3不再使用,使用GetOfficialCode
ClassMethod GetOfficialCodeRowId(inciid) As %Library.String
{
	q:inciid="" ""
	s arcim=$p(^INCI(inciid,1),"^",3) q:arcim="" ""
	s sub=$p(arcim,"||",1) q:sub="" ""
	s ver=$p(arcim,"||",2)  q:ver="" ""
	Q:'$D(^ARCIM(sub,ver,1)) ""
	s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
	s drgmst=+drgfrm q:drgmst="" ""
	i $d(^PHCD(drgmst,4)) d
	.s offcodedr=$p(^PHCD(drgmst,4),"^",2)  //保持直接取该字段的值，因为项目上一直是存的描述
	q $g(offcodedr)
}

/// 批准文号
ClassMethod GetInciRemark(InciId)
{
	q:InciId="" "-"
	s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
	q:Info="" "-"
	s Remark=$p(^DHCITMINFO(Info),"^",10)
	i $p(Remark,"-",2)="undefined" s Remark="-"
	i Remark="" s Remark="-"
	i Remark'["-" s Remark=Remark_"-"
	q Remark
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据医嘱项获取医嘱大类类信息
/// Table:ARC_ItmMast，ARC_ItemCat,OEC_OrderCategory
/// Input:医嘱项id
/// Return:	医嘱大类id^医嘱大类描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim("2||1")
ClassMethod GetOrderCategoryByArcim(arcim) As %Library.String
{
 	q:arcim="" ""
 	s sub=+arcim,ver=$p(arcim,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ""
 	s ordercat=""
 	s itemcat=$p(^ARCIM(sub,ver,1),"^",10)  
 	s:itemcat'="" ordercat=$p(^ARC("IC",itemcat),"^",8)
 	q:+ordercat=0 ""
 	s ordercatdesc=$p(^OEC("ORCAT",ordercat),"^",2) 
 	q ordercat_"^"_$g(ordercatdesc)
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据药学项获取药品用法
/// Input:药学项id           
/// Return:	用法id^用法描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcd("2||1")
ClassMethod GetPhcInstrByPhcdf(phcdf) As %Library.String
{
    Q:phcdf="" ""
    s phcd=+phcdf
    q:phcd=0
    s phcdsub=+$p(phcdf,"||",2)
    q:phcdsub=0 ""
    s instrdesc=""
    s instr=$p($g(^PHCD(phcd,"DF",phcdsub,1)),"^",5) ;指向PHC_Instruc
    q:instr="" ""
    s instrdesc=$p($g(^PHCIN(instr)),"^",2) ;取用法
	q instr_"^"_instrdesc
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据药学项获取抗菌药标志
/// Input:药学项id           
/// Return:Y/N
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf("2||1")
ClassMethod GetAntiFlagByPhcdf(phcdf) As %Library.String
{
    Q:phcdf="" ""
    s phcd=+phcdf
    q:phcd=0
    s phcdsub=+$p(phcdf,"||",2)
    q:phcdsub=0 ""
    s antiflag=$P($g(^PHCD(phcd,"DF",phcdsub,"DHC")),"^",8)
    s antiflag=$s(antiflag="Y":"Y",1:"N")
    q antiflag
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据药学项获取药品频次
/// Input:药学项id           
/// Return:频次id^频次描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf("2||1")
ClassMethod GetPhcFreqByPhcdf(phcdf) As %Library.String
{
    Q:phcdf="" ""
    s phcd=+phcdf
    q:phcd=0
    s phcdsub=+$p(phcdf,"||",2)
    q:phcdsub=0 ""
    s freqdesc=""
    s freq=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",4) ;指向PHC_Freq
    q:freq="" ""
    s freqdesc=$p(^PHCFR(freq),"^",3) ;取频次
	q freq_"^"_freqdesc
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据药学项获取管制分类
/// Input:药学项id           
/// Return:管制分类id,管制分类描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd("2||1")
ClassMethod GetPhcPoisonByPhcd(phcd) As %Library.String
{
	s phcd=+phcd
    Q:phcd="0" ""
	q:'$d(^PHCD(phcd,1)) ""
	s phcpo=$p(^PHCD(phcd,1),"^",4)
	q:phcpo="" ""
	q:'$d(^PHCPO(phcpo)) ""
	s phcpodesc=$p(^PHCPO(phcpo),"^",2)
	q phcpo_"^"_phcpodesc
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据库存项获取最高售价
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp("2")
ClassMethod GetMaxSp(InciId)
{
	q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s MaxSp=$p($g(^DHCITMINFO(Info)),"^",16)
    q MaxSp
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据库存项获取国家基本药物标志
/// Input:库存项id           
/// output:Y/N
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag("573")
/// 8.3 该标标志维护在药学项Ext
ClassMethod GetCountryBasicFlag(InciId)
{
	q:InciId="" ""
	s Phcdf=..GetPhcdf(InciId)
	q:Phcdf="" ""
	q ..GetBasicByPhcdf(Phcdf)
	// 8.3之前	
    s CountryBasicFlag=$p($g(^DHCITMINFO(Info)),"^",4)
    s CountryBasicFlag=$s(CountryBasicFlag="Y":"Y",1:"N")	
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s CountryBasicFlag=$p($g(^DHCITMINFO(Info)),"^",4)
    s CountryBasicFlag=$s(CountryBasicFlag="Y":"Y",1:"N")
    q CountryBasicFlag
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据库存项获取省基本药物标志
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag("2")
ClassMethod GetProvinceBasicFlag(InciId)
{
	q:InciId="" ""
	s Phcdf=..GetPhcdf(InciId)
	q:Phcdf="" ""
	s ProvinceBasicFlag=$p($g(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),"DHC")),"^",32)
	q $s(ProvinceBasicFlag="Y":"Y",1:"N")
	// 8.3之前	
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s ProvinceBasicFlag=$p($g(^DHCITMINFO(Info)),"^",40)
    s ProvinceBasicFlag=$s(ProvinceBasicFlag="1":"Y",1:"N")
    q ProvinceBasicFlag
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据库存项获取本院药品目录标志
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag("2")
ClassMethod GetInHosFlag(InciId)
{
	q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s InHosFlag=$p($g(^DHCITMINFO(Info)),"^",21)
	s InHosFlag=$s(InHosFlag="Y":"Y",1:"N")
    q InHosFlag
}

/// Creator:yunhaibao
/// CreatDate:20151129	
/// Description:根据库存项获取进口标志
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag("2")
ClassMethod GetImportFlag(InciId)
{
	q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s ImportFlag=$p($g(^DHCITMINFO(Info)),"^",2)
    q ImportFlag
}

/// Creator:yunhaibao
/// CreatDate:20151130	
/// Description:根据库存项获取中国药典标志
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag("2")
ClassMethod GetCodexFlag(InciId)
{
	q:InciId="" ""
	s Phcdf=..GetPhcdf(InciId)
	q:Phcdf="" ""
	s codeXFlag=$p($g(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),"DHC")),"^",36)
	q $s(codeXFlag="Y":"Y",1:"N")
	// 8.3之前	
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s codeXFlag=$p($g(^DHCITMINFO(Info)),"^",7)
	s codeXFlag=$s(codeXFlag="Y":"Y",1:"N")
    q codeXFlag
}

/// Creator:yunhaibao
/// CreatDate:20151130	
/// Description:根据库存项获取用药说明
/// Input:库存项id           
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo("2")
ClassMethod GetDrugUseInfo(InciId)
{
	q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s DrugUseInfo=$p($g(^DHCITMINFO(Info)),"^",38)
    q DrugUseInfo
}

/// Creator:yunhaibao
/// CreatDate:20151130	
/// Description:根据医嘱项获取医嘱截止日期
/// Input:医嘱项id 
/// Output:+$h格式^2015-12-12 or 空          
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate("858||1")
ClassMethod GetArcItmStopDate(arcim)
{
 	q:arcim="" ""
 	s sub=+arcim,ver=+$p(arcim,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ""
 	s arcimenddate=$P(^ARCIM(sub,ver,7),"^",1)	 
	s arcimenddate=+arcimenddate
	i arcimenddate'=0 s formatenddate=$zd(arcimenddate,3)
	e  s formatenddate=""
	q arcimenddate_"^"_formatenddate
}

/// Description:取得某库存项的招标级别id以及代码描述
/// Input:inci_itmRowid
/// Output:招标级别id^代码^名称
/// Creator:yunhaibao
/// CreateDate:2016-02-01
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevelInfo("533")
ClassMethod GetItmAddtionPbLevelInfo(inci)
{
	q:inci="" ""
	s infoid=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,infoid))
	q:infoid="" ""
	s PbLevel=$p(^DHCITMINFO(infoid),"^",30)
	i PbLevel'="" d
	.s PbLevelCode=$p($g(^DHCITMPBL(PbLevel)),"^",1) 
	.s PbLevelDesc=$p($g(^DHCITMPBL(PbLevel)),"^",2) 
	e  s PbLevelCode="",PbLevelDesc=""
	q PbLevel_"^"_PbLevelCode_"^"_PbLevelDesc
}

/// Descript:	根据库存项ID取大包装单位
/// Creater:	yunhaibao
/// CreateDate:	20160412
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	大包装单位ID^大包装单位描述
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetIncPackUom("")
ClassMethod GetIncPackUom(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	s Info=$o(^DHCITMINFO(0,"INCI",InciDr,0))
	q:Info="" ""
	s PackUomDr=$p($g(^DHCITMINFO(Info)),"^",51)
	s PackFac=$p($g(^DHCITMINFO(Info)),"^",52)
	s PackUomDesc=""
	i PackUomDr'="" s PackUomDesc=$p($g(^CT("UOM",PackUomDr)),"^",2)
	q PackUomDr_"^"_PackUomDesc_"^"_PackFac
}

/// Creator:yunhaibao
/// CreatDate:20151130	
/// Description:根据库存项获取医嘱截止日期
/// Input:库存项id 
/// Output:+$h格式^2015-12-12 or 空          
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDateByInci("858")
ClassMethod GetArcItmStopDateByInci(inci)
{
 	q:inci="" ""
 	s arcim=..GetArcim(inci)
 	q:arcim="" ""
 	s arcimdatestr=..GetArcItmStopDate(arcim)
 	q arcimdatestr
}

/// Descript:	根据医嘱项获取到某个药品的配液类别
/// Creater:	hulihua
/// CreateDate:	2016-12-20
/// Input:		arcim-医嘱项ID
/// Output:		
/// Return:     药品的配液类别
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetDrugPivaCat("858")
ClassMethod GetDrugPivaCat(arcim)
{
	q:arcim="" ""
	s sub=+arcim,ver=+$p(arcim,"||",2) 
	q:'$d(^ARCIM(sub,ver,1)) ""
	s PhcdfId=..GetPhcdfByArcim(arcim)
	q:PhcdfId="" ""
	s Phcd=+PhcdfId 
	q:Phcd="" ""
	s Chl=$p(PhcdfId,"||",2)
	s PivaCatDr=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",24)	
	q PivaCatDr
}

/// description: 获取库存项字典不可退药原因
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetCantRetReason(4560)
ClassMethod GetCantRetReason(IncId)
{
	q:IncId="" ""
	s itmAddId=$o(^DHCITMINFO(0,"INCI",IncId,""))
	q:itmAddId="" "" 
	s cantRetReasonId=$p($g(^DHCITMINFO(itmAddId)),"^",46)
	q:cantRetReasonId="" ""
	s cantRetReasonDesc=$p($g(^DHCRFRETREASON(+cantRetReasonId)),"^",2)
	q cantRetReasonId_"^"_cantRetReasonDesc
}

/// Description:根据医嘱项ID获取药品的化学通用名相关信息
/// Creator:	hulihua
/// CreateDate:	2019-01-16
/// Table:      DHC_PhcGeneric、DHC_PHChemical
/// Input:		ArcimId-医嘱项ID
/// Output:		
/// Return：	化学通用名ID、化学通用名代码、化学通用名描述	
/// Others:   
/// Debug:		w ##class(web.DHCST.Common.DrugInfoCommon).GetPHChemicalByArc("100||1")
ClassMethod GetPHChemicalByArc(ArcimId)
{
	Q:ArcimId="" ""
	S arcSub=+ArcimId,arcVer=+$p(ArcimId,"||",2) 
	Q:'$d(^ARCIM(arcSub,arcVer,1)) ""
	S phcdfId=..GetPhcdfByArcim(ArcimId)
	Q:phcdfId="" ""
	S phcdId=+phcdfId 
	Q:phcdId="" ""
	Q:'$D(^PHCD(+phcdId,4)) ""
	S geneDr=$P(^PHCD(+phcdId,4),"^",1)
	Q:geneDr="" ""
	Q:'$D(^PHCGE("GE",geneDr)) ""
	S chemicalId=$p($g(^PHCGE("GE",geneDr,"DHC")),"^",3)
	Q:chemicalId="" ""
	S chemicalCode=$p($g(^DHCPHCM(chemicalId)),"^",1)
	S chemicalDesc=$p($g(^DHCPHCM(chemicalId)),"^",2)
	S chemicalStr=chemicalId_"^"_chemicalCode_"^"_chemicalDesc
	Q chemicalStr
}

/// Author : MaYuqiang
/// Date Created : 2019-01-17
/// Description : 根据药学项子表ID获取基本药物标志(医嘱结构改造之后)
/// Table : PHC_DrgFormExt
/// Input : PhcdfId - 药学项子表ID
/// Output :		
/// Return : Y - 是 , N - 否
/// Others :   
/// Debug :	w ##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf("100||1")
ClassMethod GetBasicByPhcdf(PhcdfId)
{
	Q:PhcdfId="" ""
	s phcd=+PhcdfId
    q:phcd=0 "N"
    s phcdsub=+$p(PhcdfId,"||",2)
    q:phcdsub=0 "N"
	s basicflag=$p($g(^PHCD(+phcd,"DF",+phcdsub,"DHC")),"^",31)
	i basicflag'="Y" d
	.s basicflag="N"
	Q basicflag
}

/// Description:根据医嘱项ID判断某个医嘱项是否是免费药
/// Creator:	hulihua
/// CreateDate:	2019-03-26
/// Table:      DHC_ItmMast 医嘱项扩展表
/// Input:		ArcimDr-医嘱项ID
/// Output:	    
/// Return：	Y-是，N或空-否  
/// Others:     
/// add:  2020-04-15 yangsj  统一取值为Y/N  没有空值
/// Debug:		w ##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug("9525||1")
ClassMethod CheckIfFreeDrug(ArcimDr)
{
	s ret="N"
 	q:ArcimDr="" ret
 	s sub=+ArcimDr,ver=+$p(ArcimDr,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ret
	s dhcArcimId=$o(^DHCItmMast("0","ARCIM",ArcimDr,0))
	s freeDrugFlag=$s(dhcArcimId'="":$p(^DHCItmMast(dhcArcimId),"^",21),1:"")
	q:freeDrugFlag="" "N"
	q freeDrugFlag
}

/// Description: 根据处方通用名取剂型
/// Creator:	 yunhaibao
/// CreateDate:	 2019-06-05
/// Return：	 代码^名称^Id
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetFormByGene(1)
ClassMethod GetFormByGene(GeneId)
{
	Q:GeneId="" ""
	s formDr=$p($g(^PHCGE("GE",GeneId,"DHC")),"^",5)
	q:formDr="" ""
	s formData=$g(^PHCF(formDr))
	S formCode=$P(formData,"^",1)
	S formDesc=$P(formData,"^",2)
	Q formCode_"^"_formDesc_"^"_formDr
}

/// Description: 根据药学项Id获取处方通用名Id
ClassMethod GetGeneIdByPhcd(Phcd)
{
	s phcd=+Phcd
	q:phcd=0 ""
	q $p($g(^PHCD(phcd,4)),"^",1)
}

/// Descrption:通过库存项获取处方通用名
/// Creator:yangsj
/// CreateDate:2019-11-04
/// Input:InciDr
/// OutPut:
/// 
/// Debug : w ##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(1)
ClassMethod GetGenericByInci(InciDr)
{
	s arc=$P(^INCI(InciDr,1),"^",3)
	q:arc="" ""
	s dhcphcg=$P(^ARCIM(+arc,$P(arc,"||",2),8),"^",20)
	q:dhcphcg="" ""
	s phcg=$P(^PHCGE("GE",dhcphcg,"DHC"),"^",1)
	q:phcg="" ""
	s phcgdesc=$P(^PHCGE("GE",phcg),"^",2)
	
	q phcg_"^"_phcgdesc
}

/// Descrption:通过库存项获取基本药物标志
/// Creator:yangsj
/// CreateDate:2019-11-13
/// Input:InciDr
/// OutPut:
/// 
/// Debug : w ##class(web.DHCST.Common.DrugInfoCommon).GetBasicByInci(1610)
ClassMethod GetBasicByInci(InciDr)
{
	s arc=$P(^INCI(InciDr,1),"^",3)
	q:arc="" ""
	
	S phcdfId=..GetPhcdfByArcim(arc)
	q:phcdfId="" ""
	
	q ..GetBasicByPhcdf(phcdfId)
}

/// Description: 是否草药
/// Return:		 Y - 是
ClassMethod IsHerb(inci)
{
	s incsc=$p(^INCI(inci,2),"^",2)
	q:incsc="" "N"
	s scg=$o(^DHCSCG("STKCAT",incsc,""))
	q:scg="" "N"
	s scgset=$p(^DHCSCG(scg),"^",5)
	q:scgset="GC" "Y"
	q "N"
}

/// 药房获取批准文号相关信息 (目前药库没有使用注册证表来存批准文号，暂时使用此方法取值)
/// yangsj 2020-12-24
/// w ##class(web.DHCST.Common.DrugInfoCommon).GetRemarkByInci("2080")
ClassMethod GetRemarkByInci(inci)
{
	s info=$O(^DHCITMINFO(0,"INCI",inci,""))
	q:info=""
	s RemarkNo=$P(^DHCITMINFO(info),"^",10)
	i RemarkNo="-" s RemarkNo=""
	s stDate="",edDate=""
	s itmRek=$O(^ITMREK("INCI",inci,""),-1)
	q:itmRek="" RemarkNo
	s NewText=$P(^ITMREK(itmRek),"^",5)
	q:RemarkNo'=NewText RemarkNo
	s stDate="" //$P(^ITMREK(itmRek),"^",6)  //更改时间
	s edDate=$P(^ITMREK(itmRek),"^",6)   //有效期
	s:stDate'="" stDate=$zd(stDate,3)
	s:edDate'="" edDate=$zd(edDate,3)
	q RemarkNo_"^"_stDate_"^"_edDate
}

/// 根据库存项RowID取得注册证和注册证效期
/// Return:	注册证号^注册证效期^注册证物资名称^注册证号全称^注册证发证日期
ClassMethod GetCert(inci, manf = "") As %Library.String
{
#;	i manf="" d
#;	.s manf=$p(##class(web.DHCSTM.Common.DrugInfoCommon).GetPbManf(inci),"^",1)
#;	q:manf="" ""
#;	s irRowID=$O(^ITMREK(0,"INCIMNF",inci,manf,""))
#;	q:irRowID="" ""
#;	s imcRowiD=$P(^ITMREK(irRowID),"^",14)
#;	q:imcRowiD="" ""
#;	s CerNo=$p(^DHCIMCSA(imcRowiD),"^",2)
#;	s CerExpDate=$p(^DHCIMCSA(imcRowiD),"^",3)
 
	s ir=$o(^ITMREK("INCI",inci,""))
	q:ir="" ""
	s CerNo=$p(^ITMREK(ir),"^",11)
	s CerExpDate=$p(^ITMREK(ir),"^",12)
	s:CerExpDate'="" CerExpDate=$zd(CerExpDate,3)
	s CertItmDesc=$p(^ITMREK(ir),"^",16)
	s IRRegCertNoFull=$p(^ITMREK(ir),"^",23)
	s IRRegCertDateOfIssue=$p(^ITMREK(ir),"^",24)
	s:IRRegCertDateOfIssue'="" IRRegCertDateOfIssue=$zd(IRRegCertDateOfIssue,3)
	q CerNo_"^"_CerExpDate_"^"_CertItmDesc_"^"_IRRegCertNoFull_"^"_IRRegCertDateOfIssue
}

/// Description:取管制分类是否是（麻醉药品，一类精神） // 二类精神
/// Creator:yangsj
/// Creator:2021-07-16
/// w ##Class(web.DHCST.Common.DrugInfoCommon).CheckPoisonForVendor(3728)
ClassMethod CheckPoisonForVendor(inci) As %Library.String
{
	s Ret = "N"
	q:'$d(^INCI(inci)) Ret
	q:'$d(^INCI(inci,1)) Ret 
	s OriginalARCIM=$p(^INCI(inci,1),"^",3)
	s Arc=+OriginalARCIM
	s ArcSub=$p(OriginalARCIM,"||",2)
	q:Arc="" Ret
	q:ArcSub="" Ret
	q:'$d(^ARCIM(Arc,ArcSub,1)) Ret
	s PHCDFDR=$p(^ARCIM(Arc,ArcSub,1),"^",12)
	q:PHCDFDR="" Ret
	s DrugMast=+PHCDFDR
	q:'$d(^PHCD(DrugMast,1)) Ret
	s PHCPO=$p(^PHCD(DrugMast,1),"^",4)
	q:PHCPO="" Ret
	q:'$d(^PHCPO(PHCPO)) Ret
	s phcpodesc=$p(^PHCPO(PHCPO),"^",2)
	s phcpodesc=$tr(phcpodesc,$c(13,10),"")
	if (phcpodesc="麻醉药品")||(phcpodesc="一类精神") s Ret = "Y"
	q Ret
}

/// Descripiton: 是否集采药品(取药品信息维护的集采标识)
/// Author:		 zhaoxinlong 2022.03.17
/// Input:		 inci
/// Return:		 Y/N
/// w ##Class(web.DHCST.Common.DrugInfoCommon).IsCentPur(3728)
ClassMethod IsCentPur(inci) As %String
{
	q:(inci = "") ""
	s info = +$o(^DHCITMINFO(0,"INCI", inci, 0))
	if (info > 0) {
		s flag = $p($g(^DHCITMINFO(info, 1)), "^", 9)
	}
	s flag = $s($g(flag) = "Y":"Y" , 1:"N")
	q flag
}

}
